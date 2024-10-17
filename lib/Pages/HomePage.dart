import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/Models/StockSymbols.dart';
import 'package:stock_app/Pages/MarketHolidays.dart';
import 'package:stock_app/Pages/StockDetails.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});  // constructor of homepage and we can use const in stateful as well when its parameters are also constant
 //super.key is used in a constructor to pass the key parameter to the parent class. and Key is an identifier for widgets, helping Flutter manage and identify widgets in the widget tree.
  @override      //override: Indicates that this method is overriding the createState() method from the StatefulWidget class.
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<StockSymbol> SymbolList = [];
  List<StockSymbol> SearchSymbol = [];

  @override
  void initState() {  // method called only once when widget is build and before widget put into widget tree , so in initstate we mostly access like fetching data or putting animations
    super.initState();  // Calls the parent class's initState() method to ensure all setup in parent should also be done
    getSymbol();
  }


  void SearchList(String val) {
    setState(() {
      if (val.isEmpty) {
        SearchSymbol = SymbolList;
      } else {
        SearchSymbol = SymbolList.where((element) =>
            element.symbol.toString().toLowerCase().startsWith(val.toLowerCase())).toList();
      }
    });
  }


  Future<void> getSymbol() async {
    final response = await http.get(
      Uri.parse('https://finnhub.io/api/v1/stock/symbol?exchange=US&token=${dotenv.env['apikey']}'),
    );
   // print(dotenv.env['apikey']);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        SymbolList = data.map<StockSymbol>((item) => StockSymbol(symbol: item['symbol'])).toList();
        SearchSymbol = SymbolList;
      });
    } else {
      throw Exception('Failed to load stock symbols');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 40, 80, 1),
        title: const Text(
          'STOCKS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(30, 40, 80, 1),
              Color.fromRGBO(60, 90, 150, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  SearchList(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search Symbol',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Holidays(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 20,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Market Holidays',textStyle: TextStyle(color: Colors.greenAccent,fontSize: 15))
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                //child: Text('Market Holidays'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: SearchSymbol.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(40, 50, 90, 1),
                          Color.fromRGBO(50, 70, 110, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        SearchSymbol[index].symbol.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Stockdetails(
                              symbol: SearchSymbol[index].symbol.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
