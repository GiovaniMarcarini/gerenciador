import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/tarefa.dart';

class FiltroPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';
  static const chaveCampoOrdenacao = 'campoOrdenacao';
  static const chaveOrdenacaoDrescente = 'usarOrdenacaoDrescente';
  static const chaveFiltroDescricao = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage>{
  final _camposParaOrdenacao = {
    Tarefa.CAMPO_ID: 'Código',
    Tarefa.CAMPO_DESCRICAO: 'Descrição',
    Tarefa.CAMPO_PRAZO: 'Prazo'
  };
  late final SharedPreferences _prefs;
  final _descricaoController = TextEditingController();
  String _campoOrdenacao = Tarefa.CAMPO_ID;
  bool _usarOrdenacaoDrescente = false;
  bool _alterouvalores = false;

  @override
  void initState(){
    super.initState();
    _carregarSharedPreference();
  }

  void _carregarSharedPreference() async{
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _campoOrdenacao = _prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? Tarefa.CAMPO_ID;
      _usarOrdenacaoDrescente = _prefs.getBool(FiltroPage.chaveOrdenacaoDrescente) == true;
      _descricaoController.text = _prefs.getString(FiltroPage.chaveFiltroDescricao) ?? '';
    });
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: _onVoltarClick,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filtro de Ordenação'),
        ),
        body: _criarBody(),
      ),
    );

  }

  Widget _criarBody() => ListView(
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Text('Campo para ordenação'),
      ),
      for (final campo in _camposParaOrdenacao.keys)
        Row(
          children: [
            Radio(
              value: campo,
              groupValue: _campoOrdenacao,
              onChanged: _onCampoOrdenacaoChanged,
            ),
            Text(_camposParaOrdenacao[campo]!),
          ],
        ),
      const Divider(),
      Row(
        children: [
          Checkbox(
            value: _usarOrdenacaoDrescente,
            onChanged: _onUsarOrdemDecrescente,
          ),
          const Text('Usar ordem decrescente'),
        ],
      ),
      const Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Descrição começa com',
          ),
          controller: _descricaoController,
          onChanged: _onFiltroDescricaoChanged,
        ),
      )

    ],
  );

  void _onCampoOrdenacaoChanged(String? valor){
    _prefs.setString(FiltroPage.chaveCampoOrdenacao, valor!);
    _alterouvalores = true;
    setState(() {
      _campoOrdenacao = valor;
    });
  }
  void _onUsarOrdemDecrescente(bool? valor){
    _prefs.setBool(FiltroPage.chaveOrdenacaoDrescente, valor!);
    _alterouvalores = true;
    setState(() {
      _usarOrdenacaoDrescente = valor;
    });
  }

  void _onFiltroDescricaoChanged(String? valor){
    _prefs.setString(FiltroPage.chaveFiltroDescricao, valor ?? '');
    _alterouvalores = true;
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouvalores);
    return true;
  }

}