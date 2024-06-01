import 'package:flutter/material.dart';

import '../app_constants.dart';

class Logo extends StatelessWidget {
  final VoidCallback? onTap;

  const Logo({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.5),
                radius: 100,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.7),
                radius: 70,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.9),
                radius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
