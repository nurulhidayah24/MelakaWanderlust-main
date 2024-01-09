import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melaka_wanderlust/components/my_button.dart';
import 'package:melaka_wanderlust/components/my_textfield.dart';
import 'home.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {

  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {

  // text editing controllers
  final fullNameController = TextEditingController();
  final dateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? passwordError;
  String? emailError;
  bool isPasswordVisible = false;

  TextEditingController genderController = TextEditingController();

  // Gender dropdown options
  List<String> genderOptions = ['Male', 'Female'];
  String selectedGender = 'Male'; // Set a default value

  // DOB method
  Future<void> _selectDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        dateController.text = selected.toString().split(" ")[0];
      });
    }
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 200.0,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Male'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                    genderController.text = selectedGender;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Female'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                    genderController.text = selectedGender;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  // user register method
  void userSignUp() async {

    // Error message
    void showErrorMessage(String errorMessage) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // // Pop loading circle after showing the error message
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    // method valid email
    bool isValidEmail(String email) {
      final pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
      final regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    // validate email
    String? validateEmail(String value) {
      if (value.isEmpty) {
        return 'Email is required';
      }
      if (!isValidEmail(value)) {
        return 'Please enter a valid email address in the format example@gmail.com';
      }
      return null;
    }

    // validate password
    String? validatePassword(String value) {
      final commonErrorMessage = 'Password must be at least 8 characters long, '
          'include at least 1 digit, 1 uppercase letter and 1 lowercase letter';

      if (value.isEmpty) {
        return 'Password is required';
      }

      if (value.length < 8 ||
          !value.contains(RegExp(r'[A-Z]')) ||
          !value.contains(RegExp(r'[a-z]')) ||
          !value.contains(RegExp(r'[0-9]'))) {
        return commonErrorMessage;
      }

      return null;
    }

    // try register user
    try {
      // Validate the email address
      emailError = validateEmail(emailController.text);
      if (emailError != null) {
        showErrorMessage(emailError!);
        return; // Don't proceed with registration if the email is invalid
      }

      // Validate the password
      passwordError = validatePassword(passwordController.text);
      if (passwordError != null) {
        showErrorMessage(passwordError!);
        return; // Don't proceed with registration if the password is invalid
      }

      // check if password entered is same
      if (passwordController.text == confirmPasswordController.text) {
        // create user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Create a new document in Firestore for the users
        await FirebaseFirestore.instance.collection('users').doc(emailController.text).set({
          'full name': fullNameController.text,
          'gender': genderController.text,
          'date of birth': dateController.text,
          'phone number' : phoneController.text,
          'isActive': true,
        });

        // show error message
        Navigator.pop(context);
        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        showErrorMessage("The passwords do not match");
      }
      // pop loading circle before user logged in
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showErrorMessage("An unknown error occurred");
    }
  }

  // error message
  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register Failed'),
          content: const Text('Password does not match'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                // pop loading circle after show error message
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      // safe area of the screen - guarantee visible to user
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // allign everything to the middle of the screen
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                // logo
                Image.asset(
                  'lib/images/logo1.png',
                  height: 300,
                ),
                const SizedBox(height: 5),

                // welcome back
                Text(
                  'Welcome to our app !',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 25),

                // first name textfield
                MyTextField(
                  controller: fullNameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: genderController,
                  hintText: 'Gender',
                  obscureText: false,
                  onTap: () {
                    // Show gender dropdown when tapped
                    _showGenderPicker();
                  },
                ),
                const SizedBox(height: 10),

                // last name textfield
                MyTextField(
                  controller: dateController,
                  hintText: 'Date of Birth',
                  obscureText: false,
                  onTap: () {
                    _selectDate(); // Open the date picker when tapped
                  },
                ),
                const SizedBox(height: 10),

                // age textfield
                MyTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 50),

                // register button
                MyButton(
                  text: "Register",
                  onTap: userSignUp,
                ),

                const SizedBox(height: 50),

                // doesn't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage(); // Replace 'RegisterPage()' with your actual RegisterPage widget
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}