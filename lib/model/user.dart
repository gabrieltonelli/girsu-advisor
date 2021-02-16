class User {
  int idUsuario;
  int idColaborador;
  int idCliente;
  int idEmpresa;
  String username;
  String name;
  String rol;
  String tipo;
  String avatar;
  double latitude;
  double longitude;

  User({
    this.idUsuario,
    this.idColaborador,
    this.idCliente,
    this.idEmpresa,
    this.username,
    this.name,
    this.rol,
    this.tipo,
    this.avatar,
    this.latitude,
    this.longitude
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        idUsuario: json['id_usuario'],
        idColaborador: json['id_colaborador'],
        idCliente: json['id_cliente'],
        idEmpresa: json['id_empresa'],
        username: json['username'],
        name: json['name'],
        rol: json['rol'],
        tipo: json['tipo'],
        avatar: json['avatar'],
    );
  }
}