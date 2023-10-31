class Transaction {
  final int idTransaction;
  final int idMitra;
  final int idUser;
  final DateTime estimatedFinishDate;
  final String serviceType;
  final String status;
  final int deliveryFee;
  final int totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final String? paymentProof;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  Transaction({
    required this.idTransaction,
    required this.idMitra,
    required this.idUser,
    required this.estimatedFinishDate,
    required this.serviceType,
    required this.status,
    required this.deliveryFee,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentProof,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        idTransaction: json["id_transaction"],
        idMitra: json["id_mitra"],
        idUser: json["id_user"],
        estimatedFinishDate: DateTime.parse(json["estimated_finish_date"]),
        serviceType: json["service_type"],
        status: json["status"],
        deliveryFee: json["delivery_fee"],
        totalPrice: json["total_price"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        paymentProof: json["payment_proof"],
        notes: json["notes"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_transaction": idTransaction,
        "id_mitra": idMitra,
        "id_user": idUser,
        "estimated_finish_date": estimatedFinishDate.toIso8601String(),
        "service_type": serviceType,
        "status": status,
        "delivery_fee": deliveryFee,
        "total_price": totalPrice,
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "payment_proof": paymentProof,
        "notes": notes,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
