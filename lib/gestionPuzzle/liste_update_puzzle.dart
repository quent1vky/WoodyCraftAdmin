import 'package:flutter/material.dart';
import '../service/puzzle_service.dart'; // Importer PuzzleService
import 'update_puzzle_page.dart';

class PuzzleListPageUpdate extends StatefulWidget {
  const PuzzleListPageUpdate({super.key});

  @override
  _PuzzleListPageUpdateState createState() => _PuzzleListPageUpdateState();
}

class _PuzzleListPageUpdateState extends State<PuzzleListPageUpdate> {
  late Future<List<Puzzle>> futurePuzzles;

  @override
  void initState() {
    super.initState();
    futurePuzzles = PuzzleService().fetchPuzzles(); // Appel de fetchPuzzles
  }

  // Méthode pour naviguer et rafraîchir la page
  Future<void> _navigateAndRefresh(BuildContext context, int puzzleId) async {
    // Navigue vers la page de détails du puzzle
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PuzzleDetailPage(puzzleId: puzzleId),
      ),
    );

    // Vérifie si la page a été mise à jour avec succès
    if (result == true) {
      setState(() {
        // Rafraîchis la liste des puzzles
        futurePuzzles = PuzzleService().fetchPuzzles();
      });
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
            final puzzles = snapshot.data!;
            return ListView.builder(
              itemCount: puzzles.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(puzzles[index].nom),
                    subtitle: Text(puzzles[index].description),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Appelle la méthode _navigateAndRefresh au lieu de Navigator.push
                        _navigateAndRefresh(context, puzzles[index].id);
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