import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class News extends StatefulWidget {
  final String date;
  const News({required this.date, super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  var data;

  Future<void> getData() async {
    String url =
        'https://finnhub.io/api/v1/company-news?symbol=AAPL&from=${widget.date}&to=${widget.date}&token=${dotenv.env['apikey']}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 50, 90, 1),
        title: const Text(
          'Latest News',
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
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(child: LoadingAnimationWidget.inkDrop(
                color: Colors.white,
                size: 35,
              ));
            } else {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.blueGrey.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${data[index]['datetime']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Headline: ${data[index]['headline']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(20, 60, 100, 1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Summary :  ${data[index]['summary']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
