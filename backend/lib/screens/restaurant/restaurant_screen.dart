import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/blocs.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class RestaurantScreen extends StatefulWidget {
  static const String routeName = "/restaurants";
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  bool deleteEvent = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<RestaurantBloc>(context).add(LoadRestaurants());
  }

  _deleteRestaurant(Restaurant restaurant) {
    setState(() {
      deleteEvent = true;
    });

    context
        .read<RestaurantBloc>()
        .add(DeleteRestaurant(restaurant: restaurant));
  }

  _updateRestaurantPopular(Restaurant restaurant) {
    context.read<RestaurantBloc>().add(UpdatePopular(
          restaurantID: restaurant.id!,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdminScaffold(
      route: RestaurantScreen.routeName,
      body: BlocConsumer<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantError) {
            showSnackBar(context, state.message);
            setState(() {
              deleteEvent = false;
            });
            BlocProvider.of<RestaurantBloc>(context).add(
              LoadRestaurants(),
            );
          }

          // Show snack bar -- event delete
          if (deleteEvent && state is RestaurantLoaded) {
            showSnackBar(context, "Deleted the restaurant!");
            setState(() {
              deleteEvent = false;
            });
          }
        },
        builder: (context, state) {
          if (state is RestaurantLoading || state is RestaurantInitial) {
            return const CustomLoading();
          } else if (state is RestaurantLoaded) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.03,
                    bottom: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.5)),
                    ),
                    child: Text(
                      "Restaurants",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.025,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(0.7),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                          7: IntrinsicColumnWidth(flex: 0.6),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          _buildHeader(),
                          ...state.restaurants
                              .map((restaurant) => _buildRow(restaurant))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                "Something went wrong!",
                style: Theme.of(context).textTheme.headline2,
              ),
            );
          }
        },
      ),
    );
  }

  Container _buildCell(String title, bool header, {int? maxLines}) {
    final TextStyle headerText = Theme.of(context).textTheme.headline3!;
    final TextStyle cellText = Theme.of(context)
        .textTheme
        .headline4!
        .copyWith(fontWeight: FontWeight.normal);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: header ? headerText : cellText,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      ),
    );
  }

  _buildHeader() => TableRow(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
        ),
        children: <Widget>[
          _buildCell("ID", true),
          _buildCell("Image", true),
          _buildCell("Name", true),
          _buildCell("Description", true),
          _buildCell("Address", true),
          _buildCell("Tags", true),
          _buildCell("Categories", true),
          _buildCell("Actions", true),
        ],
      );

  TableRow _buildRow(Restaurant restaurant) => TableRow(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.025),
        ),
        children: <Widget>[
          InkWell(
            onTap: () async {
              // Save restaurant id
              SharedPreferences.getInstance().then(
                (value) =>
                    value.setString('RESTAURANT_DETAILS', restaurant.id!),
              );

              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(
                context,
                MenuScreen.routeName,
              );
            },
            child: _buildCell(restaurant.id!, false),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: AspectRatio(
              aspectRatio: 2 / 0.75,
              child: Image.network(restaurant.images[0], fit: BoxFit.contain),
            ),
          ),
          _buildCell(restaurant.name, false),
          _buildCell(restaurant.description ?? "-", false, maxLines: 3),
          _buildCell(restaurant.address.name!, false),
          _buildCell(restaurant.tags.join(", "), false),
          _buildCell(
            restaurant.categories == null
                ? "-"
                : restaurant.categories!.map((e) => e.name).join(', '),
            false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                splashRadius: 26,
                onPressed: () => _updateRestaurantPopular(restaurant),
                icon: Icon(
                  restaurant.isPopular
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: restaurant.isPopular ? Colors.blue : Colors.grey,
                ),
              ),
              IconButton(
                splashRadius: 26,
                onPressed: () => _deleteRestaurant(restaurant),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.withOpacity(0.9),
                ),
              ),
            ],
          )
        ],
      );
}
