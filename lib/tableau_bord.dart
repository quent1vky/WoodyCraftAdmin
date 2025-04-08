import 'package:flutter/material.dart';
import 'orders/liste_commandes.dart';
import 'stock/stock_list_page.dart';
import 'tableau_de_bord/affichage.dart';
import 'gestionPuzzle/GestionPuzzlePage .dart';
import 'gestionPuzzle/puzzle_list_page.dart';



class TableauBord extends StatefulWidget {
  const TableauBord({super.key});

  @override
  _TableauBordState createState() => _TableauBordState();
}

class _TableauBordState extends State<TableauBord> {
  int _selectedIndex = 2; // Index par défaut pour le tableau de bord

  final List<Widget> _pages = [
    PuzzleListPage(),
    GestionPuzzlePage(),
    Affichage(),
    CommandePage(),
    StockePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.extension, color: Colors.white), label: 'Puzzles'),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.white), label: 'Gestion'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard, color: Colors.white), label: 'Tableau de bord'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, color: Colors.white), label: 'Commande'),
          BottomNavigationBarItem(icon: Icon(Icons.storage, color: Colors.white), label: 'Stocke'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Pages placeholders (Remplacez par vos vraies pages)
class PuzzlesPage extends StatelessWidget {
  const PuzzlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Puzzles Page'));
  }
}

class GestionPage extends StatelessWidget {
  const GestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Gestion Page'));
  }
}



class CommandePage extends StatelessWidget {
  const CommandePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des Commandes'),
      backgroundColor: Colors.green,),
      body: ListeCommandes(),
    );
  }
}

class StockePage extends StatelessWidget {
  const StockePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Les Stocks'),
      backgroundColor: Colors.green,
      ),

      body: StockPage(),
    );
  }
}