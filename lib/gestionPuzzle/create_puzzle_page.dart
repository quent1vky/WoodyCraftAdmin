import 'package:flutter/material.dart';
import '../service/puzzle_service.dart'; // Importer PuzzleService
import 'package:http/http.dart' as http;

class CreatePuzzlePage extends StatefulWidget {
  const CreatePuzzlePage({super.key});

  @override
  _CreatePuzzlePageState createState() => _CreatePuzzlePageState();
}

class _CreatePuzzlePageState extends State<CreatePuzzlePage> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _description = '';
  String _image = ''; // Champ pour l'image
  double _prix = 0.0; // Champ pour le prix
  int _stock = 0;
  int _categorie = 1; // Champ pour la catégorie

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nom = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Image URL'),
                onSaved: (value) {
                  _image = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  _prix =
                      double.tryParse(value!) ?? 0.0; // Conversion en double
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType
                    .number, // Permet de saisir uniquement des chiffres
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un stock';
                  }
                  // Vérifie si la valeur peut être convertie en entier
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide pour le stock';
                  }
                  return null;
                },
                onSaved: (value) {
                  _stock = int.tryParse(value!) ??
                      1; // Convertit la valeur en entier
                },
              ),

              // Champ pour la catégorie (ID de la catégorie)
              TextFormField(
                decoration: InputDecoration(labelText: 'ID Catégorie'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ID de catégorie';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un ID valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  // Sauvegarde de l'ID de la catégorie sous forme d'entier
                  _categorie = int.tryParse(value ?? '') ??
                      1; // Valeur par défaut si vide ou null
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    PuzzleService()
                        .createPuzzle(_nom, _description, _image, _prix, _stock,
                            _categorie)
                        .then((puzzle) {
                      // Succès: Retourner à la page précédente
                      Navigator.pop(context, true);
                    }).catchError((error) {
                      // Affiche le message d'erreur dans la console
                      print('Erreur lors de la création du puzzle: $error');

                      // Si 'error' est un objet Response d'http (ce qui semble être le cas ici),
                      // nous pouvons afficher son corps pour plus de détails
                      if (error is http.Response) {
                        print('Réponse complète de l\'API: ${error.body}');
                      }

                      // Afficher une notification à l'utilisateur
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Erreur lors de la création du puzzle')),
                      );
                    });
                  }
                },
                child: Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
