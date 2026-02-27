class DetectionResultItem {
  final String id;
  final String name;
  final int unitPrice;
  final int quantity;
  final String unitLabel;

  const DetectionResultItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.unitLabel = 'RENCENG',
  });

  DetectionResultItem copyWith({
    String? id,
    String? name,
    int? unitPrice,
    int? quantity,
    String? unitLabel,
  }) {
    return DetectionResultItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      unitLabel: unitLabel ?? this.unitLabel,
    );
  }
}

class PhotoDetectionArgs {
  final String? imagePath;
  final List<DetectionResultItem> detectedItems;

  const PhotoDetectionArgs({
    this.imagePath,
    required this.detectedItems,
  });
}
