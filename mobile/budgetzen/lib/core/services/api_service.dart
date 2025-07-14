import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .get(uri, headers: {...ApiConfig.defaultHeaders, ...?headers})
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on http.ClientException {
      throw ApiException('Erreur de connexion au serveur');
    } catch (e) {
      throw ApiException('Erreur inattendue: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await http
          .post(
            uri,
            headers: {...ApiConfig.defaultHeaders, ...?headers},
            body: jsonEncode(data),
          )
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on http.ClientException {
      throw ApiException('Erreur de connexion au serveur');
    } catch (e) {
      throw ApiException('Erreur inattendue: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await http
          .put(
            uri,
            headers: {...ApiConfig.defaultHeaders, ...?headers},
            body: jsonEncode(data),
          )
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on http.ClientException {
      throw ApiException('Erreur de connexion au serveur');
    } catch (e) {
      throw ApiException('Erreur inattendue: $e');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await http
          .delete(uri, headers: {...ApiConfig.defaultHeaders, ...?headers})
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on http.ClientException {
      throw ApiException('Erreur de connexion au serveur');
    } catch (e) {
      throw ApiException('Erreur inattendue: $e');
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw ApiException('Réponse du serveur invalide');
      }
    } else {
      String errorMessage = 'Erreur du serveur';
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['error'] ?? errorMessage;
      } catch (e) {
        // Utilise le message par défaut si le parsing échoue
      }
      throw ApiException(errorMessage, statusCode: statusCode);
    }
  }
}
