import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const [
          _TextBlock(
            title: 'Information We Collect',
            body:
                'We collect information that you provide directly to us, including name, email address, and shipping information.',
          ),
          SizedBox(height: 16),
          _TextBlock(
            title: 'How We Use Your Information',
            body:
                'We use the information we collect to provide, maintain, and improve our services, process your transactions, and send you updates.',
          ),
          SizedBox(height: 16),
          _TextBlock(
            title: 'Information We Collect',
            body:
                'We collect information that you provide directly to us, including name, email address, and shipping information.',
          ),
          SizedBox(height: 16),
          _TextBlock(
            title: 'Information We Collect',
            body:
                'We collect information that you provide directly to us, including name, email address, and shipping information.',
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
        border: Border.all(color: PrivacyPolicyScreen._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: PrivacyPolicyScreen._textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: PrivacyPolicyScreen._textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
