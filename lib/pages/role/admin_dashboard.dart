import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ayursutra_app/utils/app_theme.dart';
import 'package:ayursutra_app/utils/routes.dart';
// import 'package:ayursutra_app/providers/auth_provider.dart'; // Needed for actual logout/user info

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // TODO: Implement AuthProvider.signOut() for actual sign out
              // Navigates back to the login page and clears the navigation stack
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Admin Icon and Welcome Text
              Icon(Icons.security, size: 80, color: AppTheme.accentColor),
              const SizedBox(height: 10),
              Text(
                'Welcome, System Admin',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 50),
              
              // --- Dashboard Actions Grid ---
              Wrap(
                spacing: 20, // Horizontal space between cards
                runSpacing: 20, // Vertical space between rows
                alignment: WrapAlignment.center,
                children: [
                  // 1. Manage Users Button
                  _buildDashboardCard(
                    context,
                    icon: Icons.people_alt,
                    title: 'Manage Users',
                    description: 'Add, edit, or remove doctors and managers.',
                    onTap: () {
                      // Placeholder for user management page
                      // Navigator.of(context).pushNamed(AppRoutes.userManagement);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigation to User Management (Feature coming soon!)')),
                      );
                    },
                  ),
                  
                  // 2. View System Analytics Button (Routes to Report List)
                  _buildDashboardCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'View System Reports',
                    description: 'Access consolidated reports and analytics.',
                    onTap: () {
                      // Navigates to the shared Report List Page
                      Navigator.of(context).pushNamed(AppRoutes.reportList);
                    },
                  ),
                  
                  // 3. Configure Settings Button
                  _buildDashboardCard(
                    context,
                    icon: Icons.settings,
                    title: 'Configure Settings',
                    description: 'Update application and database settings.',
                    onTap: () {
                      // Placeholder for settings page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigation to Settings (Feature coming soon!)')),
                      );
                    },
                  ),

                   // 4. View Audit Log Button
                  _buildDashboardCard(
                    context,
                    icon: Icons.fact_check,
                    title: 'View Audit Logs',
                    description: 'Track all user and system activities.',
                    onTap: () {
                      // Placeholder for audit logs page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigation to Audit Logs (Feature coming soon!)')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to create a consistent dashboard card style
  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    // Determine screen width for responsive layout
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: isMobile ? 320 : 250, // Wider card on mobile, fixed width on desktop
          height: 180,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 40,
                color: AppTheme.primaryColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryText.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}