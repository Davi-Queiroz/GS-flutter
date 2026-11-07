import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gs/models/pagina_onboarding.dart';
import 'package:gs/screens/home_screen.dart';
import 'package:gs/screens/onboarding_screen.dart';
import 'package:gs/utils/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('onboarding avança até a última página', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    expect(find.text(PaginaOnboarding.padrao.first.titulo), findsOneWidget);

    await tester.tap(find.text('Avançar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Avançar'));
    await tester.pumpAndSettle();

    expect(find.text('Começar'), findsOneWidget);
  });

  testWidgets('"Não mostrar novamente" salva a preferência', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(find.text('Pular'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(Constantes.chaveOnboardingVisto), isTrue);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
