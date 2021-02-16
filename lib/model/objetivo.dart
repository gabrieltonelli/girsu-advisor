class Objetivo {

  //int idObjetivo;
  //int idEmpresa;
  //int idCliente;
  String razonSocial;
  String denominacion;
  String descripcion;
  //DateTime fechaHoraIni;
  //DateTime fechaHoraFin;*/
  String estado;
  //double avance;

  Objetivo({
    //this.idObjetivo,
    //this.idEmpresa,
    //this.idCliente,
    this.razonSocial,
    this.denominacion,
    this.descripcion,
    //this.fechaHoraIni,
    //this.fechaHoraFin,
    this.estado,
    //this.avance
  });

  factory Objetivo.fromJson(Map<String, dynamic> json) {
    return Objetivo(
      //idObjetivo: json['id_objetivo'],
      //idEmpresa: json['id_empresa'],
      //idCliente: json['id_cliente'],
      razonSocial: json['razon_social'],
      denominacion: json['denominacion'],
      descripcion: json['descripcion'],
      //fechaHoraIni: json['fechahora_ini'],
      //fechaHoraFin: json['fechahora_fin'],
      estado: json['estado'],
      //avance: json['avance']
    );
  }
}