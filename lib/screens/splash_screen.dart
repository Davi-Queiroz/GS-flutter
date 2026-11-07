import 'package:flutter/material.dart';

import '../services/preferencias_service.dart';
import '../utils/constantes.dart';
import '../utils/rotas.dart';
import '../widgets/logo_chuvalert.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferenciasService _preferencias = PreferenciasService();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    bool visto;
    try {
      visto = await _preferencias.onboardingVisto();
    } catch (_) {
      visto = false;
    }
    await Future.delayed(Constantes.duracaoSplash);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            visto ? construirTelaPrincipal() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(child: LogoChuvalert()),
    );
  }
}
