import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ronce_tuban_app/models/local_user.dart';
import 'package:ronce_tuban_app/services/local_auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({LocalAuthService? service})
      : _service = service ?? LocalAuthService();

  final LocalAuthService _service;
  Future<void>? _initialization;
  LocalUser? _user;
  bool _isGuest = false;
  bool _isInitializing = true;
  bool _isDisposed = false;
  String? _initializationError;

  LocalUser? get user => _user;
  bool get isGuest => _isGuest;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _user != null;
  String? get initializationError => _initializationError;

  Future<void> initialize() => _initialization ??= _restoreSession();

  Future<void> _restoreSession() async {
    try {
      _user = await _service.restoreSession();
      _initializationError = null;
    } on DatabaseException catch (error) {
      _initializationError = error.toString();
    } on FileSystemException catch (error) {
      _initializationError = error.toString();
    } finally {
      _isInitializing = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  Future<void> retryInitialization() {
    _initializationError = null;
    _isInitializing = true;
    _initialization = null;
    notifyListeners();
    return initialize();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _service.register(
      name: name,
      email: email,
      password: password,
    );
    _user = user;
    _isGuest = false;
    if (!_isDisposed) notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _service.signIn(email: email, password: password);
    _user = user;
    _isGuest = false;
    if (!_isDisposed) notifyListeners();
  }

  void continueAsGuest() {
    _user = null;
    _isGuest = true;
    if (!_isDisposed) notifyListeners();
  }

  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    _isGuest = false;
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
