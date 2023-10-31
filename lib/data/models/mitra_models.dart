import 'package:shoe_care/data/models/mitra_service_model.dart';

import '../../app/constants.dart';

class Mitra {
  final int idMitra;
  final int idOwner;
  final String mitraName;
  final String address;
  final String serviceList;
  final String profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final List<MitraService> services;

  Mitra({
    required this.idMitra,
    required this.idOwner,
    required this.mitraName,
    required this.address,
    required this.serviceList,
    required this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
    this.rating = 0,
    required this.services,
  });

  String get imageUrl => "${Constants.baseUrlImages}/$profilePhoto";

  factory Mitra.fromJson(Map<String, dynamic> json) => Mitra(
        idMitra: json["id_mitra"],
        idOwner: json["id_owner"],
        mitraName: json["mitra_name"],
        address: json["address"],
        serviceList: json["service_list"],
        profilePhoto: json["profile_photo"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        rating: double.parse((json["rating"] ?? 0).toString()),
        services: json["service_items"] == null
            ? []
            : List<MitraService>.from(
                json["service_items"].map((x) => MitraService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_mitra": idMitra,
        "id_owner": idOwner,
        "mitra_name": mitraName,
        "address": address,
        "service_list": serviceList,
        "profile_photo": profilePhoto,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "rating": rating,
        "service_items": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}
