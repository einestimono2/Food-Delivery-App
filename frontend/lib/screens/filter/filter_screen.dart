import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/widgets/widgets.dart';

class FilterScreen extends StatelessWidget {
  static const String routeName = "/filters";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => FilterScreen(),
      );

  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Filters",
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Done",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionTitle(
              title: "Category",
              expand: "Clear All",
              firstTitle: true,
              onTap: () {},
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                CategoryFilterCard(category: 'All'),
                ...Category.categories
                    .map((e) => CategoryFilterCard(category: e.name))
                    .toList(),
              ],
            ),
            SizedBox(height: 20),
            SectionTitle(
              title: "Price",
              expand: "Clear All",
              onTap: () {},
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                // state.filter.priceFilters[price.key].value
                //     ? Theme.of(context)
                //         .colorScheme
                //         .primary
                //         .withAlpha(100)
                //     : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '\$\$',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilterCard extends StatelessWidget {
  const CategoryFilterCard({Key? key, required this.category})
      : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          // state.filter.priceFilters[price.key].value
          // ? Theme.of(context)
          //     .colorScheme
          //     .primary
          //     .withAlpha(100)
          // : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          category,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
