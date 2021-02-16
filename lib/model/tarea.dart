class Tarea {

  int idTarea;
  String descripcion;
  String domicilio;
  double latitud;
  double longitud;
  //DateTime fechaHoraIni;
  int idCliente;
  String razonSocial;
  int idObjetivo;
  String denominacion;
  String estado;
  double avance;
  String color;
  int idEmpresa;
  String empresa;

  Tarea({
    this.idTarea,
    this.descripcion,
    this.domicilio,
    this.latitud,
    this.longitud,
    //this.fechaHoraIni,
    this.idCliente,
    this.razonSocial,
    this.idObjetivo,
    this.denominacion,
    this.estado,
    this.avance,
    this.color,
    this.idEmpresa,
    this.empresa
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      idTarea: json['id_tarea'],
      descripcion: json['descripcion'],
      domicilio: json['domicilio'],
      latitud: json['latitud'].toDouble(),
      longitud: json['longitud'].toDouble(),
      //fechaHoraIni: json['fechahora_ini'],
      idCliente: json['id_cliente'],
      razonSocial: json['razon_social'],
      idObjetivo: json['id_objetivo'],
      denominacion: json['denominacion'],
      estado: json['estado'],
      avance: json['avance'].toDouble(),
      color: json['color'],
      idEmpresa: json['id_empresa'],
      empresa: json['empresa']
    );
  }
}