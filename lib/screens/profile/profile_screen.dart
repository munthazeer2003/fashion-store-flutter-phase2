import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../view_models/account_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>(
      create: (_) => AccountViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFF2F2F2),
                  foregroundImage: AssetImage(viewModel.profileImage),
                  onForegroundImageError: (exception, stackTrace) {},
                  child: const Icon(
                    Icons.person,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  viewModel.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(viewModel.userEmail),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
