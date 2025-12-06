
import 'package:crm/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}
