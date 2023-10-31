import 'package:shoe_care/data/models/delivery_type.dart';
import 'package:shoe_care/data/models/service_package.dart';

abstract class Constants {
  static const String baseUrl = 'http://192.168.43.154:3000';
  static const String baseUrlImages = 'http://192.168.43.154:3000/images/';
  static const String? dummyJWT = null;
  // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJraWtpMiIsImxldmVsIjoibWl0cmEiLCJpYXQiOjE2OTgzMTAxNjAsImV4cCI6MTY5ODMzODk2MH0.zpaUr4aEuxEo72H2NGc6ZiB0tMbclhjbWfExaHL0a4g";
  // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcm5hbWUiOiJraWtpMjIiLCJsZXZlbCI6Im1pdHJhIiwiaWF0IjoxNjk4MjgxNzczLCJleHAiOjE2OTgzMTA1NzN9.43kmH4YYgSNa5XqkcgcKcBwGI18jUpKpWUwxaCOvw_Y";
  static final List<ServicePackage> servicePackages = [
    ServicePackage(
      durationInDays: 1,
      additionalPrice: 5000,
      name: "Kilat 1 hari",
    ),
    ServicePackage(
      durationInDays: 2,
      additionalPrice: 3000,
      name: "Express 2 hari",
    ),
    ServicePackage(
      durationInDays: 3,
      additionalPrice: 0,
      name: "Reguler 3 hari",
    ),
  ];
  static const List<String> paymentMethods = ["Cash", "Transfer"];
  static final List<DeliveryType> deliveryMethods = [
    DeliveryType(
      name: "Ambil sendiri",
      price: 0,
    ),
    DeliveryType(
      name: "Delivery",
      price: 10000,
    ),
  ];
}
