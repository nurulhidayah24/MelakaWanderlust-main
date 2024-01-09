import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "We're sad to see you go...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("If you choose to delete your account, your status will be set to inactive."),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Delete My Account"),
              onPressed: () => _showDeleteConfirmationDialog(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _deleteAccount(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('username');

    if (email != null && email.isNotEmpty) {
      try {
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(email);

        // Check if the user document exists
        DocumentSnapshot userSnapshot = await userDoc.get();
        if (userSnapshot.exists) {
          await userDoc.update({'isActive': false});

          // Log out the user and navigate to the login screen
          await prefs.clear();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          _showErrorSnackBar(context, "User account not found.");
        }
      } catch (error) {
        _showErrorSnackBar(context, "An error occurred: ${error.toString()}");
      }
    } else {
      _showErrorSnackBar(context, "User not found.");
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete your account? This cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAccount(context); // Proceed with account deletion
              },
            ),
          ],
        );
      },
    );
  }

}
