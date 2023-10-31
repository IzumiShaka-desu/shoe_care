class MitraRekening {
  final int idRekening;
  final int idMitra;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final DateTime createdAt;
  final DateTime updatedAt;

  MitraRekening({
    required this.idRekening,
    required this.idMitra,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MitraRekening.fromJson(Map<String, dynamic> json) => MitraRekening(
        idRekening: json["id_rekening"],
        idMitra: int.parse(json["id_mitra"].toString()),
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_rekening": idRekening,
        "id_mitra": idMitra,
        "bank_name": bankName,
        "account_number": accountNumber,
        "account_name": accountName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
