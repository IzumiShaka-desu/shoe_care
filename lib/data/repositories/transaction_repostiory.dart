import 'package:shoe_care/app/utils/exception.dart';
import 'package:shoe_care/app/utils/type_definition.dart';
import 'package:shoe_care/data/models/transaction_detail_model.dart';
import 'package:shoe_care/data/models/transaction_request.dart';

import '../datasources/transaction_datasources.dart';
import '../models/transaction_models.dart';

class TransactionRepository {
  TransactionRepository._internal();
  static final _singleton = TransactionRepository._internal();
  factory TransactionRepository() => _singleton;
  final TransactionDatasources _transactionDatasource =
      TransactionDatasources();

  Future<TransactionsOrFailure> getTransaction({int? idMitra}) async =>
      tryCatch<List<Transaction>>(
        () async {
          final response =
              await _transactionDatasource.getTransaction(idMitra: idMitra);
          return response;
        },
      );

  Future<TransactionOrFailure> createTransaction({
    required TransactionRequest request,
  }) async =>
      tryCatch<Transaction>(
        () async {
          final response = await _transactionDatasource.createTransaction(
            request: request,
          );
          return response;
        },
      );

  Future<TransactionOrFailure> updateTransactionStatus(
    int idTransaction, {
    String? status,
    String? paymentStatus,
  }) async =>
      tryCatch<Transaction>(
        () async {
          final response = await _transactionDatasource.updateTransactionStatus(
            idTransaction,
            status: status,
            paymentStatus: paymentStatus,
          );
          return response;
        },
      );

  Future<TransactionOrFailure> uploadPaymentProof(
    int idTransaction, {
    required String paymentProof,
  }) async =>
      tryCatch<Transaction>(
        () async {
          final response = await _transactionDatasource.uploadPaymentProof(
            idTransaction,
            paymentProof: paymentProof,
          );
          return response;
        },
      );

  Future<TransactionOrFailure> addReview(
    int idTransaction, {
    required String review,
    required double rating,
  }) async =>
      tryCatch<Transaction>(
        () async {
          final response = await _transactionDatasource.addReview(
            idTransaction,
            review: review,
            rating: rating,
          );
          return response;
        },
      );

  Future<TransactionDetailOrFailure> getTransactionById(
          int idTransaction) async =>
      tryCatch<TransactionDetail>(
        () async {
          final response =
              await _transactionDatasource.getTransactionDetail(idTransaction);
          return response;
        },
      );
}
