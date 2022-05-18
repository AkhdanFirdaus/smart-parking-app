import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking/domain/auth/i_auth_facade.dart';
import 'package:smart_parking/domain/core/errors.dart';
import 'package:smart_parking/injection.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance.collection('users').doc(user.email);
  }
}
