import 'package:ecommerce/Model/product.dart';
import 'package:flutter/material.dart';

class Searchprovider extends ChangeNotifier {
  List<Product> _originalFilteredList = [];
  List<Product> filteredlist = [];
  final TextEditingController searchController = TextEditingController();

  void setProducts(List<Product> products) {
    _originalFilteredList = products;
    filteredlist = products;
    notifyListeners();
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredlist = _originalFilteredList;
    } else {
      filteredlist = _originalFilteredList
          .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
