import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io'; 
import '../util/db.dart'; 
import 'main_teens_screen.dart'; 

class TeensScreenView extends StatefulWidget {
  final int userId;

  TeensScreenView({required this.userId});

  @override
  _TeensScreenViewState createState() => _TeensScreenViewState();
}

class _TeensScreenViewState extends State<TeensScreenView> {
  ImageProvider<Object>? _profileImage;
  final ImagePicker _picker = ImagePicker(); 
  String _imagePath = ''; 
  final _dbHelper = DatabaseHelper(); 

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, 
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;

            return Stack(
              children: [
                Positioned(
                  top: -(width * 0.35),
                  left: -(width * 0.2),
                  child: CircleAvatar(
                    radius: width * 0.4,
                    backgroundColor: Colors.blue.shade400,
                  ),
                ),
                Positioned(
                  bottom: -(width * 0.35),
                  right: -(width * 0.2),
                  child: CircleAvatar(
                    radius: width * 0.4,
                    backgroundColor: Colors.blue.shade400,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Personaliza tu perfil.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sube una fotografía que te guste.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Muestra la imagen seleccionada o un ícono de usuario
                      CircleAvatar(
                        radius: width * 0.2,
                        backgroundColor: Colors.blue.shade200,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_imagePath)) 
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.person,
                                size: width * 0.15,
                                color: Colors.blue.shade700,
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      // Botón de editar
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue.shade400, size: width * 0.08),
                        onPressed: _selectImage, 
                      ),
                      const SizedBox(height: 30),
                      
                      ElevatedButton(
                        onPressed: _submitForm, 
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(width * 0.05),
                          backgroundColor: Colors.blue.shade400,
                        ),
                        child: Icon(
                          Icons.check,
                          size: width * 0.1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  
  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path; 
        _profileImage = FileImage(File(_imagePath)); 
      });
    }
  }

  
  Future<void> _submitForm() async {
    if (_imagePath == '') {
      _showErrorDialog('Por favor, selecciona una imagen');
    } else {
      
      await _dbHelper.updateUserImagePath(widget.userId, _imagePath);

      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainTeensScreenView(userId: widget.userId),
        ),
      );
    }
  }

  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
