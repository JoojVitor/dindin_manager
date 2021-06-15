import 'package:flutter/cupertino.dart';

class Lancamento{
  final int Codigo;
  final bool ehCredito;
  final String Nome;
  final int Preco;

  Lancamento({
    required this.Codigo,
    required this.ehCredito,
    required this.Nome,
    required this.Preco
  });

  factory Lancamento.fromJson(Map<String, dynamic> json){
    return Lancamento(
        Codigo: json['userId'],
        ehCredito: json['completed'],
        Nome: json['title'],
        Preco: json['id']
    );
  }
}