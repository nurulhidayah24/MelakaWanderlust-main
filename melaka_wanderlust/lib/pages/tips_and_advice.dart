// tips_and_advice_screen.dart
import 'package:flutter/material.dart';
import 'package:melaka_wanderlust/pages/local_advice.dart';
import 'package:melaka_wanderlust/pages/profile.dart';
import 'package:melaka_wanderlust/pages/travel_tips.dart';
import 'package:melaka_wanderlust/pages/wishlist.dart';

import '../components/nav_bar.dart';
import 'high_reviews.dart';
import 'home.dart';

class TipsAndAdviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tips and Advice'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Travel Tips'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TravelTipsScreen()), // Correct the navigation
              );
            },
          ),
          ListTile(
            title: Text('Local Advice'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocalAdviceScreen()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set the appropriate index for the TipsAndAdviceScreen
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
              break;
            case 2:
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
              break;
            case 4:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HighRatedLocationsPage(),
                ),
              );
          }
        },
      ),
    );
  }
}