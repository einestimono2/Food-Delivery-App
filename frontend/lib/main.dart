import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/simple_bloc_observer.dart';

import 'blocs/blocs.dart';
import 'configs/configs.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await AppCache.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => CategoryRepository(),
        ),
        RepositoryProvider(
          create: (context) => DiscountRepository(),
        ),
        RepositoryProvider(
          create: (context) => RestaurantRepository(),
        ),
        RepositoryProvider(
          create: (context) => VoucherRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc()..add(LoadTheme()),
          ),
          BlocProvider(
            create: (context) => SignupBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SigninBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignoutBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              signinBloc: context.read<SigninBloc>(),
              signoutBloc: context.read<SignoutBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository: context.read<CategoryRepository>(),
            )..add(LoadCategories()),
          ),
          BlocProvider(
            create: (context) => DiscountBloc(
              discountRepository: context.read<DiscountRepository>(),
            )..add(LoadDiscounts()),
          ),
          BlocProvider(
            create: (context) => RestaurantBloc(
              restaurantRepository: context.read<RestaurantRepository>(),
            )..add(LoadRestaurants()),
          ),
          BlocProvider(
            create: (context) => VoucherBloc(
              voucherRepository: context.read<VoucherRepository>(),
            )..add(LoadVouchers()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Food Delivery App',
            theme: state.themeData,
            navigatorKey: AppRouter.navigatorKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          ),
        ),
      ),
    );
  }
}
