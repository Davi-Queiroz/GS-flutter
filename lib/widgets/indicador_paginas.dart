import 'package:flutter/material.dart';

class IndicadorPaginas extends StatelessWidget {
  final int total;
  final int atual;

  const IndicadorPaginas({super.key, required this.total, required this.atual});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final ativo = i == atual;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: ativo ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: ativo ? cores.primary : cores.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
