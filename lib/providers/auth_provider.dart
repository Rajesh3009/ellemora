import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  UserModel? build() => null;

  Future<void> login(String username, String password) async {
    state = null; // Reset state
    final api = ref.read(apiServiceProvider);
    
    try {
      final user = await api.login(username, password);
      state = user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  void logout() {
    state = null;
  }
} 