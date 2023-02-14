import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';
import 'configs/app_scroll_behavior.dart';
import 'configs/theme.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => LocationRepository()),
        RepositoryProvider(create: (context) => RestaurantRepository()),
        RepositoryProvider(create: (context) => VoucherRepository()),
        RepositoryProvider(create: (context) => DiscountRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository: context.read<CategoryRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LocationBloc(
              locationRepository: context.read<LocationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AutocompleteBloc(
              locationRepository: context.read<LocationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RestaurantBloc(
              restaurantRepository: context.read<RestaurantRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(),
          ),
          BlocProvider(
            create: (context) => DiscountBloc(
              discountRepository: context.read<DiscountRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => VoucherBloc(
              voucherRepository: context.read<VoucherRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RestaurantDetailsBloc(
              restaurantRepository: context.read<RestaurantRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          scrollBehavior:
              AppScrollBehavior(), //! Fix PageView not swipeable on web
          debugShowCheckedModeBanner: false,
          title: 'FOOD DELIVERY - ADMIN',
          theme: theme(),
          initialRoute: DashboardScreen.routeName,
          onGenerateRoute: (settings) {
            final page = _getPageWidget(settings);
            if (page != null) {
              return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => page,
                  transitionsBuilder: (_, anim, __, child) {
                    return FadeTransition(
                      opacity: anim,
                      child: child,
                    );
                  });
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget? _getPageWidget(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }

    switch (Uri.parse(settings.name!).path) {
      case '/':
      case DashboardScreen.routeName:
        return const DashboardScreen();
      case RestaurantScreen.routeName:
        return const RestaurantScreen();
      case MenuScreen.routeName:
        return const MenuScreen();
      case SettingsScreen.routeName:
        return const SettingsScreen();
      case AddRestaurantScreen.routeName:
        return const AddRestaurantScreen();
      case CategoryScreen.routeName:
        return const CategoryScreen();
      case DiscountScreen.routeName:
        return const DiscountScreen();
      case VoucherScreen.routeName:
        return const VoucherScreen();
      case UserScreen.routeName:
        return const UserScreen();
    }
    return null;
  }
}
