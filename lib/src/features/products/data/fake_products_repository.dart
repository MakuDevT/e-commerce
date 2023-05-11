import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  final bool addDelay;

  //Future are for REST API
  //Stream are for real time

  final List<Product> _products = kTestProducts;

  FakeProductsRepository({this.addDelay = true});

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    // try {
    //   return _products.firstWhere(
    //     (product) => product.id == id,
    //   );
    // } catch (e) {
    //   return null;
    // }
    return _getProduct(_products, id);
  }

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay);

    // throw Exception("Error Error Error");
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await delay(addDelay);
    // return Stream.value(_products);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  Future<Product?> fetchProduct(String id) async {
    final product = await fetchProductsList();
    final matchingProduct = product.firstWhere((product) => product.id == id);
    return matchingProduct;
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere(
        (product) => product.id == id,
      );
    } catch (e) {
      return null;
    }
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
