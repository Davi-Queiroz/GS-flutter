import 'package:flutter/material.dart';

import '../utils/constantes.dart';

class LogoChuvalert extends StatelessWidget {
  final double tamanho;
  final Color cor;

  const LogoChuvalert({
    super.key,
    this.tamanho = 120,
    this.cor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: tamanho,
          height: tamanho,
          errorBuilder: (context, erro, pilha) =>
              Icon(Icons.thunderstorm_rounded, size: tamanho, color: cor),
        ),
        const SizedBox(height: 12),
        Text(
          Constantes.nomeApp,
          style: TextStyle(
            fontSize: tamanho / 3.5,
            fontWeight: FontWeight.bold,
            color: cor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
