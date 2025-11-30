import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cartprovider extends ChangeNotifier{
   List<int> quantity=[]; 
    List<Product> cartlist=[];
      List<Product> get allProducts => _allProducts;
        List<Product> _allProducts = []; 


void setAllProducts(List<Product> products) {
  _allProducts = products;
  notifyListeners();
}


void increasequantity(int index, String productId) async { 
  quantity[index]++; 

  final uid = FirebaseAuth.instance.currentUser?.uid;

  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(productId);  

  final snapshot = await cartRef.get();

  if (snapshot.exists) {
    await cartRef.update({
      "quantity": FieldValue.increment(1),
      
    });
  }
  notifyListeners();
}


void decreasequantity(int index, String productId) async { 
  if (quantity[index] > 1) {
    quantity[index]--; 

    final uid = FirebaseAuth.instance.currentUser?.uid;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId);

    final snapshot = await cartRef.get();

    if (snapshot.exists) {
      await cartRef.update({
        "quantity": FieldValue.increment(-1),
      });
    }
    notifyListeners();
  }
}

int getQuantityById(String productId) { 
  int index = cartlist.indexWhere((p) => p.id.toString() == productId);
  if (index != -1 && index < quantity.length) {
    return quantity[index];
  }
  return 0;
}

Future<void> addToCart(String itemId) async {  
  final uid = FirebaseAuth.instance.currentUser?.uid;



  if (uid == null) {
    throw Exception("User not logged in");
  }

  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(itemId);

  final snapshot = await cartRef.get();

    await cartRef.set({
      "quantity": 1,
      "addedAt": FieldValue.serverTimestamp(),
    });
  
}
  Future<void> removeFromCart(String itemId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(itemId);

    await cartRef.delete();

    cartlist.removeWhere((item) => item.id.toString() == itemId);

    notifyListeners();
  }


Future<List< Map<String,dynamic>>> fetchid() async{ 
    final uid = FirebaseAuth.instance.currentUser?.uid;

  final cart=await FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').get();
  final items=cart.docs.map((doc) {
    final data=doc.data();

    return{
    "id":doc.id,

    "quantity":data["quantity"],

    };


     

  } ).toList();

  return items;

}

void loaddata()async{ 
  try{
    final cartdata=await fetchid();
    cartlist.clear();
    quantity.clear();
    for(var item in cartdata){
      print("id${item['id']}  quantity ${item["quantity"]}",);
      for(var prod in allProducts ){
        if(prod.id.toString()==item['id']){
          cartlist.add(prod);
          quantity.add(item['quantity']);
          print(item['quantity']);
        }
      }
    }
    notifyListeners();
  }catch(e){
    print("eeeeeeeeeeeeeeeeeeeerrror${e}");
  }
}





}