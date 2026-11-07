import 'package:flutter/material.dart';

import '../models/cidade.dart';

class CartaoCidade extends StatelessWidget {
  final Cidade cidade;
  final VoidCallback onTap;
  final Widget? trailing;

  const CartaoCidade({
    super.key,
    required this.cidade,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final detalhes =
        [cidade.estado, cidade.pais].where((t) => t.isNotEmpty).join(', ');

    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on_rounded),
        title: Text(cidade.nome),
        subtitle: detalhes.isEmpty ? null : Text(detalhes),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
