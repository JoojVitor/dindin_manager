import 'dart:async';
import 'package:dindin_manager/lancamento_services.dart';
import 'package:dindin_manager/screens/insiraLancamento.dart';
import 'package:dindin_manager/widgets/lancamento_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/lancamento.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Lancamento>> futureLancamento;
  final key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    futureLancamento = LancamentoServices().fetch("");
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: Text("Meus Lançamentos"),
        ),
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
    var nome = TextEditingController();
    return Container(
      child: FutureBuilder<List<Lancamento>>(
        future: futureLancamento,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var listData = snapshot.data as List;
            var formatter = NumberFormat("0.00");
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
                Container(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    children: [
                      TextFormField(
                        controller: nome,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        onChanged: (pesquisa){
                          futureLancamento = LancamentoServices().fetch(pesquisa);
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: "Pesquisar..."),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(top: 15),
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.white,
                          onPressed: () => LancamentoServices().fetch(""),
                        ),
                      )
                    ],
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

  Widget buildItem(data, int index, Animation<double> animation) {
    return LancamentoWidget(
        lancamento: data,
        animation: animation,
        onClicked: () {
        }
    );
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