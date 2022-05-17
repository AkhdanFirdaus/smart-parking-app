import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_parking/injection.dart';
import 'package:smart_parking/presentation/core/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
