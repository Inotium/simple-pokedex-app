class Pokemon {
  final int id;  
  final String name;
  final String url;
 
  Pokemon({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
  
    return Pokemon(
      id: json['id'],   
      name: json['name'],
      url: json['url'],
    );
  }
}
