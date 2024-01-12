import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final double value; // Value should be in the range of 0 to 5
  const StarDisplay({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate whole number and fractional part of the rating
    int wholeStars = value.floor();
    double fraction = value - wholeStars;
    bool halfStar = fraction >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < wholeStars) {
          return Icon(Icons.star, color: Colors.amber);
        } else if (halfStar && index == wholeStars) {
          return Icon(Icons.star_half, color: Colors.amber);
        } else {
          return Icon(Icons.star_border, color: Colors.amber);
        }
      }),
    );
  }
}
