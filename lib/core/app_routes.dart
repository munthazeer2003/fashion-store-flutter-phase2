import 'package:flutter/material.dart';
import '../models/product_model.dart';

// Onboarding
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

// Auth
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';

// Home & Products
import '../screens/home/home_screen.dart';
import '../screens/home/all_products_screen.dart';
import '../screens/home/shopping_screen.dart';
import '../screens/home/category_screen.dart';

// Cart & Orders
import '../screens/cart/cart_screen.dart';
import '../screens/cart/checkout_screen.dart';
import '../screens/cart/order_confirmation_screen.dart';

// Wishlist
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/product/product_list_screen.dart';

// Account
import '../screens/account/account_screen.dart';
import '../screens/account/edit_profile_screen.dart';
import '../screens/account/shipping_address_screen.dart';
import '../screens/account/my_orders_screen.dart';

// Settings & Support
import '../screens/settings/settings_screen.dart';
import '../screens/settings/notifications_screen.dart';
import '../screens/support/help_center_screen.dart';
import '../screens/support/privacy_policy_screen.dart';
import '../screens/support/terms_of_service_screen.dart';

class AppRoutes {
  // Splash
  static const splash = '/splash';

  // Onboarding
  static const onboarding = '/onboarding';

  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Home & Products
  static const home = '/home';
  static const shopping = '/shopping';
  static const allProducts = '/all-products';
  static const productDetails = '/product-details';
  static const productList = '/product-list';
  static const category = '/category';

  // Cart & Orders
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderConfirmation = '/order-confirmation';

  // Wishlist
  static const wishlist = '/wishlist';
  static const profile = '/profile';

  // Account
  static const account = '/account';
  static const editProfile = '/edit-profile';
  static const shippingAddress = '/shipping-address';
  static const myOrders = '/my-orders';

  // Settings & Support
  static const settings = '/settings';
  static const notifications = '/notifications';
  static const helpCenter = '/help-center';
  static const privacyPolicy = '/privacy-policy';
  static const termsOfService = '/terms-of-service';

  static Map<String, WidgetBuilder> routes = {
    // Splash
    splash: (_) => const SplashScreen(),

    // Onboarding
    onboarding: (_) => const OnboardingScreen(),

    // Auth
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),

    // Home & Products
    home: (_) => const HomeScreen(),
    shopping: (_) => const ShoppingScreen(),
    allProducts: (_) => const AllProductsScreen(),

    // Cart & Orders
    cart: (_) => const CartScreen(),
    checkout: (_) => const CheckoutScreen(),
    orderConfirmation: (_) => const OrderConfirmationScreen(),

    // Wishlist
    wishlist: (_) => const WishlistScreen(),
    profile: (_) => const AccountScreen(),

    // Account
    account: (_) => const AccountScreen(),
    editProfile: (_) => const EditProfileScreen(),
    shippingAddress: (_) => const ShippingAddressScreen(),
    myOrders: (_) => const MyOrdersScreen(),

    // Settings & Support
    settings: (_) => const SettingsScreen(),
    notifications: (_) => const NotificationsScreen(),
    helpCenter: (_) => const HelpCenterScreen(),
    privacyPolicy: (_) => const PrivacyPolicyScreen(),
    termsOfService: (_) => const TermsOfServiceScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productDetails:
        final product = settings.arguments;
        if (product is Product) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
            settings: settings,
          );
        }
        break;
      case productList:
        final title = settings.arguments;
        if (title is String) {
          return MaterialPageRoute(
            builder: (_) => ProductListScreen(title: title),
            settings: settings,
          );
        }
        break;
      case category:
        final categoryName = settings.arguments;
        if (categoryName is String) {
          return MaterialPageRoute(
            builder: (_) => CategoryScreen(categoryName: categoryName),
            settings: settings,
          );
        }
        break;
      default:
        break;
    }

    return MaterialPageRoute(
      builder: (_) => const _RouteNotFoundScreen(),
      settings: settings,
    );
  }
}

class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Not Found')),
      body: const Center(
        child: Text('This screen is not available yet.'),
      ),
    );
  }
}