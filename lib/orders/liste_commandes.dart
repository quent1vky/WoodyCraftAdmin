import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tp_apirestful/orders/order_service.dart';
import 'package:http/http.dart' as http;
import 'order_details_page.dart';

class Order {
  final int id;
  final String typePaiement;
  final String dateCommande;
  final List<dynamic> articles;
  final double totalPrix;
  final String methodePaiement;
  final int statutCommande;

  Order({
    required this.id,
    required this.typePaiement,
    required this.dateCommande,
    required this.articles,
    required this.totalPrix,
    required this.methodePaiement,
    required this.statutCommande,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      typePaiement: json['type_paiement'] ?? '',
      dateCommande: json['date_commande'] ?? '',
      articles: json['articles'] is String
          ? jsonDecode(json['articles'])
          : json['articles'] ?? [],
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

class ListeCommandes extends StatefulWidget {
  const ListeCommandes({super.key});

  @override
  _ListeCommandesState createState() => _ListeCommandesState();
}

class _ListeCommandesState extends State<ListeCommandes> {
  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/api/orders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Order.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des commandes');
    }
  }

  // Ajout de la fonction pour supprimer une commande
  Future<void> deleteOrder(int id) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8080/api/orders/$id'),
    );

    if (response.statusCode == 200) {
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commande supprimée avec succès')),
      );
      // Recharger la liste des commandes après la suppression
      setState(() {});
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la suppression de la commande')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Order>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune commande disponible"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Order order = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text("Commande #${order.id} - ${order.totalPrix}€"),
                    subtitle: Text(
                      "Paiement: ${order.methodePaiement} | Statut: ${getStatusText(order.statutCommande)}",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(orderId: order.id),
                        ),
                      ).then((_) {
                        // Rafraîchir la liste après retour de l'écran détails
                        setState(() {});
                      });
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton de validation (visible si statut = 0)
                        if (order.statutCommande == 0)
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () async {
                              try {
                                String message = await OrderService().validerCommande(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                                setState(() {}); // Rafraîchir la liste
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur: ${e.toString()}")),
                                );
                              }
                            },
                          ),
                        // Bouton d'expédition (visible si statut = 1 c'est-à-dire validé)
                        if (order.statutCommande == 1)
                          IconButton(
                            icon: const Icon(Icons.local_shipping, color: Colors.blue),
                            onPressed: () async {
                              try {
                                String message = await OrderService().expedierCommande(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                                setState(() {}); // Rafraîchir la liste
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur: ${e.toString()}")),
                                );
                              }
                            },
                          ),
                        // Bouton de suppression (visible uniquement pour les commandes en attente)
                        if (order.statutCommande == 0)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Confirmer la suppression avant de procéder
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                        'Êtes-vous sûr de vouloir supprimer cette commande ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Annuler'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteOrder(order.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Supprimer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
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

  // Fonction utilitaire pour afficher le statut en texte
  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "En attente";
      case 1:
        return "Validée";
      case 2:
        return "Expédiée";
      default:
        return "Inconnu";
    }
  }
}