import 'dart:convert';
import 'package:dindin_manager/screens/insiraLancamento.dart';
import 'package:http/http.dart' as http;
import 'model/lancamento.dart';

class LancamentoServices{

  Future<List<Lancamento>> fetch(String pesquisa) async {
    var parametroUrl = pesquisa != ""
        ? "?descricao=${pesquisa.replaceAll(" ", "%20")}"
        : "";
    try{
      var response = await http.get(Uri.parse("http://10.0.2.2:3000/Lancamentos${parametroUrl}"), headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var getData = json.decode(response.body) as List;
        var futureList = getData.map((e) => Lancamento.fromJson(e)).toList();
        return futureList;
      }else{
        throw Exception('Failed to load album');
      }
    }catch(e){
      throw Exception(e);
    }
  }

  remove(String id) async {
    await http.delete(
      Uri.parse('http://10.0.2.2:3000/Lancamentos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  insert(String nome, String preco, CreditoDebito? opcao) async {
    int id = await generateID() + 1;

    await http.post(Uri.parse("http://10.0.2.2:3000/Lancamentos"), body: {
      "id": id.toString(),
      "descricao": nome,
      "preco": (opcao == CreditoDebito.credito)
          ? preco
          : (double.parse(preco) * (-1)).toString(),
      "ehCredito": (opcao == CreditoDebito.credito).toString()
    });
  }

  update(String id, String nome, String preco, CreditoDebito? opcao) async {
    await http.put(
        Uri.parse('http://10.0.2.2:3000/Lancamentos/$id'),
        body: {
          "descricao": nome,
          "preco": (opcao == CreditoDebito.credito)
              ? preco
              : (double.parse(preco) * (-1)).toString(),
          "ehCredito": (opcao == CreditoDebito.credito).toString()
        }
    );
  }

  Future<int> generateID() async {
    var response = await http.get(Uri.parse("http://10.0.2.2:3000/Lancamentos"), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var getData = json.decode(response.body) as List;
      var list = getData.map((e) => Lancamento.fromJson(e)).toList();
      return list.length;
    }else{
      throw Exception("Falha");
    }
  }
}