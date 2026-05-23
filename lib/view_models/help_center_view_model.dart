import 'package:flutter/material.dart';
import '../core/mvvm/base_view_model.dart';

class HelpCenterViewModel extends BaseViewModel {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
