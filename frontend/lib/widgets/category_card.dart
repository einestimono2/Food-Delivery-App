import 'package:flutter/material.dart';

import '../models/models.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.035),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.network(
                category.image,
              ),
              Spacer(),
              Text(
                category.name,
                style: Theme.of(context).textTheme.headline5!,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
