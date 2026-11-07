import '../utils/nivel_risco.dart';

class Previsao {
  final DateTime data;
  final double temperaturaMax;
  final double temperaturaMin;
  final double chuvaMm;
  final int probabilidadeChuva;
  final int codigoClima;

  const Previsao({
    required this.data,
    required this.temperaturaMax,
    required this.temperaturaMin,
    required this.chuvaMm,
    required this.probabilidadeChuva,
    required this.codigoClima,
  });

  NivelRisco get risco => NivelRisco.calcular(
        chuvaMm: chuvaMm,
        probabilidade: probabilidadeChuva,
      );

  static List<Previsao> listaDeJson(Map<String, dynamic> json) {
    final diario = json['daily'] as Map<String, dynamic>;
    final datas = diario['time'] as List<dynamic>;

    return List.generate(datas.length, (i) {
      return Previsao(
        data: DateTime.parse(datas[i] as String),
        temperaturaMax: _valor(diario, 'temperature_2m_max', i)?.toDouble() ?? 0,
        temperaturaMin: _valor(diario, 'temperature_2m_min', i)?.toDouble() ?? 0,
        chuvaMm: _valor(diario, 'precipitation_sum', i)?.toDouble() ?? 0,
        probabilidadeChuva:
            _valor(diario, 'precipitation_probability_max', i)?.round() ?? 0,
        codigoClima: _valor(diario, 'weathercode', i)?.round() ?? 0,
      );
    });
  }

  static num? _valor(Map<String, dynamic> diario, String chave, int indice) {
    final lista = diario[chave] as List<dynamic>?;
    if (lista == null || indice >= lista.length) return null;
    return lista[indice] as num?;
  }
}
