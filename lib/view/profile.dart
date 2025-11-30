import 'dart:typed_data';
import 'dart:convert';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/provider/profile_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../provider/auth_provider.dart' as myauth;
import 'login.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image; 
  Uint8List? _webImageBytes;

  @override
  void initState() {
    super.initState();
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

   profileProvider.loadImage();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final providerauth = Provider.of<myauth.AuthProvider>(context, listen: false);
          final profile = Provider.of<ProfileProvider>(context, listen: false);


    return Scaffold(
         appBar: AppBar(
  backgroundColor: Colors.transparent, 
  elevation: 4,
  shadowColor: Colors.blueAccent.withOpacity(0.5),
  centerTitle: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(25),
    ),
  ),
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.lightBlue[300]!, Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  leading: Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: Icon(Icons.chevron_left, color: Colors.white, size: 30),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Home'),
          ),
        );
      },
    ),
  ),
  title: Text(
    "Profile",
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 3,
          color: Colors.black45,
          offset: Offset(1, 1),
        ),
      ],
    ),
  ),
),

   
      body: user == null
          ? const Center(child: Text("Not signed in"))
          : ListView(
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                   Consumer<ProfileProvider>(

  builder: (context, profile, child) {
                         final   image = profile.getProfileImage(user);

    return GestureDetector(
      onTap: profile.pickImage,

      child: CircleAvatar(
        radius: 50,
        backgroundImage: image,
        child: profile.getProfileImage(user) == null
            ? const Icon(Icons.person, size: 50)
            : null,
      ),
    );
  },
),
 const SizedBox(height: 12),
                   Consumer<myauth.AuthProvider>(
  builder: (context, auth, child) {
    return Text(
      auth.userName ?? "User",
      style: Theme.of(context).textTheme.headlineSmall,
    );
  },
),
 const SizedBox(height: 6),
                    Text(
                      user.email ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
Column(
  children: [
    Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, color: Colors.blue),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Edit Profile not implemented yet")),
          );
        },
      ),
    ),

    Card(
            color: Colors.white,

            surfaceTintColor: Colors.white,

      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.settings, color: Colors.blue),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Settings not available")),
          );
        },
      ),
    ),

    Card(
            color: Colors.white,

      elevation: 4,
            surfaceTintColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.logout, color: Colors.blue),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, ),
        ),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
      ),
    ),
  ],
),

              ],
            ),
    );
  }
}
