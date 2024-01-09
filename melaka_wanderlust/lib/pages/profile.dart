import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melaka_wanderlust/pages/search.dart';
import 'package:melaka_wanderlust/pages/setting.dart';
import 'package:melaka_wanderlust/pages/tips_and_advice.dart';
import 'package:melaka_wanderlust/pages/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart'; // Import this package for XFile
import 'dart:io';

import '../components/nav_bar.dart';
import 'forgot_pw.dart';
import 'high_reviews.dart';
import 'home.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String profilePictureURL = ''; // Store the profile picture URL
  String selectedGender = 'Male';

  // A map to keep track of the edit states for each field
  final Map<String, bool> editStates = {
    'full name': false,
    'gender': false,
    'date of birth': false,
    'phone number': false,
    'email': false,
  };

  final List<String> genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore and populate the text controllers
    fetchDataFromFirestore();
  }

  // Future<void> _logout() async {
  //   // Clear user session data (in this case, the username or email)
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //
  //   // Navigate to the login or authentication screen
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => LoginPage(), // Replace with your login page widget
  //     ),
  //   );
  // }


  Future<void> fetchDataFromFirestore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email =
    prefs.getString('username'); // Get the username (email) from SharedPreferences

    if (email != null) {
      try {
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>;

          setState(() {
            fullNameController.text = userData['full name'] ?? '';
            selectedGender = userData['gender'] ?? '';
            dateOfBirthController.text = userData['date of birth']?.toString() ?? '';
            phoneNumberController.text = userData['phone number']?.toString() ?? '';
            emailController.text = email;
            passwordController.text = userData['password'] ?? '';

            // Set the profile picture URL if available
            profilePictureURL = userData['profilePicture'] ?? '';
          });
        } else {
          print("User data does not exist");
        }
      } catch (error) {
        print("Firestore Error: $error");
      }
    } else {
      print("Email is null in SharedPreferences");
    }
  }

  Future<void> uploadProfilePicture(String userEmail, XFile pickedImage) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$userEmail.jpg'); // Use a unique name for each image

      final UploadTask uploadTask = storageReference.putFile(File(pickedImage.path)); // Use File constructor
      final TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        final String downloadURL = await storageReference.getDownloadURL();

        // Update Firestore with the downloadURL
        await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
          'profilePicture': downloadURL,
        });

        // Update the profile picture URL in the state
        setState(() {
          profilePictureURL = downloadURL;
        });
      }
    } catch (error) {
      print("Image Upload Error: $error");
    }
  }

  void updateUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username =
    prefs.getString('username'); // Get the username from SharedPreferences

    if (username != null) {
      await FirebaseFirestore.instance.collection('users').doc(username).update(
        {
          'full name': fullNameController.text,
          'gender': selectedGender,
          'date of birth': dateOfBirthController.text,
          'phone number': int.parse(phoneNumberController.text),
          'email': emailController.text,
        },
      ); // Show a success dialog to indicate the profile update
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Updated'),
            content: Text('Your profile has been successfully updated.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildEditableTextBox({
    required TextEditingController controller,
    required String labelText,
    required Function() onEditPressed,
    required bool isEditable,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Add margin for spacing
      padding: EdgeInsets.all(8.0), // Add padding for better appearance
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        color: Colors.grey[200], // Set background color
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: !isEditable,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  color: isEditable ? Colors.orange : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none, // Remove the default border
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.orange,
            ),
            onPressed: onEditPressed,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                    NetworkImage(profilePictureURL), // Load the user's profile picture
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                      child: IconButton(
                        onPressed: () async {
                          final imagePicker = ImagePicker();
                          final pickedImage =
                          await imagePicker.pickImage(source: ImageSource.gallery);

                          if (pickedImage != null) {
                            await uploadProfilePicture(emailController.text, pickedImage);
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white, // Set the icon color to white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildEditableTextBox(
                controller: fullNameController,
                labelText: 'Full Name',
                onEditPressed: () {
                  setState(() {
                    editStates['full name'] = !editStates['full name']!;
                  });
                },
                isEditable: editStates['full name']!,
              ),
              buildGenderDropdown(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextFormField(
                  controller: dateOfBirthController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              buildEditableTextBox(
                controller: phoneNumberController,
                labelText: 'Phone Number',
                onEditPressed: () {
                  setState(() {
                    editStates['phone number'] = !editStates['phone number']!;
                  });
                },
                isEditable: editStates['phone number']!,
              ),
              buildEditableTextBox(
                controller: emailController,
                labelText: 'Email',
                onEditPressed: () {
                  setState(() {
                    editStates['email'] = !editStates['email']!;
                  });
                },
                isEditable: editStates['email']!,
              ),
              buildEditableTextBox(
                controller: passwordController,
                labelText: 'Password',
                onEditPressed: () {
                  // Navigate to the ForgotPassPage when the edit icon is pressed
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ForgotPassPage(),
                    ),
                  );
                },
                isEditable: false, // Always allow editing for password
              ),
              SizedBox(height: 220),
              SizedBox(
                width: double.infinity, // Make the button take the full width
                height: 50, // Adjust the height as needed
                child: ElevatedButton(
                  onPressed: updateUserDetails,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Set the button color to orange
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Set the text color to white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Set the appropriate index for the ProfilePage
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dateOfBirthController.text) {
      setState(() {
        dateOfBirthController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Widget buildGenderDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender', // Add your label text here
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButtonFormField<String>(
            value: selectedGender, // Set the initial value
            onChanged: (newValue) {
              setState(() {
                selectedGender = newValue!;
              });
            },
            items: genderOptions.map<DropdownMenuItem<String>>((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
