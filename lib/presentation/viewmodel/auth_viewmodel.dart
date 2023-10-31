import 'package:flutter/material.dart';
import 'package:shoe_care/data/models/session_auth.dart';
import 'package:shoe_care/data/models/user_profile_model.dart';
import 'package:shoe_care/presentation/view/login_screen.dart';

import '../../app/enum/screen_status.dart';
import '../../app/utils/app_state.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthViewmodel._internal();
  static final _singleton = AuthViewmodel._internal();
  factory AuthViewmodel() {
    _singleton.loadSession();
    return _singleton;
  }

  final _authRepository = AuthRepository();

  AppStatus _appStatus = AppStatus.unauthenticated;
  AppStatus get appStatus => _appStatus;

  AppState<SessionAuth> _sessionState = AppState<SessionAuth>();
  AppState<SessionAuth> get sessionState => _sessionState;

  void loadSession() async {
    _sessionState = _sessionState.copyWith(
      screenState: ScreenStatus.loading,
    );
    notifyListeners();
    final result = await _authRepository.getSession();
    if (result != null) {
      _sessionState = _sessionState.copyWith(
        screenState: ScreenStatus.success,
        data: result,
      );
      _appStatus = AppStatus.authenticated;
    } else {
      _sessionState = _sessionState.copyWith(
        screenState: ScreenStatus.error,
        errorMessage: "Session not found",
      );
      _appStatus = AppStatus.unauthenticated;
    }
    notifyListeners();
  }

  void login({
    required String email,
    required String password,
    required LoginType loginType,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    _sessionState = _sessionState.copyWith(
      screenState: ScreenStatus.loading,
    );
    notifyListeners();
    final results =
        await _authRepository.login(email, password, loginType: loginType);
    results.fold(
      (failure) {
        onError(failure.message);
      },
      (token) {
        loadSession();
        _appStatus = AppStatus.authenticated;
        onSuccess(token);
      },
    );
    notifyListeners();
  }

  void register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    required String level,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    _sessionState = _sessionState.copyWith(
      screenState: ScreenStatus.loading,
    );
    notifyListeners();
    final results = await _authRepository.register(
      email,
      password,
      name,
      phone,
      address,
      level,
    );
    results.fold(
      (failure) {
        // _tokenState = _tokenState.copyWith(
        //   screenState: ScreenStatus.error,
        //   errorMessage: failure.message,
        // );
        onError(failure.message);
      },
      (token) {
        // _tokenState = _tokenState.copyWith(
        //   screenState: ScreenStatus.success,
        //   data: token,
        // );
        print(token);
        // _appStatus = AppStatus.authenticated;
        onSuccess(token);
      },
    );
    notifyListeners();
  }

  AppState<UserProfile> _profileState = AppState();
  AppState<UserProfile> get profileState => _profileState;

  Future<void> fetchProfile() async {
    _profileState = _profileState.copyWith(
      screenState: ScreenStatus.loading,
    );
    notifyListeners();
    final results = await _authRepository.getProfile();
    results.fold(
      (failure) {
        _profileState = _profileState.copyWith(
          screenState: ScreenStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) {
        _profileState = _profileState.copyWith(
          screenState: ScreenStatus.success,
          data: profile,
        );
      },
    );
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? profilePhoto,
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    _profileState = _profileState.copyWith(
      screenState: ScreenStatus.loading,
    );
    notifyListeners();
    final results = await _authRepository.updateProfile(
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      profilePhoto: profilePhoto,
    );
    results.fold(
      (failure) {
        onError?.call(failure.message);
      },
      (profile) {
        fetchProfile();
        onSuccess?.call("Berhasil update profile");
      },
    );
    _profileState = _profileState.copyWith(
      screenState: ScreenStatus.success,
    );
    notifyListeners();
  }

  void logout() {
    _authRepository.logout();
    notifyListeners();
  }
}
