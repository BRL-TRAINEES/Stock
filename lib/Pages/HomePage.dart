import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/Models/StockSymbols.dart';
import 'package:stock_app/Pages/MarketHolidays.dart';
import 'package:stock_app/Pages/StockDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<StockSymbol> SymbolList = [];
  List<StockSymbol> SearchSymbol = [];

  @override
  void initState() {
    super.initState();
    getSymbol();
  }


  void SearchList(String val) {
    setState(() {
      if (val.isEmpty) {
        SearchSymbol = SymbolList;
      } else {
        SearchSymbol = SymbolList.where((element) => element.symbol.toString().toLowerCase().startsWith(val.toLowerCase())).toList();
      }
    });
  }

  Future<void> getSymbol() async {
    final response = await http.get(

      Uri.parse(
          'https://finnhub.io/api/v1/stock/symbol?exchange=US&token=${dotenv.env['apikey']}'),
    );
 print(dotenv.env['apikey']);

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
        title: const Text('Stocks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  SearchList(value);
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Search Symbol',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Holidays(),
                    ),
                  );
                },
                child: Text('See Market Holidays')),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: SearchSymbol.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(8, 5, 8, 8),
                  decoration: BoxDecoration(
                    boxShadow:[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Color.fromRGBO(40, 50, 90,1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(
                        SearchSymbol[index].symbol.toString(),
                        style: const TextStyle(fontSize: 17,color: Colors.white),
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
    );
  }
}