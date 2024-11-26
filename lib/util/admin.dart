import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../util/db.dart';

class AdminView extends StatefulWidget {
  @override
  DatabaseViewer createState() => DatabaseViewer();
}

class DatabaseViewer extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Viewer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: _buildAvatar(user['imagePath'], user['nombre']),
                            title: Text(
                              user['nombre'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${user['email']}'),
                                Text('Tipo: ${user['tipo'] ?? 'No especificado'}'),
                                Text('Password: ${user['password']}'),
                                Text('Imagen: ${user['imagePath'] ?? 'Sin imagen'}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteUser(user['id']);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await vaciarTablaUsuarios();
                setState(() {});
              },
              child: Text('Vaciar Tabla Usuarios'),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.query('users');
  }

  void _deleteUser(int id) async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  Future<void> vaciarTablaUsuarios() async {
    final db = await DatabaseHelper().database;
    await db.delete('users');
  }

  Widget _buildAvatar(String? imagePath, String nombre) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      );
    } else {
      return CircleAvatar(
        child: Text(nombre[0]),
      );
    }
  }
}
