import 'package:flutter/material.dart';

class RequiredLabel extends StatelessWidget {
  final String text;

  const RequiredLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.labelLarge,
        children: [
          TextSpan(
            text: '* ',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
