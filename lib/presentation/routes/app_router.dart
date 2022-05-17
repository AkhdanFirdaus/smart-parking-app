import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/presentation/splash/splash_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: SplashPage),
  ],
)
class AppRouter extends _$AppRouter {}
