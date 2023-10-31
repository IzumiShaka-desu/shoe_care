import 'package:shoe_care/app/utils/type_definition.dart';

import '../../app/enum/service_type.dart';
import '../../app/utils/exception.dart';
import '../datasources/mitra_datasources.dart';
import '../models/mitra_models.dart';
import '../models/mitra_rekening_mode.dart';
import '../models/mitra_service_model.dart';

class MitraRepository {
  MitraRepository._internal();
  static final _singleton = MitraRepository._internal();
  factory MitraRepository() => _singleton;
  final MitraDatasources _mitraDatasource = MitraDatasources();

  Future<ListMitraOrFailure> getMitra(ServiceType type) async =>
      tryCatch<List<Mitra>>(
        () async {
          final response = await _mitraDatasource.getMitra(type);
          return response;
        },
      );

  Future<MitraOrFailure> getMyMitra() async => tryCatch<Mitra>(
        () async {
          final response = await _mitraDatasource.getMyMitra();
          return response;
        },
      );

  Future<MitraOrFailure> getMitraByIdOwner(int idOwner) async =>
      tryCatch<Mitra>(
        () async {
          final response = await _mitraDatasource.getMitraByIdOwner(idOwner);
          return response;
        },
      );

  Future<MitraOrFailure> createMitra({
    required String name,
    required String address,
    required String servisList,
    required String photo,
  }) async =>
      tryCatch<Mitra>(
        () async {
          final response = await _mitraDatasource.createMitraProfile(
            mitraName: name,
            address: address,
            serviceList: servisList,
            profilePhoto: photo,
          );
          return response;
        },
      );

  Future<MitraOrFailure> updateMitra({
    required int idMitra,
    String? name,
    String? address,
    String? servisList,
    String? description,
    String? photo,
  }) async =>
      tryCatch<Mitra>(
        () async {
          final response = await _mitraDatasource.updateMitraProfile(
            idMitra,
            mitraName: name,
            address: address,
            serviceList: servisList,
            profilePhoto: photo,
          );
          return response;
        },
      );

  Future<MitraRekeningListOrFailure> getMitraRekening(int idMitra) async =>
      tryCatch<List<MitraRekening>>(
        () async {
          final response = await _mitraDatasource.getMitraRekening(idMitra);
          return response;
        },
      );

  Future<MitraRekeningOrFailure> createMitraRekening({
    required int idMitra,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async =>
      tryCatch<MitraRekening>(
        () async {
          final response = await _mitraDatasource.createMitraRekening(
            idMitra,
            bankName: bankName,
            accountNumber: accountNumber,
            accountName: accountName,
          );
          return response;
        },
      );

  Future<MitraRekeningOrFailure> updateMitraRekening({
    required int idRekening,
    required int idMitra,
    String? bankName,
    String? accountNumber,
    String? accountName,
  }) async =>
      tryCatch<MitraRekening>(
        () async {
          final response = await _mitraDatasource.updateMitraRekening(
            idMitra,
            idRekening,
            bankName: bankName,
            accountNumber: accountNumber,
            accountName: accountName,
          );
          return response;
        },
      );

  Future<StringOrFailure> deleteMitraRekening({
    required int idRekening,
    required int idMitra,
  }) async =>
      tryCatch<String>(
        () async {
          final response = await _mitraDatasource.deleteMitraRekening(
            idMitra,
            idRekening,
          );
          return "Berhasil menghapus rekening";
        },
      );

  Future<MitraServiceListOrFailure> getMitraService(int idMitra) async =>
      tryCatch<List<MitraService>>(
        () async {
          final response = await _mitraDatasource.getMitraService(idMitra);
          return response;
        },
      );
  Future<MitraServiceOrFailure> createMitraService({
    required int idMitra,
    required String serviceName,
    required int price,
    required ServiceType type,
  }) async =>
      tryCatch<MitraService>(
        () async {
          final response = await _mitraDatasource.createMitraService(
            idMitra,
            serviceName: serviceName,
            price: price,
            serviceType: type,
          );
          return response;
        },
      );

  Future<MitraServiceOrFailure> updateMitraService({
    required int idMitra,
    required int idService,
    required String serviceName,
    required int price,
    required ServiceType type,
  }) async =>
      tryCatch<MitraService>(
        () async {
          final response = await _mitraDatasource.updateMitraService(
            idMitra,
            idService,
            serviceName: serviceName,
            price: price,
            serviceType: type,
          );
          return response;
        },
      );

  Future<StringOrFailure> deleteMitraService({
    required int idMitra,
    required int idService,
  }) async =>
      tryCatch<String>(
        () async {
          final response = await _mitraDatasource.deleteMitraService(
            idMitra,
            idService,
          );
          return "Berhasil menghapus layanan";
        },
      );
}
