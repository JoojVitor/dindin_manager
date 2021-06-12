import 'package:flutter/cupertino.dart';

class Lancamento{
  final int Codigo;
  final bool ehCredito;
  final DateTime Data;
  final String Nome;
  final double Preco;

  Lancamento({
    required this.Codigo,
    required this.ehCredito,
    required this.Data,
    required this.Nome,
    required this.Preco
  });

  factory Lancamento.fromJson(Map<String, dynamic> json){
    return Lancamento(
        Codigo: json['Codigo'],
        ehCredito: json['ehCredito'],
        Data: json['Data'],
        Nome: json['Nome'],
        Preco: json['Preco']
    );
  }
}