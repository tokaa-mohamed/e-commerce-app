import 'dart:convert';

class Product{
final int id;
final String title;
final String image;
final String category;
final double price;
final String description;



Product({required this.id,required this.title,required this.image,required this.category,required this.price,required this.description});


factory Product.fromJson(Map<String,dynamic> json){
  return Product(
    id: json["id"],
    title: json['title'],
    image: json['image'],
    category: json['category'],
    price: (json['price'] as num).toDouble(),
    description: json['description']
  );
}




}