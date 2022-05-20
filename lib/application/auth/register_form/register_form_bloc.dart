import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_parking/domain/auth/auth_failure.dart';
import 'package:smart_parking/domain/auth/auth_value_objects.dart';
import 'package:smart_parking/domain/auth/i_auth_facade.dart';

part 'register_form_event.dart';
part 'register_form_state.dart';
part 'register_form_bloc.freezed.dart';

@injectable
class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  final IAuthFacade _authFacade;

  RegisterFormBloc(this._authFacade) : super(RegisterFormState.initial()) {
    on<RegisterFormEvent>((event, emit) async {
      await event.map(
        emailChanged: (e) async {
          emit(state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        passwordChanged: (e) async {
          emit(state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        phoneChanged: (e) async {
          emit(state.copyWith(
            phone: Phone(e.phoneStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        addressChanged: (e) async {
          emit(state.copyWith(
            address: Address(e.addressStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        fullnameChanged: (e) async {
          emit(state.copyWith(
            fullname: Fullname(e.fullnameStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        registerWithEmailAndPasswordPressed: (e) async {
          final isEmailValid = state.emailAddress.isValid();
          final isPasswordValid = state.password.isValid();

          if (isEmailValid && isPasswordValid) {
            emit(state.copyWith(
              isSubmitting: true,
              authFailureOrSuccessOption: none(),
            ));

            final failureOrSuccess =
                await _authFacade.registerWithEmailPassword(
              emailAddress: state.emailAddress,
              password: state.password,
              address: state.address,
              fullname: state.fullname,
              phone: state.phone,
            );

            // await _authFacade.storeGoogleUser();

            emit(state.copyWith(
              isSubmitting: false,
              authFailureOrSuccessOption: optionOf(failureOrSuccess),
            ));
          }
          emit(state.copyWith(
            showErrorMessages: true,
            authFailureOrSuccessOption: none(),
          ));
        },
      );
    });
  }
}
