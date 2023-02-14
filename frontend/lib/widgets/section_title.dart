import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    this.expand = "See All",
    this.firstTitle = false,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String expand;
  final Function()? onTap;
  final bool firstTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, top: firstTitle ? 12 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline3,
          ),
          onTap != null
              ? InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      expand,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.green),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
