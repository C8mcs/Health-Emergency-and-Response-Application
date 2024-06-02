import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_constants.dart';

class Logo extends StatefulWidget {
  final VoidCallback? onTap;
  final double logoWidth; // New property for logo width
  final double logoHeight; // New property for logo height

  const Logo({
    Key? key,
    this.onTap,
    required this.logoWidth,
    required this.logoHeight,
  }) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Center(
          child: Stack(
            children: [
              // Circles Stack
              Stack(
                children: [
                  _buildCircle(0),
                  _buildCircle(1),
                  _buildCircle(2),
                ],
              ),
              // Logo Stack
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: widget.logoWidth,
                    height: widget.logoWidth,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildCircle(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _calculateOpacity(index),
          child: child,
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 100 + (index * 15),
        ),
      ),
    );
  }

  double _calculateOpacity(int index) {
    const double minOpacity = 0.3;
    const double maxOpacity = 1.0;
    final double progress = _controller.value;
    final double baseOpacity =
        minOpacity + (maxOpacity - minOpacity) / 3 * index;
    return math.sin(progress * math.pi) * 0.5 + 0.5 * baseOpacity;
  }
}
