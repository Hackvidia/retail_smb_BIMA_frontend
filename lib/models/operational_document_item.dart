class OperationalDocumentItem {
  final String type;
  final String fileName;
  final String sizeLabel;
  final String localPath;

  const OperationalDocumentItem({
    required this.type,
    required this.fileName,
    required this.sizeLabel,
    required this.localPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'fileName': fileName,
      'sizeLabel': sizeLabel,
      'localPath': localPath,
    };
  }

  factory OperationalDocumentItem.fromJson(Map<String, dynamic> json) {
    return OperationalDocumentItem(
      type: (json['type'] ?? '') as String,
      fileName: (json['fileName'] ?? '') as String,
      sizeLabel: (json['sizeLabel'] ?? '') as String,
      localPath: (json['localPath'] ?? '') as String,
    );
  }
}

class OperationalDocumentsSummaryArgs {
  final List<OperationalDocumentItem> uploadedDocuments;
  final List<DocumentExtractionRef> extractionRefs;

  const OperationalDocumentsSummaryArgs({
    required this.uploadedDocuments,
    required this.extractionRefs,
  });
}

class DocumentExtractionRef {
  final String type;
  final String extractionId;

  const DocumentExtractionRef({
    required this.type,
    required this.extractionId,
  });
}
