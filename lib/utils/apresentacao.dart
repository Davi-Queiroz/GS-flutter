import 'package:flutter/material.dart';

import 'nivel_risco.dart';

extension NivelRiscoVisual on NivelRisco {
  Color get cor => switch (this) {
        NivelRisco.baixo => const Color(0xFF2E7D32),
        NivelRisco.moderado => const Color(0xFFF9A825),
        NivelRisco.alto => const Color(0xFFC62828),
      };

  IconData get icone => switch (this) {
        NivelRisco.baixo => Icons.check_circle_rounded,
        NivelRisco.moderado => Icons.warning_amber_rounded,
        NivelRisco.alto => Icons.error_rounded,
      };
}

const List<String> _diasSemanaCurto = [
  'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
];

const List<String> _diasSemanaLongo = [
  'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira',
  'sexta-feira', 'sábado', 'domingo',
];

const List<String> _meses = [
  'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
  'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
];

String rotuloDia(DateTime data, {DateTime? hoje}) {
  final base = hoje ?? DateTime.now();
  final diferenca = DateTime.utc(data.year, data.month, data.day)
      .difference(DateTime.utc(base.year, base.month, base.day))
      .inDays;

  if (diferenca == 0) return 'Hoje';
  if (diferenca == 1) return 'Amanhã';
  return _diasSemanaCurto[data.weekday - 1];
}

String dataCurta(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  return '$dia/$mes';
}

String dataLonga(DateTime data) {
  return '${_diasSemanaLongo[data.weekday - 1]}, ${data.day} de ${_meses[data.month - 1]}';
}

String formatarNumero(double valor, [int casas = 1]) {
  return valor.toStringAsFixed(casas).replaceAll('.', ',');
}

String descricaoClima(int codigo) {
  if (codigo == 0) return 'Céu limpo';
  if (codigo == 1 || codigo == 2) return 'Parcialmente nublado';
  if (codigo == 3) return 'Nublado';
  if (codigo == 45 || codigo == 48) return 'Neblina';
  if (codigo >= 51 && codigo <= 57) return 'Garoa';
  if (codigo >= 61 && codigo <= 67) return 'Chuva';
  if (codigo >= 71 && codigo <= 77) return 'Neve';
  if (codigo >= 80 && codigo <= 82) return 'Pancadas de chuva';
  if (codigo == 85 || codigo == 86) return 'Pancadas de neve';
  if (codigo >= 95) return 'Trovoadas';
  return 'Tempo variável';
}

IconData iconeClima(int codigo) {
  if (codigo == 0) return Icons.wb_sunny_rounded;
  if (codigo == 1 || codigo == 2) return Icons.cloud_queue_rounded;
  if (codigo == 3 || codigo == 45 || codigo == 48) return Icons.cloud_rounded;
  if ((codigo >= 51 && codigo <= 67) || (codigo >= 80 && codigo <= 82)) {
    return Icons.water_drop_rounded;
  }
  if (codigo >= 71 && codigo <= 86) return Icons.ac_unit_rounded;
  if (codigo >= 95) return Icons.thunderstorm_rounded;
  return Icons.cloud_queue_rounded;
}
