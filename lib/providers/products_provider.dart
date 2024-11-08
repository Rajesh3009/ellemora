import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';

part 'products_provider.g.dart';

@riverpod
Stream<List<Product>> products(ProductsRef ref) async* {
  final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final products = jsonData.map((json) => Product.fromJson(json)).toList();
    yield products;
  } else {
    throw Exception('Failed to load products');
  }
} 