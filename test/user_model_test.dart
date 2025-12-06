import 'package:crm/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('fromJson creates correct UserModel', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'role': 'admin',
        'createdAt': '2023-10-01T12:00:00.000',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.role, UserRole.admin);
      expect(user.createdAt, DateTime(2023, 10, 1, 12, 0, 0));
    });

    test('toJson creates correct Map', () {
      final user = UserModel(
        id: '123',
        email: 'test@example.com',
        displayName: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime(2023, 10, 1, 12, 0, 0),
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['role'], 'admin');
      expect(json['createdAt'], '2023-10-01T12:00:00.000');
    });
  });
}
