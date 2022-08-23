import 'package:gerenciador/model/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador/widgets/conteudo_form_dialog.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  var _ultimoId = 1;

  final tarefas = <Tarefa>[
    Tarefa(id: 1, descricao: 'Fazer Exercício 1', prazo: DateTime.now().add(Duration(days: 5))),
    Tarefa(id: 2, descricao: 'Exercicio 2', prazo: DateTime.now().add(Duration(days: 3))),
    Tarefa(id: 3, descricao: 'Exercicio 3', prazo: DateTime.now().add(Duration(days: 8)))
  ];


  Widget build (BuildContext context){
    return Scaffold(
      appBar: criarAppBar(),
      body: criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Nova Tarefa',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar criarAppBar(){
    return AppBar(
      title: const Text('Tarefas'),
      actions: [
        IconButton (
          icon: const Icon(Icons.filter_list),
          onPressed: () {},
        )
      ],
    );
  }

  Widget criarBody(){
    if (tarefas.isEmpty){
      return const Center (child: Text('Nenhuma tarefa cadastrada',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),);
    }
    return ListView.separated(
      itemCount: tarefas.length,
      itemBuilder: (BuildContext context, int index){
        final tarefa = tarefas[index];
        return ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text('Prazo - ${tarefa.prazoFormatado}')
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  void _abrirForm( {Tarefa? tarefaAtual, int? indice} ){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(tarefaAtual == null ? 'Nova tarefa': 'Alterar tarefa ${tarefaAtual.id}'),
          content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual,),
          actions: [
            TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop()),
        TextButton(
        child: const Text('Salvar'),
        onPressed: (){
          if (key.currentState != null  && key.currentState!.dadosValidos()){
            setState(() {
              final novaTarafa = key.currentState!.novaTarefa;
              if(indice == null){
                novaTarafa.id = ++ _ultimoId;
                tarefas.add(novaTarafa);
        }else{
                tarefas[indice] = novaTarafa;
        }
            });
            Navigator.of(context).pop();
        }
        },
        )

          ],
        );
      }
    );
  }


}