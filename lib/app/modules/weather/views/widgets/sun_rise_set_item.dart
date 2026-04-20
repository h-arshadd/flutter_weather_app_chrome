import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SunRiseSetItem extends StatelessWidget {
  final String text;
  final String value;
  const SunRiseSetItem({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Time value — never shrinks
        Text(
          value,
          style: Get.theme.textTheme.displayMedium?.copyWith(fontSize: 13),
        ),
        const SizedBox(width: 8),
        // Label — shrinks with ellipsis before it overflows
        Flexible(
          child: Text(
            text,
            style: Get.theme.textTheme.displaySmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}