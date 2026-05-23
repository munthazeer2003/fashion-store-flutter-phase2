import 'package:flutter/material.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../models/address_model.dart';
import '../../view_models/shipping_address_view_model.dart';
import '../widgets/empty_state.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  static const Color _pageBackground = Colors.white;
  static const Color _accent = Color(0xFFF26B3A);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF7A7A7A);
  static const Color _cardBorder = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShippingAddressViewModel>(
      create: (_) => ShippingAddressViewModel(),
      builder: (context, viewModel, child) {
        Future.microtask(viewModel.loadAddresses);
        return Scaffold(
          backgroundColor: ShippingAddressScreen._pageBackground,
          appBar: AppBar(
            backgroundColor: ShippingAddressScreen._pageBackground,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: ShippingAddressScreen._textPrimary,
              ),
            ),
            title: const Text(
              'Shipping Address',
              style: TextStyle(
                color: ShippingAddressScreen._textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => _showAddressSheet(context, viewModel),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ShippingAddressScreen._cardBorder,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: ShippingAddressScreen._textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: viewModel.isBusy && viewModel.addresses.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : viewModel.addresses.isEmpty
              ? EmptyState(
                  title: 'No saved address',
                  message:
                      viewModel.errorMessage ??
                      'Add a shipping address to use at checkout.',
                  actionLabel: 'Add Address',
                  onAction: () => _showAddressSheet(context, viewModel),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount:
                      viewModel.addresses.length +
                      (viewModel.errorMessage == null ? 0 : 1),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (viewModel.errorMessage != null && index == 0) {
                      return Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      );
                    }
                    final addressIndex = viewModel.errorMessage == null
                        ? index
                        : index - 1;
                    final address = viewModel.addresses[addressIndex];
                    return _AddressCard(
                      title: address.title,
                      isDefault: address.isDefault,
                      addressLine1: address.addressLine1,
                      addressLine2: address.addressLine2,
                      onEdit: () => _showAddressSheet(
                        context,
                        viewModel,
                        editIndex: addressIndex,
                      ),
                      onDelete: () =>
                          _confirmDelete(context, viewModel, addressIndex),
                    );
                  },
                ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ShippingAddressViewModel viewModel,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Remove this address from your list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final deleted = await viewModel.removeAddress(index);
      if (!context.mounted || !deleted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Address deleted')));
    }
  }

  Future<void> _showAddressSheet(
    BuildContext context,
    ShippingAddressViewModel viewModel, {
    int? editIndex,
  }) async {
    final index = editIndex;
    final isEdit = index != null;
    final item = isEdit ? viewModel.addresses[index] : null;
    var city = '';
    var stateZip = '';
    if (item != null) {
      final parts = item.addressLine2.split(',');
      city = parts.isNotEmpty ? parts.first.trim() : '';
      stateZip = parts.length > 1 ? parts.sublist(1).join(',').trim() : '';
    }

    final labelController = TextEditingController(text: item?.title ?? '');
    final addressController = TextEditingController(
      text: item?.addressLine1 ?? '',
    );
    final cityController = TextEditingController(text: city);
    final stateZipController = TextEditingController(text: stateZip);

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              24 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Address' : 'Add New Address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ShippingAddressScreen._textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(
                        Icons.close,
                        color: ShippingAddressScreen._textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _TextFieldTile(
                  icon: Icons.home_outlined,
                  hintText: 'Label (e.g., Home, Office)',
                  controller: labelController,
                ),
                const SizedBox(height: 12),
                _TextFieldTile(
                  icon: Icons.location_on_outlined,
                  hintText: 'Full Address',
                  controller: addressController,
                ),
                const SizedBox(height: 12),
                _TextFieldTile(
                  icon: Icons.location_city_outlined,
                  hintText: 'City',
                  controller: cityController,
                ),
                const SizedBox(height: 12),
                _TextFieldTile(
                  icon: Icons.map_outlined,
                  hintText: 'State & ZIP Code',
                  controller: stateZipController,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ShippingAddressScreen._accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(isEdit ? 'Save Changes' : 'Save Address'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (saved == true) {
      final line2Parts = <String>[];
      if (cityController.text.trim().isNotEmpty) {
        line2Parts.add(cityController.text.trim());
      }
      if (stateZipController.text.trim().isNotEmpty) {
        line2Parts.add(stateZipController.text.trim());
      }
      final updated = AddressItem(
        id: item?.id ?? '',
        title: labelController.text.trim().isEmpty
            ? 'Address'
            : labelController.text.trim(),
        isDefault: item?.isDefault ?? viewModel.addresses.isEmpty,
        addressLine1: addressController.text.trim(),
        addressLine2: line2Parts.join(', '),
      );
      final success = index == null
          ? await viewModel.addAddress(updated)
          : await viewModel.updateAddress(index, updated);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(index == null ? 'Address saved' : 'Address updated'),
          ),
        );
      }
    }

    labelController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateZipController.dispose();
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.title,
    required this.isDefault,
    required this.addressLine1,
    required this.addressLine2,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final bool isDefault;
  final String addressLine1;
  final String addressLine2;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ShippingAddressScreen._cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ShippingAddressScreen._pageBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: ShippingAddressScreen._accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ShippingAddressScreen._textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ShippingAddressScreen._accent.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      color: ShippingAddressScreen._accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            addressLine1,
            style: const TextStyle(color: ShippingAddressScreen._textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            addressLine2,
            style: const TextStyle(color: ShippingAddressScreen._textMuted),
          ),
          const SizedBox(height: 12),
          const Divider(height: 16, color: Color(0xFFEDEDED)),
          Row(
            children: [
              _InlineAction(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onEdit,
              ),
              const SizedBox(width: 24),
              _InlineAction(
                icon: Icons.delete_outline,
                label: 'Delete',
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: ShippingAddressScreen._accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: ShippingAddressScreen._accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldTile extends StatelessWidget {
  const _TextFieldTile({
    required this.icon,
    required this.hintText,
    required this.controller,
  });

  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: ShippingAddressScreen._textMuted),
        prefixIcon: Icon(icon, color: ShippingAddressScreen._accent),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ShippingAddressScreen._cardBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShippingAddressScreen._accent),
        ),
      ),
    );
  }
}
