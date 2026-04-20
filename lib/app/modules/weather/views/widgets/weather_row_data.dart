import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeatherRowData extends StatelessWidget {
  final String text;
  final String value;
  const WeatherRowData({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label — shrinks before value overflows
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            // Value — never shrinks (it's the number)
            Text(
              value,
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 13),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}