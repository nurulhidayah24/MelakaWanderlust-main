import 'package:flutter/material.dart';

class LocalAdviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Local Advice'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('Explore Local Cuisine', textColor: Colors.indigo),
            AdviceItem('1. Try local dishes and street food to experience the authentic flavors.', textColor: Colors.black),
            AdviceItem('2. Ask locals for restaurant recommendations to discover hidden gems.', textColor: Colors.black),
            AdviceItem('3. Visit local markets for fresh produce and unique snacks.', textColor: Colors.black),

            SectionTitle('Connect with Locals', textColor: Colors.indigo),
            AdviceItem('1. Attend local events and festivals to engage with the community.', textColor: Colors.black),
            AdviceItem('2. Learn a few basic phrases in the local language to communicate with locals.', textColor: Colors.black),
            AdviceItem('3. Join guided tours or activities led by locals for an immersive experience.', textColor: Colors.black),

            SectionTitle('Respect Local Customs', textColor: Colors.indigo),
            AdviceItem('1. Research and respect local customs and traditions.', textColor: Colors.black),
            AdviceItem('2. Dress modestly in culturally sensitive areas.', textColor: Colors.black),
            AdviceItem('3. Be aware of and follow local etiquette to show respect for the community.', textColor: Colors.black),

            SectionTitle('Explore Cultural Sites',textColor: Colors.indigo),
            AdviceItem('1. Visit the UNESCO-listed Melaka Historic City for a journey through history.', textColor: Colors.black),
            AdviceItem('2. Explore Jonker Street for its vibrant night market and local crafts.', textColor: Colors.black),
            AdviceItem('3. Discover the Baba Nyonya Heritage Museum for a glimpse into Peranakan culture.', textColor: Colors.black),
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
class AdviceItem extends StatelessWidget {
  final String advice;
  final Color textColor;

  AdviceItem(this.advice, {this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 20.0, color: Colors.yellow[900]),
          SizedBox(width: 8.0),
          Expanded(child: Text(advice, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }
}