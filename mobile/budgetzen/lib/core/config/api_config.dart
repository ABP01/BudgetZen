class ApiConfig {
  static const String baseUrl = 'http://localhost:5001'; // Backend Node.js
  static const String apiPath = '/api';

  // Endpoints
  static const String transactionsEndpoint = '$apiPath/transactions';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout
  static const Duration requestTimeout = Duration(seconds: 30);
}
