import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Holidays extends StatefulWidget {
  const Holidays({super.key});

  @override
  State<Holidays> createState() => _HolidaysState();
}

class _HolidaysState extends State<Holidays> {
  List<dynamic>finalData=[];

  Future<void>getData()async{
    String url ='https://finnhub.io/api/v1/stock/market-holiday?exchange=US&token=${dotenv.env['apikey']}';
      var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Loaded API Key----------------: ${dotenv.env['apikey']}');
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
        title: Text('Market Holidays'),
      ),
     body:  finalData.isEmpty
    ? const Center(child: Text('Unable to load'))
        : ListView.builder(
               itemCount: finalData.length,
                 itemBuilder:(context,index) {
                   var holiday = finalData[index];
                   return Container(
                      color: Colors.black38,
                     padding: EdgeInsets.all(15),
                    margin: EdgeInsets.all(8),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Event : ${holiday['eventName']}'),
                         Text(
                           'Date: ${holiday['atDate']}',
                           style: TextStyle(fontSize: 16),
                         ),
                         Text(holiday['tradingHour']?.isEmpty==true? 'Trading Hours: Closed' : 'Trading Hours: ${holiday['tradingHour'] }'),  // since in api response empty string is coming if its closed full day
                       ],
                     ),
                   );
                 },
             ),
    );
    }
  }

