import 'dart:ui';

import 'package:dindin_manager/main.dart';
import 'package:dindin_manager/model/lancamento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsiraLancamento extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return InsiraLancamentoState();
  }
}

enum CreditoDebito {credito, debito}

class InsiraLancamentoState extends State<InsiraLancamento>{
  var formKey = GlobalKey<FormState>();
  var nome = TextEditingController();
  var preco = TextEditingController();
  var codigo = 0;

  CreditoDebito? _opcao = CreditoDebito.credito;

  insert() async{
    generateID();
    var response = await http.post(Uri.parse("http://10.0.2.2:3000/Lancamentos"),
    body: {
      "id": codigo.toString(),
      "descricao": nome.text,
      "preco": preco.text,
      "ehCredito": (_opcao == CreditoDebito.credito).toString()
    });
    return response;
  }

  generateID() async{
    //late Future<List<Lancamento>> futureLancamento;
    //futureLancamento = fetchLancamento();
    codigo = item().items;
    /*FutureBuilder<List<Lancamento>>(
      future: futureLancamento,
      builder: (context, snapshot){
        if (snapshot.hasData){
          var listData = snapshot.data as List;
          codigo = listData.length + 1;
        }
        return CircularProgressIndicator();
      }
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text("Descrição"),
                    ),
                  ),
                  TextFormField(
                    validator: formValidation,
                    controller: nome,
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text("Preço"),
                    ),
                  ),
                  TextFormField(
                    validator: formValidation,
                    controller: preco,
                  ),
                  ListTile(
                    title: Text('Crédito'),
                    leading: Radio<CreditoDebito>(
                      value: CreditoDebito.credito,
                      groupValue: _opcao,
                      onChanged: (CreditoDebito? value){
                        setState(() {
                          _opcao = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Débito'),
                    leading: Radio<CreditoDebito>(
                      value: CreditoDebito.debito,
                      groupValue: _opcao,
                      onChanged: (CreditoDebito? value){
                        setState(() {
                          _opcao = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Concluído"),
                    onPressed: (){
                      insert();
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyApp()
                          )
                        );
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String? formValidation(value) =>
    value == null
        ? "Preencha este campo"
        : null;
}