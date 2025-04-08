import 'package:flutter/material.dart';
import 'create_puzzle_page.dart'; // Importer la page d'ajout de puzzle
import 'liste_update_puzzle.dart';
import 'liste_delete_puzzle.dart';


class GestionPuzzlePage extends StatelessWidget {
  const GestionPuzzlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Puzzles'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePuzzlePage()),
                );
              },
              child: Text('Ajouter un Puzzle'),
            ),
            SizedBox(height: 20), // Espacement de 20 pixels
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PuzzleListPageUpdate()),
                );
              },
              child: Text('Modifier un Puzzle'),
            ),
            SizedBox(height: 20), // Espacement de 20 pixels
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PuzzleListPageDelete()),
                );
              },
              child: Text('Supprimer un Puzzle'),
            ),
          ],
        ),
      ),
    );
  }
}
