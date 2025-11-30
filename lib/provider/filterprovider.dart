import 'package:ecommerce/Model/product.dart';
import 'package:flutter/material.dart';

class Filterprovider extends ChangeNotifier{
    List<Product> _allProducts = []; 
  List<Product> _originalFilteredList = [];  
  List<Product> filteredlist = [];
 late final  Product product;
    List<Product> get filteredProducts => filteredlist;
      String selectedCategory = "all";   

    


  bool _isLoading = false;   
  bool get isLoading => _isLoading;


  void setProducts(List<Product> products) {
    _isLoading = true;
    notifyListeners();

    _allProducts = products;
    filteredbycategory("all");

    _isLoading = false;
    notifyListeners();
  }

  void filteredbycategory(String category) {
    selectedCategory = category;

    if (category.toLowerCase() == 'all') {
      filteredlist = _allProducts;
    } else {
      filteredlist = _allProducts
          .where((product) =>
              product.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    notifyListeners();
  }
}


