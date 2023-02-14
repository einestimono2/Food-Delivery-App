import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/constants/variables.dart';
import 'package:frontend/screens/home/components/components.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => HomeScreen(),
      );

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListCategories(),
              ListDiscounts(),
              ListPopularRestaurants(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(index: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor.withOpacity(0.75),
        child: Icon(
          Icons.map_sharp,
          color: Colors.white70,
        ),
        onPressed: () => Navigator.pushNamed(context, MapScreen.routeName),
      ),
    );
  }
}
