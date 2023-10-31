import 'package:shoe_care/app/constants.dart';
import 'package:shoe_care/data/models/review_model.dart';
import 'package:shoe_care/data/models/service_package.dart';

class TransactionDetail {
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
  final List<ItemDetail> items;
  final Review? review;
  String get paymentProofUrl => "${Constants.baseUrlImages}/$paymentProof";
  TransactionDetail({
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
    required this.items,
    this.review,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) =>
      TransactionDetail(
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
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        review: json["review"] == null ? null : Review.fromJson(json["review"]),
        items: List<ItemDetail>.from(
            json["items"].map((x) => ItemDetail.fromJson(x))),
      );

  int get subtotal =>
      items.fold(0, (previousValue, element) => previousValue + element.price);
  ServicePackage get servicePackage {
    final durationInDays = createdAt.difference(estimatedFinishDate).inDays;
    return Constants.servicePackages.firstWhere(
        (element) => element.durationInDays == durationInDays,
        orElse: () => Constants.servicePackages.first);
  }

  int get additionalPrice {
    // total price - subtotal - delivery fee
    return totalPrice - subtotal - deliveryFee;
  }

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
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ItemDetail {
  final int idTransactionItem;
  final int idTransaction;
  final int idItems;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int idMitra;
  final String serviceName;
  final int price;
  final String serviceType;

  ItemDetail({
    required this.idTransactionItem,
    required this.idTransaction,
    required this.idItems,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.idMitra,
    required this.serviceName,
    required this.price,
    required this.serviceType,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        idTransactionItem: json["id_transaction_item"],
        idTransaction: json["id_transaction"],
        idItems: json["id_items"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        idMitra: json["id_mitra"],
        serviceName: json["service_name"],
        price: json["price"],
        serviceType: json["service_type"],
      );

  Map<String, dynamic> toJson() => {
        "id_transaction_item": idTransactionItem,
        "id_transaction": idTransaction,
        "id_items": idItems,
        "quantity": quantity,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id_mitra": idMitra,
        "service_name": serviceName,
        "price": price,
        "service_type": serviceType,
      };
}
