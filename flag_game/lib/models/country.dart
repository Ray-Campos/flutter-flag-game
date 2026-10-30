class Country {
  final String code;
  final String name;
  final String continent;

  Country({
    required this.code,
    required this.name,
    required this.continent,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code']?.toString() ?? '',
      name: json['pt']?.toString() ?? 'Desconhecido', // Updated key mapping
      continent: json['continent']?.toString() ?? 'Aleatório', // Fallback for missing data
    );
  }

  String get flagAssetPath => 'assets/flags/$code.png';
}