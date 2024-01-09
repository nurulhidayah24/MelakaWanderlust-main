// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class AuthService {
//
//   // Google sign in
//   signInWithGoogle() async {
//
//     // begin interactive sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//
//     // obtain auth details from request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//
//     // create a new credential for user
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//
//     final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
//     final User? user = authResult.user;
//
//     print('User signed in: ${user!.displayName}');
//
//     //return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }
