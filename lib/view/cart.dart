import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Model/product.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/provider/FavProvider.dart';
import 'package:ecommerce/provider/FavProvider.dart';
import 'package:ecommerce/provider/cartprovider.dart';
import 'package:ecommerce/provider/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

@override
void initState() {
  super.initState();
  Future.microtask(() =>
    Provider.of<Cartprovider>(context, listen: false).loaddata()
  );

    Future.microtask(() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);

    await dataProvider.fetchdata(); 
    cartProvider.setAllProducts(dataProvider.filteredlist); 
     cartProvider.loaddata();
  });

}



  int count=0;
  @override
  Widget build(BuildContext context) {

                    final providercart = Provider.of<Cartprovider>(context);
               final Fav = Provider.of<FavProvider>(context);






    return Scaffold(
      appBar: AppBar(
                backgroundColor: Colors.lightBlue[300],

        leading: IconButton(
  icon: const Icon(Icons.chevron_left, color: Colors.white,size: 35,),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: 'Home'),
      ),
    );
  },
),
title: Consumer<Cartprovider>(
  builder: (context, provider, _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      mainAxisSize: MainAxisSize.min, 
      children: [
        const Icon(Icons.shopping_cart, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          "My Cart (${providercart.cartlist.length})",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  },
),

        ),
        body:
        StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection("cart")
      .snapshots(), 
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    }

    final docs = snapshot.data!.docs;

        
       return  ListView.builder(
        
          itemCount: providercart.cartlist.length,
          itemBuilder: (context, index) {
                         var quantity =providercart.quantity[index];
              bool isFav = Fav.favid.contains(providercart.cartlist[index].id);


            return Card(
  color: Colors.white,
    surfaceTintColor: Colors.transparent, 

  elevation: 6, 
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16), 
  ),
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
  child: Column(
    children: [
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white!,
                  Colors.white!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              '${providercart.cartlist[index].image}',
              height: 100,
              width: MediaQuery.of(context).size.width * 0.2,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Text(
              providercart.cartlist[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Consumer<FavProvider>(
            builder: (context, provider, _) {
              bool isFav = Fav.favid
                  .contains(providercart.cartlist[index].id.toString());
              return IconButton(
                onPressed: () {
                  Fav.addToFav(
                      providercart.cartlist[index].id.toString());
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(isFav),
                    color: isFav ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                ),
              );
              
            },
          ),
          IconButton( 
      onPressed: () {
        providercart.removeFromCart(
          providercart.cartlist[index].id.toString(),
        );
      },
      icon:  Icon(Icons.delete, color: Colors.black),
    ),

        ],
      ),
      const SizedBox(height: 30),
      Row(
        children: [
          const SizedBox(width: 30),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[400],
            ),
            width: 30,
            height: 30,

             child:   Center(
                 child: InkWell(
                  onTap: () {
                    providercart.decreasequantity(index,
                        providercart.cartlist[index].id.toString());
                  },
                   child: const 
                          Icon(Icons.remove, size: 20),
                                    ),
               ),
            ),
          
          const SizedBox(width: 10),
          Text('$quantity'),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue[200],
            ),
            width: 30,
            height: 30,
            child: InkWell(
              onTap: () {
                providercart.increasequantity(index,
                    providercart.cartlist[index].id.toString());
              },
               child:
                Center(child: Icon(Icons.add)),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.2),
          Text(
            '${providercart.cartlist[index].price}\$ ',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      const SizedBox(height: 10),
    ],
  ),
);

            
          }

        );
  }
    ),
    );
  }

}