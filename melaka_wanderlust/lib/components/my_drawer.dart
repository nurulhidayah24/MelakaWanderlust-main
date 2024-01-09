// import 'package:flutter/material.dart';
// import 'package:melaka_wanderlust/pages/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../pages/profile.dart';
// import '../pages/tips_and_advice.dart';
// import '../pages/wishlist.dart';
//
//
// class MyDrawer extends StatelessWidget {
//
//   final BuildContext context;
//
//   MyDrawer({
//     required this.context,
//   });
//
//   // navigate to login page when user logout
//   void handleLogout() {
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>
//                 LoginPage()
//         )
//     );
//   }
//
//   // navigate to wishlist page
//   void handleWishlist() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? username = prefs.getString('username');
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WishlistPage(username: username!,),
//       ),
//     );
//   }
//
//   // navigate to tips & advice page
//   void handleTipsAdvice() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TipsAndAdviceScreen(),
//       ),
//     );
//   }
//
//   // navigate to user profile page
//   void handleProfilePage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ProfilePage()), // Assuming ProfilePage is your profile page widget
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.orangeAccent,
//       child: Column(
//         children: [
//           // logo
//           DrawerHeader(
//             child: Image.asset(
//               'lib/images/logo.png',
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Divider(
//               color: Colors.black,
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 // profile
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: ListTile(
//                     onTap: handleProfilePage,
//                     leading: Icon(
//                       Icons.account_circle,
//                       color: Colors.black,
//                     ),
//                     title: Text(
//                       'Profile',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//
//                 // wishlist
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: ListTile(
//                     onTap: handleWishlist,
//                     leading: Icon(
//                       Icons.favorite,
//                       color: Colors.black,
//                     ),
//                     title: Text(
//                       'Wishlist',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//
//                 // tips & advice
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: ListTile(
//                     onTap: handleTipsAdvice,
//                     leading: Icon(
//                       Icons.lightbulb,
//                       color: Colors.black,
//                     ),
//                     title: Text(
//                       'Tips and Advice',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Logout
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0),
//             child: GestureDetector(
//               onTap: handleLogout,
//               child: ListTile(
//                 leading: Icon(
//                   Icons.logout,
//                   color: Colors.black,
//                 ),
//                 title: Text(
//                   'Logout',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
