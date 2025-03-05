import 'dart:convert';
import 'package:http/http.dart' as http;
class Pokemon {
  final int id;
  final String nom;
  final String image;
  final String type1;
  final String type2;
  final int generation;

  const Pokemon({
    required this.id,
    required this.nom,
    required this.image,
    required this.type1,
    required this.type2,
    required this.generation,
  });

  factory Pokemon.fromJson(Map<String, dynamic>json) {
    return Pokemon(
      id: json['id'],
      nom: json['name'],
      generation: json['apiGeneration'],
      image: json['sprite'],
      type1: json['apiTypes'][0]['image'],
      type2: json['apiTypes'].length > 1 ? json['apiTypes'][1]['image'] : '',
    );
  }
}

Future<Pokemon> fetchPokemon(int id) async {

  final response = await http.get(Uri.parse('https://pokebuildapi.fr/api/v1/pokemon/$id'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Pokemon(
      id: json['id'],
      nom: json['name'],
      generation: json['apiGeneration'],
      image: json['sprite'],
      type1: json['apitypes'][0]['image'],
      type2: json['apitypes'].length > 1 ? json['apitypes'][1]['image'] : '',
    );
  } else {
    throw Exception('Failed to load Pokémon');
  }
}

