import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class AuthLoginResult {
  const AuthLoginResult({
    required this.success,
    required this.statusCode,
    this.message,
    this.token,
  });

  final bool success;
  final int statusCode;
  final String? message;
  final String? token;
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://hackvidia.asoatram.dev';
  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<AuthLoginResult> login({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login');

    try {
      final http.Response response = await _client
          .post(
            url,
            headers: const {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 45));

      final Map<String, dynamic>? body = _tryDecodeJsonObject(response.body);
      final String? message = _extractMessage(body);
      final String? token = _extractToken(body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return AuthLoginResult(
          success: true,
          statusCode: response.statusCode,
          message: message ?? 'Login success',
          token: token,
        );
      }

      return AuthLoginResult(
        success: false,
        statusCode: response.statusCode,
        message: message ?? 'Login failed (${response.statusCode})',
      );
    } on TimeoutException {
      return const AuthLoginResult(
        success: false,
        statusCode: 0,
        message:
            'Request timed out after 45s. Please check your internet or try again.',
      );
    } on SocketException {
      return const AuthLoginResult(
        success: false,
        statusCode: 0,
        message: 'Cannot connect to server. Check your internet connection.',
      );
    } on http.ClientException catch (e) {
      return AuthLoginResult(
        success: false,
        statusCode: 0,
        message: 'Network client error: ${e.message}',
      );
    } catch (_) {
      return const AuthLoginResult(
        success: false,
        statusCode: 0,
        message: 'Unexpected error while logging in.',
      );
    }
  }

  Map<String, dynamic>? _tryDecodeJsonObject(String rawBody) {
    if (rawBody.trim().isEmpty) {
      return null;
    }
    final dynamic decoded = jsonDecode(rawBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  String? _extractMessage(Map<String, dynamic>? body) {
    if (body == null) {
      return null;
    }

    final dynamic message = body['message'] ?? body['detail'] ?? body['error'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
    return null;
  }

  String? _extractToken(Map<String, dynamic>? body) {
    if (body == null) {
      return null;
    }

    final dynamic directToken =
        body['token'] ?? body['access_token'] ?? body['accessToken'];
    if (directToken is String && directToken.trim().isNotEmpty) {
      return directToken;
    }

    final dynamic data = body['data'];
    if (data is Map<String, dynamic>) {
      final dynamic nestedToken =
          data['token'] ?? data['access_token'] ?? data['accessToken'];
      if (nestedToken is String && nestedToken.trim().isNotEmpty) {
        return nestedToken;
      }
    }

    return null;
  }
}
