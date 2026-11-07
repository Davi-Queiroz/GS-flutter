import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String mensagem;

  const Loading({super.key, this.mensagem = 'Carregando...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(mensagem),
        ],
      ),
    );
  }
}
