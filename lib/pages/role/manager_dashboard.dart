import 'package:flutter/material.dart';
import 'package:ayursutra_app/utils/app_theme.dart';
import 'package:ayursutra_app/utils/routes.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement AuthProvider.signOut()
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_outlined, size: 80, color: AppTheme.accentColor),
            const SizedBox(height: 20),
            Text(
              'Welcome, Manager!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                label: const Text('View Analytics', style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  // Navigate to a dedicated analytics page or report list
                  Navigator.of(context).pushNamed(AppRoutes.reportList);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  minimumSize: const Size(double.infinity, 60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}