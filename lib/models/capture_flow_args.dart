enum WarehouseStockAction {
  insert,
  subtract,
}

class CameraPrepArgs {
  final bool markFirstInputOnUsePhoto;
  final WarehouseStockAction action;

  const CameraPrepArgs({
    this.markFirstInputOnUsePhoto = false,
    this.action = WarehouseStockAction.insert,
  });
}

class ScanCameraArgs {
  final bool markFirstInputOnUsePhoto;
  final WarehouseStockAction action;
  final String? stockDocumentType;

  const ScanCameraArgs({
    this.markFirstInputOnUsePhoto = false,
    this.action = WarehouseStockAction.insert,
    this.stockDocumentType,
  });
}

class SubmitCaptureArgs {
  final String imagePath;
  final bool markFirstInputOnUsePhoto;
  final WarehouseStockAction action;
  final String? stockDocumentType;

  const SubmitCaptureArgs({
    required this.imagePath,
    this.markFirstInputOnUsePhoto = false,
    this.action = WarehouseStockAction.insert,
    this.stockDocumentType,
  });
}
