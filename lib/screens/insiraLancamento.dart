import 'dart:async';

import 'package:dindin_manager/main.dart';
import 'package:flutter/material.dart';
import '../lancamento_services.dart';

class InsiraLancamento extends StatefulWidget {
  final id;

  InsiraLancamento({this.id});

  @override
  State<StatefulWidget> createState() {
    return InsiraLancamentoState();
  }
}

enum CreditoDebito { credito, debito }

class InsiraLancamentoState extends State<InsiraLancamento> {
  bool get ehEdicao => widget.id != null;
  var formKey = GlobalKey<FormState>();
  var nome = TextEditingController();
  var preco = TextEditingController();
  var codigo = 0;

  CreditoDebito? _opcao = CreditoDebito.credito;

  String? formValidation(value) => value == null ? "Preencha este campo" : null;

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
                      onChanged: (CreditoDebito? value) {
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
                      onChanged: (CreditoDebito? value) {
                        setState(() {
                          _opcao = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                      child: Text("Concluído"),
                      onPressed: () {
                        if(ehEdicao){
                          LancamentoServices().update(widget.id, nome.text, preco.text, _opcao);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        }else{
                          LancamentoServices().insert(nome.text, preco.text, _opcao);
                          Timer(Duration(seconds: 1), () =>
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MyApp())));
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
