import 'package:flutter/material.dart';

class TagForm extends StatelessWidget {
  const TagForm({
    Key? key,
    required this.tags,
  }) : super(key: key);

  final List<String> tags;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags
          .map(
            (tag) => tags.indexOf(tag) == tags.length - 1
                ? Text(
                    tag,
                    style: Theme.of(context).textTheme.headline6,
                  )
                : Text(
                    '$tag, ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
          )
          .toList(),
    );
  }
}
