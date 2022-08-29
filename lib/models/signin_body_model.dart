class SignInBody {
  final String password;
  final String phone;

  SignInBody({
    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["password"] = this.password;
    data["phone"] = this.phone;
    return data;
  }
}
