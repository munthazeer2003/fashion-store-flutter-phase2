import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../view_models/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>(
      create: (_) => SplashViewModel(),
      builder: (context, viewModel, child) {
        viewModel.startOnce(() {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        });
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF7A18), // orange top
                  Color(0xFFFFB347), // peach bottom
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 42,
                            color: Color(0xFFF26B3A),
                          ),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'FASHION',
                          style: TextStyle(
                            fontSize: 22,
                            letterSpacing: 6,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'STORE',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Text(
                        'Alive Meets Simplicity',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
