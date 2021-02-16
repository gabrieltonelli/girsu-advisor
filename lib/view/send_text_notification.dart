import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:girsu/model/tarea.dart';
//import 'dart:convert';
import 'package:girsu/globals.dart' as globals;

class TextNotificationScreen extends StatefulWidget {
  final Tarea tarea;
  //final int idUsuario;

  TextNotificationScreen({Key key, @required this.tarea}) : super(key: key);
  _TextNotificationScreenState createState() => _TextNotificationScreenState();
}

class _TextNotificationScreenState extends State<TextNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _observacionController = TextEditingController();

    final String baseUri =
        'https://rsuambiental.com.ar/girsu-manager/restapi/v1/notificaciones';

    _sendNotification(String observacion) async {
      var response = await http.post(Uri.encodeFull(baseUri +
          '?id_tarea=' +
          widget.tarea.idTarea.toString() +
          '&tipo=1' +
          '&id_empresa=' +
          widget.tarea.idEmpresa.toString() +
          '&id_autor=' +
          globals.loggedUser.idUsuario.toString() +
          '&observacion=' +
          observacion));

      print(response.body);

      if (response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Error al enviar notificacion")));
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Comentar algo'),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  controller: _observacionController,
                  autocorrect: true,
                  /*
              decoration: InputDecoration(

              ),*/
                  decoration: new InputDecoration(
                    hintText: 'Ingrese un comentario',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.green)),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                        bottom: 20.0, left: 20.0, right: 20.0, top: 20.0),
                  ),
                ),
              ),

/*
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () => _sendNotification(_observacionController.text),
                  child: Text('ENVIAR',
                    style: TextStyle(
                       /* color: Colors.white,*/
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),


         */

              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.green,
                        onPressed: () =>
                            _sendNotification(_observacionController.text),
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "ENVIAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
        ));
  }
}
