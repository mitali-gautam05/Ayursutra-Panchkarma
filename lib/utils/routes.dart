import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';
import '../pages/form/patient_form_page.dart';

class AppRoutes {
  static const login = '/login';
  static const form = '/form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case form:
        final idToken = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => PatientFormPage(idToken: idToken));
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text("Page not found")),
                ));
    }
  }
}