import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/widgets/widgets.dart';

class VoucherScreen extends StatelessWidget {
  static const String routeName = "/vouchers";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => VoucherScreen(),
      );
  const VoucherScreen({
    Key? key,
    this.showBottomSheet = false,
  }) : super(key: key);

  final bool showBottomSheet;

  @override
  Widget build(BuildContext context) {
    return showBottomSheet
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Reset',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.red),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                          ),
                        ),
                        child: Text(
                          "My Vouchers",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Apply',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  _buildListVouchers(),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: CustomAppBar(
              showLeading: false,
              title: "Voucher",
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Apply",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.red),
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  SectionTitle(title: 'Search Voucher', firstTitle: true),
                  SectionTitle(title: 'My Vouchers'),
                  _buildListVouchers(),
                ],
              ),
            ),
          );
  }

  Expanded _buildListVouchers() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: Voucher.vouchers.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            padding: const EdgeInsets.only(left: 25, right: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '3x',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    Voucher.vouchers[index].code,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
