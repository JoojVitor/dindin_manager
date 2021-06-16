import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormAdicionar extends StatefulWidget{
  @override
  FormAdicionarState createState() =>
      FormAdicionarState();
}

class FormAdicionarState extends State<FormAdicionar>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) =>
      Form(
        key: _formKey,
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
      );
}