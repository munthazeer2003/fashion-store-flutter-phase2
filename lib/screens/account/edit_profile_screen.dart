import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../view_models/edit_profile_view_model.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static const Color _accent = Color(0xFFF26B3A);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF7A7A7A);
  static const Color _fieldBorder = Color(0xFFE7E7E7);

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
          'Edit Profile',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ViewModelBuilder<EditProfileViewModel>(
        create: (_) => EditProfileViewModel(),
        builder: (context, viewModel, child) {
          Future.microtask(viewModel.loadProfile);
          final Uint8List? selectedBytes = viewModel.selectedImageBytes;
          return viewModel.isBusy && viewModel.nameController.text.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    Center(
                      child: SizedBox(
                        width: 122,
                        height: 122,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _accent, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: const Color(0xFFF2F2F2),
                                  foregroundImage: selectedBytes == null
                                      ? const AssetImage(
                                          'assets/images/profile/profile.png',
                                        )
                                      : MemoryImage(selectedBytes),
                                  onForegroundImageError:
                                      (exception, stackTrace) {},
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 8,
                              child: InkWell(
                                onTap: () =>
                                    _showImagePickerSheet(context, viewModel),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _accent,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        color: _textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.nameController,
                      style: const TextStyle(color: _textPrimary),
                      decoration: _inputDecoration(
                        icon: Icons.person_outline,
                        accentColor: _accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Email',
                      style: TextStyle(
                        color: _textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.emailController,
                      style: const TextStyle(color: _textPrimary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        icon: Icons.email_outlined,
                        accentColor: _accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        color: _textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.phoneController,
                      style: const TextStyle(color: _textPrimary),
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        icon: Icons.phone_outlined,
                        accentColor: _accent,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (viewModel.errorMessage != null) ...[
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.isBusy
                            ? null
                            : () async {
                                final saved = await viewModel.saveChanges();
                                if (!context.mounted || !saved) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile saved successfully'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: viewModel.isBusy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  void _showImagePickerSheet(
    BuildContext context,
    EditProfileViewModel viewModel,
  ) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E1DE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Text(
                  'Change Profile Picture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _buildSheetTile(
                  icon: Icons.photo_camera_outlined,
                  label: 'Take Photo',
                  onTap: () async {
                    Navigator.pop(context);
                    await viewModel.pickImage(ImageSource.camera);
                  },
                ),
                const Divider(height: 1, color: Color(0xFFEDEDED)),
                _buildSheetTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Choose from Gallery',
                  onTap: () async {
                    Navigator.pop(context);
                    await viewModel.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required IconData icon,
    required Color accentColor,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: accentColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accentColor),
      ),
    );
  }

  Widget _buildSheetTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: _accent),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black45),
      onTap: onTap,
    );
  }
}
