import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:girsu/model/tarea.dart';
import 'package:girsu/model/notificacion.dart';
import 'package:girsu/view/send_text_notification.dart';
import 'package:girsu/view/send_image_notification.dart';
import 'package:girsu/view/send_status_notification.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:girsu/globals.dart' as globals;
/*
void main() {
  runApp(new MaterialApp(
      title: 'GIRSU Advisor',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new TareaDetalle())
  );
}
*/

class TareaDetalle extends StatefulWidget {
  final Tarea tarea;

  TareaDetalle({Key key, @required this.tarea}) : super(key: key);
  TareaDetalleState createState() => new TareaDetalleState();
}

class TareaDetalleState extends State<TareaDetalle>
    with TickerProviderStateMixin {
  int _angle = 90;
  bool _isRotated = true;

  AnimationController _controller;
  Animation<double> _animation0;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;
  Animation<double> _animation4;
  ScrollController _scroll = ScrollController();

  double duration = 50;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> scrollToEndList() async {
    refreshKey.currentState.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
//      _controller = AnimationController(
//        vsync: this,
//        duration: Duration(seconds: 3),
//
//      );

      Timer(
          Duration(milliseconds: 500),
          () =>
//          _scroll.hasClients ? _scroll.jumpTo(_scroll.position.maxScrollExtent) :
//      _scroll.jumpTo(0.0));
              _scroll.jumpTo(_scroll.position.maxScrollExtent));
    });

    return null;
  }

  @override
  void initState() {
    scrollToEndList();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation0 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.00, 0.20, curve: Curves.linear),
    );
    _animation1 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.10, 0.30, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.20, 0.40, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.30, 0.50, curve: Curves.linear),
    );
    _animation4 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.40, 0.60, curve: Curves.linear),
    );

    _controller.reverse();
    super.initState();
  }

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    final String uri =
        'https://rsuambiental.com.ar/girsu-manager/restapi/v1/notificaciones?id_tarea=' +
            widget.tarea.idTarea.toString();

    Future<List<Notificacion>> _fetchNotificaciones() async {
      debugPrint('API: $uri');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Notificacion> notificaciones = items.map<Notificacion>((json) {
          return Notificacion.fromJson(json);
        }).toList();
        return notificaciones;
      } else {
        throw Exception('Error al obtener las notificaciones');
      }
    }
/*
    Completer<GoogleMapController> _controller = Completer();

    const LatLng _center = const LatLng(-34.584092, -58.437427);

    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }
    final Set<Marker> _markers = {};
    LatLng _lastMapPosition = _center;

    void _onAddMarkerButtonPressed(String tarea, String domicilio) {
      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: tarea,// widget.tarea.descripcion,
            snippet: domicilio,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
    _onAddMarkerButtonPressed("algo","algo2");

*/

    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: .9,
          title: Text(
            'Detalle de la Tarea',
            style: TextStyle(color: Colors.white),
          ),
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
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: new Stack(children: <Widget>[
          Container(
            color: Color(0xFFf8f9fa),
          ),

          FutureBuilder<List<Notificacion>>(
            future: _fetchNotificaciones(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return Column(children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                      height: 130.0, child: TareaHeader(tarea: widget.tarea)),
                  Container(
                    height: 35.0,
                    child: Bubble(
                      margin: BubbleEdges.fromLTRB(4, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      stick: true,
                      color: Colors.green,
                      padding: BubbleEdges.all(5),
                      radius: Radius.circular(5.0),
                      child: Text('@' + widget.tarea.descripcion,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffffffff))),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 120.0),
                      child: Card(
                          elevation: 10.0,
                          child: Container(
                              padding: new EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 10.0,
                                  left: 10.0),
                              constraints: BoxConstraints(),
                              child: ListTile(
                                title: Text(
                                  widget.tarea.denominacion,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(widget.tarea.domicilio,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    )),
                                leading: new CircularPercentIndicator(
                                  radius: 50.0,
                                  lineWidth: 5.0,
                                  animation: true,
                                  animationDuration: 2000,
                                  percent: widget.tarea.avance / 100,
                                  progressColor: Color(int.parse(
                                          widget.tarea.color.substring(1, 7),
                                          radix: 16) +
                                      0xFF000000),
                                  center: new Text(
                                    widget.tarea.avance.toString() + '%',
                                    style: new TextStyle(fontSize: 12),
                                  ),
                                ),
                              )))),
                ]),
                Expanded(
                  child: ListView(
                    children: snapshot.data
                        .map((Notificacion) => InkWell(
                              onTap: () {
                                print(Notificacion.tipo.toString());
                              },
                              /*onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) {
                                    return TareaDetalle(tarea: Tarea);
                                  },
                                ),
                              );
                            },*/
                              child: Bubble(
                                alignment: Alignment.center,
                                color: Notificacion.idAutor.toString() ==
                                        globals.loggedUser.idUsuario.toString()
                                    ? Color(0xFFE0E3E3)
                                    : Color(0xFFffdcdc),
                                elevation: 0 * px,
                                radius: Radius.circular(10.0),
                                margin: BubbleEdges.only(
                                    top: 4.0,
                                    right: 5.0,
                                    left: 5.0,
                                    bottom: 4.0),
                                nip: Notificacion.idAutor.toString() ==
                                        globals.loggedUser.idUsuario.toString()
                                    ? BubbleNip.rightTop
                                    : BubbleNip.leftTop,
                                child: ListTile(
                                  title: Notificacion.tipo == 'Imagen'
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 5.0),
                                          //width: MediaQuery.of(context).size.width - 10.0,

                                          height: 150.0,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Image.network(
                                              Notificacion.estado,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ))
                                      : Text(Notificacion.estado),
                                  subtitle: Text(Notificacion.fechaHora +
                                      ' - ' +
                                      (Notificacion.idAutor.toString() ==
                                              globals.loggedUser.idUsuario
                                                  .toString()
                                          ? "Tu"
                                          : Notificacion.autor)),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://rsuambiental.com.ar/girsu-manager/avatar.php?idusuario=' +
                                            Notificacion.idAutor.toString()),
                                    backgroundColor: Colors.white,
                                    /*child: Text(Notificacion.tipo[0],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                      )),*/
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                    //reverse: true,
                    //shrinkWrap: true,
                    controller: _scroll,
                  ),
                ),
              ]);
            },
          ),

          /***********************************************************************/

/*
            ]
            ),
            )
            ]
            ),
*/
          /*************************************************************************/

          new Positioned(
            bottom: 0.0,
            right: 0.0,
            child: ScaleTransition(
              scale: _animation0,
              alignment: FractionalOffset.bottomRight,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration:
                    BoxDecoration(color: new Color.fromRGBO(0, 0, 0, 0.8)),
              ),
            ),
          ),

          new Positioned(
              bottom: 200.0,
              right: 24.0,
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new ScaleTransition(
                      scale: _animation3,
                      alignment: FractionalOffset.center,
                      child: new Container(
                        margin: new EdgeInsets.only(right: 16.0),
                        child: new Text(
                          'Comentar algo',
                          style: new TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    new ScaleTransition(
                      scale: _animation3,
                      alignment: FractionalOffset.center,
                      child: new Material(
                          color: new Color(0xFF9E9E9E),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child: new GestureDetector(
                            child: new Container(
                                width: 40.0,
                                height: 40.0,
                                child: new InkWell(
                                  onTap: () {
                                    _rotate();

                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) {
                                          return new TextNotificationScreen(
                                              tarea: widget.tarea);
                                        },
                                      ),
                                    );
                                  },
                                  child: new Center(
                                    child: new Icon(
                                      Icons.comment,
                                      color: new Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )),
                          )),
                    ),
                  ],
                ),
              )),

          new Positioned(
              bottom: 144.0,
              right: 24.0,
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new ScaleTransition(
                      scale: _animation2,
                      alignment: FractionalOffset.center,
                      child: new Container(
                        margin: new EdgeInsets.only(right: 16.0),
                        child: new Text(
                          'Enviar una Foto',
                          style: new TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    new ScaleTransition(
                      scale: _animation2,
                      alignment: FractionalOffset.center,
                      child: new Material(
                          color: new Color(0xFF00BFA5),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child: new GestureDetector(
                            child: new Container(
                                width: 40.0,
                                height: 40.0,
                                child: new InkWell(
                                  onTap: () {
                                    _rotate();
                                    // ImageNotificationScreen()

                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) {
                                          return UploadImageDemo(
                                              tarea: widget.tarea);
                                        },
                                      ),
                                    );
                                  },
                                  child: new Center(
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: new Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )),
                          )),
                    ),
                  ],
                ),
              )),
          new Positioned(
              bottom: 88.0,
              right: 24.0,
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new ScaleTransition(
                      scale: _animation1,
                      alignment: FractionalOffset.center,
                      child: new Container(
                        margin: new EdgeInsets.only(right: 16.0),
                        child: new Text(
                          'Adjuntar Archivo',
                          style: new TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    new ScaleTransition(
                      scale: _animation1,
                      alignment: FractionalOffset.center,
                      child: new Material(
                          color: new Color(0xFFFFBC5A),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child: new GestureDetector(
                            child: new Container(
                                width: 40.0,
                                height: 40.0,
                                child: new InkWell(
                                  onTap: () {
                                    _rotate();
                                    if (_angle == 45.0) {
                                      print("foo3");
                                    }
                                  },
                                  child: new Center(
                                    child: new Icon(
                                      Icons.link,
                                      color: new Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )),
                          )),
                    ),
                  ],
                ),
              )),
//////////////////////////////////////////////////////////////////////////////

          new Positioned(
              bottom: 260.0,
              right: 24.0,
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new ScaleTransition(
                      scale: _animation4,
                      alignment: FractionalOffset.center,
                      child: new Container(
                        margin: new EdgeInsets.only(right: 16.0),
                        child: new Text(
                          'Informar Avance',
                          style: new TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    new ScaleTransition(
                      scale: _animation4,
                      alignment: FractionalOffset.center,
                      child: new Material(
                          color: new Color(0xFFE57373),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child: new GestureDetector(
                            child: new Container(
                                width: 40.0,
                                height: 40.0,
                                child: new InkWell(
                                  onTap: () {
                                    _rotate();
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) {
                                          return new StatusNotificationScreen(
                                              tarea: widget.tarea);
                                        },
                                      ),
                                    );
                                  },
                                  child: new Center(
                                    child: new Icon(
                                      Icons.new_releases,
                                      color: new Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )),
                          )),
                    ),
                  ],
                ),
              )),
          //////////////////////////////////////////////////////////////////////////////////
          new Positioned(
            bottom: 16.0,
            right: 16.0,
            child: new Material(
                color: Colors.green,
                type: MaterialType.circle,
                elevation: 6.0,
                child: new GestureDetector(
                  child: new Container(
                      width: 56.0,
                      height: 56.00,
                      child: new InkWell(
                        onTap: _rotate,
                        child: new Center(
                            child: new RotationTransition(
                          turns: new AlwaysStoppedAnimation(_angle / 360),
                          child: new Icon(
                            Icons.add,
                            color: new Color(0xFFFFFFFF),
                          ),
                        )),
                      )),
                )),
          ),
        ]));
  }
}

/******************** begin header tarea (googlemap) ********************/

class TareaHeader extends StatefulWidget {
  final Tarea tarea;
  TareaHeader({Key key, @required this.tarea}) : super(key: key);

  @override
  TareaHeaderState createState() => new TareaHeaderState();
}

class TareaHeaderState extends State<TareaHeader> {
  final double appBarHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    LatLng _center;
    LatLng _center2;
    final double desp = 0.0005;
    //const LatLng _center = const LatLng(-34.584092, -58.437427);

    print('LATITUD: ' +
        widget.tarea.latitud.toString() +
        '   LONGITUD: ' +
        widget.tarea.longitud.toString());
    if (widget.tarea.latitud != 0) {
      _center = LatLng(widget.tarea.latitud, widget.tarea.longitud);
      _center2 = LatLng((widget.tarea.latitud + desp), widget.tarea.longitud);
    } else {
      _center = LatLng(-34.584092, -58.437427);
      _center2 = LatLng((-34.584092 + desp), -58.437427);
    }
    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }

    final Set<Marker> _markers = {};
    LatLng _lastMapPosition = _center;

    void _onAddMarkerButtonPressed(String tarea, String domicilio) {
      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: tarea,
            snippet: domicilio,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }

    _onAddMarkerButtonPressed(widget.tarea.descripcion, widget.tarea.domicilio);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: Center(
        child: GoogleMap(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center2,
            zoom: 15.0,
          ),
        ),
      ),
    );
  }
}
/******************** end header tarea ********************/
