
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melaka_wanderlust/pages/place_detail.dart';
import 'package:melaka_wanderlust/pages/profile.dart';
import 'package:melaka_wanderlust/pages/tips_and_advice.dart';
import 'package:melaka_wanderlust/pages/wishlist.dart';

import '../components/nav_bar.dart';
import '../models/place.dart';
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
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
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
                    title: Text(snapshot.data![index]),

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
        )
    );

  }

  Future<List<String>> getHighRatedLocations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isGreaterThanOrEqualTo: '4.0')
          .get();

      List<String> locations = [];

      for (var doc in querySnapshot.docs) {
        locations.add(doc['location']);
      }

      // Remove duplicates (if any)
      List<String> uniqueLocations = locations.toSet().toList();

      return uniqueLocations;
    } catch (e) {
      print('Error fetching high rated locations: $e');
      return [];
    }
  }

}
