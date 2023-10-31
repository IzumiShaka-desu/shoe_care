import 'package:shoe_care/app/constants.dart';

class UserProfile {
  final int idUser;
  final String level;
  final String email;
  final String phone;
  final String name;
  final String address;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get photoProfileUrl => Constants.baseUrlImages + profilePhoto!;

  UserProfile({
    required this.idUser,
    required this.level,
    required this.email,
    required this.phone,
    required this.name,
    required this.address,
    required this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        idUser: json["id_user"],
        level: json["level"],
        email: json["email"],
        phone: json["phone"],
        name: json["name"],
        address: json["address"],
        profilePhoto: json["profile-photo"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "level": level,
        "email": email,
        "phone": phone,
        "name": name,
        "address": address,
        "profile-photo": profilePhoto,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
