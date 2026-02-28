import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HomeBusinessHealth {
  const HomeBusinessHealth({
    required this.safeItemName,
    required this.safeMessage,
    required this.warningItemName,
    required this.warningMessage,
  });

  final String safeItemName;
  final String safeMessage;
  final String warningItemName;
  final String warningMessage;
}

class HomeOverviewService {
  HomeOverviewService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://hackvidia.asoatram.dev';
  final http.Client _client;

  Future<HomeBusinessHealth?> fetchBusinessHealth({required String token}) async {
    final uri = Uri.parse('$_baseUrl/inventory/mobile-overview');
    final response = await _client
        .get(
          uri,
          headers: <String, String>{
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;

    final businessHealthRaw = decoded['businessHealth'];
    if (businessHealthRaw is! Map<String, dynamic>) return null;

    final safeRaw = businessHealthRaw['safe'];
    final warningRaw = businessHealthRaw['warning'];
    if (safeRaw is! Map<String, dynamic> || warningRaw is! Map<String, dynamic>) {
      return null;
    }

    final safeItemName = _asString(safeRaw['itemName']);
    final safeMessage = _asString(safeRaw['message']);
    final warningItemName = _asString(warningRaw['itemName']);
    final warningMessage = _asString(warningRaw['message']);

    return HomeBusinessHealth(
      safeItemName: safeItemName,
      safeMessage: safeMessage,
      warningItemName: warningItemName,
      warningMessage: warningMessage,
    );
  }

  String _asString(dynamic value) {
    if (value is String) return value.trim();
    return '';
  }
}
