import 'package:gerenciador/model/tarefa.dart';
import 'package:flutter/material.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  final tarefas = <Tarefa>[
    Tarefa(id: 1, descricao: 'Fazer Exercício 1', prazo: DateTime.now().add(Duration(days: 5))),
    Tarefa(id: 2, descricao: 'Exercicio 2', prazo: DateTime.now().add(Duration(days: 3)))
  ];


  Widget build (BuildContext context){
    return Scaffold(
      appBar: criarAppBar(),
      body: criarBody(),
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


}