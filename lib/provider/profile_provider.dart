import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  File? _image;
  Uint8List? _webImageBytes;

  File? get image => _image;
  Uint8List? get webImageBytes => _webImageBytes;

  Future<void> loadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      final base64 = prefs.getString('profile_image_${user.uid}');
      if (base64 != null) {
        try {
          final bytes = base64Decode(base64);
          _webImageBytes = bytes;
            print('Web image loaded! Bytes length: ${bytes.length}'); 

          notifyListeners();
        } catch (e) {
          print('Error decoding base64 image: $e');
        }
      }
    } else {
      final path = prefs.getString('profile_image_${user.uid}');
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          _image = file;
                  print('Mobile image loaded from path: $path'); // ✅ هنا

          notifyListeners();
        } else {
          await prefs.remove('profile_image_${user.uid}');
        }
      }
    }
  }

  Future<void> pickImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final base64String = base64Encode(bytes);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_${user.uid}', base64String);
        _webImageBytes = bytes;
        notifyListeners();
      }
    } else {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final localImage = File(picked.path);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_${user.uid}', localImage.path);
        _image = localImage;
        notifyListeners();
      }
    }
  }

  ImageProvider? getProfileImage(User user) {
    if (kIsWeb) {
      if (_webImageBytes != null) return MemoryImage(_webImageBytes!);
      if (user.photoURL != null) return NetworkImage(user.photoURL!);
      return null;
    } else {
      if (_image != null) return FileImage(_image!);
      if (user.photoURL != null) return NetworkImage(user.photoURL!);
      return null;
    }
  }
}
