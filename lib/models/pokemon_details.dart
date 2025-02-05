class PokemonDetail {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final int baseExperience;
  final int height;
  final int weight;
  final List<String> abilities;
  final List<Map<String, dynamic>> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    List<String> types = (json['types'] as List)
        .map((e) => e['type']['name'] as String)
        .toList();

    List<String> abilities = (json['abilities'] as List)
        .map((e) => e['ability']['name'] as String)
        .toList();

    List<Map<String, dynamic>> stats = (json['stats'] as List)
        .map((e) => {
              'name': e['stat']['name'],
              'base_stat': e['base_stat'],
            })
        .toList();

    String imageUrl = json['sprites']['other']['official-artwork']
            ['front_default'] ??
        json['sprites']['front_default'] ??
        '';

    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      types: types,
      imageUrl: imageUrl,
      baseExperience: json['base_experience'],
      height: json['height'],
      weight: json['weight'],
      abilities: abilities,
      stats: stats,
    );
  }
}
