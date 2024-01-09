import 'package:flutter/material.dart';
import 'package:melaka_wanderlust/pages/profile.dart';
import 'package:melaka_wanderlust/pages/tips_and_advice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/nav_bar.dart';
import '../components/wishlist_item.dart';
import '../models/wishlist.dart';
import 'high_reviews.dart';
import 'home.dart';
import 'itinerary.dart';

class WishlistPage extends StatelessWidget {

  final String username; // Provide the username

  WishlistPage({Key? key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("My Wishlist"),
      ),
      body: Consumer<Wishlist>(
        builder: (context, wishlist, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: wishlist.getUserWishlist(username), // Get the user wishlist asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle errors if any
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle the case when there's no data to display
                return Center(child: Text('No items in the wishlist.'));
              } else {
                // Process and display the data
                final wishlistPlaces = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: wishlistPlaces.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> wishlistItem = wishlistPlaces[index];
                            return WishlistItem(wishlistItem: wishlistItem);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: Column(
        // Wrap the two bottom navigation components in a Column
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              child: Text(
                'Generate Itinerary',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                String? username = prefs.getString("username");
                final wishlistItem = await Provider.of<Wishlist>(context,
                    listen: false)
                    .getUserWishlist(username!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ItineraryPage(wishlistItems: wishlistItem)),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
          CustomBottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                  break;
                case 1:
                // You're already on the WishlistPage, no need to navigate
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HighRatedLocationsPage(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}