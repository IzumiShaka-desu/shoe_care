import 'package:dio/dio.dart';
import 'package:shoe_care/app/services/base_client.dart';
import 'package:shoe_care/data/models/transaction_detail_model.dart';

import '../models/transaction_models.dart';
import '../models/transaction_request.dart';

class TransactionDatasources extends BaseClient {
  TransactionDatasources._internal();
  static final _singleton = TransactionDatasources._internal();
  factory TransactionDatasources() => _singleton;

  Future<List<Transaction>> getTransaction({int? idMitra}) async => tryRequest(
        () async {
          final path =
              idMitra == null ? "/transaction" : "/transaction/mitra/$idMitra";
          final response = await get(path);
          final data = response.data as List<dynamic>;
          return data.map((e) => Transaction.fromJson(e)).toList();
        },
      );
  Future<Transaction> createTransaction({
    required TransactionRequest request,
  }) async =>
      tryRequest(
        () async {
          final response = await post(
            "/transaction",
            data: request.toJson(),
          );
          return Transaction.fromJson(response.data);
        },
      );
  Future<Transaction> updateTransactionStatus(
    int idTransaction, {
    String? status,
    String? paymentStatus,
  }) async =>
      tryRequest(
        () async {
          final data = <String, dynamic>{
            "status": status,
            "payment_status": paymentStatus,
          };
          final response = await put(
            "/transaction/$idTransaction",
            data: data,
          );
          return Transaction.fromJson(response.data);
        },
      );
  Future<Transaction> uploadPaymentProof(
    int idTransaction, {
    required String paymentProof,
  }) async =>
      tryRequest(
        () async {
          final data = FormData.fromMap({
            "payment_proof": await MultipartFile.fromFile(paymentProof),
          });
          final response = await post(
            "/transaction/$idTransaction/payment-proof",
            data: data,
          );
          return Transaction.fromJson(response.data);
        },
      );
  Future<Transaction> addReview(
    int idTransaction, {
    required String review,
    required double rating,
  }) async =>
      tryRequest(
        () async {
          final data = <String, dynamic>{
            "review": review,
            "comment": rating,
          };
          final response = await post(
            "/transaction/$idTransaction/review",
            data: data,
          );
          return Transaction.fromJson(response.data);
        },
      );
  Future<TransactionDetail> getTransactionDetail(int idTransaction) async =>
      tryRequest(
        () async {
          final response = await get("/transaction/$idTransaction");
          return TransactionDetail.fromJson(response.data);
        },
      );
}
