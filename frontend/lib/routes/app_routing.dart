import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/explore_detail_screen.dart';
import '../screens/collection_page.dart';
import '../screens/profile_about_page.dart';

class AppRouting {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String explore = '/explore';
  static const String exploreDetail = '/explore-detail';
  static const String collection = '/collection';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case explore:
        return MaterialPageRoute(
          builder: (_) => const ExploreScreen(),
        );

      case exploreDetail:
        final product =
            settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ExploreDetailScreen(
            product: product,
          ),
        );

      case collection:
        return MaterialPageRoute(
          builder: (_) => const CollectionPage(),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileAboutPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Halaman tidak ditemukan'),
            ),
          ),
        );
    }
  }
}