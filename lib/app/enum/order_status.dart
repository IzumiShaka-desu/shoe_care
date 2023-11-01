import 'package:flutter/material.dart';

enum OrderStatus {
  preparing,
  processing,
  ready,
  delivered,
}

List<OrderStatus> orderStatuses = [
  OrderStatus.preparing,
  OrderStatus.processing,
  OrderStatus.ready,
  OrderStatus.delivered,
];
List<String> orderStatusesName = orderStatuses.map((e) => e.asName).toList();

int findIndexOrderStatus(OrderStatus status) {
  return orderStatuses.indexWhere((element) => element == status);
}

OrderStatus orderStatusFromStr(String status) {
  return orderStatuses.firstWhere((element) => element.name == status);
}

// OrderStatus to Color
extension OrderStatusX on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.preparing:
        return Colors.yellowAccent;
      case OrderStatus.processing:
        return Colors.blueAccent;
      case OrderStatus.ready:
        return Colors.orangeAccent;
      case OrderStatus.delivered:
        return Colors.greenAccent;
    }
  }

  int get index => orderStatuses.indexWhere((element) => element == this);
  String get asName {
    switch (this) {
      case OrderStatus.preparing:
        return "Di Proses";
      case OrderStatus.processing:
        return "Di Kerjakan";
      case OrderStatus.ready:
        return "Siap Diambil";
      case OrderStatus.delivered:
        return "Sudah Diambil";
    }
  }
}
