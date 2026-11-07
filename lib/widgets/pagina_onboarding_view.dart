import 'package:flutter/material.dart';

import '../models/pagina_onboarding.dart';

class PaginaOnboardingView extends StatelessWidget {
  final PaginaOnboarding pagina;

  const PaginaOnboardingView({super.key, required this.pagina});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(pagina.icone, size: 120, color: tema.colorScheme.primary),
          const SizedBox(height: 32),
          Text(
            pagina.titulo,
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pagina.descricao,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
