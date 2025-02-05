class Generation {
  final String name;
  final String url;

  Generation({
    required this.name,
    required this.url,
  });

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
      name: json['name'],
      url: json['url'],
    );
  }
}
