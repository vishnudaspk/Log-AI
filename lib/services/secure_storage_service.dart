import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create an instance of FlutterSecureStorage
  static final _secureStorage = FlutterSecureStorage();

  // Define a constant key name for storing the API key
  static const _apiKeyKey = 'apiKey';

  // Function to save the API key securely
  static Future<void> setApiKey(String apiKey) async {
    await _secureStorage.write(key: _apiKeyKey, value: apiKey);
  }

  // Function to retrieve the API key
  static Future<String?> getApiKey() async {
    return await _secureStorage.read(key: _apiKeyKey);
  }

  // Function to delete the API key (optional)
  static Future<void> deleteApiKey() async {
    await _secureStorage.delete(key: _apiKeyKey);
  }
}
