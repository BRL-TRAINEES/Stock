import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_app/Pages/splashScreen.dart';

Future<void> main()async{   // removing future will not make affect the function of app but its a good practice with async await to ensure that function will preform one after other
  WidgetsFlutterBinding.ensureInitialized();   // it make sure to initialized flutter framework before accessing some services ,here we are loading environmental using dotenv
  await dotenv.load(fileName: "assests/.env"); //accessing the .env file
  runApp(const Stock());   //const will not affect the code and app but it affect the performance of app since with const flutter does'nt create the new instance of same widget everytime we need it , it reuse it
}

 class Stock extends StatelessWidget {
   const Stock({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       title: 'Stocks',
       home: const Splashscreen(),
     );
   }
 }
