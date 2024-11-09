import 'package:ellemora/models/product_model.dart';
import 'package:ellemora/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.getAllProducts();
  return response;
});
