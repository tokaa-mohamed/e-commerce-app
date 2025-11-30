import 'package:ecommerce/payment_ways/Stripe_key.dart';
import 'package:ecommerce/provider/FavProvider.dart';
import 'package:ecommerce/provider/SearchProvider.dart';
import 'package:ecommerce/provider/cartprovider.dart';
import 'package:ecommerce/provider/dataprovider.dart';
import 'package:ecommerce/provider/filterprovider.dart';
import 'package:ecommerce/view/cart.dart';
import 'package:ecommerce/view/favourite.dart';
import 'package:ecommerce/view/login.dart';
import 'package:ecommerce/view/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import './provider/auth_provider.dart' as myauth;
import './widgets/categorylist.dart';
import'./view/profile.dart';
import './widgets/productcard.dart';
import 'package:ecommerce/provider/profile_provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart';




void main() async {
 Stripe.publishableKey=Apikeys.Publishablekey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => myauth.AuthProvider()), 
       ChangeNotifierProvider(create: (_) => DataProvider()..fetchdata()),
               ChangeNotifierProvider(create: (_) =>ProfileProvider(),
                ), 
                               ChangeNotifierProvider(create: (_) =>Cartprovider(),
                ), 
                               ChangeNotifierProvider(create: (_) =>Searchprovider(),  ), 
              ChangeNotifierProvider(create: (_) =>Filterprovider(),  ), 
             ChangeNotifierProvider(create: (_) =>FavProvider(),  ), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
  theme: ThemeData(
    scaffoldBackgroundColor: Colors.white, 
  ),

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
 void initState()  {
    super.initState();
      debugPrint("🔥 MyHomePage opened, calling fetchdata()");
    Future.microtask(() async {
     await Provider.of<ProfileProvider>(context, listen: false).loadImage();
      print("image loadded");
      await  Provider.of<DataProvider>(context, listen: false).fetchdata();
          loadInitialData();


    });


  }

  Future<void> loadInitialData() async {
  final dataProvider = Provider.of<DataProvider>(context, listen: false);
  final filterprovider = Provider.of<Filterprovider>(context, listen: false);
  final searchProvider = Provider.of<Searchprovider>(context, listen: false);
  final favProvider = Provider.of<FavProvider>(context, listen: false);

  filterprovider.setProducts(dataProvider.products);

  searchProvider.setProducts(filterprovider.filteredlist);


  favProvider.setAllProducts(dataProvider.filteredlist);
  await favProvider.fetchFav();
}

  @override
  Widget build(BuildContext context) {

final filterprovider = Provider.of<Filterprovider>(context);
final products = filterprovider.filteredProducts;

    final providerauth = Provider.of<myauth.AuthProvider>(context, listen: false);
       final profile = Provider.of<ProfileProvider>(context);
              final search = Provider.of<Searchprovider>(context);
              final searchedlist=search.filteredlist;

  final dataProvider = Provider.of<DataProvider>(context, listen: false);

        final user = FirebaseAuth.instance.currentUser;
          if (dataProvider.isLoading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
           onTap: (){
            Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const ProfileScreen()),
            
);

           },
           child:     CircleAvatar(
              radius: 18,
                backgroundImage: user != null 
      ? profile.getProfileImage(user) 
      : null,
  child: (user == null || profile.getProfileImage(user) == null)
      ? const Icon(Icons.person, size: 30)
      : null,

              
            ),

            ),
            const SizedBox(width: 10),
            FutureBuilder<String?>(
              future: providerauth.getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Hello...',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Text(
                    'Hello 👋',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                }
                return Text(
                  'Hello, ${snapshot.data} 👋',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              providerauth.logout();
                Provider.of<DataProvider>(context, listen: false).reset();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
body: Column(
  children: [
    // ✅ ثابتين فوق
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            controller: search.searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.menu_open),
            ),
            onChanged: (value) {
              Provider.of<Searchprovider>(context, listen: false)
                  .searchProduct(value);
            },
          ),
          const SizedBox(height: 10),
          const buildcategorylist(),
        
          const SizedBox(height: 10),
        ],
      ),
    ),

    Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
           Row(
  children: [
    Container(
      width: 4,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    const SizedBox(width: 8),
    const Text(
      "Featured Products",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
 const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searchedlist.length > 5 ? 5 : searchedlist.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 10),
                    child: buildProductCard(searchedlist[index], index, context),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
   Row(
  children: [
    Container(
      width: 4,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    const SizedBox(width: 8),
     Text(
      filterprovider.selectedCategory,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
           Consumer<Searchprovider>(
  builder: (context, filterprovider, _) {



    if (searchedlist.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchedlist.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        return buildProductCard(searchedlist[index], index, context);
      },
    );
  },
)
  ],
        ),
      ),
    ),
  ],
),
    );
  }
}
