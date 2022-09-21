import 'package:gerenciador/model/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador/pages/filtro_page.dart';
import 'package:gerenciador/widgets/conteudo_form_dialog.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{
  var _ultimoId = 0;
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

    final tarefas = <Tarefa>[
    //Tarefa(id: 1, descricao: 'Fazer Exercício 1', prazo: DateTime.now().add(Duration(days: 5))),
    //Tarefa(id: 2, descricao: 'Exercicio 2', prazo: DateTime.now().add(Duration(days: 3))),
    //Tarefa(id: 3, descricao: 'Exercicio 3', prazo: DateTime.now().add(Duration(days: 8)))
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
          onPressed: _abrirPaginaFiltro,
        )
      ],
    );
  }

  Widget criarBody(){
    if (tarefas.isEmpty){
      return Center (child: Text('Nenhuma tarefa cadastrada',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      );
    }
    return ListView.separated(
      itemCount: tarefas.length,
      itemBuilder: (BuildContext context, int index){
        final tarefa = tarefas[index];
        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text('Prazo - ${tarefa.prazoFormatado}')
        ),
          itemBuilder: (BuildContext context) => criarItensMenuPopup(),
        onSelected: (String valorSelecionado){
            if (valorSelecionado == ACAO_EDITAR){
              _abrirForm(tarefaAtual: tarefa, indice: index);
        }else{
              _excluir(index);
            }
        },
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
            child: Text('Cancelar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
            ),
            onPressed: () => Navigator.of(context).pop()),
        TextButton(
        child: Text('Salvar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
        ),
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
  void _abrirPaginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores){
      if (alterouValores == true){

      }
    }
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopup(){
    return[
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              ),
            ),
          ],
        ),

      ),
      PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              ),
            ),
          ],
        ),

      ),
    ];
  }
  void _excluir(int indice){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Atenção',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                ),
              ),
            ],
          ),
          content: Text('Esse registro será removido definitivamente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )
              ),
              onPressed: (){
                Navigator.of(context).pop();
                setState(() {
                  tarefas.removeAt(indice);
                });

              },
            )
          ],
        );
      }
    );
  }
}