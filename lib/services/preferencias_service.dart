import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cidade.dart';
import '../utils/constantes.dart';

class PreferenciasService {
  Future<bool> onboardingVisto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constantes.chaveOnboardingVisto) ?? false;
  }

  Future<void> salvarOnboardingVisto(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constantes.chaveOnboardingVisto, valor);
  }

  Future<List<Cidade>> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final itens = prefs.getStringList(Constantes.chaveFavoritos) ?? [];

    final favoritos = <Cidade>[];
    for (final item in itens) {
      try {
        favoritos.add(Cidade.fromJson(jsonDecode(item) as Map<String, dynamic>));
      } catch (_) {
        continue;
      }
    }
    return favoritos;
  }

  Future<bool> ehFavorita(Cidade cidade) async {
    final favoritos = await carregarFavoritos();
    return favoritos.contains(cidade);
  }

  Future<bool> alternarFavorito(Cidade cidade) async {
    final favoritos = await carregarFavoritos();
    final jaFavorita = favoritos.contains(cidade);

    if (jaFavorita) {
      favoritos.remove(cidade);
    } else {
      favoritos.add(cidade);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      Constantes.chaveFavoritos,
      favoritos.map((c) => jsonEncode(c.toJson())).toList(),
    );
    return !jaFavorita;
  }

  Future<Cidade?> carregarUltimaCidade() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(Constantes.chaveUltimaCidade);
    if (texto == null) return null;

    try {
      return Cidade.fromJson(jsonDecode(texto) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> salvarUltimaCidade(Cidade cidade) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constantes.chaveUltimaCidade, jsonEncode(cidade.toJson()));
  }
}
