import 'package:shoe_care/data/datasources/auth_datasources.dart';
import 'package:shoe_care/data/datasources/session_datasource.dart';
import 'package:shoe_care/data/models/user_profile_model.dart';
import 'package:shoe_care/presentation/view/login_screen.dart';

import '../../app/utils/exception.dart';
import '../../app/utils/type_definition.dart';
import '../models/session_auth.dart';

class AuthRepository {
  AuthRepository._internal();
  static final _singleton = AuthRepository._internal();
  factory AuthRepository() => _singleton;
  final AuthDatasources _authDatasource = AuthDatasources();
  final _sessionDatasource = SessionDatasource();

  Future<StringOrFailure> login(
    String email,
    String password, {
    LoginType loginType = LoginType.customer,
  }) async =>
      tryCatch<String>(
        () async {
          final response =
              await _authDatasource.login(email: email, password: password);
          // await Hive.box<String>('auth').put('token', response["token"]);
          await _sessionDatasource.saveSession(
              SessionAuth(token: response["token"], role: loginType.name));

          return "Login Success, wait a moment you will redirected";
        },
      );
  Future<void> logout() async {
    await _sessionDatasource.deleteSession();
  }

  Future<SessionAuth?> getSession() async =>
      await _sessionDatasource.getSession();
  Future<StringOrFailure> register(
    String email,
    String password,
    String name,
    String phone,
    String address,
    String level,
  ) async =>
      tryCatch<String>(
        () async {
          final response = await _authDatasource.register(
              email: email,
              password: password,
              name: name,
              phoneNumber: phone,
              address: address,
              level: level);
          return "Register Success, wait a moment you will redirected";
        },
      );

  Future<ProfileOrFailure> getProfile() async => tryCatch<UserProfile>(
        () async {
          final response = await _authDatasource.getUserProfile();
          return response;
        },
      );

  Future<ProfileOrFailure> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? profilePhoto,
  }) async =>
      tryCatch<UserProfile>(
        () async {
          final response = await _authDatasource.updateUserProfile(
            name: name,
            phoneNumber: phoneNumber,
            address: address,
            profilePhoto: profilePhoto,
          );
          return response;
        },
      );
}
