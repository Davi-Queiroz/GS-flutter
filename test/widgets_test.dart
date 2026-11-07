import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gs/models/previsao.dart';
import 'package:gs/widgets/estado_erro.dart';
import 'package:gs/widgets/item_previsao.dart';

void main() {
  testWidgets('EstadoErro chama a função ao tocar em Tentar novamente',
      (tester) async {
    var chamadas = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EstadoErro(
            mensagem: 'Falha de conexão',
            onTentarNovamente: () => chamadas++,
          ),
        ),
      ),
    );

    expect(find.text('Falha de conexão'), findsOneWidget);

    await tester.tap(find.text('Tentar novamente'));

    expect(chamadas, 1);
  });

  testWidgets('ItemPrevisao mostra os dados e responde ao toque',
      (tester) async {
    var toques = 0;
    final previsao = Previsao(
      data: DateTime(2026, 11, 12),
      temperaturaMax: 28,
      temperaturaMin: 19,
      chuvaMm: 12.5,
      probabilidadeChuva: 80,
      codigoClima: 61,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemPrevisao(previsao: previsao, onTap: () => toques++),
        ),
      ),
    );

    expect(find.text('12,5 mm · 80% de chuva'), findsOneWidget);
    expect(find.text('Moderado'), findsOneWidget);

    await tester.tap(find.byType(ItemPrevisao));

    expect(toques, 1);
  });
}
