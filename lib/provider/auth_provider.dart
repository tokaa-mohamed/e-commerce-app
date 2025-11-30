// auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';





class AuthProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> resetpass( String Email)async{
                          try{
         await FirebaseAuth.instance.sendPasswordResetEmail(email: Email);
                          }catch(e){
                            print('${e}');
                          }
  }

  Future<void> saveemail( String Email, String? val)async{
final prefs=await SharedPreferences.getInstance();
await prefs.setString('key', Email);
notifyListeners();

  }

  Future<String?> getemail()async{
    final prefs=await SharedPreferences.getInstance();
    notifyListeners();

  return  prefs.getString('key');



  }

   Future<void> login(String email, String password) async {

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('login');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

Future<User?> register(String email, String password, {String? fullName}) async {
  try {
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCred.user;

    if (user != null && fullName != null) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "name": fullName,
        "email": user.email,
        "provider": "email",
      }, SetOptions(merge: true));
    }

    notifyListeners();
    return user;
  } catch (e) {
    throw Exception('Register failed: $e');
  }
}
    String? _userName;
  String? get userName => _userName;

Future<String?> getUserName() async {
  final user = currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (doc.exists) {
      _userName = doc.data()?["name"];
      notifyListeners();
      return _userName;  
    }
  }
  return null;
}

    Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User? user = userCredential.user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore.collection("users").doc(user!.uid).set({
      "uid": user.uid,
      "name": user.displayName,
      "email": user.email,
      "photoUrl": user.photoURL,
      "provider": "google",
    }, SetOptions(merge: true));
  notifyListeners();

    return user;
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final credential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;


      await _firestore.collection("users").doc(user!.uid).set({
        "uid": user.uid,
        "name": user.displayName,
        "email": user.email,
        "photoUrl": user.photoURL,
        "provider": "facebook",
      }, SetOptions(merge: true));
      notifyListeners();

      return user;
    } else {
      throw Exception("Facebook login failed: ${result.status}");
    }

  }


Future<void> logout() async {
  if (await GoogleSignIn().isSignedIn()) await GoogleSignIn().signOut();
  await FacebookAuth.instance.logOut();
  await _auth.signOut();
  notifyListeners();
}
}
