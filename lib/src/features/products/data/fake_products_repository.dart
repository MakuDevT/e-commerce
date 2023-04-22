import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  //Future are for REST API
  //Stream are for real time

  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception("Error Error Error");
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    // return Stream.value(_products);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  Future<Product?> fetchProduct(String id) async {
    final product = await fetchProductsList();
    final matchingProduct = product.firstWhere((product) => product.id == id);
    return matchingProduct;
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  // debugPrint('created productListStreamProvider');
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProductsList();
});
final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  // debugPrint('created productListFutureProvider');
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.fetchProductsList();
});

final productStreamProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  // debugPrint('created productProvider with id: $id');
  // ref.onDispose(() {
  //   debugPrint("Disposed Product Stream Provider");
  // });
  // final link = ref.keepAlive();
  // Timer(const Duration(seconds: 30), () {
  //   link.close();
  // });
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProduct(id);
});

final productFutureProvider =
    FutureProvider.autoDispose.family<Product?, String>((ref, id) {
  debugPrint('created productProvider with id: $id');
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.fetchProduct(id);
});
