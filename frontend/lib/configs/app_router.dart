import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/screens/screens.dart';

import '../models/models.dart';

class AppRouter {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Route onGenerateRoute(RouteSettings settings) {
    print('Current route: ${settings.name}');

    switch (settings.name) {
      case SplashScreen.routeName:
        return SplashScreen.route();

      case OnboardingScreen.routeName:
        return OnboardingScreen.route();

      case AuthScreen.routeName:
        final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;
        return AuthScreen.route(signUp: arguments['signUp'] ?? false);

      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();

      case OTPScreen.routeName:
        final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;
        return OTPScreen.route(
            resetPassword: arguments['resetPassword'] ?? false);

      case "/home":
      case HomeScreen.routeName:
        return HomeScreen.route();

      case MapScreen.routeName:
        return MapScreen.route();

      case ProfileScreen.routeName:
        return ProfileScreen.route();

      case FilterScreen.routeName:
        return FilterScreen.route();

      case OrderScreen.routeName:
        return OrderScreen.route();

      case VoucherScreen.routeName:
        return VoucherScreen.route();

      case CheckoutScreen.routeName:
        return CheckoutScreen.route();

      case RestaurantDetailsScreen.routeName:
        return RestaurantDetailsScreen.route(
            restaurant: settings.arguments as Restaurant,
            );

      // case TaskDetailsScreen.routeName:
      //   return TaskDetailsScreen.route(id: settings.arguments as String);

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() => MaterialPageRoute(
        settings: const RouteSettings(name: "/error"),
        builder: (context) => Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/404_Error.png",
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: AppSize.screenHeight * 0.15,
                left: AppSize.screenWidth * 0.3,
                right: AppSize.screenWidth * 0.3,
                child: FloatingActionButton.extended(
                  backgroundColor: Color(0xFF6B92F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  label: Text(
                    "GO BACK",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
