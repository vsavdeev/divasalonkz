import 'dart:math';
import 'package:flutter/material.dart';

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.color = Colors.white,
  });

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  final Color color;

  static const double _dotSize = 8.0;
  static const double _maxZoom = 2.0;
  static const double _dotSpacing = 25.0;

  Widget _buildDot(int index, double page) {
    final selectedness =
        Curves.easeOut.transform(max(0.0, 1.0 - (page - index).abs()));
    final zoom = 1.0 + (_maxZoom - 1.0) * selectedness;
    return SizedBox(
      height: _dotSpacing,
      child: Center(
        child: InkWell(
          onTap: () => onPageSelected(index),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _dotSize * zoom,
            height: _dotSize * zoom,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.hasClients && controller.page != null
            ? controller.page!
            : controller.initialPage.toDouble();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) => _buildDot(index, page)),
        );
      },
    );
  }
}
