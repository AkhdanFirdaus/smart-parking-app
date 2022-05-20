import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_parking/application/auth/register_form/register_form_bloc.dart';
import 'package:smart_parking/injection.dart';
import 'package:smart_parking/presentation/auth/register/widgets/register_form_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => getIt<RegisterFormBloc>(),
          child: const RegisterFormWidget(),
        ),
      ),
    );
  }
}
