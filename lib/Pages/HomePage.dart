import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/Models/StockSymbols.dart';
import 'package:stock_app/Pages/StockDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apikey = 'cs6hoc9r01qkeuli35c0cs6hoc9r01qkeuli35cg';
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
        SearchSymbol = SymbolList
            .where((element) => element.symbol
            .toString()
            .toLowerCase()
            .startsWith(val.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> getSymbol() async {
    final response = await http.get(
      Uri.parse(
          'https://finnhub.io/api/v1/stock/symbol?exchange=US&token=$apikey'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        SymbolList = data
            .map<StockSymbol>((item) => StockSymbol(symbol: item['symbol']))
            .toList();
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
            flex: 1,
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
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: SearchSymbol.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(
                        SearchSymbol[index].symbol.toString(),
                        style: const TextStyle(fontSize: 17),
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