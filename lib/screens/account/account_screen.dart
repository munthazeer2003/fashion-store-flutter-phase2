import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../../view_models/account_view_model.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF26B3A);
    return ViewModelBuilder<AccountViewModel>(
      create: (_) => AccountViewModel(),
      builder: (context, viewModel, child) {
        Future.microtask(viewModel.loadProfile);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'My Account',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.settings),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: const Color(0xFFF2F2F2),
                            foregroundImage: AssetImage(viewModel.profileImage),
                            onForegroundImageError: (exception, stackTrace) {},
                            child: const Icon(
                              Icons.person,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            viewModel.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.userEmail,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                AppRoutes.editProfile,
                              );
                              await viewModel.loadProfile(forceRefresh: true);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildMenuTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'My Orders',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.myOrders),
                    ),
                    _buildMenuTile(
                      icon: Icons.location_on_outlined,
                      title: 'Shipping Address',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.shippingAddress,
                      ),
                    ),
                    _buildMenuTile(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.helpCenter),
                    ),
                    _buildMenuTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () => _showLogoutDialog(context, viewModel),
                      accentColor: accentColor,
                    ),
                  ],
                ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AccountViewModel viewModel) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE9E2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.logout, color: Color(0xFFF26B3A)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await viewModel.logout();
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF26B3A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color accentColor = const Color(0xFFF26B3A),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: accentColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: Colors.black38),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return AppBottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        AppNavigator.switchBottomTab(context, index);
      },
    );
  }
}
