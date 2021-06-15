import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dindin_manager/widgets/lancamento_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/lancamento.dart';

Future<List<Lancamento>> fetchLancamento() async {
  var url = Uri.parse("https://jsonplaceholder.typicode.com/todos");
  var response = await http.get(url);

    if (response.statusCode == 200) {
      var getData = json.decode(response.body) as List;
      var futureList = getData.map((e) => Lancamento.fromJson(e)).toList();
      return futureList;
    }else{
      throw Exception('Failed to load album');
    }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

/*class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}*/

class _MyAppState extends State<MyApp> {
  late Future<List<Lancamento>> futureLancamento;

  @override
  void initState() {
    super.initState();
    //HttpOverrides.global = new MyHttpOverrides();
    futureLancamento = fetchLancamento();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: FutureBuilder<List<Lancamento>>(
            future: futureLancamento,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var listData = snapshot.data as List;
                var total = listData.map((item) => item.Preco)
                    .reduce((a, b) => a + b);
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'R\$' + total.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: AnimatedList(
                          initialItemCount: listData.length,
                          itemBuilder: (context, index, animation) =>
                          buildItem(listData[index], index, animation),
                          )
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: buildInsertButton(),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildItem(data, int index, Animation<double> animation) =>
    LancamentoWidget(lancamento: data, animation: animation, onClicked: (){});

  Widget buildInsertButton() =>
      ElevatedButton(
          child: Text(
            'Insert item',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white)
          ),
          onPressed: (){}
      );
}