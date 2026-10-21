import '../constants/api_constants.dart';

/// Integration point only: no backend connection is made by the UI prototype.
class ApiClient {
  const ApiClient();
  String get baseUrl => ApiConstants.baseUrl;
  bool get isConfigured => baseUrl.isNotEmpty;
}
