import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_app/DailyAdjustedModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String apikey = "KVGTWNS5U9H7E4YC";
  late DailyAdjusted stockData;  // declare a non-nullable variable 'stockdata' without initializing it immediately.The late keyword is useful when you cannot initialize the variable right away but are sure that it will have a value before it’s accessed.

  @override
  void initState(){  //function that trigger one time when the widget created
    super.initState();  //to ensure about the parent
    getHttprequest("IBM");
  }

  Future<void> getHttprequest(String symbolName) async{
    String url ="https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=RELIANCE.BSE&outputsize=full&apikey="+apikey;
    var response = await http.get(Uri.parse(url));  //API provides 'get' method to get the data from server for which we request
    if(response.statusCode==200) {
      print(response.body);
      stockData = dailyAdjustedFromMap(response.body);
    }
    print("request received");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
      ),
      body: FutureBuilder(
          future: future,
          builder: builder)
    );
  }
}
