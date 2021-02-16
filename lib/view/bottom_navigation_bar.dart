import 'package:flutter/material.dart';
import 'package:girsu/view/send_status_evento.dart';
import 'package:girsu/view/tareas_screen.dart';
import 'package:girsu/model/checkpoint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:girsu/globals.dart' as globals;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar();
  _MyBottomNavigationBar createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  //final List<Widget> _children = [];
  Checkpoint unCheckpoint;
  //Geolocator GeolocatorInstance;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTabTapped, // new
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_location),
          label: 'Checkpoint',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adjust_outlined),
          label: 'Ubicación',
        ),
      ],
    );
  }

  Future<List<Checkpoint>> _fetchCheckpoints() async {
    final String uri =
        'https://rsuambiental.com.ar/girsu-manager/restapi/v1/user_checkpoints?id_usuario=' +
            globals.loggedUser.idUsuario.toString();

    print('API: $uri');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Checkpoint> listOfCheckpoint = items.map<Checkpoint>((json) {
        return Checkpoint.fromJson(json);
      }).toList();
      return listOfCheckpoint;
    } else {
      throw Exception('Error al obtener checkpoints del usuario');
    }
  }

  Future<LocationData> userPosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return null;
      }
    }

    return await location.getLocation();
    /* print('-------'+DateTime.now().toString());

    globals.loggedUser.latitude = _locationData.latitude;
    globals.loggedUser.longitude = _locationData.longitude;

    print('Lat: ' + _locationData.latitude.toString());
    print('Lng: '+ _locationData.longitude.toString());
    */
  }

  Future<Checkpoint> checkpointCercano() async {
    LocationData current_location = await userPosition();

    print('pasa por checkpointCercano()');

    // Position current_position = await location.getLocation();;

    print('Latitud:' + current_location.latitude.toString());
    print('Longitud:' + current_location.longitude.toString());

    List<Checkpoint> UserCheckpoints;

    UserCheckpoints = await _fetchCheckpoints();

    if (UserCheckpoints != null) {
      UserCheckpoints.forEach((item) async {
        print('entra con item.lat=' +
            item.lat.toString() +
            '   item.lng=' +
            item.lng.toString());

        double distanceInMeters = await Geolocator().distanceBetween(item.lat,
            item.lng, current_location.latitude, current_location.longitude);
        print('distanceInMeters=' + distanceInMeters.toString());
        print('item antes de salir de la funcion=' + item.toString());

        if (distanceInMeters < 30) {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) {
                return StatusEvento(unCheckpoint: item);
                //return TareaDetalle(tarea: Tarea);
              },
            ),
          );
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                  "No se ha detectado checkpoint cercano asignado a tí.")));
        }
      });
    }
    return null;
  }

  Future<String> ubicacionActual() async {
    LocationData current_location = await userPosition();
    return 'Latitud:' +
        current_location.latitude.toString() +
        ' Longitud:' +
        current_location.longitude.toString();
  }

  Future onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });

    print('Tocó:' + index.toString());
    switch (index) {
      case 0:
        await checkpointCercano();

        break;
      case 1:
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              return TareasScreen();
              //return TareaDetalle(tarea: Tarea);
            },
          ),
        );
        break;
      case 2: //ubicacion
        String latlng = await ubicacionActual();
        print(latlng);
        if (latlng.length > 0) {
          /*
                  () async =>
              await launch(
                  "https://wa.me/&text=" + latlng);
            */
          FlutterOpenWhatsapp.sendSingleMessage("", latlng);
        } else {
          SnackBar(content: Text("No se ha pudo obtener tu ubicación actual."));
        }
    }
  }
}

//BottomNavigationBar
