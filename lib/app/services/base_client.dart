import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../utils/exception.dart';
import '../utils/interceptors.dart';

abstract class BaseClient with DioMixin implements Dio {
  @override
  HttpClientAdapter get httpClientAdapter => IOHttpClientAdapter();

  @override
  BaseOptions get options {
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = Hive.box<String>('auth').get('token') ?? Constants.dummyJWT;
    if (token != null) {
      header["Authorization"] = "Bearer $token";
    }
    return BaseOptions(
      baseUrl: Constants.baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: header,
    );
  }

  @override
  Interceptors get interceptors => Interceptors()
    ..add(LogInterceptor(requestBody: true, responseBody: true))
    ..add(ErrorInterceptor());

  Future<T> tryRequest<T>(FutureOr<T> Function() computation) async {
    try {
      return await computation();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      if (e is BadRequestError) {
        throw BadRequestException(e.message);
      }
      if (e is UnAuthorizedError) {
        throw UnAuthorizedException(e.message);
      }
      if (e is ForbiddenError) {
        throw ForbiddenException();
      }
      if (e is NotFoundError) {
        throw NotFoundException(message: e.message);
      }
      if (e is InternalServerError) {
        throw ServerException();
      }
      if (e is ServiceUnavailable) {
        throw ServiceUnavailableException(message: e.message);
      }
      if (e is TimeOutError || e is GatewayTimeout) {
        throw TimeoutException();
      }

      throw ServerException(
        message:
            "We can't proceed your request. Please try again later or check your internet connection.",
      );
    }
  }
}
