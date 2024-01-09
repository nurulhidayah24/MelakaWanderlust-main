import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.orange, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        type: BottomNavigationBarType.fixed, // Fixed type to show labels
        showSelectedLabels: true, // Show labels for selected item
        showUnselectedLabels: true, // Show labels for unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: currentIndex == 0 ? Colors.orange : Colors.grey, // Customize the color for this icon
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: currentIndex == 1 ? Colors.orange : Colors.grey, // Customize the color for this icon
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb,
              color: currentIndex == 2 ? Colors.orange : Colors.grey, // Customize the color for this icon
            ),
            label: 'Tips & Advice',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: currentIndex == 3 ? Colors.orange : Colors.grey, // Customize the color for this icon
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_city,
              color: currentIndex == 4 ? Colors.orange : Colors.grey, // Customize the color for this icon
            ),
            label: 'High Rated Locations',
          ),
        ],
      ),
    );
  }
}
