import 'package:flutter/material.dart';

import '../models/cidade.dart';
import '../services/preferencias_service.dart';
import '../widgets/cartao_cidade.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/loading.dart';
import 'previsao_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final PreferenciasService _preferencias = PreferenciasService();

  List<Cidade> _favoritos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final favoritos = await _preferencias.carregarFavoritos();
    if (!mounted) return;
    setState(() {
      _favoritos = favoritos;
      _carregando = false;
    });
  }

  Future<void> _remover(Cidade cidade) async {
    await _preferencias.alternarFavorito(cidade);
    await _carregar();
  }

  Future<void> _abrir(Cidade cidade) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PrevisaoScreen(cidade: cidade)),
    );
    await _carregar();
  }

  Widget _corpo() {
    if (_carregando) return const Loading();

    if (_favoritos.isEmpty) {
      return const EstadoVazio(
        icone: Icons.favorite_border_rounded,
        mensagem: 'Você ainda não tem cidades favoritas.\nToque no coração na tela de previsão para salvar.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoritos.length,
      itemBuilder: (_, indice) {
        final cidade = _favoritos[indice];
        return CartaoCidade(
          cidade: cidade,
          onTap: () => _abrir(cidade),
          trailing: IconButton(
            tooltip: 'Remover dos favoritos',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _remover(cidade),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cidades favoritas')),
      body: _corpo(),
    );
  }
}
