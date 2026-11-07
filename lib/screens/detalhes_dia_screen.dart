import 'package:flutter/material.dart';

import '../models/cidade.dart';
import '../models/previsao.dart';
import '../utils/apresentacao.dart';
import '../widgets/card_risco.dart';
import '../widgets/linha_detalhe.dart';

class DetalhesDiaScreen extends StatelessWidget {
  final Cidade cidade;
  final Previsao previsao;

  const DetalhesDiaScreen({
    super.key,
    required this.cidade,
    required this.previsao,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final risco = previsao.risco;

    return Scaffold(
      appBar: AppBar(
        title: Text('${rotuloDia(previsao.data)} · ${dataCurta(previsao.data)}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            cidade.rotulo,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(dataLonga(previsao.data), style: tema.textTheme.bodyMedium),
          const SizedBox(height: 16),
          CardRisco(
            nivel: risco,
            titulo: 'Risco ${risco.rotulo}',
            mensagem: risco.orientacao,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                LinhaDetalhe(
                  icone: iconeClima(previsao.codigoClima),
                  rotulo: 'Condição',
                  valor: descricaoClima(previsao.codigoClima),
                ),
                const Divider(height: 1),
                LinhaDetalhe(
                  icone: Icons.water_drop_rounded,
                  rotulo: 'Chuva prevista',
                  valor: '${formatarNumero(previsao.chuvaMm)} mm',
                ),
                const Divider(height: 1),
                LinhaDetalhe(
                  icone: Icons.percent_rounded,
                  rotulo: 'Probabilidade de chuva',
                  valor: '${previsao.probabilidadeChuva}%',
                ),
                const Divider(height: 1),
                LinhaDetalhe(
                  icone: Icons.thermostat_rounded,
                  rotulo: 'Temperatura máxima',
                  valor: '${formatarNumero(previsao.temperaturaMax)}°C',
                ),
                const Divider(height: 1),
                LinhaDetalhe(
                  icone: Icons.ac_unit_rounded,
                  rotulo: 'Temperatura mínima',
                  valor: '${formatarNumero(previsao.temperaturaMin)}°C',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Os níveis de risco são estimativas baseadas na previsão e não substituem os alertas oficiais da Defesa Civil.',
            style: tema.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Voltar para a previsão'),
          ),
        ],
      ),
    );
  }
}
