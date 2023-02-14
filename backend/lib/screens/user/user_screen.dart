import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class UserScreen extends StatelessWidget {
  static const String routeName = "/users";
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomAdminScaffold(
      route: UserScreen.routeName,
      body: Center(child: Text("USER SCREEN")),
    );
  }
}
