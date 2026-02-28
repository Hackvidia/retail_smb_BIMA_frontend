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

class CameraExtractionItem {
  const CameraExtractionItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitLabel,
    this.unitPrice,
    this.sourceNames = const <String>[],
  });

  final String id;
  final String name;
  final int quantity;
  final String unitLabel;
  final int? unitPrice;
  final List<String> sourceNames;
}

class CameraExtractionResult {
  const CameraExtractionResult({
    required this.success,
    required this.statusCode,
    this.message,
    this.extractionId,
    this.items = const <CameraExtractionItem>[],
  });

  final bool success;
  final int statusCode;
  final String? message;
  final String? extractionId;
  final List<CameraExtractionItem> items;
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

  static const String _cameraStockType = 'Shelves or stacks of items';
  static const String _cameraSupplierType = 'Supplier note/invoice';

  String cameraConfirmEndpoint(String cameraDocumentType) {
    if (_normalizeCameraType(cameraDocumentType) ==
        _normalizeCameraType(_cameraStockType)) {
      return '/documents/confirm-stock-boxes';
    }
    return '/documents/confirm-supplier-documents';
  }

  String cameraManualAddEndpoint(String cameraDocumentType, String extractionId) {
    final safeId = Uri.encodeComponent(extractionId.trim());
    if (_normalizeCameraType(cameraDocumentType) ==
        _normalizeCameraType(_cameraStockType)) {
      return '/documents/stock-box-extractions/$safeId/items';
    }
    return '/documents/supplier-extractions/$safeId/items';
  }

  bool isStockBoxesConfirmEndpoint(String endpoint) {
    return endpoint.trim().toLowerCase().endsWith('/documents/confirm-stock-boxes');
  }

  bool isSupplierConfirmEndpoint(String endpoint) {
    return endpoint
        .trim()
        .toLowerCase()
        .endsWith('/documents/confirm-supplier-documents');
  }

  Future<CameraExtractionResult> uploadCameraPhoto({
    required String cameraDocumentType,
    required String imagePath,
    required String token,
  }) async {
    final endpoint = _cameraEndpointByType(cameraDocumentType);
    if (endpoint == null) {
      return CameraExtractionResult(
        success: false,
        statusCode: 0,
        message: 'Unsupported camera document type: $cameraDocumentType',
      );
    }

    final file = File(imagePath);
    if (!await file.exists()) {
      return const CameraExtractionResult(
        success: false,
        statusCode: 0,
        message: 'Captured image file not found.',
      );
    }

    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint(
      '[DocumentExtractService][Camera] POST ${uri.toString()} type=$cameraDocumentType file=$imagePath',
    );

    final request = http.MultipartRequest('POST', uri);
    request.headers[HttpHeaders.acceptHeader] = 'application/json';
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    final fileFieldName = _normalizeCameraType(cameraDocumentType) ==
            _normalizeCameraType(_cameraSupplierType)
        ? 'files'
        : 'image';
    request.files.add(
      await http.MultipartFile.fromPath(
        fileFieldName,
        imagePath,
        filename: file.path.split(Platform.pathSeparator).last,
        contentType: _contentTypeForFileName(imagePath),
      ),
    );
    if (_normalizeCameraType(cameraDocumentType) ==
        _normalizeCameraType(_cameraSupplierType)) {
      request.fields['documentType'] = 'INVOICE';
    }

    try {
      final streamResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamResponse);
      debugPrint(
        '[DocumentExtractService][Camera] POST status=${response.statusCode} body=${response.body}',
      );
      final body = _tryDecodeJsonObjectSafe(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return CameraExtractionResult(
          success: false,
          statusCode: response.statusCode,
          message: _extractMessage(body) ?? 'Upload failed (${response.statusCode})',
        );
      }
      if (body == null) {
        return const CameraExtractionResult(
          success: false,
          statusCode: 0,
          message: 'Upload succeeded but response is non-JSON.',
        );
      }

      final extractionId = _extractExtractionId(body);
      final items = _extractCameraItems(
        body,
        cameraDocumentType: cameraDocumentType,
      );
      return CameraExtractionResult(
        success: true,
        statusCode: response.statusCode,
        message: _extractMessage(body),
        extractionId: extractionId,
        items: items,
      );
    } on TimeoutException {
      return const CameraExtractionResult(
        success: false,
        statusCode: 0,
        message: 'Upload request timed out.',
      );
    } on SocketException {
      return const CameraExtractionResult(
        success: false,
        statusCode: 0,
        message: 'Cannot connect to server.',
      );
    } catch (_) {
      return const CameraExtractionResult(
        success: false,
        statusCode: 0,
        message: 'Unexpected error while uploading image.',
      );
    }
  }


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

  String? _cameraEndpointByType(String cameraDocumentType) {
    final normalized = _normalizeCameraType(cameraDocumentType);
    if (normalized == _normalizeCameraType(_cameraStockType)) {
      return '/documents/extract-stock-boxes';
    }
    if (normalized == _normalizeCameraType(_cameraSupplierType)) {
      return '/documents/extract-supplier-documents';
    }
    return null;
  }

  String _normalizeCameraType(String value) => value.toLowerCase().trim();

  List<CameraExtractionItem> _extractCameraItems(
    Map<String, dynamic> body, {
    required String cameraDocumentType,
  }) {
    final dynamic candidate =
        _normalizeCameraType(cameraDocumentType) ==
                _normalizeCameraType(_cameraStockType)
        ? (body['confirmationItems'] ?? body['items'])
        : (body['draftItems'] ??
            body['items'] ??
            body['confirmationItems'] ??
            (body['data'] is Map<String, dynamic>
                ? (body['data']['draftItems'] ??
                    body['data']['items'] ??
                    body['data']['confirmationItems'])
                : null));

    final rows = _flattenRowMaps(candidate);
    return rows.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      final name = _readString(row, const [
        'displayName',
        'display_name',
        'rawName',
        'raw_name',
        'name',
        'item',
      ]);
      final quantityRaw = row['suggestedQty'] ??
          row['quantity'] ??
          row['qty'] ??
          row['count'] ??
          row['amount'];
      final quantity = quantityRaw is num
          ? quantityRaw.toInt()
          : int.tryParse(quantityRaw?.toString() ?? '') ?? 1;
      final unitPriceRaw = row['price'] ?? row['unitPrice'] ?? row['amount'];
      final unitPrice = unitPriceRaw is num
          ? unitPriceRaw.toInt()
          : int.tryParse(unitPriceRaw?.toString() ?? '');
      final unitLabel = _readString(row, const ['uom', 'unit', 'unitLabel']);
      final sourceNamesDynamic = row['sourceNames'];
      final sourceNames = sourceNamesDynamic is List
          ? sourceNamesDynamic.map((e) => e.toString()).toList()
          : <String>[];
      final rowId = _readString(row, const ['lineItemId', 'itemId', 'id']);

      return CameraExtractionItem(
        id: rowId.isEmpty
            ? 'camera-item-$index'
            : rowId,
        name: name.isEmpty ? '-' : name,
        quantity: quantity <= 0 ? 1 : quantity,
        unitLabel: unitLabel.isEmpty ? 'BOX' : unitLabel,
        unitPrice: (unitPrice != null && unitPrice < 0) ? 0 : unitPrice,
        sourceNames: sourceNames,
      );
    }).toList();
  }

  Future<DocumentExtractResult> addManualExtractionItem({
    required String endpoint,
    required String token,
    required String displayName,
    required int qty,
    required String uom,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[DocumentExtractService][Camera] POST ${uri.toString()} (manual item)');
    try {
      final response = await http
          .post(
            uri,
            headers: <String, String>{
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'displayName': displayName,
              'qty': qty,
              'uom': uom,
            }),
          )
          .timeout(const Duration(seconds: 60));
      final body = _tryDecodeJsonObjectSafe(response.body);
      return DocumentExtractResult(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        message: _extractMessage(body) ?? response.body,
      );
    } on TimeoutException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Manual item request timed out.',
      );
    } on SocketException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Cannot connect to server.',
      );
    } catch (_) {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Unexpected error while adding manual item.',
      );
    }
  }

  Future<List<CameraExtractionItem>> fetchStockBoxReview({
    required String extractionId,
    required String token,
  }) async {
    final safeId = Uri.encodeComponent(extractionId.trim());
    final uri = Uri.parse('$baseUrl/documents/stock-box-extractions/$safeId');
    debugPrint('[DocumentExtractService][Camera] GET ${uri.toString()} (review)');
    final response = await http.get(
      uri,
      headers: <String, String>{
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 60));
    final body = _tryDecodeJsonObjectSafe(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300 || body == null) {
      throw Exception('Failed to fetch stock box review (${response.statusCode}).');
    }
    return _extractStockBoxReviewItems(body);
  }

  Future<DocumentExtractResult> patchStockBoxReview({
    required String extractionId,
    required String token,
    required List<CameraExtractionItem> items,
  }) async {
    final safeId = Uri.encodeComponent(extractionId.trim());
    final uri = Uri.parse('$baseUrl/documents/stock-box-extractions/$safeId');
    debugPrint('[DocumentExtractService][Camera] PATCH ${uri.toString()} (review)');
    try {
      final response = await http
          .patch(
            uri,
            headers: <String, String>{
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'items': items.map(_toStockConfirmItemJson).toList(),
            }),
          )
          .timeout(const Duration(seconds: 60));
      final body = _tryDecodeJsonObjectSafe(response.body);
      return DocumentExtractResult(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        message: _extractMessage(body) ?? response.body,
      );
    } on TimeoutException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Patch review request timed out.',
      );
    } on SocketException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Cannot connect to server.',
      );
    } catch (_) {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Unexpected error while patching stock box review.',
      );
    }
  }

  Future<DocumentExtractResult> confirmCameraExtraction({
    required String endpoint,
    required String token,
    required String extractionId,
    required List<CameraExtractionItem> items,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[DocumentExtractService][Camera] POST ${uri.toString()} (confirm)');
    final isStockConfirm = isStockBoxesConfirmEndpoint(endpoint);
    final isSupplierConfirm = isSupplierConfirmEndpoint(endpoint);
    List<CameraExtractionItem> payloadItems = items;
    if (isSupplierConfirm) {
      payloadItems = await _resolveSupplierLineItemIds(
        extractionId: extractionId,
        token: token,
        items: items,
      );
    }
    final bodyPayload = <String, dynamic>{
      'extractionId': extractionId,
      'items': isStockConfirm
          ? payloadItems.map(_toStockConfirmItemJson).toList()
          : isSupplierConfirm
              ? payloadItems.map(_toSupplierConfirmItemJson).toList()
              : payloadItems
                  .map(
                    (item) => <String, dynamic>{
                      'displayName': item.name,
                      'qty': item.quantity,
                      'uom': item.unitLabel,
                    },
                  )
                  .toList(),
    };
    if (isSupplierConfirm) {
      bodyPayload['confirmedAt'] = DateTime.now().toUtc().toIso8601String();
      bodyPayload['source'] = 'supplier-note';
    }
    debugPrint(
      '[DocumentExtractService][Camera] confirm endpoint=$endpoint body=${jsonEncode(bodyPayload)}',
    );

    try {
      final response = await http
          .post(
            uri,
            headers: <String, String>{
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(bodyPayload),
          )
          .timeout(const Duration(seconds: 60));
      final body = _tryDecodeJsonObjectSafe(response.body);
      return DocumentExtractResult(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        message: _extractMessage(body) ?? response.body,
      );
    } on TimeoutException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Confirm request timed out.',
      );
    } on SocketException {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Cannot connect to server.',
      );
    } catch (_) {
      return const DocumentExtractResult(
        success: false,
        statusCode: 0,
        message: 'Unexpected error while confirming extraction.',
      );
    }
  }

  Map<String, dynamic> _toStockConfirmItemJson(CameraExtractionItem item) {
    return <String, dynamic>{
      'displayName': item.name,
      'confirmedQty': item.quantity,
      'uom': item.unitLabel,
    };
  }

  Map<String, dynamic> _toSupplierConfirmItemJson(CameraExtractionItem item) {
    final qty = item.quantity < 0 ? 0 : item.quantity;
    return <String, dynamic>{
      'lineItemId': item.id,
      'displayName': item.name,
      'confirmedQty': qty,
    };
  }

  Future<List<CameraExtractionItem>> _resolveSupplierLineItemIds({
    required String extractionId,
    required String token,
    required List<CameraExtractionItem> items,
  }) async {
    try {
      final parsed = await _fetchSupplierParsedLineItems(
        extractionId: extractionId,
        token: token,
      );
      if (parsed.isEmpty) return items;

      final byName = <String, String>{};
      final validIds = <String>[];
      for (final row in parsed) {
        final lineItemId = _readString(row, const ['lineItemId', 'line_item_id']);
        final displayName = _readString(row, const ['displayName', 'display_name', 'name']);
        if (lineItemId.isEmpty) continue;
        validIds.add(lineItemId);
        if (displayName.isNotEmpty) {
          byName[_normalizeKey(displayName)] = lineItemId;
        }
      }
      if (validIds.isEmpty) return items;
      final validIdSet = validIds.toSet();
      int fallbackIndex = 0;

      return items
          .map((item) {
            final currentId = item.id.trim();
            String? resolved;
            if (currentId.isNotEmpty && validIdSet.contains(currentId)) {
              resolved = currentId;
            } else {
              resolved = byName[_normalizeKey(item.name)];
            }
            if (resolved == null || resolved.isEmpty || !validIdSet.contains(resolved)) {
              resolved = validIds[fallbackIndex % validIds.length];
              fallbackIndex++;
            }
            debugPrint(
              '[DocumentExtractService][Camera] supplier lineItemId item="${item.name}" current="$currentId" resolved="$resolved"',
            );
            if (resolved.isNotEmpty) {
              return CameraExtractionItem(
                id: resolved,
                name: item.name,
                quantity: item.quantity,
                unitLabel: item.unitLabel,
                unitPrice: item.unitPrice,
                sourceNames: item.sourceNames,
              );
            }
            return item;
          })
          .toList();
    } catch (_) {
      return items;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSupplierParsedLineItems({
    required String extractionId,
    required String token,
  }) async {
    final safeId = Uri.encodeComponent(extractionId.trim());
    final uri = Uri.parse('$baseUrl/documents/supplier-extractions/$safeId');
    debugPrint('[DocumentExtractService][Camera] GET ${uri.toString()} (supplier parsed line items)');
    final response = await http.get(
      uri,
      headers: <String, String>{
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 60));
    final body = _tryDecodeJsonObjectSafe(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300 || body == null) {
      return const <Map<String, dynamic>>[];
    }
    final dynamic parsed = body['parsedLineItems'] ??
        (body['data'] is Map<String, dynamic> ? body['data']['parsedLineItems'] : null);
    return _flattenRowMaps(parsed);
  }

  String _normalizeKey(String value) => value.trim().toLowerCase();

  List<CameraExtractionItem> _extractStockBoxReviewItems(Map<String, dynamic> body) {
    final dynamic candidate = body['items'] ??
        body['confirmationItems'] ??
        (body['data'] is Map<String, dynamic>
            ? (body['data']['items'] ?? body['data']['confirmationItems'])
            : null);
    final rows = _flattenRowMaps(candidate);
    return rows.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      final name = _readString(row, const [
        'displayName',
        'display_name',
        'rawName',
        'name',
      ]);
      final qtyRaw = row['confirmedQty'] ?? row['suggestedQty'] ?? row['quantity'];
      final qty = qtyRaw is num
          ? qtyRaw.toInt()
          : int.tryParse(qtyRaw?.toString() ?? '') ?? 1;
      final uom = _readString(row, const ['uom', 'unit', 'unitLabel']);
      final sourceNamesDynamic = row['sourceNames'];
      final sourceNames = sourceNamesDynamic is List
          ? sourceNamesDynamic.map((e) => e.toString()).toList()
          : <String>[];
      return CameraExtractionItem(
        id: _readString(row, const ['itemId', 'id']).isEmpty
            ? 'stock-review-$index'
            : _readString(row, const ['itemId', 'id']),
        name: name.isEmpty ? '-' : name,
        quantity: qty <= 0 ? 1 : qty,
        unitLabel: uom.isEmpty ? 'BOX' : uom,
        unitPrice: null,
        sourceNames: sourceNames,
      );
    }).toList();
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

    final extraction = body['extraction'];
    if (extraction is Map<String, dynamic>) {
      final nested = extraction['extractionId'] ??
          extraction['extraction_id'] ??
          extraction['id'];
      if (nested is String && nested.trim().isNotEmpty) return nested.trim();
      if (nested is num) return nested.toString();
    }

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
