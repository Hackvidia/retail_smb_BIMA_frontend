import 'package:shared_preferences/shared_preferences.dart';
import 'package:retail_smb/models/capture_flow_args.dart';

class AppSessionState {
  AppSessionState._();

  static final AppSessionState instance = AppSessionState._();
  static const String _authTokenKey = 'auth_token';

  bool _hasCompletedFirstInput = false;
  String? _authToken;
  WarehouseStockAction _currentStockAction = WarehouseStockAction.insert;

  bool get isFirstTimeInput => !_hasCompletedFirstInput;
  String? get authToken => _authToken;
  WarehouseStockAction get currentStockAction => _currentStockAction;

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_authTokenKey);
  }

  Future<void> setAuthToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = token;

    if (token == null || token.trim().isEmpty) {
      await prefs.remove(_authTokenKey);
      return;
    }

    await prefs.setString(_authTokenKey, token);
  }

  void markFirstInputCompleted() {
    _hasCompletedFirstInput = true;
  }

  void setCurrentStockAction(WarehouseStockAction action) {
    _currentStockAction = action;
  }
}
