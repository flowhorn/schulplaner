class Teacher {
  String teacherid, name, tel, email;

  Teacher({this.teacherid, this.name, this.tel, this.email});

  Teacher.fromData(dynamic data) {
    teacherid = data['teacherid'];
    name = data['name'];
    tel = data['tel'];
    email = data['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherid': teacherid,
      'name': name,
      'tel': tel,
      'email': email,
    };
  }

  Map<String, dynamic> toPrimitiveJson() {
    return {
      'id': teacherid,
      'name': name,
      'tel': tel,
      'email': email,
    };
  }

  bool validate() {
    if (teacherid == null) return false;
    if (name == null || name == '') return false;
    return true;
  }
}
