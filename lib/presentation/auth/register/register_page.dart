import 'package:flutter/material.dart';
import 'package:smart_parking/presentation/routes/app_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: ListView(
            children: [
              const Text('Register'),
              const SizedBox(height: 16),
              TextFormField(
                textInputAction: TextInputAction.continueAction,
                decoration: const InputDecoration(
                  hintText: 'Nama',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.continueAction,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
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
                  context.router.replace(const RegisterRoute());
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
        ),
      ),
    );
  }
}
