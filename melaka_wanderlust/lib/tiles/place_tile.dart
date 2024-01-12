import 'package:flutter/material.dart';
import 'package:melaka_wanderlust/models/place.dart';
import 'package:melaka_wanderlust/pages/place_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceTile extends StatefulWidget {
  final Place place;
  final bool isFavorite;

  PlaceTile({
    Key? key,
    required this.place,
    required this.isFavorite,
  });

  @override
  _PlaceTileState createState() => _PlaceTileState();
}

class _PlaceTileState extends State<PlaceTile> {
  double? rating; // Initialize as nullable to handle "No reviews available"

  @override
  void initState() {
    super.initState();
    fetchRatingFromFirebase(); // Fetch the rating when the widget is initialized
  }

  Future<void> fetchRatingFromFirebase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    var reviewsSnapshot = await firestore
        .collection('reviews')
        .where('location', isEqualTo: widget.place.name)
        .get();

    if (reviewsSnapshot.docs.isNotEmpty) {
      // If there are reviews for this place, calculate the average rating
      double totalRating = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += double.tryParse(doc['rating'] ?? '0.0') ?? 0.0;
      }
      rating = totalRating / reviewsSnapshot.docs.length;
    }

    // Update the state to rebuild the widget with the new rating
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailPage(place: widget.place),
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
              widget.place.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(widget.place.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.place.minPrice == 0 ? 'Free Entry' : 'RM ${widget.place.minPrice} - RM ${widget.place.maxPrice}',
                ),
                if (rating != null)
                  Row(
                    children: [
                      Text('Rating: '),
                      RatingBarIndicator(
                        rating: rating!, // Use the fetched rating
                        itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 18.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                if (rating == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0), // Add padding to create space
                    child: Text('No reviews available'),
                  ),
              ],
            ),
            trailing: widget.isFavorite
                ? Icon(Icons.favorite) // Show the favorite icon if isFavorite is true
                : Icon(Icons.favorite_border_outlined), // Show the outline icon if isFavorite is false
          ),
        ),
      ),
    );
  }
}
