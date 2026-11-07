class Cidade {
  final String nome;
  final String estado;
  final String pais;
  final double latitude;
  final double longitude;

  const Cidade({
    required this.nome,
    required this.estado,
    required this.pais,
    required this.latitude,
    required this.longitude,
  });

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      nome: json['name'] as String? ?? '',
      estado: json['admin1'] as String? ?? '',
      pais: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nome,
      'admin1': estado,
      'country': pais,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get id => '$latitude,$longitude';

  String get rotulo => estado.isEmpty ? nome : '$nome, $estado';

  @override
  bool operator ==(Object other) => other is Cidade && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
