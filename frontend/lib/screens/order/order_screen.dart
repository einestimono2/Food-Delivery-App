import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/widgets/widgets.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = "/orders";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => OrderScreen(),
      );
  const OrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Orders",
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.history),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) => _order(context),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: AppSize.screenHeight / 3.5,
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Do you have a voucher ?',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      TextButton(
                        onPressed: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Container(
                            height: AppSize.screenHeight / 2,
                            child: VoucherScreen(showBottomSheet: true),
                          ),
                        ),
                        child: Text(
                          'Select',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      '\$20.00',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      '\$20.00',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      '\$40.00',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    'Check out',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    CheckoutScreen.routeName,
                  ),
                ),
                //
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _order(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5.0,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Restaurants
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Il Panino del Laghetto'),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, size: 12),
                    Text('Ha Noi, Bac Ninh, Viet Nam'),
                  ],
                ),
              ],
            ),
          ),
          // Items
          _item(context),
          _item(context),
          _item(context),
          _item(context),
          _item(context),
          Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.add, size: 16, color: Colors.red),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      'Add more items',
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _item(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.35)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '1x',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Apple Pie',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Text(
            '\$2.00',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
