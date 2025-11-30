
import 'dart:convert';

import 'package:ecommerce/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class DataProvider extends ChangeNotifier {
  List<Product> _allProducts = [];            
  List<Product> _originalFilteredList = [];   
  List<Product> filteredlist = [];            

  bool _isLoading = false;
  bool _isFetched = false;

  List<Product> get products => _allProducts;
  bool get isLoading => _isLoading;
  bool get isFetched => _isFetched;

  Future<String?> fetchdata() async {
    if (_isFetched) return null;   

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      debugPrint("📡 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> jsondata = jsonDecode(response.body);
        debugPrint("Data length: ${jsondata.length}");
        debugPrint(" First product: ${jsondata.isNotEmpty ? jsondata[0] : 'No data'}");

        _allProducts = jsondata.map((e) => Product.fromJson(e)).toList();
        _originalFilteredList = _allProducts;
        filteredlist = _allProducts;

        _isFetched = true;
        _isLoading = false;
        notifyListeners();
        return null;   
      } else {
        _isLoading = false;
        notifyListeners();
        debugPrint(" Server error: ${response.statusCode}");
        return "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(" Exception: $e");
      return "Error: $e";
    }
  }

  void reset() {
    _allProducts = [];
    _originalFilteredList = [];
    filteredlist = [];
    _isFetched = false;
    _isLoading = false;
    notifyListeners();
  }
}
