import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/constants/constants.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.screenHeight * 0.08,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(
              Theme.of(context).brightness == Brightness.light ? 0.25 : 0.08,
            ),
            offset: Offset(
              0,
              -5,
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildItemNavBar(context, Icons.home, "Home", 0, '/'),
            _buildItemNavBar(context, Icons.search, "Search", 1, '/search'),
            Spacer(),
            _buildItemNavBar(
                context, Icons.shopping_bag_outlined, "Orders", 2, '/orders'),
            _buildItemNavBar(context, Icons.person, "Profile", 3, '/profile'),
          ],
        ),
      ),
    );
  }

  Expanded _buildItemNavBar(
    BuildContext context,
    IconData icon,
    String label,
    int itemIndex,
    String routeName,
  ) {
    return Expanded(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, routeName),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                icon,
                color: index == itemIndex
                    ? kPrimaryColor
                    : Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
              ),
            ),
            index == itemIndex
                ? Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
