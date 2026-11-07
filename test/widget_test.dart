import 'package:flutter_test/flutter_test.dart';
import 'package:gs/models/cidade.dart';
import 'package:gs/models/previsao.dart';
import 'package:gs/utils/nivel_risco.dart';

void main() {
  group('NivelRisco', () {
    test('chuva fraca gera risco baixo', () {
      expect(NivelRisco.calcular(chuvaMm: 2, probabilidade: 30), NivelRisco.baixo);
    });

    test('chuva intermediária gera risco moderado', () {
      expect(NivelRisco.calcular(chuvaMm: 20, probabilidade: 50), NivelRisco.moderado);
      expect(NivelRisco.calcular(chuvaMm: 5, probabilidade: 60), NivelRisco.moderado);
    });

    test('chuva intensa gera risco alto', () {
      expect(NivelRisco.calcular(chuvaMm: 60, probabilidade: 90), NivelRisco.alto);
      expect(NivelRisco.calcular(chuvaMm: 35, probabilidade: 80), NivelRisco.alto);
    });
  });

  test('Previsao.listaDeJson converte a resposta da API', () {
    final json = {
      'daily': {
        'time': ['2026-11-07', '2026-11-08'],
        'temperature_2m_max': [30.5, 28],
        'temperature_2m_min': [20, 19.5],
        'precipitation_sum': [0.0, 42.3],
        'precipitation_probability_max': [10, null],
        'weathercode': [1, 95],
      },
    };

    final previsoes = Previsao.listaDeJson(json);

    expect(previsoes.length, 2);
    expect(previsoes[0].data.day, 7);
    expect(previsoes[0].temperaturaMax, 30.5);
    expect(previsoes[1].chuvaMm, 42.3);
    expect(previsoes[1].probabilidadeChuva, 0);
    expect(previsoes[1].risco, NivelRisco.moderado);
  });

  test('Cidade converte para JSON e volta', () {
    const cidade = Cidade(
      nome: 'São Paulo',
      estado: 'São Paulo',
      pais: 'Brasil',
      latitude: -23.5475,
      longitude: -46.6361,
    );

    final copia = Cidade.fromJson(cidade.toJson());

    expect(copia, cidade);
    expect(copia.rotulo, 'São Paulo, São Paulo');
  });
}
