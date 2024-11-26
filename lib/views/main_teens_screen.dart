import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import '../util/db.dart'; 
import '../mapapi/mapa.dart';
import '../sessions/login_screen.dart';
import 'teens_purchases_screen.dart';

class MainTeensScreenView extends StatefulWidget {
  final int userId; 

  MainTeensScreenView({required this.userId});

  @override
  _MainTeensScreenViewState createState() => _MainTeensScreenViewState();
}

class _MainTeensScreenViewState extends State<MainTeensScreenView> {
  final dbHelper = DatabaseHelper();
  String? imagePath; 
  double balance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    final db = await dbHelper.database;
    final user = await db.query('users', where: 'id = ?', whereArgs: [widget.userId]);
    
    if (user.isNotEmpty) {
      setState(() {
        imagePath = user.first['imagePath'] as String?; 
        balance = user.first['balance'] as double? ?? 0.0; 
      });
    }
  }

  Future<void> updateBalance(int id, double balance) async {
    final db = await dbHelper.database;
    await db.update(
      'users',
      {'balance': balance},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

void _showPurchaseModal() {
  final _formKey = GlobalKey<FormState>();
  String product = '';
  double price = 0.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue.withOpacity(0.7),
        title: Text('Comprar algo', style: TextStyle(color: Colors.white)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Producto', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el producto';
                  }
                  product = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  try {
                    price = double.parse(value);
                  } catch (e) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Comprar', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (balance >= price) {
                  setState(() {
                    balance -= price;
                  });
                  await updateBalance(widget.userId, balance);
                  await dbHelper.addPurchase(widget.userId, product, price);
                  Navigator.of(context).pop();
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Uy, no te alcanza',
                    text: 'Saldo insuficiente',
                  );
                }
              }
            },
          ),
        ],
      );
    },
  );
}


  void _showEditBalanceModal() {
    final _formKey = GlobalKey<FormState>();
    double newBalance = balance;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Saldo'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: balance.toString(),
              decoration: InputDecoration(labelText: 'Nuevo Saldo'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nuevo saldo';
                }
                try {
                  newBalance = double.parse(value);
                } catch (e) {
                  return 'Por favor ingrese un número válido';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    balance = newBalance;
                    updateBalance(widget.userId, balance); 
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showFinancialAdvice() {
    final advices = [
      "Ahorra al menos el 10% de tus ingresos para tener un colchón financiero en caso de emergencias.",
      "Evita las deudas innecesarias y trata de pagar tus tarjetas de crédito a tiempo para evitar intereses altos.",
      "Invierte en tu educación financiera para tomar decisiones más informadas sobre tu dinero.",
      "Lleva un registro detallado de tus gastos diarios para identificar áreas donde puedas ahorrar.",
      "Establece un presupuesto mensual y síguelo para mantener tus finanzas bajo control."
    ];
    final advice = (advices..shuffle()).first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue.withOpacity(0.8),
        title: Row(
        children: [
          SvgPicture.asset(
          'assets/erizo_emprendedor.svg',
          height: 40,
          ),
          SizedBox(width: 10),
          Text(
          'Consejo Financiero',
          style: TextStyle(color: Colors.white),
          ),
        ],
        ),
        content: Text(
        advice,
        style: TextStyle(color: Colors.white),
        ),
        actions: [
        TextButton(
          child: Text(
          'Cerrar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
          Navigator.of(context).pop();
          },
        ),
        ],
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        backgroundColor: Colors.white, 
        appBar: AppBar(
          automaticallyImplyLeading: false, 
          backgroundColor: Colors.blue, 
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Foto de perfil en el AppBar
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.5),
                radius: 20,
                child: imagePath != null
                    ? _buildProfileImage(imagePath!) 
                    : SvgPicture.asset(
                        'assets/avatar.svg', 
                        width: 30,
                        height: 30,
                      ),
              ),
              // Botón de mensajes en el AppBar

            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Opciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.lightbulb),
                title: Text('Consejo Financiero'),
                onTap: _showFinancialAdvice,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreenView()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Círculos decorativos en la parte inferior
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // Contenedor principal del "Mi banco"
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), 
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/erizo_emprendedor.svg', 
                              height: 80, 
                            ),
                            SizedBox(width: 10),
                            Text(
                              '\$ ${balance.toStringAsFixed(2)}', 
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Botón de restar
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  balance -= 1.0; 
                                  updateBalance(widget.userId, balance); 
                                });
                              },
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                              iconSize: 40,
                              padding: EdgeInsets.all(20),
                              splashColor: Colors.blue,
                            ),
                            SizedBox(width: 20),
                            // Botón de sumar
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  balance += 1.0; 
                                  updateBalance(widget.userId, balance); 
                                });
                              },
                              icon: Icon(Icons.add),
                              color: Colors.green,
                              iconSize: 40,
                              padding: EdgeInsets.all(20),
                              splashColor: Colors.green,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Botón de editar saldo
                        ElevatedButton(
                          onPressed: _showEditBalanceModal,
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          ),
                          child: Text(
                          'Editar Saldo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botones de opciones como cápsulas que salen de la izquierda
                  GestureDetector(
                    onTap: _showPurchaseModal,
                    child: _buildCapsuleButton('¡Quiero comprar algo!', Icons.shopping_cart),
                  ),
                  _buildCapsuleButton('¡Busquemos bancos!', Icons.account_balance_wallet, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  }),
                _buildCapsuleButton('Mis Compras', Icons.receipt, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPurchasesScreen(userId: widget.userId),
                    ),
                  );
                }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String path) {
    if (path.startsWith('/')) {
      // Si la ruta es un archivo del sistema
      return ClipOval(
        child: Image.file(
          File(path),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Si es un asset SVG
      return SvgPicture.asset(
        path,
        width: 30,
        height: 30,
      );
    }
  }

  Widget _buildCapsuleButton(String text, IconData icon, [VoidCallback? onPressed]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), 
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), 
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), 
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        text,
                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
