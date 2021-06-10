import 'package:flutter/cupertino.dart';

class Lancamento{
  final int Codigo;
  final bool ehCredito;
  final DateTime Data;
  final String Nome;
  final double Preco;

  const Lancamento({
    @required this.Codigo,
    @required this.ehCredito,
    @required this.Data,
    @required this.Nome,
    @required this.Preco
  });
}