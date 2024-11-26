import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import '../util/db.dart';
import '../juego/kids_quiz.dart';
import '../sessions/login_screen.dart';
import 'kids_purchases_screen.dart';

class MainKidsScreenView extends StatefulWidget {
  final int userId;

  MainKidsScreenView({required this.userId});

  @override
  _MainKidsScreenViewState createState() => _MainKidsScreenViewState();
}

class _MainKidsScreenViewState extends State<MainKidsScreenView> {
  final dbHelper = DatabaseHelper();
  String imagePath = 'assets/avatar.svg';
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
        imagePath = user.first['imagePath'] as String? ?? 'assets/avatar.svg';
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
        backgroundColor: Colors.red.withOpacity(0.7),
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
          backgroundColor: Colors.red.withOpacity(0.8),
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
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.5),
                radius: 20,
                child: SvgPicture.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
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
                title: Text('Consejo financiero'),
                onTap: _showFinancialAdvice,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreenView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
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
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
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
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showPurchaseModal,
                    child: _buildCapsuleButton('¡Quiero comprar algo!', Icons.shopping_cart),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizGame(userId: widget.userId),
                        ),
                      );
                    },
                    child: _buildCapsuleButton('¡Quiero aprender jugando!', Icons.games),
                  ),
                  GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KidsPurchasesScreen(userId: widget.userId),
                    ),
                    );
                  },
                  child: _buildCapsuleButton('¡Quiero ver mis compras!', Icons.receipt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapsuleButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
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
                    Icon(icon, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text(
                      text,
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

