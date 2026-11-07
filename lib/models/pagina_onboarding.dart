import 'package:flutter/material.dart';

class PaginaOnboarding {
  final IconData icone;
  final String titulo;
  final String descricao;

  const PaginaOnboarding({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  static const List<PaginaOnboarding> padrao = [
    PaginaOnboarding(
      icone: Icons.thunderstorm_rounded,
      titulo: 'Bem-vindo ao Chuvalert',
      descricao:
          'Alertas simples e locais sobre chuva forte e risco de enchente, '
          'para você se preparar antes que o problema aconteça.',
    ),
    PaginaOnboarding(
      icone: Icons.location_city_rounded,
      titulo: 'Busque sua cidade',
      descricao:
          'Pesquise qualquer cidade e veja a previsão dos próximos 7 dias, '
          'com a quantidade de chuva e a probabilidade de precipitação.',
    ),
    PaginaOnboarding(
      icone: Icons.shield_rounded,
      titulo: 'Entenda o risco',
      descricao:
          'Cada dia recebe um nível de risco (baixo, moderado ou alto) e uma '
          'orientação de segurança. Salve suas cidades favoritas para acesso rápido.',
    ),
  ];
}
