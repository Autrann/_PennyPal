import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quickalert/quickalert.dart';
import 'register_screen.dart';
import '../util/db.dart'; 
import '../views/main_kids_screen.dart';
import '../views/main_teens_screen.dart';

class LoginScreenView extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
                color: Colors.redAccent,
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
                color: Colors.redAccent.withOpacity(0.7),
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
                color: Colors.redAccent,
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
                color: Colors.redAccent.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Contenido del login
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo de PennyPal con SVG
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'PennyPal',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    '¡Inicia Sesión!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Stack(
                  children: [
                    // Cápsula con borde plano a la izquierda
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        padding: EdgeInsets.only(right: 70),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Campo de correo electrónico
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.email, color: Colors.red),
                                border: InputBorder.none,
                              ),
                            ),
                            Divider(color: Colors.grey[400]),
                            // Campo de contraseña
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock, color: Colors.red),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Checkmark sobre la cápsula convertido en botón
                    Positioned(
                      right: 10,
                      top: 30,
                      child: GestureDetector(
                        onTap: () async {
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          var user = await _databaseHelper.loginUser(email, password);
                          if (user != null) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Inicio de sesión exitoso',
                            );
                            if (user['tipo'] == 'kids') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainKidsScreenView(userId: user['id'])),
                              );
                            } else if (user['tipo'] == 'teens') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainTeensScreenView(userId: user['id'])),
                              );
                            }
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: 'Correo o contraseña incorrectos',
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.check, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Aún no tienes una cuenta?',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreenView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(255, 224, 224, 224),
                          side: BorderSide(color: const Color.fromARGB(255, 226, 226, 226)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        child: Text(
                          'Registro',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
