import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Get user data from Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data()!, userDoc.id);
        }
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register new user
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? employeeId,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create user document in Firestore
        final userModel = UserModel(
          id: result.user!.uid,
          name: name,
          email: email,
          employeeId: employeeId,
          role: 'employee',
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userModel.toMap());

        return userModel;
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data()!, userDoc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle authentication exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No se encontró ningún usuario con ese correo electrónico.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'email-already-in-use':
          return 'Ya existe una cuenta con ese correo electrónico.';
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        case 'user-disabled':
          return 'Esta cuenta ha sido deshabilitada.';
        case 'too-many-requests':
          return 'Demasiados intentos. Por favor, intenta más tarde.';
        case 'operation-not-allowed':
          return 'Operación no permitida.';
        case 'invalid-credential':
          return 'Las credenciales proporcionadas son inválidas.';
        default:
          return 'Error de autenticación: ${e.message}';
      }
    }
    return 'Error desconocido: $e';
  }
}
