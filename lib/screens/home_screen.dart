import 'package:flutter/material.dart';

import '../models/cidade.dart';
import '../services/clima_service.dart';
import '../services/preferencias_service.dart';
import '../utils/constantes.dart';
import '../utils/estado_carregamento.dart';
import '../widgets/cartao_cidade.dart';
import '../widgets/estado_erro.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/loading.dart';
import 'dicas_screen.dart';
import 'favoritos_screen.dart';
import 'previsao_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClimaService _clima = ClimaService();
  final PreferenciasService _preferencias = PreferenciasService();
  final TextEditingController _campoBusca = TextEditingController();

  EstadoCarregamento _estado = EstadoCarregamento.inicial;
  List<Cidade> _resultados = [];
  Cidade? _ultimaCidade;
  String _termoBuscado = '';
  String _mensagemErro = '';

  @override
  void initState() {
    super.initState();
    _carregarUltimaCidade();
  }

  @override
  void dispose() {
    _campoBusca.dispose();
    super.dispose();
  }

  Future<void> _carregarUltimaCidade() async {
    final cidade = await _preferencias.carregarUltimaCidade();
    if (!mounted) return;
    setState(() => _ultimaCidade = cidade);
  }

  Future<void> _buscar() async {
    final termo = _campoBusca.text.trim();
    if (termo.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite pelo menos 2 letras para buscar.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _termoBuscado = termo;
      _estado = EstadoCarregamento.carregando;
    });

    try {
      final cidades = await _clima.buscarCidades(termo);
      if (!mounted) return;
      setState(() {
        _resultados = cidades;
        _estado = EstadoCarregamento.sucesso;
      });
    } on ClimaException catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = e.mensagem;
        _estado = EstadoCarregamento.erro;
      });
    }
  }

  Future<void> _abrirPrevisao(Cidade cidade) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PrevisaoScreen(cidade: cidade)),
    );
    if (!mounted) return;
    await _carregarUltimaCidade();
  }

  void _abrirFavoritos() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FavoritosScreen()),
    );
  }

  void _abrirDicas() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DicasScreen()),
    );
  }

  Widget _conteudo() {
    switch (_estado) {
      case EstadoCarregamento.carregando:
        return const Loading(mensagem: 'Buscando cidades...');
      case EstadoCarregamento.erro:
        return EstadoErro(
          mensagem: _mensagemErro,
          onTentarNovamente: _buscar,
        );
      case EstadoCarregamento.sucesso:
        return _listaResultados();
      case EstadoCarregamento.inicial:
        return _inicio();
    }
  }

  Widget _inicio() {
    final ultima = _ultimaCidade;
    if (ultima == null) {
      return const EstadoVazio(
        icone: Icons.travel_explore_rounded,
        mensagem: 'Busque uma cidade para ver a previsão de chuva\ne o nível de risco dos próximos dias.',
      );
    }

    return ListView(
      children: [
        Text(
          'Última cidade consultada',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        CartaoCidade(cidade: ultima, onTap: () => _abrirPrevisao(ultima)),
      ],
    );
  }

  Widget _listaResultados() {
    if (_resultados.isEmpty) {
      return EstadoVazio(
        icone: Icons.search_off_rounded,
        mensagem: 'Nenhuma cidade encontrada para "$_termoBuscado".',
      );
    }

    return ListView.builder(
      itemCount: _resultados.length,
      itemBuilder: (_, indice) {
        final cidade = _resultados[indice];
        return CartaoCidade(cidade: cidade, onTap: () => _abrirPrevisao(cidade));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              errorBuilder: (context, erro, pilha) =>
                  const Icon(Icons.thunderstorm_rounded),
            ),
            const SizedBox(width: 8),
            const Text(Constantes.nomeApp),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            icon: const Icon(Icons.favorite_rounded),
            onPressed: _abrirFavoritos,
          ),
          IconButton(
            tooltip: 'Dicas de segurança',
            icon: const Icon(Icons.health_and_safety_rounded),
            onPressed: _abrirDicas,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _campoBusca,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _buscar(),
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome da cidade',
                      prefixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _buscar,
                    child: const Text('Buscar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _conteudo()),
          ],
        ),
      ),
    );
  }
}
