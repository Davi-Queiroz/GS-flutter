import 'package:flutter/material.dart';

class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String mensagem;

  const EstadoVazio({super.key, required this.icone, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: cores.outline),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
