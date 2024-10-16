import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assests/.env"); //accessing the .env file
  runApp(const Stock());
}

 class Stock extends StatelessWidget {
   const Stock({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       title: 'Stocks',
       home: const HomePage(),
     );
   }
 }
