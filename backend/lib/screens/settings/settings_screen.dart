import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/restaurant/settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String id;
  List<OpeningHours>? openingHoursList;

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

  _updateOpeningHours({required OpeningHours newOpeningHours}) {
    // Update
    openingHoursList = openingHoursList!.map((e) {
      return e.day == newOpeningHours.day ? newOpeningHours : e;
    }).toList();

    setState(() {});
  }

  _saveOpeningHours() {
    context.read<RestaurantDetailsBloc>().add(
          UpdateRestaurantOpeningHours(openingHours: openingHoursList!),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsBloc, RestaurantDetailsState>(
      builder: (context, state) {
        if (state is RestaurantDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RestaurantDetailsLoaded) {
          // Nếu openingHoursList null thì gán <=> khởi tạo 1 lần duy nhất
          openingHoursList ??= (state.currentRestaurant.openingHours == null ||
                  state.currentRestaurant.openingHours!.isEmpty)
              ? OpeningHours.openingHoursList
              : state.currentRestaurant.openingHours;

          return CustomRestaurantScaffold(
              restaurantName: state.currentRestaurant.name,
              route: SettingsScreen.routeName,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Restaurant Information",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 25,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text("Edit"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ImageSlider(
                                      images: state.currentRestaurant.images,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  _buildRestaurantInformation(
                                    context,
                                    state.currentRestaurant,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Opening Hours",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 25,
                              ),
                            ),
                            onPressed: () => _saveOpeningHours(),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildListOpeningHours(),
                    ],
                  ),
                ),
              ));
        } else if (state is RestaurantDetailsError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("Something went wrong!"));
        }
      },
    );
  }

  Expanded _buildRestaurantInformation(
    BuildContext context,
    Restaurant restaurant,
  ) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 0.5,
            color: Colors.black.withOpacity(0.25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildRestaurantContent(
              context,
              "ID",
              '#${restaurant.id}',
            ),
            _buildRestaurantContent(
              context,
              "Name",
              restaurant.name,
            ),
            _buildRestaurantContent(
              context,
              "Description",
              restaurant.description ?? "",
            ),
            _buildRestaurantContent(
              context,
              "Tags",
              restaurant.tags.join(", "),
            ),
            _buildRestaurantContent(
              context,
              "Categories",
              restaurant.categories?.map((e) => e.name).toList().join(", "),
            ),
            _buildRestaurantContent(
              context,
              "Products",
              restaurant.products?.map((e) => e.name).toList().join(", "),
            ),
            _buildRestaurantContent(
              context,
              "Address",
              restaurant.address.name,
            ),
            _buildRestaurantContent(
              context,
              "Coordinates",
              '${restaurant.address.lat} - ${restaurant.address.lon}',
            ),
          ],
        ),
      ),
    );
  }

  Row _buildRestaurantContent(
    BuildContext context,
    String title,
    String? content,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            content ?? "",
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }

  _buildListOpeningHours() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: openingHoursList!.length,
      itemBuilder: (BuildContext context, int index) {
        return OpeningHoursCard(
          openingHours: openingHoursList![index],
          onCheckboxChanged: (value) => _updateOpeningHours(
            newOpeningHours: openingHoursList![index].copyWith(isOpen: value),
          ),
          onSliderChanged: (value) => _updateOpeningHours(
            newOpeningHours: openingHoursList![index].copyWith(
              openAt: value.start,
              closeAt: value.end,
            ),
          ),
        );
      },
    );
  }
}
