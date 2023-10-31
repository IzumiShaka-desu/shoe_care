class MitraService {
  final int idItems;
  final int idMitra;
  final String serviceName;
  final int price;
  final String serviceType;
  final DateTime createdAt;
  final DateTime updatedAt;

  MitraService({
    required this.idItems,
    required this.idMitra,
    required this.serviceName,
    required this.price,
    required this.serviceType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MitraService.fromJson(Map<String, dynamic> json) => MitraService(
        idItems: json["id_items"],
        idMitra: int.parse(json["id_mitra"].toString()),
        serviceName: json["service_name"],
        price: json["price"],
        serviceType: json["service_type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_items": idItems,
        "id_mitra": idMitra,
        "service_name": serviceName,
        "price": price,
        "service_type": serviceType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
