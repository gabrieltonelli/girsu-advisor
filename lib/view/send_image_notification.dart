import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:girsu/model/tarea.dart';
//import 'package:camera/camera.dart';
//import 'package:path/path.dart' show join;
//import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:girsu/globals.dart' as globals;

/***********************************************************************/

class UploadImageDemo extends StatefulWidget {
  final Tarea tarea;
  // UploadImageDemo() : super();

  //final String title = "Upload Image Demo";
  //final CameraDescription camera;

  const UploadImageDemo({Key key, @required this.tarea}) : super(key: key);

  @override
  UploadImageDemoState createState() => UploadImageDemoState();
}

class UploadImageDemoState extends State<UploadImageDemo> {
  //
  static final String uploadEndPoint =
      'https://rsuambiental.com.ar/girsu-manager/restapi/v1/upload.php';
  //Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error durante el envío.';

  File file;
  final picker = ImagePicker();

  Future chooseImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 1280.0,
        maxHeight: 1280.0,
        imageQuality: 70);
    if (pickedFile != null) {
      file = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setStatus('');
  }

  Future takePicture() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        maxWidth: 1280.0,
        maxHeight: 1280.0,
        imageQuality: 70);
    if (pickedFile != null) {
      file = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    print("pasa por startUpload()");

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
        _sendNotification(result.body.toString());

        Navigator.pop(context);
      }
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        print('pasa por aca gabi1');
        if (null != file) {
//        if (snapshot.connectionState == ConnectionState.done &&
//            null != file) {
          tmpFile = file;
          print('pasa por aca gabi2');
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
            'Error al seleccionar foto.',
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

  final String postUri =
      'https://rsuambiental.com.ar/girsu-manager/restapi/v1/notificaciones';

  _sendNotification(String image_url) async {
    final String url = postUri +
        '?id_tarea=' +
        widget.tarea.idTarea.toString() +
        '&tipo=3' +
        '&id_empresa=' +
        widget.tarea.idEmpresa.toString() +
        '&id_autor=' +
        globals.loggedUser.idUsuario.toString() +
        '&image_url=' +
        image_url;

    var response = await http.post(Uri.encodeFull(url));
    print('**********************************');
    print(url);

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Error al enviar foto")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar una Foto'),
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
                    onTap: () => chooseImage(),
                    child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        elevation: 10.0,
                        child: Container(
                            padding: new EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            height: 140.0,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.image,
                                    size: 40.0,
                                  ),
                                  Text('Elegir desde la galería',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        //color: Colors.white,
                                        fontSize: 17.0,
                                      ))
                                ])))),
                InkWell(
                    onTap: () => takePicture(),
                    child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        elevation: 10.0,
                        child: Container(
                            padding: new EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            height: 140.0,
                            child: Column(
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

            /*OutlineButton(
              onPressed: chooseImage,
              child: Text('elegir imagen'),
            ),*/
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            /*
            SizedBox(
              height: 20.0,
            ),
*/

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
