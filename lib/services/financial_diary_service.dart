import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class FinancialDiaryOverview {
  const FinancialDiaryOverview({
    required this.headlineTitle,
    required this.progressPercent,
    required this.deltaText,
    required this.costText,
    required this.profitText,
    required this.outOfTrendRows,
    required this.stockOverviewRows,
  });

  final String headlineTitle;
  final int progressPercent;
  final String deltaText;
  final String costText;
  final String profitText;
  final List<FinancialDiaryRow> outOfTrendRows;
  final List<FinancialDiaryRow> stockOverviewRows;
}

class FinancialDiaryRow {
  const FinancialDiaryRow({
    required this.itemName,
    required this.stockLevel,
    required this.status,
  });

  final String itemName;
  final String stockLevel;
  final String status;
}

class FinancialDiaryService {
  FinancialDiaryService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://hackvidia.asoatram.dev';
  final http.Client _client;

  Future<FinancialDiaryOverview?> fetchOverview({required String token}) async {
    final uri = Uri.parse('$_baseUrl/dashboard/financial-diary');
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

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;

    final headline = decoded['headline'] as Map<String, dynamic>?;
    final financialDiary = decoded['financialDiary'] as Map<String, dynamic>?;
    if (financialDiary == null) return null;

    final outOfTrend = _mapRows(decoded['outOfTrend']);
    final stockOverview = _mapRows(decoded['stockOverview']);

    final percentRaw = financialDiary['profitPercent'];
    final percent = percentRaw is num ? percentRaw.toInt() : 0;

    final costLabel = _asString(financialDiary['costLabel']);
    final profitLabel = _asString(financialDiary['profitLabel']);
    final totalLabel = _asString(financialDiary['totalLabel']);

    return FinancialDiaryOverview(
      headlineTitle: _asString(headline?['title']).isEmpty
          ? 'Let\'s see how your shop is doing this week'
          : _asString(headline?['title']),
      progressPercent: percent.clamp(0, 100),
      deltaText: totalLabel.isEmpty ? '-' : totalLabel,
      costText: costLabel.isEmpty ? 'Cost (-)' : 'Cost ($costLabel)',
      profitText: profitLabel.isEmpty ? 'Profit (-)' : 'Profit ($profitLabel)',
      outOfTrendRows: outOfTrend,
      stockOverviewRows: stockOverview,
    );
  }

  List<FinancialDiaryRow> _mapRows(dynamic raw) {
    if (raw is! List) return const <FinancialDiaryRow>[];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .map(
          (row) => FinancialDiaryRow(
            itemName: _asString(row['itemName']),
            stockLevel: _asString(row['stockLevel']),
            status: _asString(row['status']),
          ),
        )
        .toList();
  }

  String _asString(dynamic value) {
    if (value is String) return value.trim();
    return '';
  }
}
