import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';

class ListPopularRestaurants extends StatelessWidget {
  const ListPopularRestaurants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitle(title: 'Popular Restaurants', onTap: () {}),
        BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoading || state is RestaurantInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is RestaurantLoaded) {
              List<Restaurant> popularRestaurant = state.restaurants
                  .where((element) => element.isPopular)
                  .toList();

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemCount: popularRestaurant.length,
                itemBuilder: (context, index) => RestaurantCard(
                  restaurant: popularRestaurant[index],
                ),
              );
            } else if (state is RestaurantError) {
              return Text(
                state.message,
                style: Theme.of(context).textTheme.headline3,
              );
            } else {
              return Text(
                "Something went wrong!",
                style: Theme.of(context).textTheme.headline3,
              );
            }
          },
        ),
      ],
    );
  }
}
