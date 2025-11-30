import 'package:ecommerce/Model/product.dart';
import 'package:ecommerce/provider/FavProvider.dart';
import 'package:ecommerce/provider/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../payment_ways/Manager.dart';


class Cartdetails extends StatefulWidget {
  final Product product;
  final int index;

  const Cartdetails({super.key, required this.product, required this.index});

  @override
  State<Cartdetails> createState() => _CartdetailsState();
}

class _CartdetailsState extends State<Cartdetails> {
  String limitWords(String text, int wordCount) {
    List<String> words = text.split(' ');
    if (words.length <= wordCount) return text;
    return words.take(wordCount).join(' ') + '...';
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FavProvider>(context, listen: false).fetchFav();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavProvider>(context);
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(      limitWords(widget.product.title, 2),
),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.network(
                  widget.product.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            ListTile(
              title: Text(
                widget.product.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Consumer<FavProvider>(
                builder: (context, provider, _) {
                  bool isFav = favProvider.favid.contains(widget.product.id.toString());
                  return IconButton(
                    onPressed: () => favProvider.addToFav(widget.product.id.toString()),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
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
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                limitWords(widget.product.description, 20),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[400],
                    ),
                    width: 30,
                    height: 30,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          cartProvider.decreasequantity(
                            cartProvider.cartlist.indexWhere(
                              (p) => p.id.toString() == widget.product.id.toString(),
                            ),
                            widget.product.id.toString(),
                          );
                        },
                        child: const 
                        Icon(Icons.remove, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${cartProvider.getQuantityById(widget.product.id.toString())}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[200],
                    ),
                    width: 30,
                    height: 30,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          cartProvider.increasequantity(
                            cartProvider.cartlist.indexWhere(
                              (p) => p.id.toString() == widget.product.id.toString(),
                            ),
                            widget.product.id.toString(),
                          );
                        },
                        child: const Icon(Icons.add, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () => cartProvider.addToCart(widget.product.id.toString()),
                      child: const Text('Add to cart'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        int amountInCents = (widget.product.price * 100).round(); 

                        StripeService.makePayment( amountInCents, "usd");

                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
