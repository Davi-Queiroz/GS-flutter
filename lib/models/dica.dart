import 'package:flutter/material.dart';

class Dica {
  final IconData icone;
  final String titulo;
  final List<String> itens;

  const Dica({required this.icone, required this.titulo, required this.itens});

  static const List<Dica> padrao = [
    Dica(
      icone: Icons.checklist_rounded,
      titulo: 'Antes da chuva',
      itens: [
        'Acompanhe a previsão e os alertas da Defesa Civil.',
        'Deixe lanterna, pilhas e carregador portátil à mão.',
        'Guarde documentos em sacos plásticos, em local alto.',
        'Limpe calhas e ralos ao redor da casa.',
      ],
    ),
    Dica(
      icone: Icons.flood_rounded,
      titulo: 'Durante chuva forte ou enchente',
      itens: [
        'Não atravesse ruas alagadas, a pé ou de carro.',
        'Não toque em fios caídos nem em aparelhos elétricos molhados.',
        'Procure um local alto e fique longe de rios e córregos.',
        'Se a água entrar em casa, desligue a energia elétrica.',
      ],
    ),
    Dica(
      icone: Icons.wb_sunny_rounded,
      titulo: 'Calor extremo',
      itens: [
        'Beba água com frequência, mesmo sem sede.',
        'Evite o sol entre 10h e 16h.',
        'Use roupas leves e protetor solar.',
        'Nunca deixe crianças ou animais em carros fechados.',
      ],
    ),
    Dica(
      icone: Icons.phone_in_talk_rounded,
      titulo: 'Telefones de emergência',
      itens: [
        'Defesa Civil: 199',
        'Bombeiros: 193',
        'SAMU: 192',
        'Polícia Militar: 190',
      ],
    ),
  ];
}
