import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  LatLng? _currentPosition;


  final List<LatLng> _bankLocations = [
    LatLng(22.13935245329827, -100.94090353125549), 
    LatLng(22.140008346639586, -101.00096355572437),
    LatLng(22.146845354439566, -101.00873123278599),
    LatLng(22.14938927266354, -101.0045684445373),
    LatLng(22.148752651331808, -101.01109158258458),
    LatLng(22.1420747379536, -100.99984776274954),
    LatLng(22.14736144550988, -101.0159410164319),
    LatLng(22.14275049356514, -100.98602902213261),
    LatLng(22.151415778506273, -100.97431313276076),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos de ubicación están permanentemente denegados.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_currentPosition!, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa con bancos cercanos"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition ?? LatLng(22.1565, -100.9855),
          maxZoom: 28.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _currentPosition!,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                // Marcadores para cada coordenada de banco
                ..._bankLocations.map((location) => Marker(
                      width: 80.0,
                      height: 80.0,
                      point: location,
                      child: Icon(
                        Icons.account_balance,
                        color: Colors.red,
                        size: 30,
                      ),
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
