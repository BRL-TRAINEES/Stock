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
  List<dynamic> finalData = [];

  Future<void> getData() async {
    String url =
        'https://finnhub.io/api/v1/stock/market-holiday?exchange=US&token=${dotenv.env['apikey']}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        finalData = jsonResponse; // Access the entire response data.
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
        backgroundColor: Color.fromRGBO(40, 50, 90, 1),
        title: const Text(
          'Market Holidays',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(30, 40, 80, 1),
              Color.fromRGBO(70, 100, 160, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: finalData.isEmpty
            ? const Center(
          child: Text(
            'Unable to load holidays data.',
            style: TextStyle(color: Colors.white),
          ),
        )
            : ListView.builder(
          itemCount: finalData.length,
          itemBuilder: (context, index) {
            var holiday = finalData[index];
            return Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event: ${holiday['eventName']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(40, 50, 90, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${holiday['atDate']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    holiday['tradingHour']?.isEmpty == true
                        ? 'Trading Hours: Closed'
                        : 'Trading Hours: ${holiday['tradingHour']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
