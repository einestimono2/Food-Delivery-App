import 'package:backend/blocs/discount/discount_bloc.dart';
import 'package:backend/constants/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';

class DiscountScreen extends StatefulWidget {
  static const String routeName = "/discounts";
  const DiscountScreen({Key? key}) : super(key: key);

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<DiscountBloc>(context).add(LoadDiscounts());
  }

  _deleteDiscount(Discount discount) {
    setState(() {
      isDeleted = true;
    });

    context.read<DiscountBloc>().add(
          DeleteDiscount(discount: discount),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdminScaffold(
      route: DiscountScreen.routeName,
      body: BlocConsumer<DiscountBloc, DiscountState>(
        listener: (context, state) {
          if (state is DiscountError) {
            showSnackBar(context, state.message);
            context.read<DiscountBloc>().add(LoadDiscounts());
          }

          // Show snack bar -- event delete
          if (isDeleted && state is DiscountLoaded) {
            showSnackBar(context, "Deleted the Discount!");
            setState(() {
              isDeleted = false;
            });
          }
        },
        builder: (context, state) {
          if (state is DiscountLoading || state is DiscountInitial) {
            return const CustomLoading();
          } else if (state is DiscountLoaded) {
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
                          "Discounts",
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
                          builder: (context) => const DiscountCard(),
                        ),
                        child: Text(
                          "+ ADD Discount",
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
                        spacing: 40,
                        runSpacing: 30,
                        children: state.discounts
                            .map((e) => _buildDiscountCard(e, context))
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

  Container _buildDiscountCard(Discount discount, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 580,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: <Widget>[
          Image.network(
            discount.image!,
            fit: BoxFit.fill,
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discount.title,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(height: 10),
                Text(
                  discount.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 30,
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
                        builder: (context) => DiscountCard(
                          discount: discount,
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
                    onTap: () => _deleteDiscount(discount),
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
    );
  }
}
