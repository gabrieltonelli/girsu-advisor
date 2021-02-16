import 'package:flutter/material.dart';
//import 'package:girsu/model/evento.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
//import 'package:girsu/model/tarea.dart';
import 'package:girsu/model/estado.dart';
import 'package:girsu/model/checkpoint.dart';

//import 'package:girsu/misc/my_library.dart';
/******************** packages para usar la camara **********************/
//import 'package:camera/camera.dart';
//import 'package:path/path.dart' show join;
//import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:girsu/globals.dart' as globals;

/***********************************************************************/

class StatusEvento extends StatefulWidget {
  final Checkpoint unCheckpoint;

  const StatusEvento({Key key, @required this.unCheckpoint}) : super(key: key);

  @override
  StatusEventoState createState() => StatusEventoState();
}

class StatusEventoState extends State<StatusEvento> {
  //
  static final String uploadEndPoint =
      'https://rsuambiental.com.ar/girsu-manager/restapi/v1/upload.php';
  String status = '';
  Estado estadoSeleccionado;
  String base64Image;
  File tmpFile;
  String errMessage = 'Error durante el envío.';
  File file;
  final picker = ImagePicker();

  Future takePicture() async {
    print('entra a takePicture()');
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        maxWidth: 1280.0,
        maxHeight: 1280.0,
        imageQuality: 70);
    setState(() {
      print('pickedFile=' + pickedFile.toString());

      //file = ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 1280.0,maxHeight: 1280.0);
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No se ha fotografiado nada aun.');
      }
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Future _estados;

  @override
  void initState() {
    super.initState();
    takePicture(); //llamada inicial de la camara (abre la camara automaticamente)
    _estados = _fetchEstados();
  }

  Future<List<Estado>> _fetchEstados() async {
    final String uri =
        'https://rsuambiental.com.ar/girsu-manager/restapi/v1/estados?id_empresa=' +
            widget.unCheckpoint.id_empresa.toString() +
            '&tipo=checkpoints';

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

  startUpload() {
    setStatus('Enviando...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? "Enviada!" : errMessage);
      print('Codigo de retorno:' + result.statusCode.toString());
      if (result.statusCode == 200) {
        //grabar notificacion en la base de datos
        print('URL:' + result.body.toString());
        _sendEvento(result.body.toString());
        Navigator.pop(context);
      }
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (null != file) {
          tmpFile = file;
          base64Image = base64Encode(file.readAsBytesSync());
          return Container(
            margin: const EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width - 10.0,
            height: 150.0,
            child: Image.file(
              file,
              fit: BoxFit.fitHeight,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error al cargar foto.',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No haz establecido ninguna foto aún',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  _sendEvento(String image_url) async {
    final String postUri =
        'https://rsuambiental.com.ar/girsu-manager/restapi/v1/evento';

    /*
    final String url = postUri + '?id_tarea=' + widget.tarea.idTarea.toString()
        + '&tipo=3'
        +'&id_empresa=' + widget.tarea.idEmpresa.toString()
        + '&id_autor=' + globals.loggedUser.idUsuario.toString()
        + '&image_url=' + image_url;
*/
    final String url = postUri +
        '?id_checkpoint=' +
        widget.unCheckpoint.id_checkpoint.toString() +
        '&id_usuario=' +
        globals.loggedUser.idUsuario.toString() +
        '&id_estado=' +
        estadoSeleccionado.idEstado.toString() +
        '&id_empresa=' +
        widget.unCheckpoint.id_empresa.toString() +
        '&image_url=' +
        image_url +
        '&id_recorrido=' +
        widget.unCheckpoint.id_recorrido.toString();

    var response = await http.post(Uri.encodeFull(url));
    print('**********************************');
    print(Uri.encodeFull(url));

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Error al enviar estado.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Estado selected;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de estado'),
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
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () => takePicture(),
                    child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        elevation: 10.0,
                        child: Container(
                            padding: new EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width - 30,
                            height: 80.0,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40.0,
                                  ),
                                  Text('Tomar una nueva foto',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        //color: Colors.white,
                                        fontSize: 17.0,
                                      ))
                                ])))),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            Center(
              child: FutureBuilder<List<Estado>>(
                  future: _estados,
                  builder: (context, snapshot2) {
                    if (!snapshot2.hasData)
                      return Center(child: CircularProgressIndicator());

                    //DropdownButtonFormField
                    return DropdownButtonFormField(
                      hint: Text('--seleccione un estado--'),
                      items: snapshot2.data
                          .map<DropdownMenuItem<Estado>>((Estado estado) {
                        return DropdownMenuItem(
                          child: Text(estado.descripcion.toString()),
                          value: estado,
                        );
                      }).toList(),
                      onChanged: (Estado newVal) {
                        setState(() {
                          estadoSeleccionado = newVal;
                        });
                      },
                      value: estadoSeleccionado,
                    );
                  }),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Colors.green,
                      onPressed: () => startUpload(),
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
                                'ENVIAR',
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
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
