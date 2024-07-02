import 'package:flutter/material.dart';

import '../../../styles/colors.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Go',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          TextSpan(
            text: '-Cofee',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
