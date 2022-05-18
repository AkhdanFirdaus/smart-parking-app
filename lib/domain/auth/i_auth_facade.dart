import 'package:dartz/dartz.dart';
import 'package:smart_parking/domain/auth/app_user.dart';
import 'package:smart_parking/domain/auth/app_user_failure.dart';
import 'package:smart_parking/domain/auth/auth_failure.dart';
import 'package:smart_parking/domain/auth/auth_value_objects.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailPassword({
    required EmailAddress emailAddress,
    required Password password,
    required Fullname fullname,
    required Address address,
    required Phone phone,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<Either<AuthFailure, Unit>> updateProfile({
    required EmailAddress emailAddress,
    required Password? password,
    required PasswordConfirmation? passwordConfirmation,
    required Fullname fullname,
    required Address address,
    required Phone phone,
  });
  Future<void> signOut();
  Future<Option<AppUser>> getSignedInUser();
  Future<Either<AuthFailure, Unit>> storeGoogleUser({
    required bool isLogin,
    AppUser? appUser,
  });
  Stream<Either<AppUserFailure, AppUser>> watchUserProfile();
}
