import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import '../util/db.dart';
import '../views/kids_choice_screen.dart';
import '../views/teens_choice_screen.dart';



class ChoiceScreenView extends StatefulWidget {
  final int userId; 

  ChoiceScreenView({required this.userId});

  @override
  State<ChoiceScreenView> createState() => ChoiceScreen();
}




class ChoiceScreen extends State<ChoiceScreenView> {
  
   final dbHelper = DatabaseHelper();
 @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Círculos superiores
          Positioned(
            top: -200,
            left: -150,
            child: CircleAvatar(
              radius: 300,
              backgroundColor: Colors.red.shade400,
            ),
          ),
          Positioned(
            top: -170,
            right: -120,
            child: CircleAvatar(
              radius: 280,
              backgroundColor: Colors.red.shade300,
            ),
          ),
          // Círculos inferiores
          Positioned(
            bottom: -200,
            left: -150,
            child: CircleAvatar(
              radius: 300,
              backgroundColor: Colors.blue.shade400,
            ),
          ),
          Positioned(
            bottom: -170,
            right: -120,
            child: CircleAvatar(
              radius: 280,
              backgroundColor: Colors.blue.shade300,
            ),
          ),
          // Contenido principal
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón de "Escoge Kids"
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _showKidsModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Escoge Kids',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50), 
              // Logo de Pennypal y texto explicativo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text.rich(
                    TextSpan(
                      text: 'PennyPal ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.red,
                      ),
                      children: [
                        TextSpan(
                          text: 'es personalizable.',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Selecciona tu modo para comenzar:\n\nKids: Aprende a manejar tu dinero con juegos y actividades divertidas.\nTeens: Gestiona tus finanzas y descubre conceptos avanzados.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 50), 
              // Botón de "Escoge Teens"
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _showTeensModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Escoge Teens',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  
  void _showKidsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título y cierre
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PennyPal Kids',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '• Introducir conceptos básicos de finanzas de manera divertida.\n'
                  '• Motivar a los niños a aprender y participar activamente en actividades que involucren ahorrar.\n'
                  '• Facilitar el acceso a juegos educativos y actividades.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await dbHelper.updateUserTipo(widget.userId, 'kids');
                    
                    Navigator.of(context).pop();
                    

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => KidsScreenView(userId: widget.userId),
                      ),
                    );

                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¡Quiero Kids!',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 
  void _showTeensModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PennyPal Teens',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '• Proporcionar herramientas y recursos para manejar finanzas personales más complejas.\n'
                  '• Facilitar el aprendizaje de conceptos avanzados de finanzas.\n'
                  '• Motivar a los adolescentes a planificar y gestionar su dinero de manera efectiva.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await dbHelper.updateUserTipo(widget.userId, 'teens');
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TeensScreenView(userId: widget.userId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¡Quiero Teens!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
