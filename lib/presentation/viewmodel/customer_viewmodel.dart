import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shoe_care/app/enum/service_type.dart';
import 'package:shoe_care/data/models/delivery_type.dart';
import 'package:shoe_care/data/models/mitra_models.dart';
import 'package:shoe_care/data/models/mitra_rekening_mode.dart';
import 'package:shoe_care/data/models/mitra_service_model.dart';
import 'package:shoe_care/data/models/service_package.dart';
import 'package:shoe_care/data/models/transaction_detail_model.dart';
import 'package:shoe_care/data/models/transaction_models.dart';
import 'package:shoe_care/data/models/transaction_request.dart';
import 'package:shoe_care/data/repositories/mitra_repository.dart';

import '../../app/utils/app_state.dart';
import '../../app/utils/failure.dart';
import '../../data/repositories/transaction_repostiory.dart';

class CustomerViewmodel extends ChangeNotifier {
  CustomerViewmodel._internal();
  static final _singleton = CustomerViewmodel._internal();
  factory CustomerViewmodel() => _singleton;

  final _mitrarepository = MitraRepository();
  final _transactionRepository = TransactionRepository();

  AppState<List<Mitra>> _mitraListState = AppState();
  AppState<List<Mitra>> get mitraListState => _mitraListState;
  List<MitraService> get mitraServiceList {
    if (_mitraListState.data == null) {
      return [];
    }
    try {
      return _mitraListState.data!
          .firstWhere(
              (element) => element.idMitra == _transactionRequest.idMitra)
          .services
          .where((element) =>
              element.serviceType == _transactionRequest.serviceType)
          .toList();
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<void> getMitraList(
    ServiceType type,
  ) async {
    _mitraListState = AppState.loading();
    notifyListeners();

    final response = await _mitrarepository.getMitra(type);
    _mitraListState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  TransactionRequest _transactionRequest = TransactionRequest.initial();
  TransactionRequest get transactionRequest => _transactionRequest;
  List<Item> get items => _transactionRequest.items;
  bool get quantityValid {
    print(items.isNotEmpty && items.every((element) => element.quantity > 0));
    return items.isNotEmpty && items.every((element) => element.quantity > 0);
  }

  int getInitialQuantity(int idItem) {
    final index = _transactionRequest.items
        .indexWhere((element) => element.idItems == idItem);
    if (index == -1) {
      return 0;
    }
    return _transactionRequest.items[index].quantity;
  }

  void resetRequest() {
    _transactionRequest = TransactionRequest.initial();
    notifyListeners();
  }

  void updateRequest({
    int? idMitra,
    DateTime? estimatedFinishDate,
    String? serviceType,
    int? deliveryFee,
    int? totalPrice,
    String? paymentMethod,
    String? notes,
  }) {
    _transactionRequest = _transactionRequest.copyWith(
      idMitra: idMitra,
      estimatedFinishDate: estimatedFinishDate,
      serviceType: serviceType,
      deliveryFee: deliveryFee,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod,
      notes: notes,
    );
    notifyListeners();
  }

  void setItemQuantity(int idItem, int quantity) {
    final index = _transactionRequest.items
        .indexWhere((element) => element.idItems == idItem);
    if (index == -1) {
      _transactionRequest.items.add(Item(idItems: idItem, quantity: quantity));
    } else {
      if (quantity < 1) {
        _transactionRequest.items.removeAt(index);
      } else {
        _transactionRequest.items[index] =
            _transactionRequest.items[index].copyWith(quantity: quantity);
      }
    }
    notifyListeners();
  }

  void setServicePackage(ServicePackage value) {
    int totalPrice = 0;
    for (final item in _transactionRequest.items) {
      totalPrice += item.quantity *
          (value.additionalPrice +
              mitraServiceList
                  .firstWhere((element) => element.idItems == item.idItems)
                  .price);
    }
    final estimatedFinishDate = DateTime.now().add(
      Duration(
        days: value.durationInDays,
      ),
    );
    _transactionRequest = _transactionRequest.copyWith(
      totalPrice: totalPrice,
      estimatedFinishDate: estimatedFinishDate,
    );
    notifyListeners();
  }

  void setDeliveryType(DeliveryType type) {
    _transactionRequest = _transactionRequest.copyWith(
      deliveryFee: type.price,
    );
    notifyListeners();
  }

  void setJenisPembayaran(String value) {
    _transactionRequest = _transactionRequest.copyWith(
      paymentMethod: value,
    );
    notifyListeners();
  }

  bool _isMakingTransaction = false;
  bool get isMakingTransaction => _isMakingTransaction;

  Future<void> makeTransaction({
    required void Function(String message) onError,
    required void Function(String message) onSuccess,
  }) async {
    if (_isMakingTransaction) return;
    if (!_transactionRequest.isValid) {
      onError("Data tidak valid");
      return;
    }
    _isMakingTransaction = true;
    notifyListeners();

    final response = await _transactionRepository.createTransaction(
      request: _transactionRequest,
    );
    _isMakingTransaction = false;
    notifyListeners();
    response.fold(
      (l) => onError(l.message),
      (r) async {
        await getTransactionList();
        onSuccess("Transaksi berhasil dibuat");
      },
    );
  }

  AppState<List<Transaction>> _transactionListState = AppState();
  AppState<List<Transaction>> get transactionListState => _transactionListState;
  Future<void> getTransactionList() async {
    if (_transactionListState.isLoading) return;
    _transactionListState = AppState.loading();
    notifyListeners();

    final response = await _transactionRepository.getTransaction();
    _transactionListState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  AppState<TransactionDetail> _transactionDetailState = AppState();
  AppState<TransactionDetail> get transactionDetailState =>
      _transactionDetailState;
  Future<void> getTransactionDetail(int idTransaction) async {
    if (_transactionDetailState.isLoading) return;
    _transactionDetailState = AppState.loading();
    notifyListeners();

    final response =
        await _transactionRepository.getTransactionById(idTransaction);
    _transactionDetailState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  Future<void> uploadPaymentProof(String imagePath) async {
    final response = await _transactionRepository.uploadPaymentProof(
      transactionDetailState.data!.idTransaction,
      paymentProof: imagePath,
    );
    response.fold(
      (l) => print(l.message),
      (r) {
        getTransactionDetail(transactionDetailState.data!.idTransaction);
      },
    );
    notifyListeners();
  }

  AppState<List<MitraRekening>> _mitraRekeningState = AppState();
  AppState<List<MitraRekening>> get mitraRekeningState => _mitraRekeningState;
  Future<void> getMitraRekening() async {
    if (_mitraRekeningState.isLoading) return;
    _mitraRekeningState = AppState.loading();
    notifyListeners();

    final response = await _mitrarepository.getMitraRekening(
      _transactionDetailState.data!.idMitra,
    );
    _mitraRekeningState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  Future<void> addReview(String comment, double rating,
      {required void Function() onSuccess,
      required void Function(Failure e) onError}) async {
    final results = await _transactionRepository.addReview(
        transactionDetailState.data!.idTransaction,
        review: comment,
        rating: rating);
    results.fold(
      (failure) {
        onError(failure);
      },
      (review) {
        onSuccess();
        getTransactionDetail(transactionDetailState.data!.idTransaction);
      },
    );
    notifyListeners();
  }
}
