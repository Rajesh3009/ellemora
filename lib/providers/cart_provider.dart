import 'package:ellemora/config/appwrite_config.dart';
import 'package:ellemora/providers/appwrite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  final String? id; // Appwrite document ID

  CartItem({
    required this.product,
    this.quantity = 1,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'price': product.price,
      'productName': product.title, // Changed from name to title
      // Add other product fields you want to store
    };
  }

  static CartItem fromMap(Map<String, dynamic> map, String docId) {
    return CartItem(
      product: ProductModel(
        id: map['productId'],
        title: map['productName'],
        price: map['price'],
        description: map['description'] ?? '',
        category: map['category'] ?? '',
        image: map['image'] ?? '',
        // Map other product fields
      ),
      quantity: map['quantity'],
      id: docId,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  final Databases databases;
  final String userId;
  static const String databaseId = AppwriteConfig.databaseId; 
  static const String collectionId = AppwriteConfig.collectionId;

  CartNotifier({required this.databases, required this.userId}) : super([]) {
    // Load cart items when initialized
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('userId', userId),
        ],
      );

      final items = response.documents.map((doc) {
        return CartItem.fromMap(doc.data, doc.$id);
      }).toList();

      state = items;
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  Future<void> addItem(ProductModel product) async {
    try {
      final existingIndex =
          state.indexWhere((item) => item.product.id == product.id);

      if (existingIndex >= 0) {
        // Update quantity in Appwrite
        final item = state[existingIndex];
        final newQuantity = item.quantity + 1;

        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: item.id!,
          data: {
            'quantity': newQuantity,
          },
        );

        state = state.map((item) {
          if (item.product.id == product.id) {
            return CartItem(
                product: item.product, quantity: newQuantity, id: item.id);
          }
          return item;
        }).toList();
      } else {
        // Create new cart item in Appwrite
        final doc = await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: {
            'userId': userId,
            ...CartItem(product: product).toMap(),
          },
        );

        state = [...state, CartItem(product: product, id: doc.$id)];
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> removeItem(ProductModel product) async {
    try {
      final item = state.firstWhere((item) => item.product.id == product.id);

      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: item.id!,
      );

      state = state.where((item) => item.product.id != product.id).toList();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> updateQuantity(ProductModel product, int quantity) async {
    if (quantity <= 0) {
      await removeItem(product);
      return;
    }

    try {
      final item = state.firstWhere((item) => item.product.id == product.id);

      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: item.id!,
        data: {
          'quantity': quantity,
        },
      );

      state = state.map((item) {
        if (item.product.id == product.id) {
          return CartItem(
              product: item.product, quantity: quantity, id: item.id);
        }
        return item;
      }).toList();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  double get total {
    return state.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier(
    databases: ref.watch(databaseProvider),
    userId: ref.watch(userIdProvider),
  );
});
