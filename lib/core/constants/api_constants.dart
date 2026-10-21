abstract final class ApiConstants {
  // Replace with a server you control once the backend is implemented.
  static const baseUrl = String.fromEnvironment('SKINSYNC_API_URL',
      defaultValue: '');
}
