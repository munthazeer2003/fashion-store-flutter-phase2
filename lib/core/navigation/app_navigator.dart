import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../app_routes.dart';

class AppNavigator {
  static Future<dynamic> toProductDetails(
    BuildContext context,
    Product product,
  ) {
    return Navigator.pushNamed(
      context,
      AppRoutes.productDetails,
      arguments: product,
    );
  }

  static void switchBottomTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.shopping);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.wishlist);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
    }
  }
}
