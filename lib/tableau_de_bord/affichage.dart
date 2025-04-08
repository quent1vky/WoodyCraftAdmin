import 'package:flutter/material.dart';
import 'dart:convert';
import '../puzzle_service.dart'; // Assurez-vous que ce chemin est correct
import 'package:http/http.dart' as http;

class Affichage extends StatefulWidget {
  const Affichage({super.key});

  @override
  _AffichageState createState() => _AffichageState();
}

class _AffichageState extends State<Affichage> {
  late Future<List<Puzzle>> _puzzles;

  @override
  void initState() {
    super.initState();
    _puzzles = fetchPuzzles(); // Appel à l'API pour récupérer les puzzles
  }

  // Fonction pour récupérer les puzzles
  Future<List<Puzzle>> fetchPuzzles() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/api/puzzles'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Puzzle> puzzles = data.map((json) => Puzzle.fromJson(json)).toList();

      // Trier les puzzles par stock (du plus petit au plus grand)
      puzzles.sort((a, b) => a.stock.compareTo(b.stock));

      // Retourner uniquement les 3 puzzles avec les stocks les plus bas
      return puzzles.take(3).toList();
    } else {
      throw Exception('Erreur de chargement des puzzles');
    }
  }

  // Fonction pour afficher la section des puzzles avec les stocks les plus bas
  Widget _buildStockSection(BuildContext context) {
    return Card(
      color: Colors.green.withOpacity(0.2),
      child: ListTile(
        title: Text('Niveaux de stock', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: FutureBuilder<List<Puzzle>>(
          future: _puzzles, // Utilise le Future pour afficher les puzzles
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Affichage pendant le chargement
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}')); // Affichage en cas d'erreur
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun puzzle disponible.')); // Si pas de puzzles à afficher
            } else {
              List<Puzzle> puzzles = snapshot.data!;

              // Affichage des puzzles dans une ListView
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: puzzles.map((puzzle) {
                  return _buildPuzzleRow(puzzle.nom, puzzle.stock);
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget pour afficher une ligne avec le nom du puzzle et son stock
  Widget _buildPuzzleRow(String puzzleName, int stock) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(puzzleName, style: const TextStyle(fontSize: 16)),
          Text('Stock: $stock', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord - Puzzles'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildSection(context, 'Commandes en attente', Colors.blue),
                  _buildStockSection(context), // Section pour afficher les puzzles avec les stocks les plus bas
                  _buildSection(context, 'Statistiques de vente', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer d'autres sections si nécessaire (exemple pour 'Commandes en attente' et 'Statistiques de vente')
  Widget _buildSection(BuildContext context, String title, Color color) {
    return Card(
      color: color.withOpacity(0.2),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
