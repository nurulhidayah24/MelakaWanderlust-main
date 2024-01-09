// travel_tips_screen.dart

import 'package:flutter/material.dart';

class TravelTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Travel Tips'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('Pack Smartly', textColor: Colors.indigo),
            TipsItem('1. Check the weather forecast before packing.', textColor: Colors.black),
            TipsItem('2. Pack versatile clothing items for mix-and-match outfits.', textColor: Colors.black),
            TipsItem('3. Don\'t forget essential items like chargers, medications, and travel documents.', textColor: Colors.black),

            SectionTitle('Stay Safe', textColor: Colors.indigo),
            TipsItem('1. Keep your belongings secure, especially in crowded areas.',textColor: Colors.black),
            TipsItem('2. Be aware of your surroundings and trust your instincts.',textColor: Colors.black),
            TipsItem('3. Share your travel itinerary with a friend or family member.',textColor: Colors.black),

            SectionTitle('Travel on a Budget', textColor: Colors.indigo),
            TipsItem('1. Set a daily budget for meals, attractions, and transportation.',textColor: Colors.black),
            TipsItem('2. Look for budget-friendly accommodations and dining options.',textColor: Colors.black),
            TipsItem('3. Take advantage of free or low-cost activities and attractions.',textColor: Colors.black),

            SectionTitle('Make the Most of Your Trip', textColor: Colors.indigo),
            TipsItem('1. Plan your itinerary but leave room for spontaneity.',textColor: Colors.black),
            TipsItem('2. Connect with locals to discover hidden gems.',textColor: Colors.black),
            TipsItem('3. Capture memories but also take time to enjoy the moment.',textColor: Colors.black),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;

  SectionTitle(this.title, {this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}

class TipsItem extends StatelessWidget {
  final String tip;
  final Color textColor;

  TipsItem(this.tip, {this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 20.0, color: Colors.yellow[900]),
          SizedBox(width: 8.0),
          Expanded(child: Text(tip, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }
}