import 'package:ecommerce/provider/SearchProvider.dart';
import 'package:ecommerce/provider/filterprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class buildcategorylist extends StatefulWidget {
  const buildcategorylist({super.key});

  @override
  State<buildcategorylist> createState() => _buildcategorylistState();
}

class _buildcategorylistState extends State<buildcategorylist> {
  String selectedCategory = 'all'; 

  @override
  Widget build(BuildContext context) {
    final categories = [
      'all',
      'electronics',
      'jewelery',
      "men's clothing",
      "women's clothing"
    ];

    return SizedBox(
      height: 50,
      child: Consumer<Filterprovider>(
        builder: (context, provider, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  provider.filteredbycategory(category);
   final searchProvider = Provider.of<Searchprovider>(context, listen: false);
  searchProvider.setProducts(provider.filteredProducts); 

                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: provider.selectedCategory == category
                        ? Colors.blue
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: provider.selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
