import 'package:dindin_manager/data.dart';
import 'package:dindin_manager/model/lancamento.dart';
import 'package:dindin_manager/widgets/lancamento_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: appHomePage(),
    );
  }
}

class appHomePage extends StatelessWidget{
  late Future<List<Lancamento>> lancamentosf;
  final key = GlobalKey<AnimatedListState>();
  final lancamentos = List.from(Data.lancamentos);

  @override
  void initState(){
    super.initState();
    lancamentosf = fetchLancamentos();
  }

  Future<List<Lancamento>> fetchLancamentos() async{
    final response = await http.get(Uri.parse('https://localhost:44334/api/produto/ConsulteProdutos'));
    if(response.statusCode == 200){
      var getLancamentosData = json.decode(response.body) as List;
      var lancamentosData = getLancamentosData.map((i) => Lancamento.fromJSON(i)).toList();
      return lancamentosData;
    }else{
      throw Exception('Failed to load')
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
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
          Container(
            padding: EdgeInsets.all(16),
            child: buildInsertButton(),
          )
        ],
      ),
    );
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
      onPressed: (){

      },
  );
}

