import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = "/dashboard";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
    BlocProvider.of<ProductBloc>(context).add(LoadProducts());
    BlocProvider.of<RestaurantBloc>(context).add(LoadRestaurants());
    BlocProvider.of<VoucherBloc>(context).add(LoadVouchers());
    BlocProvider.of<DiscountBloc>(context).add(LoadDiscounts());
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdminScaffold(
      route: DashboardScreen.routeName,
      body: Container(
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Statistical",
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category
                _buildStatisticalCard(
                  route: CategoryScreen.routeName,
                  title: 'Category',
                  iconData: Icons.category,
                  content: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is CategoryLoaded) {
                        return Text(
                          '${state.categories.length} categories',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.red),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // Product
                _buildStatisticalCard(
                  route: RestaurantScreen.routeName,
                  title: 'Product',
                  iconData: Icons.compost,
                  content: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is ProductLoaded) {
                        return Text(
                          '${state.products.length} products',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.red),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // Restaurant
                _buildStatisticalCard(
                  route: RestaurantScreen.routeName,
                  title: 'Restaurant',
                  iconData: Icons.food_bank,
                  content: BlocBuilder<RestaurantBloc, RestaurantState>(
                    builder: (context, state) {
                      if (state is RestaurantLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is RestaurantLoaded) {
                        return Text(
                          '${state.restaurants.length} restaurants',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.red),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // Discount
                _buildStatisticalCard(
                  route: DiscountScreen.routeName,
                  title: 'Discount',
                  iconData: Icons.production_quantity_limits_outlined,
                  content: BlocBuilder<DiscountBloc, DiscountState>(
                    builder: (context, state) {
                      if (state is DiscountLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is DiscountLoaded) {
                        return Text(
                          '${state.discounts.length} discounts',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.red),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // Voucher
                _buildStatisticalCard(
                  route: VoucherScreen.routeName,
                  title: 'Voucher',
                  iconData: Icons.discount,
                  content: BlocBuilder<VoucherBloc, VoucherState>(
                    builder: (context, state) {
                      if (state is VoucherLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is VoucherLoaded) {
                        return Text(
                          '${state.vouchers.length} vouchers',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.red),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // User
                _buildStatisticalCard(
                  route: VoucherScreen.routeName,
                  title: 'User',
                  iconData: Icons.person,
                  content: BlocBuilder<VoucherBloc, VoucherState>(
                    builder: (context, state) {
                      if (state is VoucherLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is VoucherLoaded) {
                        return Text(
                          '${state.vouchers.length} vouchers',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.red),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _buildStatisticalCard({
    required String route,
    required String title,
    required IconData iconData,
    required Widget content,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 100,
        padding: const EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(145, 225, 218, 218),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Colors.red,
                  size: 34,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
            content,
          ],
        ),
      ),
    );
  }
}
