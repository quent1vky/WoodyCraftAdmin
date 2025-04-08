
import 'package:flutter/material.dart';
import 'order_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<Order> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder =
        OrderService().fetchOrderDetails(widget.orderId); // Fetch order details
  }

    Future<void> handleExpedition() async {
      try {
        String message = await OrderService().validerCommande(widget.orderId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        // Rafraîchir les données après validation
        setState(() {
          futureOrder = OrderService().fetchOrderDetails(widget.orderId);
        });
      } catch (e) {
        print("Erreur: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${e.toString()}")),
        );
      }
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la commande"),
      ),
      body: FutureBuilder<Order>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucune donnée disponible'));
          } else {
            final order = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Commande: ${order.id}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Type de paiement: ${order.typePaiement}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Date de commande: ${order.dateCommande}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Total prix: ${order.totalPrix.toStringAsFixed(2)} €',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Methode de paiement: ${order.methodePaiement}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                      'Statut de la commande: ${order.statutCommande}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),

                  // Displaying the articles list
                  const Text('Liste des articles:', style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap:
                          true, // Prevents ListView from taking all available space
                      itemCount: order.articles.length,
                      itemBuilder: (context, index) {
                        final article = order.articles[index];
                        return Card(
                          child: Column(
                            children: [
                              Text(
                                article['nom'] ?? 'Nom inconnu',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text('Prix: ${article['prix']} €'),
                              Text('Quantité: ${article['quantity']}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 120.0,
        height: 40.0,
        child: FloatingActionButton(
          onPressed: handleExpedition, // Appelle la fonction d'expédition
          child: const Text("Valider"),
        ),
      ),

    );
  }
}
