import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _userId;
  String? _username;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      _setStatus(AuthStatus.loading);
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final username = prefs.getString('username');

      if (userId != null && username != null) {
        _userId = userId;
        _username = username;
        _setStatus(AuthStatus.authenticated);
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _setError('Erreur lors de la vérification de l\'authentification');
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      _setStatus(AuthStatus.loading);

      // Simuler un ID utilisateur unique
      final userId = DateTime.now().millisecondsSinceEpoch.toString();

      // Sauvegarder les informations utilisateur
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      await prefs.setString('username', username);
      await prefs.setString('email', email);

      _userId = userId;
      _username = username;
      _setStatus(AuthStatus.authenticated);

      return true;
    } catch (e) {
      _setError('Erreur lors de l\'inscription: $e');
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      _setStatus(AuthStatus.loading);

      // Simuler une authentification
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 'Utilisateur';
      final userId =
          prefs.getString('user_id') ??
          DateTime.now().millisecondsSinceEpoch.toString();

      _userId = userId;
      _username = username;
      _setStatus(AuthStatus.authenticated);

      return true;
    } catch (e) {
      _setError('Erreur lors de la connexion: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('username');
      await prefs.remove('email');

      _userId = null;
      _username = null;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError('Erreur lors de la déconnexion');
    }
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
