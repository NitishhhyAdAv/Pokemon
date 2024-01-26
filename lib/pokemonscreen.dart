
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final String pokemonName;

  const PokemonDetailsScreen({super.key, required this.pokemonName});

  @override

  PokemonDetailsScreenState createState() => PokemonDetailsScreenState();
}

class PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
 
  Map<String, dynamic> pokemonDetails = {};
  
 
  

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails();
  }

  Future<void> fetchPokemonDetails() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${widget.pokemonName}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pokemonDetails = data;
      });
    } else {
      
      print('Failed to load Pokemon details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Details'),
      ),
      body: Center(
        child: pokemonDetails.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pokemonDetails['sprites']['front_default']),
                  const SizedBox(height: 20),
                  Text('Name: ${pokemonDetails['name']}'),
                  Text('Height: ${pokemonDetails['height']}'),
                  Text('Weight: ${pokemonDetails['weight']}'),
                  
                ],
              ),
      ),
    );
  }
}
