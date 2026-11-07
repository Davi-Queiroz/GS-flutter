import '../models/previsao.dart';
import 'nivel_risco.dart';

List<Previsao> apenasComRisco(List<Previsao> previsoes) {
  return previsoes.where((p) => p.risco != NivelRisco.baixo).toList();
}

Previsao? diaMaisCritico(List<Previsao> previsoes) {
  if (previsoes.isEmpty) return null;
  return previsoes.reduce((a, b) => b.chuvaMm > a.chuvaMm ? b : a);
}
