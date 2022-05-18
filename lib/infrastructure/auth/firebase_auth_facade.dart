import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_parking/domain/auth/app_user_failure.dart';
import 'package:smart_parking/domain/auth/app_user.dart';
import 'package:smart_parking/domain/auth/auth_failure.dart';
import 'package:smart_parking/domain/auth/auth_value_objects.dart';
import 'package:smart_parking/domain/auth/i_auth_facade.dart';
import 'package:smart_parking/domain/core/errors.dart';
import 'package:smart_parking/domain/core/value_objects.dart';
import 'package:smart_parking/infrastructure/auth/firebase_user_mapper.dart';
import 'package:smart_parking/infrastructure/core/firestore_helper.dart';
import 'package:smart_parking/injection.dart';

@LazySingleton(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthFacade(
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore,
  );

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailPassword({
    required EmailAddress emailAddress,
    required Password password,
    required Fullname fullname,
    required Address address,
    required Phone phone,
  }) async {
    final emailAddressStr = emailAddress.getOrCrash();
    final passwordStr = password.getOrCrash();
    final fullnameStr = fullname.getOrCrash();
    final addressStr = address.getOrCrash();
    final phoneStr = phone.getOrCrash();
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      )
          .then((_) async {
        final user = AppUser(
          id: emailAddressStr,
          email: emailAddressStr,
          name: fullnameStr,
          address: addressStr,
          phone: phoneStr,
          photoURL: _.user?.photoURL,
        );
        return storeGoogleUser(isLogin: false, appUser: user).then(
          (failureOrSuccess) => failureOrSuccess.fold(
            (l) => left(const AuthFailure.serverError()),
            (r) => right(unit),
          ),
        );
      });
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailPassword({
    required EmailAddress emailAddress,
    required Password password,
  }) async {
    final emailAddressStr = emailAddress.getOrCrash();
    final passwordStr = password.getOrCrash();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      );
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(const AuthFailure.cancelledByUser());
      }
      final googleAuthentication = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );
      return _firebaseAuth.signInWithCredential(authCredential).then((_) async {
        return storeGoogleUser(isLogin: true).then(
          (failureOrSuccess) => failureOrSuccess.fold(
            (l) => left(const AuthFailure.serverError()),
            (r) => right(unit),
          ),
        );
      });
    } on FirebaseAuthException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<void> signOut() {
    return Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
  }

  @override
  Future<Option<AppUser>> getSignedInUser() async {
    return optionOf(_firebaseAuth.currentUser?.toDomain());
  }

  @override
  Future<Either<AuthFailure, Unit>> storeGoogleUser({
    required bool isLogin,
    AppUser? appUser,
  }) async {
    try {
      if (isLogin) {
        final userDoc = await _firestore.userDocument();
        final userOption = await getIt<IAuthFacade>().getSignedInUser();
        final user = userOption
            .getOrElse(() => throw NotAuthenticatedError())
            .copyWith(
              id: UniqueId().getOrCrash(),
            )
            .toJson();
        await userDoc.set(user);
      } else {
        final userDoc = await _firestore.userDocument();
        await userDoc
            .set(appUser!.copyWith(id: UniqueId().getOrCrash()).toJson());
      }
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const AuthFailure.serverError());
      } else {
        return left(const AuthFailure.unexpected());
      }
    }
  }

  @override
  Stream<Either<AppUserFailure, AppUser>> watchUserProfile() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc
        .snapshots()
        .map(
          (snapshot) => right<AppUserFailure, AppUser>(
            AppUser.fromFirebase(snapshot).toDomain(),
          ),
        )
        .handleError((e) {
      if (e is FirebaseException && e.message!.contains('PERMISSION_DENIED')) {
        return left(const AppUserFailure.insufficientPermissions());
      } else {
        return left(const AppUserFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<AuthFailure, Unit>> updateProfile({
    required EmailAddress emailAddress,
    required Password? password,
    required PasswordConfirmation? passwordConfirmation,
    required Fullname fullname,
    required Address address,
    required Phone phone,
  }) async {
    try {
      final emailAddressStr = emailAddress.getOrCrash();
      final fullnameStr = fullname.getOrCrash();
      final addressStr = address.getOrCrash();
      final phoneStr = phone.getOrCrash();

      final appUser = AppUser(
        email: emailAddressStr,
        name: fullnameStr,
        address: addressStr,
        phone: phoneStr,
      ).toJson();

      final userDoc = await _firestore.userDocument();
      await userDoc.set(appUser);
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const AuthFailure.serverError());
      } else {
        return left(const AuthFailure.unexpected());
      }
    }
  }
}
