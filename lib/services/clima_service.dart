import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cidade.dart';
import '../models/previsao.dart';
import '../utils/constantes.dart';

class ClimaException implements Exception {
  final String mensagem;

  const ClimaException(this.mensagem);

  @override
  String toString() => mensagem;
}

class ClimaService {
  final http.Client _client;

  ClimaService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Cidade>> buscarCidades(String nome) async {
    final termo = nome.trim();
    if (termo.length < 2) return [];

    final uri = Uri.https(Constantes.hostGeocoding, '/v1/search', {
      'name': termo,
      'count': '10',
      'language': 'pt',
      'format': 'json',
    });

    final json = await _get(uri);
    final resultados = json['results'] as List<dynamic>? ?? [];
    return resultados
        .map((item) => Cidade.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Previsao>> buscarPrevisao(Cidade cidade) async {
    final uri = Uri.https(Constantes.hostPrevisao, '/v1/forecast', {
      'latitude': cidade.latitude.toString(),
      'longitude': cidade.longitude.toString(),
      'daily': 'weathercode,temperature_2m_max,temperature_2m_min,'
          'precipitation_sum,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': Constantes.diasPrevisao.toString(),
    });

    final json = await _get(uri);
    return Previsao.listaDeJson(json);
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final resposta =
          await _client.get(uri).timeout(Constantes.tempoLimiteRequisicao);

      if (resposta.statusCode != 200) {
        throw ClimaException(
          'O servidor respondeu com erro (${resposta.statusCode}). Tente novamente.',
        );
      }

      return jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    } on ClimaException {
      rethrow;
    } on TimeoutException {
      throw const ClimaException(
        'A conexão demorou demais. Verifique sua internet e tente novamente.',
      );
    } on FormatException {
      throw const ClimaException('Resposta inválida do servidor.');
    } on TypeError {
      throw const ClimaException('Os dados recebidos estão em formato inesperado.');
    } catch (_) {
      throw const ClimaException(
        'Não foi possível conectar. Verifique sua internet e tente novamente.',
      );
    }
  }
}
