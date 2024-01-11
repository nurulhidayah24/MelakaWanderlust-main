import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melaka_wanderlust/pages/profile.dart';
import 'package:melaka_wanderlust/pages/tips_and_advice.dart';
import 'package:melaka_wanderlust/pages/wishlist.dart';

import '../components/nav_bar.dart';
import '../models/star_rating.dart';
import 'home.dart';

class HighRatedLocationsPage extends StatefulWidget {
  @override
  _HighRatedLocationsScreenState createState() => _HighRatedLocationsScreenState();
}

class _HighRatedLocationsScreenState extends State<HighRatedLocationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Rated Locations'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: getHighRatedLocations(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No high rated locations found.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Rating: '),
                          StarRating(rating: 5), // Replace with the actual rating value from your data
                        ],
                      ),
                      // Display the image using Image.network
                      Image.network(
                        snapshot.data![index]['imagePath'],
                        height: 100, // Set the desired height
                        width: 100,  // Set the desired width
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  // You can add more details if needed
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Set the appropriate index for the TipsAndAdviceScreen
        onTap: (index) {
          // Handle navigation based on the index
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
              break;
            case 1:
              var emailController;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WishlistPage(username: emailController.text),
                ),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => TipsAndAdviceScreen(),
                ),
              );
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getHighRatedLocations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isGreaterThanOrEqualTo: '4.0')
          .limit(15)
          .get();

      List<Map<String, dynamic>> locations = [];

      for (var doc in querySnapshot.docs) {
        String locationName = doc['name'];

        // List of image collections to check
        List<String> imageCollections = ['beaches', 'attractions', 'historicals','restaurants'];

        // Iterate over each image collection
        for (String collectionName in imageCollections) {
          QuerySnapshot imageQuerySnapshot = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('name', isEqualTo: locationName)
              .get();

          if (imageQuerySnapshot.docs.isNotEmpty) {
            // Check if 'imagePath' field exists and is not null
            var imagePath = imageQuerySnapshot.docs.first['imagePath'];
            if (imagePath != null && imagePath is String) {
              // Add location details along with the image path
              locations.add({
                'name': locationName,
                'imagePath': imagePath,
              });
            }
            // Break out of the loop if an image is found in the current collection
            break;
          }
        }
      }

      // Remove duplicates (if any)
      List<Map<String, dynamic>> uniqueLocations = locations.toSet().toList();

      return uniqueLocations;
    } catch (e) {
      print('Error fetching high rated locations: $e');
      return [];
    }
  }
}
