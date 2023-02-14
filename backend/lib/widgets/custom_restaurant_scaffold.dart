import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../screens/screens.dart';

class CustomRestaurantScaffold extends StatelessWidget {
  const CustomRestaurantScaffold({
    super.key,
    required this.restaurantName,
    required this.route,
    required this.body,
  });

  final Widget body;
  final String route;
  final String restaurantName;

  void _switchScreen(BuildContext context, String route) {
    if (route == this.route) return;

    switch (route) {
      case MenuScreen.routeName:
        Navigator.pushNamed(context, MenuScreen.routeName);
        break;
      case SettingsScreen.routeName:
        Navigator.pushNamed(context, SettingsScreen.routeName);
        break;
      case RestaurantScreen.routeName:
        Navigator.pushReplacementNamed(context, RestaurantScreen.routeName);
        break;

      // default:
    }
  }

  final List<AdminMenuItem> _adminMenuItems = const [
    AdminMenuItem(
      title: 'User Profile',
      icon: Icons.account_circle,
      route: '/',
    ),
    AdminMenuItem(
      title: 'Settings',
      icon: Icons.settings,
      route: '/',
    ),
    AdminMenuItem(
      title: 'Logout',
      icon: Icons.logout,
      route: '/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          restaurantName,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<AdminMenuItem>(
            position: PopupMenuPosition.under,
            child: const Icon(
              Icons.account_circle,
              size: 44,
            ),
            itemBuilder: (context) {
              return _adminMenuItems
                  .map(
                    (AdminMenuItem item) => PopupMenuItem<AdminMenuItem>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(item.icon, color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList();
            },
            onSelected: (item) {
              print(
                  'actions: onSelected(): title = ${item.title}, route = ${item.route}');
              // Navigator.of(context).pushNamed(item.route!);
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      sideBar: SideBar(
        textStyle: const TextStyle(fontSize: 15),
        activeTextStyle: const TextStyle(fontSize: 15),
        activeBackgroundColor: const Color.fromARGB(255, 223, 216, 216),
        items: const [
          AdminMenuItem(
            title: 'Go Back',
            icon: Icons.arrow_back,
            route: RestaurantScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Order',
            icon: Icons.category,
            route: "",
          ),
          AdminMenuItem(
            title: 'Menu',
            icon: Icons.food_bank,
            route: MenuScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Settings',
            route: SettingsScreen.routeName,
            icon: Icons.settings,
          ),
        ],
        selectedRoute: route,
        onSelected: (item) {
          if (item.route != null) {
            _switchScreen(context, item.route!);
          }
        },
      ),
      body: body,
    );
  }
}
