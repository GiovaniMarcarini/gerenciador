import 'package:flutter/material.dart';
import 'package:gerenciador/model/tarefa.dart';
import 'package:intl/intl.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefa;

  ConteudoFormDialog( {Key? key, this.tarefa}) : super(key: key);

  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog>{

  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  void initState(){
    super.initState();
    if (widget.tarefa != null){
      _descricaoController.text = widget.tarefa!.descricao;
      _prazoController.text = widget.tarefa!.prazoFormatado;
    }
  }

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição',),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _prazoController,
              decoration: InputDecoration(labelText: 'Prazo',
              prefixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _mostrarCalendario,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _prazoController.clear(),
              ),
              ),
              readOnly: true,
            ),
          ],
      ),
    );
  }

  void _mostrarCalendario(){
    final dataFormatada = _prazoController.text;
    var data = DateTime.now();
    if (dataFormatada.isNotEmpty){
      data = _dateFormat.parse(dataFormatada);
    }

    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days: 5*365)),
      lastDate: data.add(Duration(days: 5*365)),
    ).then((DateTime? dataSelecionada){
      if( dataSelecionada != null){
        setState(() {
          _prazoController.text = _dateFormat.format(dataSelecionada);
        });
      }
    }

    );

  }

  bool dadosValidos() => _formKey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
    id: widget.tarefa?.id ?? 0,
    descricao: _descricaoController.text,
    prazo: _prazoController.text.isEmpty ? null : _dateFormat.parse(_prazoController.text),
  );

}
