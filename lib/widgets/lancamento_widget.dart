import 'package:dindin_manager/model/lancamento.dart';
import 'package:flutter/material.dart';

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
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      leading: IconButton(
        icon: Icon(
            lancamento.ehCredito
            ? Icons.add_circle
            : Icons.remove_circle_rounded ,
            color: lancamento.ehCredito
                    ? Colors.green
                    : Colors.red,
            size: 32),
        onPressed: onClicked,
      ),
      title: Text(lancamento.Nome, style: TextStyle(fontSize: 20)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(lancamento.ehCredito
                ? "+R\$" + lancamento.Preco.toString()
                : "-R\$" + lancamento.Preco.toString(),
              style: TextStyle(
              fontSize: 20,
              color: lancamento.ehCredito
                  ? Colors.green
                  : Colors.red
          ))
        ],
      ),
    ),
  );
}