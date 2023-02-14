import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.actions,
    this.showLeading = true,
    required this.title,
  }) : super(key: key);

  final List<Widget>? actions;
  final String title;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title, style: Theme.of(context).textTheme.headline3),
      leading: showLeading
          ? InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).textTheme.headline3!.color,
                size: 20,
              ),
            )
          : null,
      actions: actions,
    );
  }

  Size get preferredSize => Size.fromHeight(getProportionateScreenHeight(57));
}
