import 'package:flutter_test/flutter_test.dart';
import 'package:gs/models/previsao.dart';
import 'package:gs/utils/analise_previsao.dart';
import 'package:gs/utils/apresentacao.dart';

Previsao previsaoCom(double chuva, int probabilidade, {int dia = 1}) {
  return Previsao(
    data: DateTime(2026, 11, dia),
    temperaturaMax: 30,
    temperaturaMin: 20,
    chuvaMm: chuva,
    probabilidadeChuva: probabilidade,
    codigoClima: 61,
  );
}

void main() {
  test('apenasComRisco remove dias de risco baixo', () {
    final previsoes = [
      previsaoCom(1, 10),
      previsaoCom(20, 50),
      previsaoCom(60, 90),
    ];

    expect(apenasComRisco(previsoes).length, 2);
  });

  test('diaMaisCritico retorna o dia com mais chuva', () {
    final previsoes = [
      previsaoCom(5, 40, dia: 1),
      previsaoCom(60, 90, dia: 2),
      previsaoCom(12, 70, dia: 3),
    ];

    expect(diaMaisCritico(previsoes)?.data.day, 2);
    expect(diaMaisCritico([]), isNull);
  });

  test('rotuloDia identifica hoje, amanhã e dia da semana', () {
    final hoje = DateTime(2026, 11, 7);

    expect(rotuloDia(DateTime(2026, 11, 7), hoje: hoje), 'Hoje');
    expect(rotuloDia(DateTime(2026, 11, 8), hoje: hoje), 'Amanhã');
    expect(rotuloDia(DateTime(2026, 11, 9), hoje: hoje), 'Seg');
  });

  test('formatadores de apresentação', () {
    expect(formatarNumero(14.7), '14,7');
    expect(dataCurta(DateTime(2026, 11, 7)), '07/11');
    expect(descricaoClima(95), 'Trovoadas');
  });
}
