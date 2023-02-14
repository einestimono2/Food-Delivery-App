import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/blocs.dart';
import '../../constants/show_snack_bar.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = "/restaurant/menu";
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0;
  late String id;

  @override
  void initState() {
    super.initState();

    _getRestaurant();
  }

  _getRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('RESTAURANT_DETAILS')!;

    // ignore: use_build_context_synchronously
    context.read<RestaurantDetailsBloc>().add(LoadRestaurant(restaurantID: id));
  }

  _addCategory(Restaurant restaurant) => showDialog(
        context: context,
        builder: (context) {
          return AddCategoryCard(restaurant: restaurant);
        },
      );

  _addProduct(List<Category>? categories, String restaurantID) {
    if (categories == null || categories.isEmpty) {
      return showSnackBar(
          context, "You have no categories. Please add category first!");
    }

    return showDialog(
      context: context,
      builder: (context) {
        return ProductCard(
          categories: categories,
          currentCategory: categories[selectedIndex],
          restaurantID: restaurantID,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
      listener: (context, state) {
        // if (state is RestaurantDetailsError) {
        //   context
        //       .read<RestaurantDetailsBloc>()
        //       .add(LoadRestaurant(restaurantID: id));
        // }
      },
      builder: (context, state) {
        if (state is RestaurantDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RestaurantDetailsLoaded) {
          return CustomRestaurantScaffold(
            restaurantName: state.currentRestaurant.name,
            route: MenuScreen.routeName,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _buildListCategories(state.currentRestaurant),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildListProducts(state.currentRestaurant),
                  ),
                ],
              ),
            ),
          );
        } else if (state is RestaurantDetailsError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("Something went wrong!"));
        }
      },
    );
  }

  _buildListCategories(Restaurant restaurant) => Column(
        children: [
          Row(
            children: [
              const Spacer(flex: 1),
              Text(
                "Categories",
                style: Theme.of(context).textTheme.headline2!,
              ),
              const Spacer(flex: 20),
              IconButton(
                splashRadius: 28,
                onPressed: () => _addCategory(restaurant),
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: (restaurant.categories == null ||
                    restaurant.categories!.isEmpty)
                ? _buildNoElement(
                    context: context,
                    headline: "You have no categories yet!",
                    textButton: "Add a category now",
                    onPressed: () => _addCategory(restaurant),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: restaurant.categories!.length,
                    itemBuilder: (context, index) {
                      Category category = restaurant.categories![index];
                      return _buildCategoryTile(
                        index: index,
                        category: category,
                        context: context,
                      );
                    },
                  ),
          ),
        ],
      );

  ListTile _buildCategoryTile({
    required index,
    required Category category,
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () => setState(() {
        selectedIndex = index;
      }),
      tileColor: index == selectedIndex ? Colors.black.withOpacity(0.08) : null,
      leading: Image.network(
        category.image!,
        height: 80,
        width: 60,
        fit: BoxFit.contain,
      ),
      title: Text(
        category.name,
        style: Theme.of(context).textTheme.headline3,
      ),
      subtitle: Text(
        category.description,
        style: Theme.of(context).textTheme.headline6,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () => context.read<RestaurantDetailsBloc>().add(
              DeleteRestaurantCategory(category: category),
            ),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  _buildListProducts(Restaurant restaurant) {
    List<Product>? products;
    Category? currentCategory;

    if (restaurant.categories == null || restaurant.categories!.isEmpty) {
    } else {
      currentCategory = restaurant.categories?[selectedIndex];

      products = restaurant.products
          ?.where((element) => element.category == currentCategory?.id)
          .toList();
    }

    return Column(
      children: [
        Row(
          children: [
            const Spacer(flex: 2),
            Text(
              "Dishs",
              style: Theme.of(context).textTheme.headline2!,
            ),
            const Spacer(flex: 20),
            IconButton(
              splashRadius: 28,
              onPressed: () =>
                  _addProduct(restaurant.categories, restaurant.id!),
              icon: const Icon(
                Icons.add,
                color: Colors.red,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: (products == null || products.isEmpty)
                ? _buildNoElement(
                    context: context,
                    headline:
                        '${currentCategory == null ? "You" : '\'${currentCategory.name}\''} have no dishs yet!',
                    textButton: "Add a dish now",
                    onPressed: () =>
                        _addProduct(restaurant.categories, restaurant.id!),
                  )
                : Wrap(
                    spacing: 30,
                    runSpacing: 25,
                    children: products
                        .map(
                          (e) =>
                              _buildProductCard(product: e, context: context),
                        )
                        .toList(),
                  ),
          ),
        ),
      ],
    );
  }

  Container _buildProductCard({
    required Product product,
    required BuildContext context,
  }) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black.withOpacity(0.03),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 215,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(product.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headline4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton<Widget>(
                    position: PopupMenuPosition.under,
                    child: const Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return <PopupMenuEntry<Widget>>[
                        PopupMenuItem<Widget>(
                          onTap: () => context
                              .read<RestaurantDetailsBloc>()
                              .add(
                                UpdateFeaturedProduct(productID: product.id!),
                              ),
                          child: Row(
                            children: [
                              Icon(
                                product.isFeatured
                                    ? Icons.favorite_outline
                                    : Icons.favorite,
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                product.isFeatured
                                    ? "Not Featured"
                                    : "Featured",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<Widget>(
                          onTap: () =>
                              context.read<RestaurantDetailsBloc>().add(
                                    DeleteRestaurantProduct(product: product),
                                  ),
                          child: Row(
                            children: const [
                              Icon(Icons.delete),
                              SizedBox(width: 12.0),
                              Text(
                                "Delete",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                  // InkWell(
                  //   onTap: () => Pop,
                  //   child: const Icon(Icons.more_vert),
                  // ),
                ],
              )
            ],
          ),
          if (product.isFeatured)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  "Featured",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '${product.price} \$',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center _buildNoElement({
    required BuildContext context,
    required String headline,
    required String textButton,
    Function()? onPressed,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            headline,
            style: Theme.of(context).textTheme.headline1!,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onPressed,
            child: Text(
              textButton,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class AddCategoryCard extends StatefulWidget {
  const AddCategoryCard({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  final Restaurant restaurant;

  @override
  State<AddCategoryCard> createState() => _AddCategoryCardState();
}

class _AddCategoryCardState extends State<AddCategoryCard> {
  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    categories = widget.restaurant.categories!;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const CustomLoading();
            } else if (state is CategoryLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: state.categories
                      .where(
                        (element) => !categories.contains(element),
                      )
                      .map(
                        (e) =>
                            _buildCategoryTile(category: e, context: context),
                      )
                      .toList(),
                ),
              );
            } else {
              return const Text("Something went wrong!");
            }
          },
        ),
      ),
    );
  }

  ListTile _buildCategoryTile({
    required Category category,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Image.network(
        category.image!,
        height: 80,
        width: 60,
        fit: BoxFit.contain,
      ),
      title: Text(
        category.name,
        style: Theme.of(context).textTheme.headline3,
      ),
      subtitle: Text(
        category.description,
        style: Theme.of(context).textTheme.headline6,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          context
              .read<RestaurantDetailsBloc>()
              .add(AddRestaurantCategory(category: category));

          setState(() {
            categories.add(category);
          });
        },
        icon: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}
