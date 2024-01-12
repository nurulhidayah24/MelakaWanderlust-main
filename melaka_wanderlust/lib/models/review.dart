
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String username;
  String location;
  String rating;
  String comment;
  DateTime date;
  String? imageUrl;

  Review({
    required this.id,
    required this.username,
    required this.location,
    required this.rating,
    required this.comment,
    required this.date,
    this.imageUrl,
  });

  /*
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'location': location,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
*/

    // Factory method to create a Review from a Firestore document
    factory Review.fromFirestore(DocumentSnapshot doc) {
      Map data = doc.data() as Map;
      return Review(
          id: data['id'],
          username: data['username'],
          location: data['location'],
          rating: data['rating'].toDouble(), // Convert to double
          comment: data['comment'],
          date: DateTime.parse(data['date']),
          imageUrl: data['imageUrl'],
      );
    }
}