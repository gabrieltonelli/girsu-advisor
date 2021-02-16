class Checkpoint {
  int id_checkpoint;
  String descripcion;
  int id_recorrido;
  String ubicacion;
  int estado;
  double lat;
  double lng;
  int id_empresa;
  Checkpoint({
    this.id_checkpoint,
    this.descripcion,
    this.id_recorrido,
    this.ubicacion,
    this.estado,
    this.lat,
    this.lng,
    this.id_empresa
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id_checkpoint: json['id_checkpoint'],
      descripcion: json['descripcion'],
      id_recorrido: json['id_recorrido'],
      ubicacion: json['ubicacion'],
      estado: json['estado'],
      lat: json['lat'],
      lng: json['lng'],
      id_empresa: json['id_empresa']
    );
  }
}