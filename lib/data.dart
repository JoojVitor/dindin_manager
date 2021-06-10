import 'package:flutter/material.dart';

import 'model/lancamento.dart';

class Data {
  static List<Lancamento> lancamentos = [
    Lancamento(
      Codigo: 1,
      ehCredito: false,
      Data: DateTime.now(),
      Nome: 'Gasto',
      Preco: 2.19
    ),
    Lancamento(
        Codigo: 2,
        ehCredito: true,
        Data: DateTime.now(),
        Nome: 'Lucro',
        Preco: 1.99
    )
  ];
}