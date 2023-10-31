import 'package:dio/dio.dart';
import 'package:shoe_care/app/enum/service_type.dart';
import 'package:shoe_care/app/services/base_client.dart';
import 'package:shoe_care/data/models/mitra_models.dart';
import 'package:shoe_care/data/models/mitra_rekening_mode.dart';
import 'package:shoe_care/data/models/mitra_service_model.dart';

class MitraDatasources extends BaseClient {
  MitraDatasources._internal();
  static final _singleton = MitraDatasources._internal();
  factory MitraDatasources() => _singleton;

  Future<Mitra> createMitraProfile({
    required String mitraName,
    required String address,
    required String serviceList,
    required String profilePhoto,
  }) async =>
      tryRequest(
        () async {
          final data = FormData.fromMap({
            "name": mitraName,
            "address": address,
            "service_list": serviceList,
            "image": await MultipartFile.fromFile(profilePhoto),
          });
          final response = await post(
            "/mitra",
            data: data,
          );
          return Mitra.fromJson(response.data);
        },
      );

  Future<List<Mitra>> getMitra(ServiceType type) async => tryRequest(
        () async {
          final response = await get("/mitra", queryParameters: {
            "filterType": type.name,
          });
          final data = response.data as List<dynamic>;
          return data.map((e) => Mitra.fromJson(e)).toList();
        },
      );
  Future<Mitra> getMitraByIdOwner(int idOwner) async => tryRequest(
        () async {
          final response = await get("/mitra/$idOwner");
          return Mitra.fromJson(response.data);
        },
      );
  Future<Mitra> getMyMitra() async => tryRequest(
        () async {
          final response = await get("/mitra/my");
          return Mitra.fromJson(response.data);
        },
      );
  Future<Mitra> updateMitraProfile(
    int idMitra, {
    String? mitraName,
    String? address,
    String? serviceList,
    String? profilePhoto,
  }) async =>
      tryRequest(
        () async {
          final data = <String, dynamic>{
            "name": mitraName,
            "address": address,
            "service_list": serviceList,
          };
          if (profilePhoto != null) {
            data["image"] = await MultipartFile.fromFile(profilePhoto);
          }
          final response = await put(
            "/mitra/$idMitra",
            data: FormData.fromMap(data),
          );
          return Mitra.fromJson(response.data);
        },
      );

  Future<List<MitraRekening>> getMitraRekening(int idMitra) async => tryRequest(
        () async {
          final response = await get("/mitra/$idMitra/rekening");
          final data = response.data as List<dynamic>;
          return data.map((e) => MitraRekening.fromJson(e)).toList();
        },
      );
  Future<MitraRekening> createMitraRekening(
    int idMitra, {
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async =>
      tryRequest(
        () async {
          final response = await post(
            "/mitra/$idMitra/rekening",
            data: {
              "bank_name": bankName,
              "account_number": accountNumber,
              "account_name": accountName,
            },
          );
          return MitraRekening.fromJson(response.data);
        },
      );
  Future<MitraRekening> updateMitraRekening(
    int idMitra,
    int idRekening, {
    String? bankName,
    String? accountNumber,
    String? accountName,
  }) async =>
      tryRequest(
        () async {
          final data = <String, dynamic>{
            "bank_name": bankName,
            "account_number": accountNumber,
            "account_name": accountName,
          };
          final response = await put(
            "/mitra/$idMitra/rekening/$idRekening",
            data: data,
          );
          return MitraRekening.fromJson(response.data);
        },
      );
  Future<void> deleteMitraRekening(int idMitra, int idRekening) async =>
      tryRequest(
        () async {
          await delete("/mitra/$idMitra/rekening/$idRekening");
        },
      );
  Future<List<MitraService>> getMitraService(int idMitra) async => tryRequest(
        () async {
          final response = await get("/mitra/$idMitra/service");
          final data = response.data as List<dynamic>;
          return data.map((e) => MitraService.fromJson(e)).toList();
        },
      );
  Future<MitraService> createMitraService(
    int idMitra, {
    required String serviceName,
    required int price,
    required ServiceType serviceType,
  }) async =>
      tryRequest(
        () async {
          final data = {
            "service_name": serviceName,
            "price": price,
            "service_type": serviceTypeToString(serviceType),
          };
          final response = await post(
            "/mitra/$idMitra/service",
            data: data,
          );
          return MitraService.fromJson(response.data);
        },
      );
  Future<MitraService> updateMitraService(
    int idMitra,
    int idItems, {
    String? serviceName,
    int? price,
    ServiceType? serviceType,
  }) async =>
      tryRequest(
        () async {
          final data = <String, dynamic>{
            "service_name": serviceName,
            "price": price,
            if (serviceType != null)
              "service_type": serviceTypeToString(serviceType),
          };
          final response = await put(
            "/mitra/$idMitra/service/$idItems",
            data: data,
          );
          return MitraService.fromJson(response.data);
        },
      );
  Future<void> deleteMitraService(int idMitra, int idItems) async => tryRequest(
        () async {
          await delete("/mitra/$idMitra/service/$idItems");
        },
      );
}
