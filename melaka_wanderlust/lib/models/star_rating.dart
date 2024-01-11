import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // The rating value, e.g., 4.5
  final double size; // The size of each star icon
  final Color color; // The color of the stars
  final IconData filledStar; // The icon for a filled star
  final IconData unfilledStar; // The icon for an unfilled star

  StarRating({
    required this.rating,
    this.size = 24.0,
    this.color = Colors.yellow,
    this.filledStar = Icons.star,
    this.unfilledStar = Icons.star_border,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(
            filledStar,
            size: size,
            color: color,
          );
        } else {
          return Icon(
            unfilledStar,
            size: size,
            color: color,
          );
        }
      }),
    );
  }
}
