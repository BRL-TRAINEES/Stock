import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Holidays extends StatefulWidget {
  const Holidays({super.key});

  @override
  State<Holidays> createState() => _HolidaysState();
}

class _HolidaysState extends State<Holidays> {
  List<dynamic> finalData = [];

  Future<void> getData() async {
    String url = 'https://finnhub.io/api/v1/stock/market-holiday?exchange=US&token=${dotenv.env['apikey']}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        finalData = jsonResponse['data']; // Update to access the 'data' key.
      });
    } else {
      throw Exception('Failed to load holidays details');
    }
  }

  @override
  void initState() {
    super.initState();
    getData(); // Call getData() in initState to ensure it is only called once.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Holidays',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromRGBO(40, 50, 90, 1),
      ),
      body: finalData.isEmpty
          ? Center(
          child: LoadingAnimationWidget.inkDrop(
            color: Color.fromRGBO(40, 50, 90, 1),
            size: 35,
          ),
      )
          : ListView.builder(
        itemCount: finalData.length,
        itemBuilder: (context, index) {
          var holiday = finalData[index];
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(40, 50, 90, 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event: ${holiday['eventName']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Date: ${holiday['atDate']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  holiday['tradingHour']?.isEmpty == true
                      ? 'Trading Hours: Closed'
                      : 'Trading Hours: ${holiday['tradingHour']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.greenAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
