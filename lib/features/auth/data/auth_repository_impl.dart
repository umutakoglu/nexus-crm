import 'package:crm/features/auth/domain/auth_repository.dart';
import 'package:crm/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromJson(doc.data()!);
        }
      } catch (e) {
        // Handle error or return null
      }
      return null;
    });
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        // Special check for the main admin
        if (email == 'admin@uakoglu.com' ||
            uid == 'wtZ0T2DBqUhnclLFD7OuOPVcW963') {
          // Force update/create admin user in Firestore
          final adminUser = UserModel(
            id: uid,
            email: email,
            displayName: 'Admin', // Default name
            role: UserRole.admin,
            createdAt: DateTime.now(),
            department: 'Administration',
          );
          await _firestore
              .collection('users')
              .doc(uid)
              .set(adminUser.toJson(), SetOptions(merge: true));
        }

        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromJson(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
    }
    return null;
  }
}
