import 'package:flutter/material.dart';
import '../service/puzzle_service.dart'; // Importer PuzzleService

class PuzzleListPageDelete extends StatefulWidget {
  const PuzzleListPageDelete({super.key});

  @override
  _PuzzleListPageDeleteState createState() => _PuzzleListPageDeleteState();
}

class _PuzzleListPageDeleteState extends State<PuzzleListPageDelete> {
  late Future<List<Puzzle>> futurePuzzles;

  @override
  void initState() {
    super.initState();
    futurePuzzles = PuzzleService().fetchPuzzles();
  }

  Future<void> _deletePuzzle(int puzzleId) async {
    bool isDeleted = await PuzzleService().deletePuzzle(puzzleId);

    if (isDeleted) {
      setState(() {
        futurePuzzles = PuzzleService().fetchPuzzles(); // Rafraîchir la liste après la suppression
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Puzzle supprimé avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du puzzle')),
      );
    }
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
            final puzzles = snapshot.data!; // Utiliser tous les puzzles
            return ListView.builder(
              itemCount: puzzles.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(puzzles[index].nom),
                    subtitle: Text(puzzles[index].description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletePuzzle(puzzles[index].id);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
