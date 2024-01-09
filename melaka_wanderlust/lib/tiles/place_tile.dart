import 'package:flutter/material.dart';
import 'package:melaka_wanderlust/models/place.dart';
import 'package:melaka_wanderlust/pages/place_detail.dart';

class PlaceTile extends StatelessWidget {

  final Place place;
  final bool isFavorite;

  PlaceTile({
    Key? key,
    required this.place,
    required this.isFavorite
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailPage(place: place),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(top: 8),
          child: ListTile(
            leading: Image.asset(
              place.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(place.name),
            subtitle: Text(
              place.minPrice == 0 ? 'Free Entry' :
                'RM ${place.minPrice} - RM ${place.maxPrice}',
            ),
            trailing: isFavorite
                ? Icon(Icons.favorite) // Show the favorite icon if isFavorite is true
                : Icon(Icons.favorite_border_outlined), // Show the outline icon if isFavorite is false
          ),
        ),
      ),
    );
  }
}
