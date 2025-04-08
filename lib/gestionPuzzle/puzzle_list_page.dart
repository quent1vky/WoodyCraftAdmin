import 'package:flutter/material.dart';
import '../service/puzzle_service.dart'; // Importer PuzzleService
import 'create_puzzle_page.dart'; // Importer CreatePuzzlePage

class PuzzleListPage extends StatefulWidget {
  const PuzzleListPage({super.key});

  @override
  _PuzzleListPageState createState() => _PuzzleListPageState();
}

class _PuzzleListPageState extends State<PuzzleListPage> {
  late Future<List<Puzzle>> futurePuzzles;

  @override
  void initState() {
    super.initState();
    futurePuzzles = PuzzleService().fetchPuzzles(); // Appel de fetchPuzzles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion du catalogue'),
      ),
      body: FutureBuilder<List<Puzzle>>(
        future: futurePuzzles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            final puzzles = snapshot.data!;
            return ListView.builder(
              itemCount: puzzles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(puzzles[index].nom),
                  subtitle: Text(puzzles[index].description),
                );
              },
            );
          }
        },
      ),
    );
  }
}
