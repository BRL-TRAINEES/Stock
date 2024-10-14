import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';

void main(){
  runApp(const Stock());
}
 class Stock extends StatelessWidget {
   const Stock({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       title: 'Stocks',
       home: HomePage(),
     );
   }
 }
