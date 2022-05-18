// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$$_AppUserFromJson(Map<String, dynamic> json) => _$_AppUser(
      name: json['name'] as String?,
      photoURL: json['photoURL'] as String?,
      email: json['email'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'photoURL': instance.photoURL,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
    };
