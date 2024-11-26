import 'package:flutter/material.dart';
import '../util/db.dart';

class UserPurchasesScreen extends StatefulWidget {
  final int userId;

  UserPurchasesScreen({required this.userId});

  @override
  _UserPurchasesScreenState createState() => _UserPurchasesScreenState();
}

class _UserPurchasesScreenState extends State<UserPurchasesScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> purchases = [];

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    final userPurchases = await dbHelper.getPurchases(widget.userId);
    setState(() {
      purchases = userPurchases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Círculos en la esquina superior izquierda
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: -150,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Círculos en la esquina inferior derecha
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: -150,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Contenido de la pantalla de compras
          Column(
            children: [
              AppBar(
                title: Text('Mis Compras'),
                backgroundColor: Colors.blue,
              ),
              Expanded(
                child: purchases.isEmpty
                    ? Center(child: Text('No hay compras registradas.'))
                    : ListView.builder(
                        itemCount: purchases.length,
                        itemBuilder: (context, index) {
                          final purchase = purchases[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                purchase['productName'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.0),
                                  Text('Costo: \$${purchase['cost'].toStringAsFixed(2)}'),
                                  SizedBox(height: 8.0),
                                ],
                              ),
                              leading: Icon(Icons.shopping_cart, color: Colors.blue),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}