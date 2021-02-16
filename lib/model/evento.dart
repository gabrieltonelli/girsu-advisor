class Evento {
  int id_checkpoint;
  DateTime fechahora;
  int id_usuario;
  int id_estado;
  String image_url;
  String detalle;
  int id_empresa;
  Evento({
    this.id_checkpoint,
    this.fechahora,
    this.id_usuario,
    this.id_estado,
    this.image_url,
    this.detalle,
    this.id_empresa
  });
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
        id_checkpoint: json['id_checkpoint'],
        fechahora: json['fechahora'],
        id_usuario: json['id_usuario'],
        id_estado: json['estado'],
        image_url: json['image_url'],
        detalle: json['detalle'],
        id_empresa: json['id_empresa']
    );

  }
}