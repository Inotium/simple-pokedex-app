import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon_details.dart';
import 'package:pokedex_app/theme/theme.dart';
import '../services/api_service.dart';

class PokemonDetailBottomSheet extends StatefulWidget {
  final int pokemonId;
  final String pokemonName;

  const PokemonDetailBottomSheet({
    Key? key,
    required this.pokemonId,
    required this.pokemonName,
  }) : super(key: key);

  @override
  _PokemonDetailBottomSheetState createState() =>
      _PokemonDetailBottomSheetState();
}

class _PokemonDetailBottomSheetState extends State<PokemonDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  PokemonDetail? detail;
  List<Map<String, String>> evolutionChain = [];
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    fetchDetails();
   }

  @override
  void dispose() {
     super.dispose();
  }

  Future<void> fetchDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedDetail =
          await ApiService.fetchPokemonDetail(widget.pokemonId);

      if (fetchedDetail != null) {
         final speciesData =
            await ApiService.fetchPokemonSpecies(widget.pokemonId);
        if (speciesData != null &&
            speciesData['evolution_chain'] != null &&
            speciesData['evolution_chain']['url'] != null) {
          final evolutionUrl = speciesData['evolution_chain']['url'];
          final chain = await ApiService.fetchEvolutionChain(evolutionUrl);
          setState(() {
            detail = fetchedDetail;
            evolutionChain = chain;
          });
        } else {
          setState(() {
            detail = fetchedDetail;
          });
        }
      }
    } catch (e) {
      print("Error fetching Pokémon details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Widget buildTypeChips(List<String> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types.map((type) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: typeColors[type.toLowerCase()] ??
                Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            type.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  Widget buildStats(List<Map<String, dynamic>> stats) {
    int maxStatValue = stats
        .map((stat) => stat['base_stat'] as int)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: stats.map((stat) {
        double statValue = stat['base_stat'] / maxStatValue; 
        String statName = formatStatName(stat['name']);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  statName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300], 
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: statValue, 
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: getStatColor(stat['name']), 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(stat['base_stat'].toString()),
            ],
          ),
        );
      }).toList(),
    );
  }

  String formatStatName(String statName) {
    switch (statName.toLowerCase()) {
      case "special-attack":
        return "SP-ATT";
      case "special-defense":
        return "SP-DEF";
      default:
        return statName.toUpperCase();
    }
  }

  Color getStatColor(String statName) {
    switch (statName.toLowerCase()) {
      case "hp":
        return Colors.red;
      case "attack":
        return Colors.orange;
      case "defense":
        return Colors.blue;
      case "special-attack":
        return Colors.purple;
      case "special-defense":
        return Colors.green;
      case "speed":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

   Widget buildEvolutionChain(List<Map<String, String>> chain) {
    List<Widget> evolutionWidgets = [];

    for (int i = 0; i < chain.length; i++) {
      evolutionWidgets.add(
        Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chain[i]['imageUrl'] ?? ''),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 4),
            Text(chain[i]['name']!.toUpperCase()),
          ],
        ),
      );

      // Add  arrow icon between evolutions if not the last one
      if (i < chain.length - 1) {
        evolutionWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward, size: 24),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: evolutionWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
              ? const Center(child: Text("No details available"))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        detail!.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.network(
                        detail!.imageUrl,
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(height: 8),
                      buildTypeChips(detail!.types),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "EXP",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(detail!.baseExperience.toString()),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Height",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(detail!.height.toString()),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Weight",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(detail!.weight.toString()),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Abilities",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            children: detail!.abilities
                                .map((ability) => Chip(
                                      label: Text(ability.toUpperCase()),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stats",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          buildStats(detail!.stats),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (evolutionChain.isNotEmpty) ...[
                        Text(
                          "Evolution Chain",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        buildEvolutionChain(evolutionChain),
                      ],
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
    );
  }
}
