import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductModel>>>((ref) {
  final apiService = ApiService();
  return ProductsNotifier(apiService);
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ApiService _apiService;

  ProductsNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncValue.loading();
      final products = await _apiService.getAllProducts();
      state = AsyncValue.data(products);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
