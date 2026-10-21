/// Interface to implement using flutter_secure_storage when authentication ships.
/// Intentionally does NOT store or log credentials in the UI prototype.
abstract class SecureStorage {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> clear();
}
