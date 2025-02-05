import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 import 'package:pokedex_app/widgets/global_appbar.dart';
 import '../models/generation.dart';
import 'pokedex_pokemon_screen.dart';
 

class GenerationScreen extends StatefulWidget {
  @override
  _GenerationScreenState createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  List<Generation> generations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGenerations();
  }

  Future<void> fetchGenerations() async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://pokeapi.co/api/v2/generation/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          generations =
              results.map((json) => Generation.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print("Error fetching generations: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

 
  int extractGenIdFromUrl(String url) {
    List<String> parts = url.split('/');
    return int.tryParse(parts[parts.length - 2]) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: const GlobalAppBar(title: "Choose a Generation"),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemCount: generations.length,
              itemBuilder: (context, index) {
                final gen = generations[index];
                final genId = extractGenIdFromUrl(gen.url);
                final displayName = "Generation ${genId}".toUpperCase();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PokedexScreen(generationId: genId),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Center(
                      child: Text(
                        displayName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
