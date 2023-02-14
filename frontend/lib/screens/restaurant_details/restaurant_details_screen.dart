import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  static const String routeName = '/restaurant-details';
  static Route route({required Restaurant restaurant}) {
    return MaterialPageRoute(
      builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
      settings: RouteSettings(name: routeName),
    );
  }

  const RestaurantDetailsScreen({Key? key, required this.restaurant})
      : super(key: key);

  final Restaurant restaurant;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with SingleTickerProviderStateMixin {
  var _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
          _customSliverAppBar(widget.restaurant),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.restaurant.name,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TagForm(tags: widget.restaurant.tags),
                  SizedBox(height: 5),
                  Text(
                    '0.1 km away - \$3.99 delivery fee',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Restaurant Information',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.restaurant.description ?? "",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              tabs: <Widget>[
                Tab(text: "Products"),
                Tab(text: "Reviews"),
              ],
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildRestaurantProducts(widget.restaurant),
            _buildRestaurantReviews(),
          ],
        ),
      ),
    );
  }

  Container _buildRestaurantProducts(Restaurant restaurant) {
    if (restaurant.categories == null ||
        restaurant.categories!.isEmpty ||
        restaurant.products == null ||
        restaurant.products!.isEmpty) {
      return Container(
        child: Text("Rỗng"),
      );
    } else {
      Map<Category, List<Product>> map = {};

      restaurant.categories!.forEach(
        (e) {
          map[e] = restaurant.products!
              .where((element) => element.category == e.id)
              .toList();
        },
      );

      return Container(
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 30),
          itemCount: map.length,
          itemBuilder: (context, index) {
            Category key = restaurant.categories![index];
            List<Product>? values = map[restaurant.categories![index]];
            values!.sort((a, b) => a.name.compareTo(b.name));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    key.name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                SizedBox(height: 10),
                ...values
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ListTile(
                          leading: Image.network(
                            fit: BoxFit.fill,
                            e.image,
                            width: 60,
                            height: double.maxFinite,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              e.name,
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            e.description,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                if (index == map.length - 1) SizedBox(height: 50)
              ],
            );
          },
        ),
      );
    }
  }

  Container _buildRestaurantReviews() => Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("TEST"),
            Text("TEST"),
            Text("TEST"),
            Text("TEST"),
          ],
        ),
      );

  SliverAppBar _customSliverAppBar(Restaurant restaurant) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 200,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.favorite_sharp,
              size: 18,
              color: Colors.pink,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 12),
          ),
          items: restaurant.images
              .map(
                (e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(22),
                      // Radius.elliptical(
                      //   AppSize.screenWidth,
                      //   AppSize.screenHeight / 10,
                      // ),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(e),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
