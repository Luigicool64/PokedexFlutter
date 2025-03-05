import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Pokedex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Ensure this is the correct import for your Pokemon model

class _MyHomePageState extends State<MyHomePage> {
  Pokemon? pokemon; // Declare a variable to hold the Pokémon data, nullable
  int pokemonId = 1; // Starting Pokémon ID
  bool isLoading = true; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    fetchPokemons(pokemonId); // Fetch the initial Pokémon
  }

  Future<void> fetchPokemons(int id) async {
    setState(() {
      isLoading = true; // Set loading to true before fetching
    });

    final response = await http.get(Uri.parse('https://pokebuildapi.fr/api/v1/pokemon/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        pokemon = Pokemon.fromJson(jsonData); // Store the fetched Pokémon
        isLoading = false; // Set loading to false after fetching
      });
    } else {
      print('Failed to load Pokémon: ${response.statusCode}');
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  void updatePokemon(int change) {
    setState(() {
      pokemonId += change;
      
      if (pokemonId < 1) {
        pokemonId = 898; 
      }

      if (pokemonId > 898){
        pokemonId = 1;
      }
      fetchPokemons(pokemonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show loading indicator while fetching
            : pokemon == null
                ? const Text('Pokémon non trouvé') // Handle case where no Pokémon is returned
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(pokemon!.image, height: 150, width: 150),
                      const SizedBox(height: 20),
                      Text('Nom: ${pokemon!.nom}', style: const TextStyle(fontSize: 20)),
                      Text('generation: ${pokemon!.generation}', style: const TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           const Text(
                            'Type:', 
                            style: TextStyle(
                              fontSize: 20
                            )),
                            Image.network(pokemon!.type1, height: 50, width: 50),
                            Image.network(pokemon!.type2, height: 50, width: 50),
                        ],
                      )
                      // Add type images here if needed
                    ],
                  ),
      ),
      bottomNavigationBar: Container(
  height: 100,
  decoration: const BoxDecoration(
    color: Colors.black,
    border: Border(top: BorderSide(color: Colors.black, width: 10)),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextButton(
        onPressed: () => updatePokemon(-1),
        child: const Text(
          '<<',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      Container(
        width: 60, 
        height: 60, 
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, 
          border: Border.all(color: Colors.black, width: 2), 
        ),
        alignment: Alignment.center,
        child: Text(
          '${pokemon?.id ?? 'N/A'}', 
          style: const TextStyle(fontSize: 24, color: Colors.black), 
        ),
      ),
      TextButton(
        onPressed: () => updatePokemon(1),
        child: const Text(
                '>>',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

