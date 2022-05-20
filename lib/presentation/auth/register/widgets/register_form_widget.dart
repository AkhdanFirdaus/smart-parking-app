import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_parking/application/auth/auth_bloc.dart';
import 'package:smart_parking/application/auth/register_form/register_form_bloc.dart';
import 'package:smart_parking/presentation/routes/app_router.dart';

class RegisterFormWidget extends StatelessWidget {
  const RegisterFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterFormBloc, RegisterFormState>(
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
                      .read<RegisterFormBloc>()
                      .add(RegisterFormEvent.fullnameChanged(value));
                },
                validator: (_) {
                  return context
                      .read<RegisterFormBloc>()
                      .state
                      .fullname
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          empty: (_) => 'Nama tidak boleh kosong',
                          multiline: (_) => 'Tidak boleh lebih dari 1 baris',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                textInputAction: TextInputAction.continueAction,
                decoration: const InputDecoration(
                  hintText: 'Nama',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  context
                      .read<RegisterFormBloc>()
                      .add(RegisterFormEvent.fullnameChanged(value));
                },
                validator: (_) {
                  return context
                      .read<RegisterFormBloc>()
                      .state
                      .phone
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          empty: (_) => 'Telpon tidak boleh kosong',
                          multiline: (_) => 'Tidak boleh lebih dari 1 baris',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                textInputAction: TextInputAction.continueAction,
                decoration: const InputDecoration(
                  hintText: 'No. HP',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  context
                      .read<RegisterFormBloc>()
                      .add(RegisterFormEvent.addressChanged(value));
                },
                validator: (_) {
                  return context
                      .read<RegisterFormBloc>()
                      .state
                      .address
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          empty: (_) => 'Alamat tidak boleh kosong',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                textInputAction: TextInputAction.continueAction,
                decoration: const InputDecoration(
                  hintText: 'Alamat',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  context
                      .read<RegisterFormBloc>()
                      .add(RegisterFormEvent.emailChanged(value));
                },
                validator: (_) {
                  return context
                      .read<RegisterFormBloc>()
                      .state
                      .emailAddress
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          invalidEmail: (_) =>
                              'Alamat Email tidak boleh kosong',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                autocorrect: false,
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
                      .read<RegisterFormBloc>()
                      .add(RegisterFormEvent.passwordChanged(value));
                },
                validator: (_) {
                  return context
                      .read<RegisterFormBloc>()
                      .state
                      .password
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          empty: (_) => 'Password tidak boleh kosong',
                          shortPassword: (_) => 'Password terlalu pendek',
                          orElse: () => null,
                        ),
                        (r) => null,
                      );
                },
                obscureText: true,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.router.replace(const LoginRoute());
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Belum memiliki akun?',
                    style: TextStyle(color: Colors.blueGrey),
                    children: [
                      TextSpan(
                        text: ' Daftar',
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
