class User {
  String? nama;
  String? email;
  String? password;
  String? otpCode;

  User({this.nama, this.email, this.password, this.otpCode});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      otpCode: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'otp': otpCode,
    };
  }
}
