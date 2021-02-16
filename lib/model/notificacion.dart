class Notificacion {

  int idNotificacion;
  String tipo;
  String estado;
  int idAutor;
  String autor;
  String fechaHora;

  Notificacion({
    this.idNotificacion,
    this.tipo,
    this.estado,
    this.idAutor,
    this.autor,
    this.fechaHora
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
        idNotificacion: json['id_notificacion'],
        tipo: json['tipo'],
        estado: json['estado'],
        idAutor: json['id_autor'],
        autor: json['autor'],
        fechaHora: json['fechahora']
    );
  }
}