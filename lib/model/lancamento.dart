import 'package:flutter/cupertino.dart';

class Lancamento{
  final int Codigo;
  final bool ehCredito;
  final String Nome;
  final double Preco;

  Lancamento({
    required this.Codigo,
    required this.ehCredito,
    required this.Nome,
    required this.Preco
  });

  factory Lancamento.fromJson(Map<String, dynamic> json){
    return Lancamento(
        Codigo: int.parse(json['id']),
        ehCredito: json['ehCredito'] == "true",
        Nome: json['descricao'],
        Preco: double.parse(json['preco'])
    );
  }
}