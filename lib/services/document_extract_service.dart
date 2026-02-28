import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:retail_smb/models/operational_document_item.dart';

class DocumentExtractResult {
  const DocumentExtractResult({
    required this.success,
    required this.statusCode,
    this.message,
    this.extractionId,
  });

  final bool success;
  final int statusCode;
  final String? message;
  final String? extractionId;
}

class DocumentSummaryRow {
  const DocumentSummaryRow({
    required this.item,
    required this.stockType,
    required this.price,
  });

  final String item;
  final String stockType;
  final String price;
}

class DocumentSummaryData {
  const DocumentSummaryData({
    required this.type,
    required this.title,
    required this.rows,
  });

  final String type;
  final String title;
  final List<DocumentSummaryRow> rows;
}

class DocumentExtractService {
  static const String baseUrl = 'https://hackvidia.asoatram.dev';

  static const Map<String, String> endpointByType = {
    'Stock Boxes': '/documents/extract-stock-boxes',
    'Supplier Docs': '/documents/extract-supplier-documents',
    'Document Price List': '/documents/extract-price-list',
    'Document Sales Record': '/documents/extract-sales-records',
    'Document Operational Expenditures': '/documents/extract-operational-expenditures',
    'Daily Sales': '/documents/extract-sales-records',
    'Product Price List': '/documents/extract-price-list',
    'Operational Expenditures': '/documents/extract-operational-expenditures',
    'Capital Expenditures': '/documents/extract-capital-expenditures',
  };

  static const Map<String, String> summaryEndpointByType = {
    'Stock Boxes': '/documents/stock-box-extractions',
    'Supplier Docs': '/documents/supplier-extractions',
    'Document Price List': '/documents/price-list-extractions',
    'Document Sales Record': '/documents/sales-extractions',
    'Document Operational Expenditures': '/documents/operational-extractions',
    'Daily Sales': '/documents/sales-extractions',
    'Product Price List': '/documents/price-list-extractions',
    'Operational Expenditures': '/documents/operational-extractions',
    'Capital Expenditures': '/documents/capital-extractions',
    'Supplier Extraction': '/documents/supplier-extractions',
    'Supplier Documents': '/documents/supplier-extractions',
    'Supplier note/invoice': '/documents/supplier-extractions',
  };

  Future<DocumentExtractResult> uploadForType({
    required String type,
    required List<OperationalDocumentItem> documents,
    required String token,
  }) async {
    final endpoint = endpointByType[type];
    if (endpoint == null) {
      return DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Unsupported document type: $type',
      );
    }
    if (documents.isEmpty) {
      return DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'No files selected for $type.',
      );
    }

    String? firstExtractionId;
    for (final doc in documents) {
      final file = File(doc.localPath);
      if (!await file.exists()) {
        return DocumentExtractResult(
          success: false,
          statusCode: 0,
          message: 'File not found: ${doc.fileName}',
        );
      }

      var result = await _sendSingleFile(
        endpoint: endpoint,
        token: token,
        doc: doc,
        fieldName: _primaryUploadFieldByType(type),
        extraFields: _extraUploadFieldsByType(type),
      );
      if (!result.success && (result.statusCode == 422 || result.statusCode == 400)) {
        result = await _sendSingleFile(
          endpoint: endpoint,
          token: token,
          doc: doc,
          fieldName: _primaryUploadFieldByType(type) == 'files' ? 'file' : 'files',
          extraFields: _extraUploadFieldsByType(type),
        );
      }
      if (!result.success && (result.statusCode == 422 || result.statusCode == 400)) {
        result = await _sendSingleFile(
          endpoint: endpoint,
          token: token,
          doc: doc,
          fieldName: 'image',
          extraFields: _extraUploadFieldsByType(type),
        );
      }
      if (!result.success) {
        return DocumentExtractResult(
          success: false,
          statusCode: result.statusCode,
          message: '${doc.fileName}: ${result.message ?? 'Upload failed for $type'}',
        );
      }

      firstExtractionId ??= result.extractionId;
    }

    if (firstExtractionId == null || firstExtractionId.trim().isEmpty) {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Upload succeeded but extractionId is missing in response.',
      );
    }

    return DocumentExtractResult(
      success: true,
      statusCode: 200,
      message: '$type uploaded successfully.',
      extractionId: firstExtractionId,
    );
  }

  Future<DocumentSummaryData> fetchSummary({
    required String type,
    required String extractionId,
    required String token,
  }) async {
    final endpoints = _summaryEndpointsForType(type);
    if (endpoints.isEmpty) {
      throw Exception('Unsupported document type: $type');
    }

    final safeId = Uri.encodeComponent(extractionId.trim());
    http.Response? lastResponse;
    Map<String, dynamic>? lastBody;
    final attemptedUrls = <String>[];

    for (final endpoint in endpoints) {
      final uri = Uri.parse('$baseUrl$endpoint/$safeId');
      attemptedUrls.add(uri.toString());
      debugPrint('[DocumentExtractService] GET ${uri.toString()}');
      final response = await http.get(
        uri,
        headers: <String, String>{
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 60));
      debugPrint(
        '[DocumentExtractService] GET status=${response.statusCode} type=$type',
      );
      debugPrint('[DocumentExtractService] GET body=${response.body}');
      final body = _tryDecodeJsonObjectSafe(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (body == null) {
          throw Exception(
            'Summary endpoint returned non-JSON response for $type. '
            'Please verify GET endpoint path and extractionId.\n'
            'Tried URL: ${uri.toString()}',
          );
        }
        final rows = _extractRows(body, type: type);
        debugPrint(
          '[DocumentExtractService] Parsed rows=${rows.length} type=$type extractionId=$extractionId',
        );
        for (final row in rows) {
          debugPrint(
            '[DocumentExtractService] row item=${row.item}, stockType=${row.stockType}, price=${row.price}',
          );
        }
        return DocumentSummaryData(
          type: type,
          title: _titleByType(type),
          rows: rows,
        );
      }
      lastResponse = response;
      lastBody = body;
    }

    if (lastResponse == null) {
      throw Exception(
        'Failed to fetch summary for $type.\n'
        'Tried URLs: ${attemptedUrls.join(' , ')}',
      );
    }
    if (lastBody != null) {
      throw Exception(
        _extractMessage(lastBody) ??
            'Failed to fetch summary for $type (${lastResponse.statusCode})\n'
                'Tried URLs: ${attemptedUrls.join(' , ')}',
      );
    }
    throw Exception(
      'Summary endpoint returned non-JSON response '
      '(${lastResponse.statusCode}) for $type.\n'
      'Tried URLs: ${attemptedUrls.join(' , ')}',
    );
  }

  Future<DocumentExtractResult> _sendSingleFile({
    required String endpoint,
    required String token,
    required OperationalDocumentItem doc,
    required String fieldName,
    Map<String, String>? extraFields,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint(
      '[DocumentExtractService] POST ${uri.toString()} field=$fieldName file=${doc.fileName}',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers[HttpHeaders.acceptHeader] = 'application/json';
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
    if (extraFields != null) {
      request.fields.addAll(extraFields);
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        fieldName,
        doc.localPath,
        filename: doc.fileName,
        contentType: _contentTypeForFileName(doc.fileName),
      ),
    );

    try {
      final streamResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamResponse);
      debugPrint(
        '[DocumentExtractService] POST status=${response.statusCode} endpoint=$endpoint',
      );
      debugPrint('[DocumentExtractService] POST body=${response.body}');
      final body = _tryDecodeJsonObjectSafe(response.body);
      final message = _extractMessage(body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DocumentExtractResult(
          success: true,
          statusCode: response.statusCode,
          message: message,
          extractionId: _extractExtractionId(body),
        );
      }

      return DocumentExtractResult(
        success: false,
        statusCode: response.statusCode,
        message: message ?? 'Upload failed (${response.statusCode})',
      );
    } on SocketException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Cannot connect to server.',
      );
    } on TimeoutException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Upload request timed out.',
      );
    } catch (_) {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Unexpected error while uploading file.',
      );
    }
  }

  List<DocumentSummaryRow> _extractRows(
    Map<String, dynamic>? body, {
    String? type,
  }) {
    if (body == null) return const <DocumentSummaryRow>[];

    final isCapital = type == 'Capital Expenditures';
    final isOperational = type == 'Document Operational Expenditures' ||
        type == 'Operational Expenditures';
    final isPriceList =
        type == 'Document Price List' || type == 'Product Price List';
    final dynamic candidate = isCapital
        ? _capitalItemsCandidate(body)
        : isOperational
            ? _operationalItemsCandidate(body)
            : body['items'] ??
                body['lineItems'] ??
                body['parsedLineItems'] ??
                body['rows'] ??
                body['data'] ??
                body['result'] ??
                body['extractedData'];
    if (isPriceList) {
      debugPrint(
        '[DocumentExtractService][PriceList] bodyKeys=${body.keys.toList()}',
      );
      debugPrint(
        '[DocumentExtractService][PriceList] candidateType=${candidate.runtimeType}',
      );
      debugPrint(
        '[DocumentExtractService][PriceList] candidate=$candidate',
      );
    }

    final List<Map<String, dynamic>> maps = _flattenRowMaps(candidate);
    if (isPriceList) {
      debugPrint(
        '[DocumentExtractService][PriceList] flattenedRows=${maps.length}',
      );
    }
    return maps.map((row) {
      final item = _readString(row, const [
        'displayName',
        'display_name',
        'rawName',
        'raw_name',
        'item',
        'name',
        'product',
        'product_name',
        'description',
      ]);
      final stockType = isCapital
          ? '-'
          : isOperational
          ? '-'
          : _readString(row, const [
              'stock_type',
              'type_of_stocks',
              'type',
              'unit',
              'uom',
              'category',
            ]);
      final price = isCapital
          ? _readPrice(row, preferredKeys: const ['amount'])
          : isOperational
              ? _readPrice(row, preferredKeys: const ['amount'])
          : _readPrice(row);
      if (isPriceList) {
        debugPrint(
          '[DocumentExtractService][PriceList] parsedRow raw=$row => item=$item, stockType=$stockType, price=$price',
        );
      }

      return DocumentSummaryRow(
        item: item.isEmpty ? '-' : item,
        stockType: stockType.isEmpty ? '-' : stockType,
        price: price.isEmpty ? '-' : price,
      );
    }).toList();
  }

  dynamic _capitalItemsCandidate(Map<String, dynamic> body) {
    if (body['draftItems'] is List) return body['draftItems'];
    if (body['items'] is List) return body['items'];
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      if (data['draftItems'] is List) return data['draftItems'];
      if (data['items'] is List) return data['items'];
    }
    return null;
  }

  dynamic _operationalItemsCandidate(Map<String, dynamic> body) {
    if (body['draftItems'] is List) return body['draftItems'];
    final data = body['data'];
    if (data is Map<String, dynamic> && data['draftItems'] is List) {
      return data['draftItems'];
    }
    return null;
  }

  List<Map<String, dynamic>> _flattenRowMaps(dynamic source) {
    if (source is List) {
      return source
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (source is Map<String, dynamic>) {
      if (source['items'] is List) {
        return _flattenRowMaps(source['items']);
      }
      if (source['lineItems'] is List) {
        return _flattenRowMaps(source['lineItems']);
      }
      if (source['parsedLineItems'] is List) {
        return _flattenRowMaps(source['parsedLineItems']);
      }
      if (source['rows'] is List) {
        return _flattenRowMaps(source['rows']);
      }
      return <Map<String, dynamic>>[source];
    }
    return const <Map<String, dynamic>>[];
  }

  String _readString(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      final value = row[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is num) return value.toString();
    }
    return '';
  }

  String _readPrice(
    Map<String, dynamic> row, {
    List<String> preferredKeys = const ['price', 'unit_price', 'amount', 'total'],
  }) {
    for (final key in preferredKeys) {
      final value = row[key];
      if (value is num) return 'Rp ${value.toStringAsFixed(0)}';
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }

  String _titleByType(String type) {
    switch (type) {
      case 'Stock Boxes':
        return 'Stock Boxes';
      case 'Supplier Docs':
        return 'Supplier Documents';
      case 'Document Price List':
      case 'Daily Sales':
        return 'Daily Sales';
      case 'Document Sales Record':
      case 'Product Price List':
        return 'Product Pricing';
      case 'Document Operational Expenditures':
      case 'Operational Expenditures':
        return 'Operational Expenditures';
      case 'Capital Expenditures':
        return 'Capital Expenditures';
      default:
        return type;
    }
  }

  List<String> _summaryEndpointsForType(String type) {
    final mapped = summaryEndpointByType[type];
    if (mapped != null) {
      if (mapped == '/documents/stock-box-extractions') {
        return const [
          '/documents/stock-box-extractions',
          '/documents/stock-box-extraction',
        ];
      }
      return <String>[mapped];
    }

    final normalized = type.toLowerCase();
    if (normalized.contains('stock') && normalized.contains('box')) {
      return const [
        '/documents/stock-box-extractions',
        '/documents/stock-box-extraction',
      ];
    }
    if (normalized.contains('supplier')) {
      return const ['/documents/supplier-extractions'];
    }
    if (normalized.contains('price')) {
      return const ['/documents/price-list-extractions'];
    }
    if (normalized.contains('sales')) {
      return const ['/documents/sales-extractions'];
    }
    if (normalized.contains('operational')) {
      return const ['/documents/operational-extractions'];
    }
    if (normalized.contains('capital')) {
      return const ['/documents/capital-extractions'];
    }
    return const <String>[];
  }

  String _primaryUploadFieldByType(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('stock') && normalized.contains('box')) {
      return 'image';
    }
    return 'files';
  }

  Map<String, String>? _extraUploadFieldsByType(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('supplier')) {
      return const {'documentType': 'INVOICE'};
    }
    return null;
  }

  Map<String, dynamic>? _tryDecodeJsonObjectSafe(String rawBody) {
    if (rawBody.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(rawBody);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      return null;
    }
    return null;
  }

  String? _extractMessage(Map<String, dynamic>? body) {
    if (body == null) return null;
    final message = body['message'] ?? body['detail'] ?? body['error'];
    if (message is String && message.trim().isNotEmpty) return message;
    return null;
  }

  String? _extractExtractionId(Map<String, dynamic>? body) {
    if (body == null) return null;
    final direct = body['extractionId'] ?? body['extraction_id'] ?? body['id'];
    if (direct is String && direct.trim().isNotEmpty) return direct.trim();
    if (direct is num) return direct.toString();

    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final nested =
          data['extractionId'] ?? data['extraction_id'] ?? data['id'];
      if (nested is String && nested.trim().isNotEmpty) return nested.trim();
      if (nested is num) return nested.toString();
    }
    return null;
  }

  MediaType _contentTypeForFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.pdf')) return MediaType('application', 'pdf');
    if (lower.endsWith('.doc')) return MediaType('application', 'msword');
    if (lower.endsWith('.docx')) {
      return MediaType(
        'application',
        'vnd.openxmlformats-officedocument.wordprocessingml.document',
      );
    }
    if (lower.endsWith('.xls')) return MediaType('application', 'vnd.ms-excel');
    if (lower.endsWith('.xlsx')) {
      return MediaType(
        'application',
        'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
    }
    if (lower.endsWith('.csv')) return MediaType('text', 'csv');
    if (lower.endsWith('.txt')) return MediaType('text', 'plain');
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    return MediaType('application', 'octet-stream');
  }
}
