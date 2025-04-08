import 'package:flutter/material.dart';
import 'dart:convert';
import '../puzzle_service.dart';
import 'package:http/http.dart' as http;

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<Puzzle>> _puzzles;
  final int stockMinimum = 5;

  @override
  void initState() {
    super.initState();
    _puzzles = fetchPuzzles();
  }

  Future<List<Puzzle>> fetchPuzzles() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/api/puzzles'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);         
      List<Puzzle> puzzles = data.map((json) => Puzzle.fromJson(json)).toList();

      // Trier les puzzles par stock (du plus petit au plus grand)
      puzzles.sort((a, b) => a.stock.compareTo(b.stock));

      return puzzles;
    } else {
      throw Exception('Erreur de chargement des puzzles');
    }
  }


  Future<void> updateStock(int puzzleId, int newStock) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8080/api/puzzles/$puzzleId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'stock': newStock}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur de mise à jour du stock');
    }
  }

  void showStockUpdateMessage(BuildContext context, String puzzleName, int newStock) {
    String message = 'Le stock de "$puzzleName" a été mis à jour à $newStock unités';
    if (newStock <= stockMinimum) {
      message += '\nATTENTION: Niveau de stock bas !';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: newStock <= stockMinimum ? Colors.orange : Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Puzzle>>(
        future: _puzzles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun puzzle disponible.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final puzzle = snapshot.data![index];
              TextEditingController stockController = TextEditingController(text: puzzle.stock.toString());
              
              return ListTile(
                title: Text(puzzle.nom),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Stock',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        try {
                          int newStock = int.tryParse(stockController.text) ?? puzzle.stock;
                          await updateStock(puzzle.id, newStock);
                          showStockUpdateMessage(context, puzzle.nom, newStock);
                          setState(() {
                            _puzzles = fetchPuzzles();
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur lors de la mise à jour du stock'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                leading: Icon(Icons.extension, color: puzzle.stock <= stockMinimum ? Colors.red : Colors.black),
              );
            },
          );
        },
      ),
    );
  }
}