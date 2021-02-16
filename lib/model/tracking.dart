class Tracking {
  int id_tracking;
  int id_usuario;
  int idCliente;
  double lat;
  double lng;
  Tracking({
    this.id_tracking,
    this.id_usuario,
    this.idCliente,
    this.lat,
    this.lng
  });
  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      id_tracking: json['id_tracking'],
      id_usuario: json['id_usuario'],
      idCliente: json['idCliente'],
      lat: json['lat'],
      lng: json['lng']
    );
  }
}