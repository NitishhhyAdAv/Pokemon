import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokimoon/pokemonscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  
  
  PokemonListScreenState createState() => PokemonListScreenState();
}
class PokemonListScreenState extends State<PokemonListScreen> {
  List<String> pokemonList = [];
  int offset = 0;
  int limit = 20;
  bool isLoading = false;

  String capitalize(String s) {
    return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonList();
  }

  Future<void> fetchPokemonList() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pokemonList.addAll(List<String>.from(
            data['results'].map((pokemon) => capitalize(pokemon['name']))));
        offset += limit;
        isLoading = false;
      });
    } else {
      // ignore: avoid_print
      print('Failed to load Pokemon list');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon List'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !isLoading) {
            fetchPokemonList();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: pokemonList.length + 1,
          itemBuilder: (context, index) {
            if (index == pokemonList.length) {
              return isLoading
                  ? const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink();
            }

            return ListTile(
              title: Text('${index + 1}-> ${capitalize(pokemonList[index])}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PokemonDetailsScreen(pokemonName: pokemonList[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
