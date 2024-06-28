class UserProfile {
  String nama;
  String email;
  String profileImage;
  String backgroundImage;

  UserProfile({
    required this.nama,
    required this.email,
    required this.profileImage,
    required this.backgroundImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nama: json['nama'],
      email: json['email'],
      profileImage: json['profileImage'],
      backgroundImage: json['backgroundImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'profileImage': profileImage,
      'backgroundImage': backgroundImage,
    };
  }
}
