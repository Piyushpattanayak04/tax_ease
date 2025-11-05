import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/theme/theme_controller.dart';

class AuthResult {
  final String? token; // access_token
  final String? refreshToken;
  final String? displayName;
  final String? filingType; // e.g., T1/T2 if provided by backend

  AuthResult({this.token, this.refreshToken, this.displayName, this.filingType});
}

class AuthApi {
  AuthApi._();

  static Dio _dio() => Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.BASE_URL,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
headers: {
            'Content-Type': 'application/json',
            // Bypass ngrok browser interstitial for API calls
            'ngrok-skip-browser-warning': 'true',
            if (ThemeController.authToken != null)
              'Authorization': 'Bearer ${ThemeController.authToken}',
          },
        ),
      );

  /// Register user (email verification via OTP follows).
  static Future<void> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    String? phone,
    required bool acceptTerms,
  }) async {
    try {
      await _dio().post(
        ApiEndpoints.REGISTER,
        data: {
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'password': password,
          'accept_terms': acceptTerms,
        },
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  /// Attempt login; returns tokens according to docs.
  static Future<AuthResult> login({required String email, required String password}) async {
    try {
      final res = await _dio().post(
        ApiEndpoints.LOGIN,
        data: {
          'email': email,
          'password': password,
        },
      );
      final data = res.data;
      return _parseAuthResult(data);
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      throw Exception(message);
    }
  }

  /// Request an OTP for email verification or password reset
  static Future<void> requestOtp({
    required String email,
    required String purpose, // 'email_verification' | 'password_reset'
  }) async {
    try {
      await _dio().post(
        ApiEndpoints.REQUEST_OTP,
        data: {
          'email': email,
          'purpose': purpose,
        },
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  /// Verify an OTP code
  static Future<void> verifyOtp({
    required String email,
    required String code,
    required String purpose,
  }) async {
    try {
      await _dio().post(
        ApiEndpoints.VERIFY_OTP,
        data: {
          'email': email,
          'code': code,
          'purpose': purpose,
        },
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  static AuthResult _parseAuthResult(dynamic data) {
    // Docs:
    // { "access_token": "...", "refresh_token": "...", "token_type": "Bearer", "expires_in": 0 }
    dynamic root = data;
    if (data is String) {
      try { root = json.decode(data); } catch (_) {}
    }

    String? token;
    String? refreshToken;
    String? name;
    String? filingType;

    if (root is Map) {
      token = (root['access_token'] ?? root['token'])?.toString();
      refreshToken = (root['refresh_token'])?.toString();

      final user = (root['user'] ?? root['data']?['user']) as Map?;
      name = (user?['name'] ?? user?['fullName'] ?? user?['first_name'] ?? user?['firstName'])?.toString();
      filingType = (user?['filingType'] ?? user?['filing_type'])?.toString();
    }

    return AuthResult(
      token: token,
      refreshToken: refreshToken,
      displayName: name,
      filingType: filingType,
    );
  }

  static String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map && (e.response!.data as Map)['message'] != null) {
      return (e.response!.data as Map)['message'].toString();
    }
    if (e.message != null) return e.message!;
    return 'Login failed. Please try again.';
  }
}