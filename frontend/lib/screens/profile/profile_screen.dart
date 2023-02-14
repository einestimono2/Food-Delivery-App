import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/screens/profile/components/components.dart';
import 'package:frontend/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProfileScreen(),
      );

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ProfileForm(),
          SettingForm(),
        ],
      ),
      bottomNavigationBar: CustomNavBar(index: 3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor.withOpacity(0.5),
        child: Icon(
          Icons.map_sharp,
          color: Colors.white70,
        ),
        onPressed: () {},
      ),
    );
  }
}
