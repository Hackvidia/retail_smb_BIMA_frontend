import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:retail_smb/models/operational_document_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentStorageService {
  static const String _storageKey = 'operational_documents_v1';

  Future<List<OperationalDocumentItem>> loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return <OperationalDocumentItem>[];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return <OperationalDocumentItem>[];
    }

    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(OperationalDocumentItem.fromJson)
        .where((item) => item.localPath.trim().isNotEmpty)
        .toList();
  }

  Future<void> saveDocuments(List<OperationalDocumentItem> documents) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(documents.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<OperationalDocumentItem> persistPickedFile({
    required String type,
    required String sourcePath,
    required String originalFileName,
    required int bytes,
  }) async {
    final sourceFile = File(sourcePath);
    final appDirectory = await getApplicationDocumentsDirectory();
    final typeFolder = _typeToFolder(type);
    final docsDirectory =
        Directory('${appDirectory.path}/uploaded_docs/$typeFolder');
    if (!docsDirectory.existsSync()) {
      await docsDirectory.create(recursive: true);
    }

    final cleanName = originalFileName.trim().isEmpty
        ? 'document_${DateTime.now().millisecondsSinceEpoch}'
        : originalFileName.trim();
    final targetPath =
        '${docsDirectory.path}/${DateTime.now().millisecondsSinceEpoch}_$cleanName';
    final copied = await sourceFile.copy(targetPath);

    return OperationalDocumentItem(
      type: type,
      fileName: cleanName,
      sizeLabel: _formatSizeLabel(bytes),
      localPath: copied.path,
    );
  }

  Future<void> deleteLocalFile(OperationalDocumentItem item) async {
    if (item.localPath.trim().isEmpty) return;
    final file = File(item.localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> localFileExists(String path) async {
    if (path.trim().isEmpty) return false;
    return File(path).exists();
  }

  String _formatSizeLabel(int bytes) {
    if (bytes <= 0) return 'Unknown size';
    final sizeInMb = bytes / (1024 * 1024);
    return '${sizeInMb.toStringAsFixed(2).replaceAll('.', ',')} MB';
  }

  String _typeToFolder(String type) {
    return type
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
