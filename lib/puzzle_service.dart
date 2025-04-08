import 'dart:convert';
import 'package:http/http.dart' as http;

class Puzzle {
  final int id;
  final String nom;
  final String description;
  final String image; // Champ pour l'image
  final double prix; // Champ pour le prix
  final int stock; // Champ pour le stock
  final int categorie; // Champ pour la catégorie

  Puzzle({
    required this.id,
    required this.nom,
    required this.description,
    this.image = '', // Valeur par défaut
    this.prix = 0.0, // Valeur par défaut
    this.stock = 0, // Valeur par défaut
    this.categorie = 1, // Valeur par défaut
  });

  // Méthode pour convertir la réponse JSON en un objet Puzzle
  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      id: json['id'],
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      image: json['path_image'] ?? '',
      prix: json['prix']?.toDouble() ?? 0.0,
      stock: json['stock'],
      categorie: json['categorie_id'] ?? 2,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'path_image': image,
      'prix': prix,
      'categorie_id': categorie,  // Envoi 'categorie_id' vers l'API
      'stock': stock,
    };
  }
}

class PuzzleService {
  // URL de l'API
  final String apiUrl = 'http://127.0.0.1/WoodyCraftWeb/projetPuzzle/public/api/puzzles';
  // Méthode pour récupérer tous les puzzles depuis l'API
  Future<List<Puzzle>> fetchPuzzles() async {
    // Envoie la requête GET
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Décoder le corps de la réponse JSON
      List<dynamic> jsonData = json.decode(response.body);

      // Convertir chaque élément JSON en objet Puzzle
      List<Puzzle> puzzles = jsonData.map((dynamic item) => Puzzle.fromJson(item)).toList();

      // Retourner la liste de puzzles
      return puzzles;
    } else {
      // Si la requête échoue, lève une exception
      throw Exception('Failed to load puzzles');
    }
  }

  // Fonction pour ajouter un nouveau puzzle (POST)
  Future<Puzzle> createPuzzle(String nom, String description, String image, double prix,int stock, int categorie) async {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nom': nom,
          'description': description,
          'path_image': image, // Ajouter l'image
          'prix': prix, // Ajouter le prix
          'stock': stock,
          'categorie_id': categorie, // Ajouter la catégorie
        }),
      );

      if (response.statusCode == 201) {
        return Puzzle.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create puzzle: ${response.body}'); // Afficher le corps de la réponse en cas d'erreur
      }
  }

}
