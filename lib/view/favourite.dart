import 'package:ecommerce/Model/product.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/provider/FavProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FavProvider>(context, listen: false).fetchFav());
  }

  @override
  Widget build(BuildContext context) {
        final Fav = Provider.of<FavProvider>(context);


    return Scaffold(
      appBar: AppBar(
 backgroundColor: Colors.white,
  elevation: 4, 
  toolbarHeight: 70, 
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(20),
    ),
  ),        
leading: IconButton(
  icon: const Icon(Icons.chevron_left, color: Colors.black),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: 'Home'),
      ),
    );
  },
),
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
        ),
      ),
      body:
      
      Consumer<FavProvider>(
  builder: (context, favProvider, _) {

      return ListView.builder(
        padding: const EdgeInsets.all(12),
itemCount: favProvider.favs.length,
itemBuilder: (context, index) {
  final product = favProvider.favs[index];
  bool isFav = favProvider.favid.contains(product.id.toString());

         return Card(
  color: Colors.white, 
  surfaceTintColor: Colors.transparent, 
  margin: const EdgeInsets.symmetric(vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15), 
  ),
  elevation: 6, 
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.price}\$',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Fav.addToFav(product.id.toString());
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isFav),
                        color: isFav ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
  },
      );
  }
      )
    );
  }
}
