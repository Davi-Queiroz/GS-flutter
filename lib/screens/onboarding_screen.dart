import 'package:flutter/material.dart';

import '../models/pagina_onboarding.dart';
import '../services/preferencias_service.dart';
import '../utils/rotas.dart';
import '../widgets/indicador_paginas.dart';
import '../widgets/pagina_onboarding_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final PreferenciasService _preferencias = PreferenciasService();
  final List<PaginaOnboarding> _paginas = PaginaOnboarding.padrao;

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  bool get _ultimaPagina => _paginaAtual == _paginas.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _voltar() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _avancar() async {
    if (_ultimaPagina) {
      await _finalizar();
      return;
    }
    await _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finalizar() async {
    await _preferencias.salvarOnboardingVisto(_naoMostrarNovamente);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => construirTelaPrincipal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finalizar,
                child: const Text('Pular'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _paginas.length,
                onPageChanged: (indice) => setState(() => _paginaAtual = indice),
                itemBuilder: (_, indice) =>
                    PaginaOnboardingView(pagina: _paginas[indice]),
              ),
            ),
            IndicadorPaginas(total: _paginas.length, atual: _paginaAtual),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CheckboxListTile(
                value: _naoMostrarNovamente,
                onChanged: (valor) =>
                    setState(() => _naoMostrarNovamente = valor ?? false),
                title: const Text('Não mostrar novamente'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _paginaAtual == 0 ? null : _voltar,
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _avancar,
                      child: Text(_ultimaPagina ? 'Começar' : 'Avançar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
