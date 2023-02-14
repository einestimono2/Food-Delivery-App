import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../widgets/widgets.dart';

class ListDiscounts extends StatelessWidget {
  const ListDiscounts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitle(title: 'Offers & Discounts'),
        BlocBuilder<DiscountBloc, DiscountState>(
          builder: (context, state) {
            if (state is DiscountLoading || state is DiscountInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DiscountLoaded) {
              return Container(
                width: double.infinity,
                height: 150,
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1,
                    viewportFraction: 0.99,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 8),
                  ),
                  items: state.discounts
                      .map((discount) => DiscountCard(discount: discount))
                      .toList(),
                ),
              );
            } else if (state is DiscountError) {
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
