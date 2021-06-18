import 'package:dindin_manager/lancamento_services.dart';
import 'package:dindin_manager/model/lancamento.dart';
import 'package:dindin_manager/screens/insiraLancamento.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class LancamentoWidget extends StatelessWidget {
  final Lancamento lancamento;
  final Animation animation;
  final VoidCallback onClicked;

  const LancamentoWidget({
    required this.lancamento,
    required this.animation,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      leading: Container(
        child: Text(
            lancamento.ehCredito
            ? "+R\$" + lancamento.Preco.toString()
            : "-R\$" + lancamento.Preco.toString().substring(1),
            style: TextStyle(
                fontSize: 20,
                color: lancamento.ehCredito
                    ? Colors.green
                    : Colors.red
            )
        ),
      ),
      title: Text(lancamento.Nome, style: TextStyle(fontSize: 20)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PopupMenuButton(
            itemBuilder: (context){
              return [
                PopupMenuItem(
                  value: "Alterar",
                  child: Text("Alterar"),
                ),
                PopupMenuItem(
                  value: "Excluir",
                  child: Text("Excluir"),
                )
              ];
            },
            onSelected: (option){
              if(option == "Alterar"){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => InsiraLancamento(
                      id: lancamento.Codigo.toString(),
                   )
                ));
              }else{
                LancamentoServices().removeItem(lancamento.Codigo.toString());
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MyApp()
                  )
                );
              }
            },
          )
        ],
      ),
    ),
  );


}