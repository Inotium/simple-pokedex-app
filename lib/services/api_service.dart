import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/pokemon_details.dart';

class ApiService {
   static Future<PokemonDetail?> fetchPokemonDetail(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<PokemonDetail?> fetchPokemonByName(String name) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      return null;
    }
  }
   static Future<Map<String, dynamic>?> fetchPokemonSpecies(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon-species/$id/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

    static Future<List<Map<String, String>>> fetchEvolutionChain(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, String>> evolutionChain = [];

      void traverseEvolution(Map<String, dynamic> chain) {
        if (chain.isNotEmpty) {
          final speciesName = chain['species']['name'];
          final speciesUrl = chain['species']['url'];
           List<String> parts = speciesUrl.split('/');
          int id = int.tryParse(parts[parts.length - 2]) ?? 0;
          final imageUrl =
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
          evolutionChain.add({'name': speciesName, 'imageUrl': imageUrl});
          if (chain['evolves_to'] != null && chain['evolves_to'].isNotEmpty) {
            traverseEvolution(chain['evolves_to'][0]);
          }
        }
      }

      traverseEvolution(data['chain']);
      return evolutionChain;
    } else {
      return [];
    }
  }
}
