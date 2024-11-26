import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quickalert/quickalert.dart';
import '../util/db.dart'; 
import 'choice_screen.dart'; 

class RegisterScreenView extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreenView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
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
          // Contenido del registro
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
                    '¡Regístrate!',
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
                        height: 180,
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
                            // Campo de nombre
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Nombre',
                                prefixIcon: Icon(Icons.person, color: Colors.red),
                                border: InputBorder.none,
                              ),
                            ),
                            Divider(color: Colors.grey[400]),
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
                      top: 60,
                      child: GestureDetector(
                        onTap: () async {
                          String nombre = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          if (nombre.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                            if (!_isValidEmail(email)) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Error',
                                text: 'Por favor, ingrese un correo electrónico válido',
                              );
                              return;
                            }

                            bool emailExists = await _databaseHelper.checkEmailExists(email);

                            if (emailExists) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Error',
                                text: 'El correo electrónico ya está en uso',
                              );
                            } else {
                              int id = await _databaseHelper.registerUser(nombre, email, password);

                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: 'Éxito',
                                text: 'Registrado con éxito! ID: $id',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChoiceScreenView(userId: id),
                                ),
                              );
                            }
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Error',
                              text: 'Por favor, complete todos los campos',
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
                      '¿Ya tienes una cuenta?',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                          'Iniciar Sesión',
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