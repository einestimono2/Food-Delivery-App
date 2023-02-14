import 'package:flutter/material.dart';
import 'package:frontend/blocs/auth/auth_bloc.dart';
import 'package:frontend/screens/screens.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/configs.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => SplashScreen(),
      );

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSize().init(context);

    final String link = Theme.of(context).brightness == Brightness.dark
        ? 'assets/images/foodies_logo_white.json'
        : 'assets/images/foodies_logo_black.json';

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          }

          if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }
        },
        child: Center(
          child: Lottie.asset(
            link,
            fit: BoxFit.cover,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().whenComplete(
                  () => BlocProvider.of<AuthBloc>(context).add(AuthStarted()),
                );
            },
          ),
        ),
      ),
    );
  }
}
