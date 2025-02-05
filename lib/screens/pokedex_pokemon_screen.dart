import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/widgets/global_appbar.dart';
import 'package:pokedex_app/widgets/pokemon_details_bottom_sheet.dart';
import '../models/pokemon.dart';

class PokedexScreen extends StatefulWidget {
  final int generationId;

  const PokedexScreen({Key? key, required this.generationId})
      : super(key: key);

  @override
  _PokedexScreenState createState() =>
      _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  List<Pokemon> pokemons = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGenerationPokemons();
  }

  Future<void> fetchGenerationPokemons() async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://pokeapi.co/api/v2/generation/${widget.generationId}/';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      final List<dynamic> speciesList = data['pokemon_species'];

      List<Pokemon> tempList = [];
      for (var species in speciesList) {
        final pokemonUrl = species['url'];
        final pokemonId = extractIdFromUrl(pokemonUrl);

        final pokemon = Pokemon(
          id: pokemonId,
          name: species['name'],
          url: pokemonUrl,
        );
        tempList.add(pokemon);
      }

      tempList.sort((a, b) => a.id.compareTo(b.id));

      setState(() {
        pokemons = tempList;
      });
    } catch (e) {
      print("Error fetching generation pokemons: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int extractIdFromUrl(String url) {
    List<String> parts = url.split('/');
    return int.tryParse(parts[parts.length - 2]) ?? 0;
  }

 
  String getImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
          title: "Gen ${widget.generationId} Pokemon"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                final id = extractIdFromUrl(pokemon.url);
                final imageUrl = getImageUrl(id);
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => PokemonDetailBottomSheet(
                        pokemonId: id,
                        pokemonName: pokemon.name,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
