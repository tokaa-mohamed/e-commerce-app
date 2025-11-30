
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavProvider extends  ChangeNotifier{
  List <String> favid=[]; 
      List<Product> favs=[];
        List<Product> _allProducts = [];  
          List<Product> get allProducts => _allProducts;


void setAllProducts(List<Product> products) {
  _allProducts = products;
}


Future<void> addToFav(String itemId) async { 
  final uid = FirebaseAuth.instance.currentUser?.uid;



  if (uid == null) {
    throw Exception("User not logged in");
  }

  final favRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Fav')
      .doc(itemId);

  final snapshot = await favRef.get();
if (snapshot.exists) {
  await favRef.delete();
  favid.remove(itemId);
  favs.removeWhere((p) => p.id.toString() == itemId); 
} else {
  await favRef.set({"favourite": true});
  favid.add(itemId);

  final product = _allProducts.firstWhere(
    (p) => p.id.toString() == itemId,
  );
  if (!favs.any((p) => p.id.toString() == itemId)) {
    favs.add(product); 
  }
}
notifyListeners();
  
}


Future<void> fetchFav() async { 
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final favDocs = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Fav')
      .get();

  favid = favDocs.docs.map((doc) => doc.id).toList();

  favs = allProducts
      .where((prod) => favid.contains(prod.id.toString()))
      .toList();

  notifyListeners();
}



}