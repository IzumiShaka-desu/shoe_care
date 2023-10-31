import 'package:dio/dio.dart';
import 'package:shoe_care/app/services/base_client.dart';
import 'package:shoe_care/data/models/user_profile_model.dart';

class AuthDatasources extends BaseClient {
  AuthDatasources._internal();
  static final _singleton = AuthDatasources._internal();
  factory AuthDatasources() => _singleton;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async =>
      tryRequest(
        () async {
          final response = await post(
            "/auth/login",
            data: {
              "email": email,
              "password": password,
            },
          );
          return response.data as Map<String, dynamic>;
        },
      );
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String address,
    required String level,
  }) async =>
      tryRequest(
        () async {
          final data = {
            "email": email,
            "password": password,
            "name": name,
            "phone": phoneNumber,
            "address": address,
            "level": level,
          };
          final response = await post(
            "/auth/register",
            data: data,
          );
          return response.data as Map<String, dynamic>;
        },
      );

  Future<UserProfile> getUserProfile() async => tryRequest(
        () async {
          final response = await get("/auth/me");
          return UserProfile.fromJson(response.data);
        },
      );

  Future<UserProfile> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? profilePhoto,
    String? password,
  }) async =>
      tryRequest(
        () async {
          final data = <String, dynamic>{
            "name": name,
            "phone": phoneNumber,
            "address": address,
            "password": password,
          };
          if (profilePhoto != null) {
            data["profile_picture"] =
                await MultipartFile.fromFile(profilePhoto);
          }

          final response = await put(
            "/auth/me",
            data: FormData.fromMap(data),
          );
          return UserProfile.fromJson(response.data);
        },
      );
}
