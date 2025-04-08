import 'dart:convert';
import 'package:http/http.dart' as http;

class Order {
  final int id;
  final String typePaiement;
  final String dateCommande;
  final List<dynamic> articles; // Champ pour l'image
  final double totalPrix; // Champ pour le prix
  final String methodePaiement; // Champ pour la catégorie
  final int statutCommande; // Champ pour la catégorie

  Order({
    required this.id,
    required this.typePaiement,
    required this.dateCommande,
    required this.articles, // Valeur par défaut
    required this.totalPrix, // Valeur par défaut
    required this.methodePaiement, // Valeur par défaut
    required this.statutCommande, // Valeur par défaut
  });

  // Méthode pour convertir la réponse JSON en un objet Commande (Order)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      typePaiement: json['type_paiement'] ?? '',
      dateCommande: json['date_commande'] ?? '',
      articles: json['articles'] ?? '',
      totalPrix: json['total_prix'] is int
          ? (json['total_prix'] as int).toDouble()
          : json['total_prix'] is double
              ? json['total_prix']
              : double.tryParse(json['total_prix'].toString()) ?? 0.0,
      methodePaiement: json['methode_paiement'] ?? '',
      statutCommande: json['statut_commande'] is String
          ? int.tryParse(json['statut_commande']) ?? 0
          : (json['statut_commande'] ?? 0),
    );
  }
}

class OrderService {
  final String apiUrl =
      "http://localhost:8080/api/orders"; // URL de l'API Laravel

  // Fonction pour récupérer tous les puzzles
  Future<List<Order>> fetchOrder() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Order> orders =
          body.map((dynamic item) => Order.fromJson(item)).toList();
      return orders;
    } else {
      throw Exception('Failed to load puzzles');
    }
  }


  // Fonction pour récupérer les détails d'une commande spécifique
  Future<Order> fetchOrderDetails(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Order.fromJson(body);
    } else {
      throw Exception('Failed to load order details');
    }
  }


// Fonction pour valider une commande
  Future<String> validerCommande(int id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/validate/$id'), 
      headers: {"Content-Type": "application/json"},
    );

    print("Réponse API: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message']; // Message de succès
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message']); // Message d'erreur
    }
  }
  
  Future<String> expedierCommande(int id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/$id/expedier'), // Modifier cet URL pour correspondre aux routes Laravel
      headers: {"Content-Type": "application/json"},
    );
    print("Réponse API expédition: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message']; // Message de succès
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message']); // Message d'erreur
    }
  }
}


