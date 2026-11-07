import 'package:flutter/material.dart';

import '../models/previsao.dart';
import '../utils/apresentacao.dart';

class ItemPrevisao extends StatelessWidget {
  final Previsao previsao;
  final VoidCallback onTap;

  const ItemPrevisao({super.key, required this.previsao, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final risco = previsao.risco;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 56,
                decoration: BoxDecoration(
                  color: risco.cor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                iconeClima(previsao.codigoClima),
                size: 32,
                color: tema.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${rotuloDia(previsao.data)} · ${dataCurta(previsao.data)}',
                      style: tema.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(descricaoClima(previsao.codigoClima)),
                    Text(
                      '${formatarNumero(previsao.chuvaMm)} mm · ${previsao.probabilidadeChuva}% de chuva',
                      style: tema.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${previsao.temperaturaMax.round()}°',
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${previsao.temperaturaMin.round()}°'),
                  const SizedBox(height: 4),
                  Text(
                    risco.rotulo,
                    style: tema.textTheme.labelSmall?.copyWith(
                      color: risco.cor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
