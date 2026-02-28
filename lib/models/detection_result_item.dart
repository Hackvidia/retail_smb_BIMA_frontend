class DetectionResultItem {
  final String id;
  final String name;
  final int? unitPrice;
  final int quantity;
  final String unitLabel;
  final List<String> sourceNames;

  const DetectionResultItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.unitLabel = 'RENCENG',
    this.sourceNames = const <String>[],
  });

  DetectionResultItem copyWith({
    String? id,
    String? name,
    int? unitPrice,
    bool clearUnitPrice = false,
    int? quantity,
    String? unitLabel,
    List<String>? sourceNames,
  }) {
    return DetectionResultItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unitPrice: clearUnitPrice ? null : (unitPrice ?? this.unitPrice),
      quantity: quantity ?? this.quantity,
      unitLabel: unitLabel ?? this.unitLabel,
      sourceNames: sourceNames ?? this.sourceNames,
    );
  }
}

class PhotoDetectionArgs {
  final String? imagePath;
  final List<DetectionResultItem> detectedItems;
  final String? extractionId;
  final String? confirmEndpoint;
  final String? manualAddEndpoint;
  final String? sourceType;

  const PhotoDetectionArgs({
    this.imagePath,
    required this.detectedItems,
    this.extractionId,
    this.confirmEndpoint,
    this.manualAddEndpoint,
    this.sourceType,
  });
}
