import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? _auth;
  User? _user;
  bool _isLoading = false;
  bool _isGuest = false;
  bool _firebaseAvailable = false;

  AuthProvider() {
    _initFirebase();
  }

  void _initFirebase() {
    try {
      _auth = FirebaseAuth.instance;
      _firebaseAvailable = true;
      _auth!.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Firebase Auth not available: $e');
      _firebaseAvailable = false;
    }
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null || _isGuest;
  bool get isGuest => _isGuest;
  bool get isLoading => _isLoading;
  bool get firebaseAvailable => _firebaseAvailable;
  String? get userEmail => _user?.email;

  void continueAsGuest() {
    _isGuest = true;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    if (_auth == null) throw Exception('Firebase not available');
    _isLoading = true;
    notifyListeners();
    try {
      await _auth!.createUserWithEmailAndPassword(email: email, password: password);
      _isGuest = false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    if (_auth == null) throw Exception('Firebase not available');
    _isLoading = true;
    notifyListeners();
    try {
      await _auth!.signInWithEmailAndPassword(email: email, password: password);
      _isGuest = false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isGuest = false;
    if (_auth != null) {
      await _auth!.signOut();
    }
    notifyListeners();
  }
}
