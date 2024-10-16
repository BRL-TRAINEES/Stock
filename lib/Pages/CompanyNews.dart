import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  final date;
  const News({required this.date , super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  var data;
  Future<void>getData()async{
    String url ='https://finnhub.io/api/v1/company-news?symbol=AAPL&from=${widget.date}&to=${widget.date}&token=cs6hoc9r01qkeuli35c0cs6hoc9r01qkeuli35cg';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
       data = jsonDecode(response.body.toString());
    }else {
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
        title: Text('Latest News'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
    if (snapshot.connectionState == ConnectionState.waiting) {  // if Api taking time to fetch data
    return const Center(child: CircularProgressIndicator());
          }else{
    return ListView.builder(
       itemCount: 10,
        itemBuilder: (context,index){
         return Container(

           padding: EdgeInsets.all(12),
           margin: EdgeInsets.all(15),
           decoration: BoxDecoration(
             boxShadow:[
           BoxShadow(
           color: Colors.grey.withOpacity(0.5),
           spreadRadius: 2,
           blurRadius: 5,
           offset: Offset(0, 3),
         ),
          ],
             color: Colors.greenAccent,
             borderRadius: BorderRadius.circular(10),
           ),
           child: Column(
             children: [
                Text('DateTime :   ${data[index]['datetime']}'),
                Text('HeadLine :   ${data[index]['headline']}'),
                Text('Summary :    ${data[index]['summary']}'),

             ],
           ),
         );
        }
    );
    }
      },)
    );
  }
}
