import 'package:ellemora/config/appwrite_config.dart';
import 'package:ellemora/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

final clientProvider = Provider<Client>((ref) {
  Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')  // Your Appwrite Endpoint
    .setProject(AppwriteConfig.projectId);               // Your project ID
  return client;
});

final databaseProvider = Provider<Databases>((ref) {
  final client = ref.watch(clientProvider);
  return Databases(client);
});

final userIdProvider = Provider<String>((ref) {
  final user = ref.watch(authStateProvider);
  return user.when(
    data: (user) => user?.$id ?? '',
    error: (_, __) => '',
    loading: () => '',
  );
}); 