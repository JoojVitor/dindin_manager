import 'dart:convert';

import 'package:dindin_manager/data.dart';
import 'package:dindin_manager/model/lancamento.dart';
import 'package:dindin_manager/widgets/lancamento_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late Future<List<Lancamento>> futureLancamentos;
  final Key key = GlobalKey<AnimatedListState>();

  @override
  void initState(){
    super.initState();
    futureLancamentos = fetchLancamentos();
  }

  Future<List<Lancamento>> fetchLancamentos() async{
    final response = await http.get(Uri.parse('https://localhost:44334/api/produto/ConsulteProdutos'));
    if(response.statusCode == 200){
      var getLancamentosData = jsonDecode(response.body) as List;
      var lancamentosData = getLancamentosData.map((i) => Lancamento.fromJson(i)).toList();
      return lancamentosData;
    }else{
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerencie seu dindin',
      home: Scaffold(
          backgroundColor: Colors.lightGreen,
          body: FutureBuilder<List<Lancamento>>(
            future: futureLancamentos,
            builder: (context, snapshot){
              if(snapshot.hasData){
                var lancamentos = (snapshot.data as List<Lancamento>);
                return Scaffold(
                  backgroundColor: Colors.lightGreen,
                  body: Column(
                    children: [
                      Expanded(
                        child: AnimatedList(
                          padding: EdgeInsets.only(top: 30),
                          initialItemCount: lancamentos.length,
                          itemBuilder: (context, index, animation) =>
                              buildItem(lancamentos[index], index, animation),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          )
      ),
    );

    /*return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              padding: EdgeInsets.only(top: 30),
              initialItemCount: ,
              itemBuilder: (context, index, animation) =>
                  buildItem(futureLancamentos[index], index, animation),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: buildInsertButton(),
          )
        ],
      ),
    );*/
  }

  Widget buildItem(lancamento, int index, Animation<double> animation) =>
      LancamentoWidget(animation: animation, lancamento: lancamento, onClicked: (){});

  Widget buildInsertButton() => ElevatedButton(
    child: Text(
      'Inserir lançamento',
      style: TextStyle(
          fontSize: 20,
          color: Colors.black
      ),
    ),
    style: ElevatedButton.styleFrom(
        primary: Colors.white
    ),
    onPressed: (){},
  );
}


