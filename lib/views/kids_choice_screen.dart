import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/db.dart';
import 'main_kids_screen.dart';

class KidsScreenView extends StatefulWidget {
  final int userId; 

  KidsScreenView({required this.userId});

  @override
  State<KidsScreenView> createState() => KidsScreen();
}

class KidsScreen extends State<KidsScreenView> {
  String? selectedProfile;
  int? selectedIndex;
  final dbHelper = DatabaseHelper(); 

  
  final List<Map<String, String>> profiles = [
    {"name": "Zorro Ahorrador", "asset": "assets/zorro_ahorrador.svg"},
    {"name": "Gato Inversor", "asset": "assets/gato_inversor.svg"},
    {"name": "Foca Financiera", "asset": "assets/foca_financiera.svg"},
    {"name": "Tortuga Tesorera", "asset": "assets/tortuga_tesorera.svg"},
    {"name": "Mariposa Monedera", "asset": "assets/mariposa_monedera.svg"},
    {"name": "Erizo Emprendedor", "asset": "assets/erizo_emprendedor.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, 
      child: Scaffold(
        appBar: AppBar(
          title: Text('¡Escoge tu perfil!'),
          backgroundColor: Colors.redAccent,
          automaticallyImplyLeading: false, 
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                '¡Escoge tu perfil!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProfile = profiles[index]['asset'];
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.all(isSelected ? 4.0 : 8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blueAccent : Colors.red,
                            width: isSelected ? 6 : 4, 
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            profiles[index]['asset']!,
                            height: 90, 
                            width: 90,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedProfile != null
                    ? () async {
                        await dbHelper.updateUserImagePath(widget.userId, selectedProfile!);

                        Navigator.of(context).pop();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainKidsScreenView(userId: widget.userId),
                          ),
                        );
                      }
                    : null, 
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.blue, 
                ),
                child: Icon(Icons.check, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
