import 'package:flutter/material.dart';
import 'package:frontend/widgets/widgets.dart';

class CheckoutScreen extends StatelessWidget {
  static const String routeName = "/checkout";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CheckoutScreen(),
      );
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Checkout"),
    );
  }
}
