class TransactionRequest {
  final int idMitra;
  final DateTime estimatedFinishDate;
  final String serviceType;
  final int deliveryFee;
  final int totalPrice;
  final String paymentMethod;
  final String? notes;
  final List<Item> items;

  TransactionRequest({
    required this.idMitra,
    required this.estimatedFinishDate,
    required this.serviceType,
    required this.deliveryFee,
    required this.totalPrice,
    required this.paymentMethod,
    required this.items,
    this.notes,
  });

  TransactionRequest.initial()
      : idMitra = 0,
        estimatedFinishDate = DateTime.now(),
        serviceType = "",
        deliveryFee = 0,
        totalPrice = 0,
        paymentMethod = "",
        items = [],
        notes = "";

  bool get isValid {
    return idMitra != 0 &&
        (DateTime.now()
                    .difference(
                      estimatedFinishDate,
                    )
                    .inMinutes <
                60 &&
            DateTime.now().compareTo(
                  estimatedFinishDate,
                ) <
                1) &&
        serviceType.isNotEmpty &&
        totalPrice != 0 &&
        paymentMethod.isNotEmpty &&
        items.isNotEmpty;
  }

  TransactionRequest copyWith({
    int? idMitra,
    DateTime? estimatedFinishDate,
    String? serviceType,
    int? deliveryFee,
    int? totalPrice,
    String? paymentMethod,
    String? notes,
    List<Item>? items,
  }) =>
      TransactionRequest(
        idMitra: idMitra ?? this.idMitra,
        estimatedFinishDate: estimatedFinishDate ?? this.estimatedFinishDate,
        serviceType: serviceType ?? this.serviceType,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        totalPrice: totalPrice ?? this.totalPrice,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        notes: notes ?? this.notes,
        items: items ?? this.items,
      );

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      TransactionRequest(
        idMitra: json["id_mitra"],
        estimatedFinishDate: DateTime.parse(json["estimated_finish_date"]),
        serviceType: json["service_type"],
        deliveryFee: json["delivery_fee"],
        totalPrice: json["total_price"],
        paymentMethod: json["payment_method"],
        notes: json["notes"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_mitra": idMitra,
        "estimated_finish_date": estimatedFinishDate.toIso8601String(),
        "service_type": serviceType,
        "delivery_fee": deliveryFee,
        "total_price": totalPrice,
        "payment_method": paymentMethod,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        if (notes != null) "notes": notes,
      };
}

class Item {
  final int idItems;
  final int quantity;

  Item({
    required this.idItems,
    required this.quantity,
  });

  Item copyWith({
    int? idItems,
    int? quantity,
  }) =>
      Item(
        idItems: idItems ?? this.idItems,
        quantity: quantity ?? this.quantity,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        idItems: json["id_items"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id_items": idItems,
        "quantity": quantity,
      };
}
