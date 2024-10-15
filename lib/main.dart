import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()async{
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
