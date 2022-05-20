import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_parking/application/auth/auth_bloc.dart';
import 'package:smart_parking/application/auth/login_form/login_form_bloc.dart';
import 'package:smart_parking/presentation/routes/app_router.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    failure.map(
                      cancelledByUser: (_) => 'Cancelled',
                      serverError: (_) => 'Server Error',
                      emailAlreadyInUse: (_) => 'Email already in use',
                      invalidEmailAndPasswordCombination: (_) =>
                          'Invalid email an password combination',
                      unexpected: (_) =>
                          'Unexpected Error Occured. Please Contact Support',
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            (_) {
              // TODO: Ke halaman utama
              context
                  .read<AuthBloc>()
                  .add(const AuthEvent.authCheckRequested());
            },
          ),
        );
      },
      buildWhen: (previous, current) =>
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              const Text('Register'),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  context
                      .read<LoginFormBloc>()
                      .add(LoginFormEvent.emailChanged(value));
                },
                validator: (_) {
                  return context
                      .read<LoginFormBloc>()
                      .state
                      .emailAddress
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          invalidEmail: (_) => 'Invalid Email',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.continueAction,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  context
                      .read<LoginFormBloc>()
                      .add(LoginFormEvent.passwordChanged(value));
                },
                validator: (_) {
                  return context
                      .read<LoginFormBloc>()
                      .state
                      .password
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          empty: (_) => 'Invalid Password',
                          shortPassword: (_) => 'Password is too short',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login with Google'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.router.replace(const RegisterRoute());
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Sudah memiliki akun?',
                    style: TextStyle(color: Colors.blueGrey),
                    children: [
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
