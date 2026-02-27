class OperationalDocumentItem {
  final String type;
  final String fileName;
  final String sizeLabel;

  const OperationalDocumentItem({
    required this.type,
    required this.fileName,
    required this.sizeLabel,
  });
}

class OperationalDocumentsSummaryArgs {
  final List<OperationalDocumentItem> uploadedDocuments;

  const OperationalDocumentsSummaryArgs({
    required this.uploadedDocuments,
  });
}
