import 'package:flutter/material.dart';

import '../utils/apresentacao.dart';
import '../utils/nivel_risco.dart';

class CardRisco extends StatelessWidget {
  final NivelRisco nivel;
  final String titulo;
  final String mensagem;

  const CardRisco({
    super.key,
    required this.nivel,
    required this.titulo,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      color: nivel.cor.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: nivel.cor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(nivel.icone, color: nivel.cor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(mensagem),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
