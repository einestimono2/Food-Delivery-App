import 'package:backend/constants/show_snack_bar.dart';
import 'package:backend/models/voucher_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';

class VoucherScreen extends StatefulWidget {
  static const String routeName = "/vouchers";
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<VoucherBloc>(context).add(LoadVouchers());
  }

  _deleteVoucher(Voucher voucher) {
    setState(() {
      isDeleted = true;
    });

    context.read<VoucherBloc>().add(
          DeleteVoucher(voucher: voucher),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdminScaffold(
      route: VoucherScreen.routeName,
      body: BlocConsumer<VoucherBloc, VoucherState>(
        listener: (context, state) {
          if (state is VoucherError) {
            showSnackBar(context, state.message);
            context.read<VoucherBloc>().add(LoadVouchers());
          }

          // Show snack bar -- event delete
          if (isDeleted && state is VoucherLoaded) {
            showSnackBar(context, "Deleted the voucher!");
            setState(() {
              isDeleted = false;
            });
          }
        },
        builder: (context, state) {
          if (state is VoucherLoading || state is VoucherInitial) {
            return const CustomLoading();
          } else if (state is VoucherLoaded) {
            return Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5)),
                        ),
                        child: Text(
                          "Vouchers",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 22,
                          ),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => const VoucherCard(),
                        ),
                        child: Text(
                          "+ ADD Voucher",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 30,
                        runSpacing: 20,
                        children: state.vouchers
                            .map((e) => _buildVoucherCard(e, context))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
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

  Container _buildVoucherCard(Voucher voucher, BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.fromLTRB(22.0, 15.0, 10.0, 15.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          width: 0.25,
          color: Colors.grey.withOpacity(0.75),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(voucher.code,
                    style: Theme.of(context).textTheme.headline3),
                const SizedBox(height: 8.0),
                RichText(
                  text: TextSpan(
                    text: 'Discount ',
                    children: [
                      TextSpan(
                        text: '${voucher.value}%',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.red),
                      ),
                    ],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 15),
            width: 25,
            child: PopupMenuButton<Widget>(
              position: PopupMenuPosition.under,
              child: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return <PopupMenuEntry<Widget>>[
                  PopupMenuItem<Widget>(
                    /*
                      the onTap callback of PopupMenuItem calls Navigator.pop to close the Popup ==> tap on the PopupMenuItem and call showDialog, the Dialog will be popped immediately, and leaves the Popup open.
                    */
                    onTap: () => Future.delayed(
                      const Duration(seconds: 0),
                      () => showDialog(
                        context: context,
                        builder: (context) => VoucherCard(
                          voucher: voucher,
                        ),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.edit),
                        SizedBox(width: 12.0),
                        Text(
                          "Edit",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<Widget>(
                    onTap: () => _deleteVoucher(voucher),
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
          ),
        ],
      ),
      // ListTile(
      //   leading: IconButton(
      //     splashRadius: 22,
      //     onPressed: () {},
      //     icon: const Icon(Icons.edit),
      //   ),
      //   title: Padding(
      //     padding: const EdgeInsets.only(bottom: 6.0),
      //     child: Text(e.code, style: Theme.of(context).textTheme.headline3),
      //   ),
      //   subtitle: RichText(
      //     text: TextSpan(
      //       text: 'Discount ',
      //       children: [
      //         TextSpan(
      //           text: '${e.value}%',
      //           style: Theme.of(context)
      //               .textTheme
      //               .headline6!
      //               .copyWith(color: Colors.red),
      //         ),
      //       ],
      //       style: Theme.of(context).textTheme.headline6,
      //     ),
      //   ),
      //   trailing: IconButton(
      //     splashRadius: 22,
      //     onPressed: () {},
      //     icon: const Icon(Icons.delete),
      //   ),
      // ),
    );
  }
}
