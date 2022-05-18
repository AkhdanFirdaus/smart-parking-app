import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    @JsonKey(ignore: true) String? id,
    String? name,
    String? photoURL,
    required String email,
    String? address,
    String? phone,
  }) = _AppUser;

  const AppUser._();

  AppUser toDomain() {
    return AppUser(
      id: id,
      name: name,
      photoURL: photoURL,
      email: email,
      address: address,
      phone: phone,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromFirebase(DocumentSnapshot doc) {
    return AppUser.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }
}
