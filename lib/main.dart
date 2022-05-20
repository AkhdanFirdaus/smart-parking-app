import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_parking/injection.dart';
import 'package:smart_parking/presentation/core/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.prod);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(AppWidget());
}
