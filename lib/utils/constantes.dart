class Constantes {
  static const String nomeApp = 'Chuvalert';

  static const String hostGeocoding = 'geocoding-api.open-meteo.com';
  static const String hostPrevisao = 'api.open-meteo.com';

  static const int diasPrevisao = 7;
  static const Duration tempoLimiteRequisicao = Duration(seconds: 10);
  static const Duration duracaoSplash = Duration(seconds: 2);

  static const String chaveOnboardingVisto = 'onboarding_visto';
  static const String chaveFavoritos = 'cidades_favoritas';
  static const String chaveUltimaCidade = 'ultima_cidade';
}
