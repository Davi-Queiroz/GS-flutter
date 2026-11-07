import 'package:flutter/material.dart';

class LinhaDetalhe extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final String valor;

  const LinhaDetalhe({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Icon(icone, color: tema.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(rotulo)),
          Text(
            valor,
            style: tema.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
