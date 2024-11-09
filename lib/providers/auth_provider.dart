import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:ellemora/providers/appwrite_provider.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<models.User?>>((ref) {
  final client = ref.watch(clientProvider);
  final account = Account(client);
  return AuthNotifier(account);
});

class AuthNotifier extends StateNotifier<AsyncValue<models.User?>> {
  final Account account;

  AuthNotifier(this.account) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await account.get();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.data(null);
    }
  }

  Future<models.User> signUp({
    required String email,
    required String password,
    required String name,
    String? username,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // After creating the account, create a session
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<models.User> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      
      final user = await account.get();
      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await account.deleteSession(sessionId: 'current');
      state = const AsyncValue.data(null);
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<models.User?> getCurrentUser() async {
    try {
      final user = await account.get();
      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      state = const AsyncValue.data(null);
      return null;
    }
  }
} 