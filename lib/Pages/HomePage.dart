import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/Models/StockSymbols.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final apikey = "cs6hoc9r01qkeuli35c0cs6hoc9r01qkeuli35cg";
  //since server se data list form m aa rha h so definitely hum list lenge usse store krne ke leye
  List<StockSymbol>SymbolList=[];

  @override
  void initState(){
    super.initState();
    getSymbol();
  }

  Future<List<StockSymbol>>getSymbol() async {  // return type will be list of StockSymbol
   final response = await http.get(Uri.parse('https://finnhub.io/api/v1/stock/symbol?exchange=US&token=${apikey}'));  //URI specify the location of resources that we want to access
   var data = jsonDecode(response.body.toString());
   if(response.statusCode==200){
    for(Map i in data){
      StockSymbol stockSymbol = StockSymbol(symbol: i['symbol']);  // create an object and give a required parameter to the constructor
      SymbolList.add(stockSymbol);
    }
    return SymbolList;
   }else {
     throw Exception('Failed to load stock symbols');
   }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
      ),

      body:FutureBuilder(
          future: getSymbol(),
          builder: (context,AsyncSnapshot<List<StockSymbol>> snapshot){
            return ListView.builder(
              itemCount: SymbolList.length,
                itemBuilder:(context,index){
                return Padding(
                    padding: const EdgeInsets.all(6.0),
               child: ListTile(
                title: Text(snapshot.data![index].symbol.toString() ,style: TextStyle(fontSize: 17),),
                ),);
                }
            );
          }
      )
    );
  }
}
