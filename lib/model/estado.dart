class Estado {

  int idEstado;
  String descripcion;
  double avance;
  String color;
  String tipo;

  Estado({
    this.idEstado,
    this.descripcion,
    this.avance,
    this.color,
    this.tipo
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
        idEstado: json['id_empresa_estado'],
        descripcion: json['descripcion'],
        avance: json['avance'].toDouble(),
        color: json['color'],
        tipo: json['tipo']
    );
  }
}