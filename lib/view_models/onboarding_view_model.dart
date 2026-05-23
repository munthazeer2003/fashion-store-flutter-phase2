import 'package:flutter/material.dart';
import '../core/mvvm/base_view_model.dart';

class OnboardingViewModel extends BaseViewModel {
  final PageController controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/banners/banner_1.jpg',
      'title': 'Discover Latest Trends',
      'subtitle':
          'Explore the newest fashion trends and find your unique style',
    },
    {
      'image': 'assets/images/banners/banner_2.jpg',
      'title': 'Choose Your Style',
      'subtitle': 'Select from a wide range of clothing, shoes and accessories',
    },
    {
      'image': 'assets/images/banners/banner_1.jpg',
      'title': 'Fast & Easy Shopping',
      'subtitle': 'Add to cart and enjoy a smooth shopping experience',
    },
  ];

  int get currentIndex => _currentIndex;

  bool get isLastPage => _currentIndex == pages.length - 1;

  String get buttonLabel => isLastPage ? 'Get Started' : 'Next';

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> nextPage() async {
    await controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
