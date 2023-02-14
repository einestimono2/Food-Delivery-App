import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../screens/screens.dart';

class CustomAdminScaffold extends StatelessWidget {
  const CustomAdminScaffold({
    Key? key,
    required this.route,
    required this.body,
  }) : super(key: key);

  final Widget body;
  final String route;

  void _switchScreen(BuildContext context, String route) {
    if (route == this.route) return;

    switch (route) {
      case DashboardScreen.routeName:
        Navigator.pushNamed(context, DashboardScreen.routeName);
        break;
      case RestaurantScreen.routeName:
        Navigator.pushNamed(context, RestaurantScreen.routeName);
        break;
      case AddRestaurantScreen.routeName:
        Navigator.pushNamed(context, AddRestaurantScreen.routeName);
        break;
      case CategoryScreen.routeName:
        Navigator.pushNamed(context, CategoryScreen.routeName);
        break;
      case DiscountScreen.routeName:
        Navigator.pushNamed(context, DiscountScreen.routeName);
        break;
      case VoucherScreen.routeName:
        Navigator.pushNamed(context, VoucherScreen.routeName);
        break;
      case UserScreen.routeName:
        Navigator.pushNamed(context, UserScreen.routeName);
        break;

      default:
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
        title: InkWell(
          onTap: () => _switchScreen(context, DashboardScreen.routeName),
          child: Text(
            "FOOD DELIVERY - ADMIN",
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.white),
          ),
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
            title: 'Dashboard',
            route: DashboardScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Category',
            icon: Icons.category,
            route: CategoryScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Restaurant',
            icon: Icons.food_bank,
            children: [
              AdminMenuItem(
                title: 'Add',
                icon: Icons.add_circle,
                route: AddRestaurantScreen.routeName,
              ),
              AdminMenuItem(
                title: 'All Restaurants',
                icon: Icons.list_sharp,
                route: RestaurantScreen.routeName,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'User',
            route: UserScreen.routeName,
            icon: Icons.person,
          ),
          AdminMenuItem(
            title: 'Discount',
            route: DiscountScreen.routeName,
            icon: Icons.production_quantity_limits_outlined,
          ),
          AdminMenuItem(
            title: 'Voucher',
            route: VoucherScreen.routeName,
            icon: Icons.discount,
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
