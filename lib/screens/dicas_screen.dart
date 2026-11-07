import 'package:flutter/material.dart';

import '../models/dica.dart';
import '../widgets/cartao_dica.dart';

class DicasScreen extends StatelessWidget {
  const DicasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dicas de segurança')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final dica in Dica.padrao) CartaoDica(dica: dica),
          const SizedBox(height: 8),
          Text(
            'Em caso de emergência, siga sempre as orientações da Defesa Civil e dos órgãos oficiais.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
