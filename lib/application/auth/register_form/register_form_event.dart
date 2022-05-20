part of 'register_form_bloc.dart';

@freezed
class RegisterFormEvent with _$RegisterFormEvent {
  const factory RegisterFormEvent.emailChanged(String emailStr) = _EmailChanged;
  const factory RegisterFormEvent.passwordChanged(String passwordStr) =
      _PasswordChanged;
  const factory RegisterFormEvent.phoneChanged(String phoneStr) = _PhoneChanged;
  const factory RegisterFormEvent.addressChanged(String addressStr) =
      _AddressChanged;
  const factory RegisterFormEvent.fullnameChanged(String fullnameStr) =
      _FullnameChanged;
  const factory RegisterFormEvent.registerWithEmailAndPasswordPressed() =
      _RegisterWithEmailAndPasswordPressed;
}
