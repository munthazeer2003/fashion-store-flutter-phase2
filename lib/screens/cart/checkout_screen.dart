import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../core/mvvm/view_model_builder.dart';
import '../../models/payment_method_model.dart';
import '../../view_models/checkout_view_model.dart';
import '../../view_models/payment_methods_view_model.dart';
import '../widgets/empty_state.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const Color _accent = Color(0xFFF26B3A);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF7A7A7A);
  static const Color _cardBorder = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>(
      create: (_) => CheckoutViewModel(),
      builder: (context, viewModel, child) {
        Future.microtask(viewModel.loadCheckout);
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
              'Checkout',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _InfoCard(
                leading: const Icon(Icons.location_on_outlined, color: _accent),
                title: viewModel.shippingTitle,
                subtitle: viewModel.shippingSubtitle,
                onEdit: () async {
                  await Navigator.pushNamed(context, AppRoutes.shippingAddress);
                  await viewModel.loadCheckout(forceRefresh: true);
                },
              ),
              const SizedBox(height: 18),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _InfoCard(
                leading: const Icon(
                  Icons.credit_card,
                  color: _accent,
                  size: 18,
                ),
                title: viewModel.paymentTitle,
                subtitle: viewModel.paymentSubtitle,
                onEdit: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentMethodsScreen(),
                    ),
                  );
                  await viewModel.loadCheckout(forceRefresh: true);
                },
              ),
              const SizedBox(height: 18),
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (viewModel.errorMessage != null) ...[
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(height: 10),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Subtotal', value: viewModel.subtotal),
                    const SizedBox(height: 10),
                    _SummaryRow(label: 'Shipping', value: viewModel.shipping),
                    const SizedBox(height: 10),
                    _SummaryRow(label: 'Tax', value: viewModel.tax),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: CheckoutScreen._cardBorder),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Total',
                      value: viewModel.total,
                      highlight: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isBusy
                      ? null
                      : () async {
                          final orderId = await viewModel.placeOrder();
                          if (!context.mounted || orderId == null) {
                            return;
                          }
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.orderConfirmation,
                            arguments: orderId,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                      : Text('Place Order (${viewModel.total})'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onEdit,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CheckoutScreen._cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CheckoutScreen._accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: leading),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CheckoutScreen._textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: CheckoutScreen._textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: CheckoutScreen._accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: CheckoutScreen._accent,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: highlight
                ? CheckoutScreen._accent
                : CheckoutScreen._textMuted,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? CheckoutScreen._accent
                : CheckoutScreen._textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: highlight ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const Color _accent = Color(0xFFF26B3A);
  static const Color _textPrimary = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentMethodsViewModel>(
      create: (_) => PaymentMethodsViewModel(),
      builder: (context, viewModel, child) {
        Future.microtask(viewModel.loadPaymentMethods);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: _textPrimary),
            ),
            title: const Text(
              'Payment Methods',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _showPaymentSheet(context, viewModel),
                icon: const Icon(Icons.add, color: _textPrimary),
              ),
            ],
          ),
          body: viewModel.isBusy && viewModel.methods.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : viewModel.methods.isEmpty
              ? EmptyState(
                  title: 'No payment method',
                  message:
                      viewModel.errorMessage ??
                      'Add a payment method to use at checkout.',
                  actionLabel: 'Add Payment',
                  onAction: () => _showPaymentSheet(context, viewModel),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount:
                      viewModel.methods.length +
                      1 +
                      (viewModel.errorMessage == null ? 0 : 1),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _OnlinePaymentBanner(
                        onTap: () async {
                          final saved = await viewModel.addOnlinePayment();
                          if (!context.mounted || !saved) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Online payment selected'),
                            ),
                          );
                        },
                      );
                    }
                    if (viewModel.errorMessage != null && index == 1) {
                      return Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      );
                    }
                    final methodIndex = viewModel.errorMessage == null
                        ? index - 1
                        : index - 2;
                    final method = viewModel.methods[methodIndex];
                    return _PaymentMethodCard(
                      method: method,
                      onSelect: () => viewModel.setDefault(methodIndex),
                      onEdit: () => _showPaymentSheet(
                        context,
                        viewModel,
                        editIndex: methodIndex,
                      ),
                      onDelete: () =>
                          _confirmDelete(context, viewModel, methodIndex),
                    );
                  },
                ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PaymentMethodsViewModel viewModel,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Payment Method'),
          content: const Text('Remove this payment method?'),
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
      final deleted = await viewModel.removePaymentMethod(index);
      if (!context.mounted || !deleted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment method deleted')));
    }
  }

  Future<void> _showPaymentSheet(
    BuildContext context,
    PaymentMethodsViewModel viewModel, {
    int? editIndex,
  }) async {
    final index = editIndex;
    final isEdit = index != null;
    final item = isEdit ? viewModel.methods[index] : null;
    var paymentType = item?.type ?? 'card';
    final brandController = TextEditingController(text: item?.brand ?? '');
    final holderController = TextEditingController(
      text: item?.holderName ?? '',
    );
    final last4Controller = TextEditingController(text: item?.last4 ?? '');
    final expiryController = TextEditingController(text: item?.expiry ?? '');

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void selectType(String type) {
              setSheetState(() {
                paymentType = type;
                if (type == 'cash') {
                  brandController.text = 'Cash on Delivery';
                  holderController.text = 'Pay when your order arrives';
                  last4Controller.text = 'COD';
                  expiryController.clear();
                } else if (type == 'online') {
                  brandController.text = 'Online Payment';
                  holderController.text = 'Pay securely online';
                  last4Controller.text = 'ONLINE';
                  expiryController.clear();
                } else if (brandController.text == 'Cash on Delivery' ||
                    brandController.text == 'Online Payment') {
                  brandController.clear();
                  holderController.clear();
                  last4Controller.clear();
                  expiryController.clear();
                }
              });
            }

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
                            isEdit
                                ? 'Edit Payment Method'
                                : 'Add Payment Method',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context, false),
                          icon: const Icon(Icons.close, color: _textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _PaymentTypeChip(
                          label: 'Card',
                          selected: paymentType == 'card',
                          onTap: () => selectType('card'),
                        ),
                        const SizedBox(width: 8),
                        _PaymentTypeChip(
                          label: 'Online',
                          selected: paymentType == 'online',
                          onTap: () => selectType('online'),
                        ),
                        const SizedBox(width: 8),
                        _PaymentTypeChip(
                          label: 'COD',
                          selected: paymentType == 'cash',
                          onTap: () => selectType('cash'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _PaymentTextField(
                      controller: brandController,
                      icon: Icons.credit_card,
                      hintText: paymentType == 'card'
                          ? 'Brand (Visa, Mastercard)'
                          : 'Payment name',
                    ),
                    const SizedBox(height: 12),
                    _PaymentTextField(
                      controller: holderController,
                      icon: Icons.person_outline,
                      hintText: 'Card holder / payment note',
                    ),
                    const SizedBox(height: 12),
                    _PaymentTextField(
                      controller: last4Controller,
                      icon: Icons.pin_outlined,
                      hintText: paymentType == 'card'
                          ? 'Last 4 digits'
                          : 'Payment code',
                      keyboardType: paymentType == 'card'
                          ? TextInputType.number
                          : TextInputType.text,
                      maxLength: paymentType == 'card' ? 4 : null,
                    ),
                    const SizedBox(height: 12),
                    _PaymentTextField(
                      controller: expiryController,
                      icon: Icons.event_outlined,
                      hintText: 'Expiry (MM/YY)',
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(isEdit ? 'Save Changes' : 'Save Payment'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true) {
      final updated = PaymentMethodItem(
        id: item?.id ?? '',
        brand: brandController.text.trim().isEmpty
            ? 'Card'
            : brandController.text.trim(),
        holderName: holderController.text.trim().isEmpty
            ? 'Card Holder'
            : holderController.text.trim(),
        last4: last4Controller.text.trim(),
        expiry: expiryController.text.trim(),
        isDefault: item?.isDefault ?? viewModel.methods.isEmpty,
        type: paymentType,
      );
      final success = index == null
          ? await viewModel.addPaymentMethod(updated)
          : await viewModel.updatePaymentMethod(index, updated);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              index == null ? 'Payment method saved' : 'Payment method updated',
            ),
          ),
        );
      }
    }

    brandController.dispose();
    holderController.dispose();
    last4Controller.dispose();
    expiryController.dispose();
  }
}

class _OnlinePaymentBanner extends StatelessWidget {
  const _OnlinePaymentBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.payment, color: Color(0xFFF26B3A)),
      label: const Text('Add / Select Online Payment'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFF26B3A),
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFFF26B3A)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _PaymentTypeChip extends StatelessWidget {
  const _PaymentTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChoiceChip(
        label: Center(child: Text(label)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: const Color(0xFFF26B3A),
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  final PaymentMethodItem method;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.credit_card, color: Color(0xFFF26B3A)),
            title: Text(
              method.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(method.subtitle),
            trailing: IconButton(
              onPressed: onSelect,
              icon: Icon(
                method.isDefault
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: method.isDefault
                    ? const Color(0xFFF26B3A)
                    : Colors.black38,
              ),
            ),
            onTap: onSelect,
          ),
          const Divider(height: 16, color: Color(0xFFEDEDED)),
          Row(
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF26B3A),
                ),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentTextField extends StatelessWidget {
  const _PaymentTextField({
    required this.controller,
    required this.icon,
    required this.hintText,
    this.keyboardType,
    this.maxLength,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFFF26B3A)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF26B3A)),
        ),
      ),
    );
  }
}
