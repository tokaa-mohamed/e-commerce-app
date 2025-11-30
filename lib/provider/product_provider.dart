
import 'package:ecommerce/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class ProductProvider extends ChangeNotifier {

  //   final TextEditingController searchController = TextEditingController();

  // @override
  // void dispose() {
  //   searchController.dispose();
  //   super.dispose();
  // }

  // List<Product> _allProducts = []; //data    //filter
  // List<Product> _originalFilteredList = [];  //data //search //filter
  // List<Product> filteredlist = [];//data      //search
//  late final  Product product;
//  List<Product> cartlist=[]; //fav
//  List<int> quantity=[]; //fav
//   bool _isloading = false;
//   bool get isloading => _isloading;
// List <String> favid=[]; //fav
  // List<Product> get allProducts => _allProducts;
  // List<Product> get filteredProducts => filteredlist;
  //   List<Product> favs=[];//fav


// void increasequantity(int index, String productId) async { //cart
//   quantity[index]++; 

//   final uid = FirebaseAuth.instance.currentUser?.uid;

//   final cartRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('cart')
//       .doc(productId);  

//   final snapshot = await cartRef.get();

//   if (snapshot.exists) {
//     await cartRef.update({
//       "quantity": FieldValue.increment(1),
      
//     });
//   }
//   notifyListeners();
// }

// void decreasequantity(int index, String productId) async { //cart
//   if (quantity[index] > 1) {
//     quantity[index]--; 

//     final uid = FirebaseAuth.instance.currentUser?.uid;

//     final cartRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('cart')
//         .doc(productId);

//     final snapshot = await cartRef.get();

//     if (snapshot.exists) {
//       await cartRef.update({
//         "quantity": FieldValue.increment(-1),
//       });
//     }
//     notifyListeners();
//   }
// }


// int getQuantityById(String productId) { //cart
//   int index = cartlist.indexWhere((p) => p.id.toString() == productId);
//   if (index != -1 && index < quantity.length) {
//     return quantity[index];
//   }
//   return 0;
// }



// Future<void> addToCart(String itemId) async {  //cart
//   final uid = FirebaseAuth.instance.currentUser?.uid;



//   if (uid == null) {
//     throw Exception("User not logged in");
//   }

//   final cartRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('cart')
//       .doc(itemId);

//   final snapshot = await cartRef.get();

//     await cartRef.set({
//       "quantity": 1,
//       "addedAt": FieldValue.serverTimestamp(),
//     });
  
// }

// Future<void> addToFav(String itemId) async { //fav
//   final uid = FirebaseAuth.instance.currentUser?.uid;



//   if (uid == null) {
//     throw Exception("User not logged in");
//   }

//   final favRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('Fav')
//       .doc(itemId);

//   final snapshot = await favRef.get();
//   if(snapshot.exists){
//     await favRef.delete();
//     favid.remove(itemId);
//   }
//    else{
//     await favRef.set({
//       "favourite":true,

//     },
// );
//         favid.add(itemId);

//    }

//    notifyListeners();
  
// }






// Future<List< Map<String,dynamic>>> fetchid() async{ //cart
//     final uid = FirebaseAuth.instance.currentUser?.uid;

//   final cart=await FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').get();
//   final items=cart.docs.map((doc) {
//     final data=doc.data();

//     return{
//     "id":doc.id,

//     "quantity":data["quantity"],

//     };


     

//   } ).toList();

//   return items;

// }

// Future<void> fetchFav() async { //fav
//   final uid = FirebaseAuth.instance.currentUser?.uid;
//   final favDocs = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('Fav')
//       .get();

//   favid = favDocs.docs.map((doc) => doc.id).toList();

//   favs = allProducts
//       .where((prod) => favid.contains(prod.id.toString()))
//       .toList();

//   notifyListeners();
// }



// void loaddata()async{ //cart
//   try{
//     final cartdata=await fetchid();
//     cartlist.clear();
//     quantity.clear();
//     for(var item in cartdata){
//       print("id${item['id']}  quantity ${item["quantity"]}",);
//       for(var prod in allProducts ){
//         if(prod.id.toString()==item['id']){
//           cartlist.add(prod);
//           quantity.add(item['quantity']);
//           print(item['quantity']);
//         }
//       }
//     }
//     notifyListeners();
//   }catch(e){
//     print("eeeeeeeeeeeeeeeeeeeerrror${e}");
//   }
// }




// Future<String?> fetchdata() async { //data
//   _isloading = true;
//   notifyListeners();
//   try {
//     final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

//     print("📡 Status Code: ${response.statusCode}");

//     if (response.statusCode == 200) {
//       List<dynamic> jsondata = jsonDecode(response.body);

//       print("✅ Data length: ${jsondata.length}");
//       print("🛍️ First product: ${jsondata.isNotEmpty ? jsondata[0] : 'No data'}");

//       _allProducts = jsondata.map((e) => Product.fromJson(e)).toList();
//       _originalFilteredList = _allProducts;
//       filteredlist = _allProducts;

//       _isloading = false;
//       notifyListeners();
//       return null; // null يعني مفيش مشكلة
//     } else {
//       print("❌ Server error: ${response.statusCode}");
//       return "Server error: ${response.statusCode}";
//     }
//   } catch (e) {
//     print("⚠️ Exception: $e");
//     return "Error: $e";
//   }
// }

  // void filteredbycategory(String category) { //filter
  //   if (category.toLowerCase() == 'all') {
  //     _originalFilteredList = _allProducts;
  //   } else {
  //     _originalFilteredList = _allProducts
  //         .where((product) => product.category.toLowerCase() == category.toLowerCase())
  //         .toList();
  //   }
  //   filteredlist = _originalFilteredList; 
  //   notifyListeners();
  // }

  // void searchProduct(String query) {
  //   if (query.isEmpty) {
  //     filteredlist = _originalFilteredList;
  //   } else {
  //     filteredlist = _originalFilteredList
  //         .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }
  //   notifyListeners();
  // }


}
