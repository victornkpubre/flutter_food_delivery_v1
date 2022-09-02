class SignInBody {
  final String password;
  final String phone;
  final String email;

  SignInBody({
    required this.password,
    required this.phone,
    required this.email
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["password"] = this.password;
    data["phone"] = this.phone;
    data["email"] = this.email;
    return data;
  }
}
