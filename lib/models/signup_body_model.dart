class SignUpBody {
  final String name;
  final String password;
  final String email;
  final String phone;

  SignUpBody(
      {required this.password,
      required this.email,
      required this.phone,
      required this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["f_name"] = this.name;
    data["phone"] = this.phone;
    data["email"] = this.email;
    data["password"] = this.password;
    return data;
  }

  @override
  String toString() {
    
    return toJson().toString();
  }


}
