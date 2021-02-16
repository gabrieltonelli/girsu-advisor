import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:girsu/model/estado.dart';
import 'package:girsu/model/tarea.dart';
import 'package:flutter/foundation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:girsu/globals.dart' as globals;

class StatusNotificationScreen extends StatefulWidget {

  final Tarea tarea;
  //final int idUsuario;

  StatusNotificationScreen({Key key, @required this.tarea}): super(key: key);
  _StatusNotificationScreenState createState() => _StatusNotificationScreenState();
}

class _StatusNotificationScreenState extends State<StatusNotificationScreen> {

  @override
  Widget build(BuildContext context) {

    final String uri = 'https://rsuambiental.com.ar/girsu-manager/restapi/v1/estados?id_empresa='+widget.tarea.idEmpresa.toString()+'&tipo=tareas';

    final String postUri = 'https://rsuambiental.com.ar/girsu-manager/restapi/v1/notificaciones';

    Estado selected;

    Future<List<Estado>> _fetchEstados() async {
      debugPrint('API: $uri');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Estado> listOfEstados = items.map<Estado>((json) {
          return Estado.fromJson(json);
        }).toList();
        return listOfEstados;
      } else {
        throw Exception('Error al obtener los estados');
      }
    }







    _sendNotification(int idEstado) async {
        var response = await http.post(Uri.encodeFull(postUri + '?id_tarea=' + widget.tarea.idTarea.toString()
            + '&tipo=2'
            +'&id_empresa=' + widget.tarea.idEmpresa.toString()
            + '&id_autor=' + globals.loggedUser.idUsuario.toString()
            + '&id_estado=' + idEstado.toString()));

        print(response.body);




        if (response.statusCode == 201) {
          Navigator.pop(context);
        }
        else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Error al enviar notificacion.")));
        }
    }

    _onSelected(Estado index) {
      setState(() => selected = index);
      print(selected.descripcion);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Informar Avance'),
        backgroundColor: Colors.green,
        elevation: .9,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          /*
            IconButton(
              icon: Icon(
                Icons.videocam,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.white,
              ),
              onPressed: () {},
            ),

            */

          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          )


        ],
      ),

      body: FutureBuilder<List<Estado>>(
        future: _fetchEstados(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            children: snapshot.data.map((estado) =>


            InkWell(
                onTap: () => _sendNotification(estado.idEstado),
          child:


          Card(
          elevation: 10.0,
          child:
          Container(
              child:

          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                   new CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 5.0,
                        animation: false,
                        animationDuration: 2000,
                        percent: estado.avance/100,
                        progressColor: Color(int.parse(estado.color.substring(1, 7), radix: 16) + 0xFF000000),
                        center: new Text(
                          estado.avance.toString()+'%',
                          style:
                          new TextStyle(fontSize: 12),
                        ),
                      ),
              Text(estado.descripcion)
                      //onTap: () => _sendNotification(estado.idEstado),
                  ]
                    )
               )
            )
            )
            )
                .toList(),
          );
        },
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _sendNotification(),
        label: Text('Enviar'),
        icon: Icon(Icons.send),
      ),*/
    );
  }
}