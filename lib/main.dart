import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dindin_manager/screens/insiraLancamento.dart';
import 'package:dindin_manager/widgets/lancamento_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'model/lancamento.dart';

Future<List<Lancamento>> fetchLancamento() async {
  try{
    var response = await http.get(Uri.parse("http://10.0.2.2:3000/Lancamentos"), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var getData = json.decode(response.body) as List;
      var futureList = getData.map((e) => Lancamento.fromJson(e)).toList();
      return futureList;
    }else{
      throw Exception('Failed to load album');
    }
  }catch(e){
    throw Exception(e);
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

class item{
  var items = 0;
}

class _MyAppState extends State<MyApp> {
  late Future<List<Lancamento>> futureLancamento;
  final key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    //HttpOverrides.global = new MyHttpOverrides();
    futureLancamento = fetchLancamento();
  }

  int _tabIndex = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        backgroundColor: Colors.green,
        body: [homeWidget(), InsiraLancamento()][_tabIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Adicionar",
            ),
          ],
          onTap: (index){
            setState(() {
              _tabIndex = index;
            });
          },
          fixedColor: Colors.green,
        ),
      ),
    );
  }

  Widget homeWidget(){
    return Container(
      child: FutureBuilder<List<Lancamento>>(
        future: futureLancamento,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var listData = snapshot.data as List;
            item().items = listData.length;
            var formatter = NumberFormat("00.00");
            var total = listData.map((item) => item.Preco)
                .reduce((a, b) => a + b);
            return Column(
              children: [
                Container(
                  child: Container(
                    padding: EdgeInsets.all(60),
                    child: Text(
                      'R\$' + formatter.format(total),
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
                      key: key,
                      initialItemCount: listData.length,
                      itemBuilder: (context, index, animation) =>
                        buildItem(listData[index], index, animation),
                    )
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget formWidget(){
    return Container(
      child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Preencha este campo';
                  }
                  return null;
                },
              )
            ],
          )
      ),
    );
  }

  static const opcoes = [
    "Alterar",
    "Excluir"
  ];

  Widget buildItem(data, int index, Animation<double> animation) {
    return LancamentoWidget(
        lancamento: data,
        animation: animation,
        onClicked: () {
        }
    );
  }

  Future<http.Response> removeItem(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('http://10.0.2.2:3000/Lancamentos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    MyApp();
    return response;
  }

  Widget buildInsertButton() =>
      ElevatedButton(
          child: Text(
            'Novo',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green)
          ),
          onPressed: (){}
      );
}