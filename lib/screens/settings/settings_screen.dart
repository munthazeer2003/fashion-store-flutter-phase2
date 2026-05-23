import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../view_models/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);

    return ViewModelBuilder<SettingsViewModel>(
      create: (_) => SettingsViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _buildSectionTitle('Appearance'),
              _buildCard(
                child: _buildSwitchTile(
                  value: viewModel.darkMode,
                  onChanged: viewModel.setDarkMode,
                  icon: Icons.wb_sunny_outlined,
                  title: 'Dark Mode',
                  accentColor: accentColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Notifications'),
              _buildCard(
                child: Column(
                  children: [
                    _buildSwitchTile(
                      value: viewModel.pushNotifications,
                      onChanged: viewModel.setPushNotifications,
                      icon: Icons.notifications_none,
                      title: 'Push Notifications',
                      subtitle:
                          'Receive push notifications about orders and promotions',
                      accentColor: accentColor,
                    ),
                    const Divider(height: 1, color: Color(0xFFEDEDED)),
                    _buildSwitchTile(
                      value: viewModel.emailNotifications,
                      onChanged: viewModel.setEmailNotifications,
                      icon: Icons.email_outlined,
                      title: 'Email Notifications',
                      subtitle: 'Receive email updates about your orders',
                      accentColor: accentColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Privacy'),
              _buildCard(
                child: Column(
                  children: [
                    _buildNavigationTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'View our privacy policy',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                    ),
                    const Divider(height: 1, color: Color(0xFFEDEDED)),
                    _buildNavigationTile(
                      icon: Icons.assignment_outlined,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms of service',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.termsOfService,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('About'),
              _buildCard(
                child: _buildNavigationTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  onTap: () => _showAppVersionDialog(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAppVersionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Version'),
        content: const Text('Current version: 1.0.0'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }

  Widget _buildSwitchTile({
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required String title,
    String? subtitle,
    required Color accentColor,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: accentColor,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFE6E1DE),
      secondary: Icon(icon, color: Colors.black54, size: 20),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE9E1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFF26B3A), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.black45)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
