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
  List<StockSymbol>SearchSymbol=[];  //list that will update acc to user search input

  @override
  void initState(){
    super.initState();
    getSymbol();
  }

  void SearchList(String val){
    setState(() {  // so that searchlist rebuild whenever changes occures
      if(val.isEmpty){
        SearchSymbol = SymbolList;
      }
      else{
        SearchSymbol=SymbolList.where((element)=>element.symbol.toString().toLowerCase().startsWith(val.toString().toLowerCase())).toList();
      }
    });
  }



  Future<List<StockSymbol>>getSymbol() async {  // return type will be list of StockSymbol-model
   final response = await http.get(Uri.parse('https://finnhub.io/api/v1/stock/symbol?exchange=US&token=${apikey}'));  //URI specify the location of resources that we want to access
   var data = jsonDecode(response.body.toString());

   if(response.statusCode==200){

    for(Map<String,dynamic> i in data){
      StockSymbol stockSymbol = StockSymbol(symbol: i['symbol']);  // create an object and give a required parameter to the constructor
      SymbolList.add(stockSymbol);
    }
    setState(() {
      SearchSymbol = SymbolList;
    });
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

      body:Column(
        children: [
          Expanded(
            flex: 1,
              child: Padding(
                  padding:const EdgeInsets.all(10),
                child: TextField(
                  onChanged:(value){
                    SearchList(value); // update acc to user input
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText:'Search Symbol',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              )
          ),
          Expanded(
            flex: 6,
            child: FutureBuilder(
                future: getSymbol(),
                builder: (context,AsyncSnapshot<List<StockSymbol>> snapshot){
                  return ListView.builder(
                    itemCount: SearchSymbol.length,
                      itemBuilder:(context,index){
                      return Padding(
                          padding: const EdgeInsets.all(6.0),
                     child: ListTile(
                      title: Text(SearchSymbol[index].symbol.toString() ,style: TextStyle(fontSize: 17),),
                      ),);
                      }
                  );
                }
            ),
          ),
        ],
      )
    );
  }
}
