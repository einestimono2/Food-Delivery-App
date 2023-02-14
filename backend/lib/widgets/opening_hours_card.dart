import 'package:flutter/material.dart';

import '../models/models.dart';

class OpeningHoursCard extends StatelessWidget {
  const OpeningHoursCard(
      {Key? key,
      required this.openingHours,
      this.onCheckboxChanged,
      this.onSliderChanged})
      : super(key: key);

  final OpeningHours openingHours;
  final Function(bool?)? onCheckboxChanged;
  final Function(RangeValues)? onSliderChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      color: openingHours.isOpen
          ? Theme.of(context).colorScheme.background
          : Colors.white,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Checkbox(
            value: openingHours.isOpen,
            onChanged: onCheckboxChanged,
            activeColor: Theme.of(context).colorScheme.primary,
            fillColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              openingHours.day,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: openingHours.isOpen ? Colors.black : Colors.grey,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RangeSlider(
              divisions: 24,
              values: RangeValues(
                openingHours.openAt,
                openingHours.closeAt,
              ),
              min: 0,
              max: 24,
              onChanged: openingHours.isOpen ? onSliderChanged : null,
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 150,
            child: openingHours.isOpen
                ? Text(
                    'Open from ${openingHours.openAt} to ${openingHours.closeAt}',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color:
                              openingHours.isOpen ? Colors.black : Colors.grey,
                        ),
                  )
                : Text(
                    'Closed on ${openingHours.day}',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color:
                              openingHours.isOpen ? Colors.black : Colors.grey,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}
