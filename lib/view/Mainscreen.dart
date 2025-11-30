import 'package:ecommerce/main.dart';
import 'package:ecommerce/view/cart.dart';
import 'package:ecommerce/view/favourite.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {

    int selectedindex=0;

  List<Widget> Pages=[
MyHomePage(title: '',),
Favourite(),
Cart(),

  ];

  ontap(index){
    selectedindex=index;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[selectedindex],
            bottomNavigationBar: BottomNavigationBar(

              backgroundColor: Colors.white,
              selectedIconTheme:IconThemeData(color: Colors.blue[300]),
                            unselectedIconTheme:IconThemeData(color: Colors.grey[600]),
                              selectedItemColor: Colors.blue[300],    
  unselectedItemColor: Colors.grey[600],    


              onTap: ontap,
              currentIndex: selectedindex,
              items: [BottomNavigationBarItem( label: 'home',icon: Icon(Icons.home,)),
      BottomNavigationBarItem(label: 'Favourite',icon: Icon(Icons.favorite)),
      BottomNavigationBarItem(label: 'Cart',icon: Icon(Icons.shopping_bag)),
      ],),

    );
  }
}