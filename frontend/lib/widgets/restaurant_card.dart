import 'package:flutter/material.dart';

import '../configs/configs.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import 'widgets.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        RestaurantDetailsScreen.routeName,
        arguments: restaurant,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.03),
              spreadRadius: 3.0,
              blurRadius: 3.0,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: AppSize.screenWidth,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                      bottom: Radius.circular(5),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(restaurant.images[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    width: 60,
                    height: 30,
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '30 min',
                        style: Theme.of(context).textTheme.bodyText1!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.name,
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(height: 8),
                      TagForm(tags: restaurant.tags),
                      SizedBox(height: 5),
                      Text(
                        '0.1 km away - \$3.99 delivery fee',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 3),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
