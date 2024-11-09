import 'package:appwrite/appwrite.dart';
import '../config/appwrite_config.dart';
import '../models/user_model.dart';

class AppwriteService {
  late final Client client;
  late final Account account;
  late final Databases databases;

  AppwriteService() {
    client = Client().setProject(AppwriteConfig.projectId);
    account = Account(client);
    databases = Databases(client);
  }

  Future<UserModel> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // Create session (login)
      await account.createEmailPasswordSession(email: email, password: password);

      return UserModel.fromJson(response.toMap());
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await account.get();
      return UserModel.fromJson(user.toMap());
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await account.get();
      return UserModel.fromJson(user.toMap());
    } catch (e) {
      return null;
    }
  }
}
