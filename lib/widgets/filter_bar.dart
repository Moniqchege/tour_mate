
import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final double maxCost;
  final ValueChanged<double> onChanged;

  const FilterBar({
    Key? key,
    required this.maxCost,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Max Cost:"),
        Slider(
          value: maxCost,
          min: 100,
          max: 5000,
          divisions: 50,
          label: '\$${maxCost.toInt()}',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
