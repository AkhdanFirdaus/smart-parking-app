import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/presentation/auth/login/login_page.dart';
import 'package:smart_parking/presentation/auth/profile/profile_page.dart';
import 'package:smart_parking/presentation/auth/register/register_page.dart';
import 'package:smart_parking/presentation/splash/splash_page.dart';

export 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: LoginPage),
    AutoRoute(page: RegisterPage),
    AutoRoute(page: ProfilePage),
  ],
)
class AppRouter extends _$AppRouter {}
