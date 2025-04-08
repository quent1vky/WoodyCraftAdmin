import 'package:flutter/material.dart';
import '../service/puzzle_service.dart';

class PuzzleDetailPage extends StatefulWidget {
  final int puzzleId;

  const PuzzleDetailPage({super.key, required this.puzzleId});

  @override
  _PuzzleDetailPageState createState() => _PuzzleDetailPageState();
}

class _PuzzleDetailPageState extends State<PuzzleDetailPage> {
  Puzzle? puzzle;
  bool isLoading = true;
  String errorMessage = '';

  // Controllers pour préremplir et modifier les champs
  final TextEditingController nomController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categorieController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPuzzleDetails();
  }

  Future<void> fetchPuzzleDetails() async {
    try {
      Puzzle fetchedPuzzle =
          await PuzzleService().fetchPuzzleById(widget.puzzleId);
      setState(() {
        puzzle = fetchedPuzzle;
        isLoading = false;
        // Pré-remplissage des champs avec les valeurs du puzzle
        nomController.text = puzzle!.nom;
        descriptionController.text = puzzle!.description;
        prixController.text = puzzle!.prix.toString();
        stockController.text = puzzle!.stock.toString();
        imageController.text = puzzle!.image;
        categorieController.text = puzzle!.categorie.toString();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors du chargement du puzzle';
        isLoading = false;
      });
    }
  }

  Future<void> updatePuzzle() async {
    if (puzzle == null) return;

    try {
      // Appel de l'API pour mettre à jour le puzzle
      await PuzzleService().updatePuzzle(
        puzzle!.id.toString(),
        nomController.text,
        descriptionController.text,
        imageController.text,
        double.tryParse(prixController.text) ?? 0.0,
        int.tryParse(stockController.text) ?? 0,
        int.tryParse(categorieController.text) ?? 1,
      );

      // Message de succès et retour à la page précédente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Puzzle mis à jour avec succès !')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier le Puzzle')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nomController,
                          decoration: InputDecoration(labelText: 'Nom'),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(labelText: 'Description'),
                        ),
                        TextFormField(
                          controller: prixController,
                          decoration: InputDecoration(labelText: 'Prix (€)'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: stockController,
                          decoration: InputDecoration(labelText: 'Stock'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: imageController,
                          decoration: InputDecoration(labelText: 'URL Image'),
                        ),
                        TextFormField(
                          controller: categorieController,
                          decoration:
                              InputDecoration(labelText: 'Catégorie ID'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: updatePuzzle,
                          child: Text('Enregistrer les modifications'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
