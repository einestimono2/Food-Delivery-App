import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/models.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({
    Key? key,
    required this.discount,
  }) : super(key: key);

  final Discount discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 8),
      // width: double.infinity,
      // height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            discount.image,
          ),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              kSecondaryColor.withOpacity(0.75),
              kPrimaryColor.withOpacity(0.75),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                discount.title,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 15),
              Text(
                discount.description,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
