class Usuario {
  String login;
  String nome;
  String email;
  String token;

  List<String> roles;

  //Lista de inicializacao
  Usuario.fromJson(Map<String, dynamic> map)
      : nome = map["nome"],
        email = map["email"],
        login = map["login"],
        token = map["token"],
        roles = map["roles"] != null
            ? map["roles"].map<String>((role) => role.toString()).toList()
            : null;
  //roles = getRoles(map);

  @override
  String toString() {
    return "Usuario: login: ${login} - email: ${email} - Nome: ${nome} - token: ${token} - roles: ${roles}";
  }

  static getRoles(Map<String, dynamic> map) {
    List list = map["roles"];
//    List<String> roles = [];
//    for (String role in list) {
//      roles.add(role);
//    }

    List<String> roles = list.map<String>((role) => role.toString()).toList();

    return roles;
  }
}
