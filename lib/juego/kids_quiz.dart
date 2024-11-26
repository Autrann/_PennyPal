import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../views/main_kids_screen.dart';

class QuizGame extends StatefulWidget {
  final int userId;
  @override
  QuizGame({required this.userId});
  _QuizGameState createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> selectedQuestions = [];

  final List<Map<String, dynamic>> allQuestions = [
    {'question': '¿Cuál es una buena forma de ahorrar dinero?', 'options': ['Comprar cosas innecesarias', 'Guardar en una alcancía', 'Gastar todo en dulces', 'No hacer nada'], 'answer': 'Guardar en una alcancía'},
    {'question': '¿Qué es mejor hacer con el dinero que te sobra?', 'options': ['Gastar en videojuegos', 'Ahorrarlo', 'Comprarle un regalo a alguien', 'No importa'], 'answer': 'Ahorrarlo'},
    {'question': '¿Por qué es bueno ahorrar?', 'options': ['Para tener dinero en el futuro', 'Para perder dinero', 'Para gastar más', 'No tiene sentido'], 'answer': 'Para tener dinero en el futuro'},
    {'question': '¿Dónde podrías guardar dinero?', 'options': ['En una cuenta de ahorro', 'En la basura', 'Debajo de la cama', 'Gastarlo todo'], 'answer': 'En una cuenta de ahorro'},
    {'question': '¿Cuál es una buena razón para ahorrar?', 'options': ['Comprar más juguetes', 'Estar preparado para emergencias', 'Gastarlo rápido', 'Para no tener nada'], 'answer': 'Estar preparado para emergencias'},
    
  ];

  @override
  void initState() {
    super.initState();
    selectedQuestions = getRandomQuestions();
  }

  List<Map<String, dynamic>> getRandomQuestions() {
    final random = Random();
    List<Map<String, dynamic>> questionsCopy = List.from(allQuestions);
    questionsCopy.shuffle(random);
    return questionsCopy.take(3).toList();
  }

  void checkAnswer(String selectedOption) {
    String correctAnswer = selectedQuestions[currentQuestionIndex]['answer'];
    setState(() {
      if (selectedOption == correctAnswer) {
        score += 1;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              title: Text('¡Correcto! 🎉', style: TextStyle(color: Colors.white)),
              content: Text('¡Bien hecho! Sigue aprendiendo sobre el ahorro.', style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                TextButton(
                  child: Text('Siguiente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    nextQuestion();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              title: Text('Incorrecto ❌', style: TextStyle(color: Colors.white)),
              content: Text('Intenta de nuevo y recuerda cómo ahorrar.', style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                TextButton(
                  child: Text('Intentar de nuevo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < selectedQuestions.length - 1) {
        currentQuestionIndex += 1;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              title: Text('¡Juego Terminado! 🎉', style: TextStyle(color: Colors.white)),
              content: Text('Puntuación: $score/${selectedQuestions.length}', style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                TextButton(
                  child: Text('Ir a la pantalla principal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainKidsScreenView(userId: widget.userId)),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/erizo_emprendedor.svg',
                      height: screenHeight * 0.2,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Flexible(
                  flex: 1,
                  child: Text(
                    'Pregunta ${currentQuestionIndex + 1}/${selectedQuestions.length}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            selectedQuestions[currentQuestionIndex]['question'],
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Expanded(
                            child: ListView.builder(
                              itemCount: selectedQuestions[currentQuestionIndex]['options'].length,
                              itemBuilder: (context, index) {
                                String option = selectedQuestions[currentQuestionIndex]['options'][index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => checkAnswer(option),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.white, // Set the font color to white
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
