enum NivelRisco {
  baixo(
    'Baixo',
    'Sem previsão de chuva forte. Acompanhe as atualizações normalmente.',
  ),
  moderado(
    'Moderado',
    'Chuva relevante prevista. Evite áreas de alagamento e acompanhe os alertas.',
  ),
  alto(
    'Alto',
    'Risco de enchente. Evite sair, fique longe de rios e córregos e procure um local seguro.',
  );

  const NivelRisco(this.rotulo, this.orientacao);

  final String rotulo;
  final String orientacao;

  static NivelRisco calcular({
    required double chuvaMm,
    required int probabilidade,
  }) {
    if (chuvaMm >= 50 || (chuvaMm >= 30 && probabilidade >= 70)) {
      return NivelRisco.alto;
    }
    if (chuvaMm >= 15 || (chuvaMm >= 5 && probabilidade >= 60)) {
      return NivelRisco.moderado;
    }
    return NivelRisco.baixo;
  }
}
