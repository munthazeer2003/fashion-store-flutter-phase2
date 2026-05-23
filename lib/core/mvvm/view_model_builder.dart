import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelBuilder<T extends ChangeNotifier> extends StatelessWidget {
  const ViewModelBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.child,
  });

  final T Function(BuildContext context) create;
  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: create,
      child: Consumer<T>(builder: builder, child: child),
    );
  }
}
