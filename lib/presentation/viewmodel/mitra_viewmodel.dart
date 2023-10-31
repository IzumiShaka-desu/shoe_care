import 'package:flutter/material.dart';
import 'package:shoe_care/app/enum/service_type.dart';
import 'package:shoe_care/app/utils/app_state.dart';
import 'package:shoe_care/data/models/mitra_models.dart';
import 'package:shoe_care/data/models/mitra_service_model.dart';

import '../../data/models/mitra_rekening_mode.dart';
import '../../data/models/transaction_detail_model.dart';
import '../../data/models/transaction_models.dart';
import '../../data/repositories/mitra_repository.dart';
import '../../data/repositories/transaction_repostiory.dart';

class MitraViewmodel extends ChangeNotifier {
  MitraViewmodel._internal();
  static final _singleton = MitraViewmodel._internal();
  factory MitraViewmodel() => _singleton;

  final _mitraRepository = MitraRepository();
  final _transactionRepository = TransactionRepository();

  AppState<Mitra> _myMitraState = AppState();
  AppState<Mitra> get myMitraState => _myMitraState;

  Future<void> getMyMitra() async {
    _myMitraState = AppState.loading();
    notifyListeners();

    final response = await _mitraRepository.getMyMitra();
    _myMitraState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  bool isCreatingMitra = false;

  Future<void> createMitra({
    required String name,
    required String address,
    required String servisList,
    required String photo,
    Function(Mitra)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitra) return;

    isCreatingMitra = true;
    notifyListeners();

    final response = await _mitraRepository.createMitra(
      name: name,
      address: address,
      servisList: servisList,
      photo: photo,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) async {
        onSuccess?.call(r);
        await getMyMitra();
      },
    );
    isCreatingMitra = false;
    notifyListeners();
  }

  Future<void> updateMitra({
    required int idMitra,
    String? name,
    String? address,
    String? servisList,
    String? description,
    String? photo,
    ServiceType? type,
    Function(Mitra)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitra) return;

    isCreatingMitra = true;
    notifyListeners();

    final response = await _mitraRepository.updateMitra(
      idMitra: idMitra,
      name: name,
      address: address,
      servisList: servisList,
      description: description,
      photo: photo,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) async {
        onSuccess?.call(r);
        await getMyMitra();
      },
    );
    isCreatingMitra = false;
    notifyListeners();
  }

  AppState<List<MitraService>> _mitraServiceState = AppState();
  AppState<List<MitraService>> get mitraServiceState => _mitraServiceState;

  Future<void> getMitraService() async {
    _mitraServiceState = AppState.loading();
    notifyListeners();

    final response =
        await _mitraRepository.getMitraService(_myMitraState.data!.idMitra);
    _mitraServiceState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  bool isCreatingMitraService = false;

  Future<void> createMitraService({
    required String serviceName,
    required int price,
    required ServiceType serviceType,
    Function(MitraService)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitraService) return;

    isCreatingMitraService = true;
    notifyListeners();

    final response = await _mitraRepository.createMitraService(
      idMitra: _myMitraState.data!.idMitra,
      serviceName: serviceName,
      price: price,
      type: serviceType,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getMitraService();
      },
    );
    isCreatingMitraService = false;
    notifyListeners();
  }

  Future<void> updateMitraService({
    required int idService,
    required String serviceName,
    required int price,
    required ServiceType serviceType,
    Function(MitraService)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitraService) return;

    isCreatingMitraService = true;
    notifyListeners();

    final response = await _mitraRepository.updateMitraService(
      idMitra: _myMitraState.data!.idMitra,
      idService: idService,
      serviceName: serviceName,
      price: price,
      type: serviceType,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getMitraService();
      },
    );
    isCreatingMitraService = false;
    notifyListeners();
  }

  Future<void> deleteMitraService({
    required int idService,
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitraService) return;

    isCreatingMitraService = true;
    notifyListeners();

    final response = await _mitraRepository.deleteMitraService(
      idMitra: _myMitraState.data!.idMitra,
      idService: idService,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getMitraService();
      },
    );
    isCreatingMitraService = false;
    notifyListeners();
  }

  AppState<List<MitraRekening>> _mitraRekeningState = AppState();
  AppState<List<MitraRekening>> get mitraRekeningState => _mitraRekeningState;

  Future<void> getMitraRekening() async {
    _mitraRekeningState = AppState.loading();
    notifyListeners();

    final response =
        await _mitraRepository.getMitraRekening(_myMitraState.data!.idMitra);
    _mitraRekeningState = response.fold(
      (l) => AppState.error(l.message),
      (r) => AppState.completed(data: r),
    );
    notifyListeners();
  }

  bool isCreatingMitraRekening = false;

  Future<void> createMitraRekening({
    required String bankName,
    required String accountNumber,
    required String accountName,
    Function(MitraRekening)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitraRekening) return;

    isCreatingMitraRekening = true;
    notifyListeners();

    final response = await _mitraRepository.createMitraRekening(
      idMitra: _myMitraState.data!.idMitra,
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getMitraRekening();
      },
    );
    isCreatingMitraRekening = false;
    notifyListeners();
  }

  Future<void> updateMitraRekening({
    required int idRekening,
    required String bankName,
    required String accountNumber,
    required String accountName,
    Function(MitraRekening)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitraRekening) return;

    isCreatingMitraRekening = true;
    notifyListeners();

    final response = await _mitraRepository.updateMitraRekening(
      idRekening: idRekening,
      idMitra: _myMitraState.data!.idMitra,
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getMitraRekening();
      },
    );
    isCreatingMitraRekening = false;
    notifyListeners();
  }

  Future<void> deleteMitraRekening({
    required int idRekening,
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    if (isCreatingMitraRekening) return;

    isCreatingMitraRekening = true;
    notifyListeners();

    final response = await _mitraRepository.deleteMitraRekening(
      idMitra: _myMitraState.data!.idMitra,
      idRekening: idRekening,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getMitraRekening();
      },
    );
    isCreatingMitraRekening = false;
    notifyListeners();
  }

  AppState<List<Transaction>> _transactionListState = AppState();
  AppState<List<Transaction>> get transactionListState => _transactionListState;
  Future<void> getTransactionList() async {
    if (_transactionListState.isLoading) return;
    _transactionListState = AppState.loading();
    notifyListeners();

    final response = await _transactionRepository.getTransaction(
      idMitra: _myMitraState.data!.idMitra,
    );
    _transactionListState = response.fold(
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
      (r) {
        print(r);
        return AppState.completed(data: r);
      },
    );

    notifyListeners();
  }

  Future<void> updateTransactionStatus({
    required int idTransaction,
    String? status,
    String? paymentStatus,
    Function(Transaction)? onSuccess,
    Function(String)? onError,
  }) async {
    final response = await _transactionRepository.updateTransactionStatus(
      idTransaction,
      status: status,
      paymentStatus: paymentStatus,
    );
    response.fold(
      (l) {
        onError?.call(l.message);
      },
      (r) {
        onSuccess?.call(r);
        getTransactionDetail(
          transactionDetailState.data!.idTransaction,
        );
      },
    );
  }
}
