import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF6F6F6F);
  static const Color _cardBorder = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const [
          _TextBlock(
            title: 'Terms of Service',
            body:
                'By using this app, you agree to our terms and conditions. Please read them carefully before using our services.',
          ),
          SizedBox(height: 16),
          _TextBlock(
            title: 'User Responsibilities',
            body:
                'You agree to use the app lawfully and provide accurate information when creating an account or placing an order.',
          ),
          SizedBox(height: 16),
          _TextBlock(
            title: 'Payments & Refunds',
            body:
                'All payments are processed securely. Refunds are handled according to our refund policy in the Help Center.',
          ),
          SizedBox(height: 16),
          _TextBlock(
            title: 'Service Updates',
            body:
                'We may update these terms at any time. Continued use of the app means you accept the latest changes.',
          ),
        ],
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TermsOfServiceScreen._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: TermsOfServiceScreen._textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: TermsOfServiceScreen._textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
