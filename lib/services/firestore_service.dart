import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users/employees
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection('users')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Get user by employee ID
  Future<UserModel?> getUserByEmployeeId(String employeeId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('employeeId', isEqualTo: employeeId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return UserModel.fromMap(doc.data(), doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user by employee ID: $e');
      return null;
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Search users by name
  Future<List<UserModel>> searchUsersByName(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('name')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Get employees only (exclude admins)
  Stream<List<UserModel>> getEmployees() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get total employee count
  Future<int> getEmployeeCount() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'employee')
          .count()
          .get();
      return querySnapshot.count ?? 0;
    } catch (e) {
      print('Error getting employee count: $e');
      return 0;
    }
  }
}
