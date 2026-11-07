import 'package:flutter/material.dart';

import '../models/cidade.dart';
import '../models/previsao.dart';
import '../services/clima_service.dart';
import '../services/preferencias_service.dart';
import '../utils/analise_previsao.dart';
import '../utils/apresentacao.dart';
import '../utils/estado_carregamento.dart';
import '../utils/nivel_risco.dart';
import '../widgets/card_risco.dart';
import '../widgets/estado_erro.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/item_previsao.dart';
import '../widgets/loading.dart';
import 'detalhes_dia_screen.dart';

class PrevisaoScreen extends StatefulWidget {
  final Cidade cidade;

  const PrevisaoScreen({super.key, required this.cidade});

  @override
  State<PrevisaoScreen> createState() => _PrevisaoScreenState();
}

class _PrevisaoScreenState extends State<PrevisaoScreen> {
  final ClimaService _clima = ClimaService();
  final PreferenciasService _preferencias = PreferenciasService();

  EstadoCarregamento _estado = EstadoCarregamento.inicial;
  List<Previsao> _previsoes = [];
  String _mensagemErro = '';
  bool _favorita = false;
  bool _apenasRisco = false;

  @override
  void initState() {
    super.initState();
    _carregarPrevisao();
    _carregarFavorita();
  }

  Future<void> _carregarFavorita() async {
    final favorita = await _preferencias.ehFavorita(widget.cidade);
    if (!mounted) return;
    setState(() => _favorita = favorita);
  }

  Future<void> _carregarPrevisao({bool atualizacao = false}) async {
    if (!atualizacao) {
      setState(() => _estado = EstadoCarregamento.carregando);
    }

    try {
      final previsoes = await _clima.buscarPrevisao(widget.cidade);
      _preferencias.salvarUltimaCidade(widget.cidade);
      if (!mounted) return;
      setState(() {
        _previsoes = previsoes;
        _estado = EstadoCarregamento.sucesso;
      });
    } on ClimaException catch (e) {
      if (!mounted) return;
      if (atualizacao && _previsoes.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.mensagem)),
        );
        return;
      }
      setState(() {
        _mensagemErro = e.mensagem;
        _estado = EstadoCarregamento.erro;
      });
    }
  }

  Future<void> _alternarFavorito() async {
    final agoraFavorita = await _preferencias.alternarFavorito(widget.cidade);
    if (!mounted) return;
    setState(() => _favorita = agoraFavorita);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          agoraFavorita
              ? 'Cidade adicionada aos favoritos.'
              : 'Cidade removida dos favoritos.',
        ),
      ),
    );
  }

  void _abrirDetalhes(Previsao previsao) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetalhesDiaScreen(
          cidade: widget.cidade,
          previsao: previsao,
        ),
      ),
    );
  }

  Widget _corpo() {
    switch (_estado) {
      case EstadoCarregamento.inicial:
        return const EstadoVazio(
          icone: Icons.cloud_queue_rounded,
          mensagem: 'Preparando a previsão...',
        );
      case EstadoCarregamento.carregando:
        return const Loading(mensagem: 'Carregando previsão...');
      case EstadoCarregamento.erro:
        return EstadoErro(
          mensagem: _mensagemErro,
          onTentarNovamente: _carregarPrevisao,
        );
      case EstadoCarregamento.sucesso:
        return _lista();
    }
  }

  Widget _resumo(Previsao critico) {
    final semRisco = critico.risco == NivelRisco.baixo;
    final titulo = semRisco
        ? 'Sem alertas para os próximos dias'
        : 'Maior atenção: ${rotuloDia(critico.data)}, ${dataCurta(critico.data)}';
    final mensagem = semRisco
        ? critico.risco.orientacao
        : '${formatarNumero(critico.chuvaMm)} mm previstos. ${critico.risco.orientacao}';

    return CardRisco(nivel: critico.risco, titulo: titulo, mensagem: mensagem);
  }

  Widget _lista() {
    final visiveis = _apenasRisco ? apenasComRisco(_previsoes) : _previsoes;
    final critico = diaMaisCritico(_previsoes);

    return RefreshIndicator(
      onRefresh: () => _carregarPrevisao(atualizacao: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (critico != null) _resumo(critico),
          SwitchListTile(
            value: _apenasRisco,
            onChanged: (valor) => setState(() => _apenasRisco = valor),
            title: const Text('Mostrar apenas dias com risco'),
            contentPadding: EdgeInsets.zero,
          ),
          if (visiveis.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Nenhum dia com risco moderado ou alto previsto.',
                textAlign: TextAlign.center,
              ),
            ),
          for (final previsao in visiveis)
            ItemPrevisao(
              previsao: previsao,
              onTap: () => _abrirDetalhes(previsao),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cidade.rotulo),
        actions: [
          IconButton(
            tooltip: _favorita ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
            icon: Icon(
              _favorita ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            ),
            onPressed: _alternarFavorito,
          ),
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _carregarPrevisao,
          ),
        ],
      ),
      body: _corpo(),
    );
  }
}
