import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastCartRepository implements LocalCartRepository {
  final Database db;
  final store = StoreRef.main();

  SembastCartRepository(this.db);
  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  //simple helper method that we can use to create a default database
  static Future<SembastCartRepository> makeDefault() async {
    return SembastCartRepository(await createDatabase('default.db'));
  }

  static const cartItemsKey = 'cartItems';
  @override
  Future<Cart> fetchCart() async {
    final cartJson = await store.record(cartItemsKey).get(db) as String?;
    if (cartJson != null) {
      return Cart.fromJson(cartJson);
    } else {
      return const Cart();
    }
  }

  @override
  Future<void> setCart(Cart cart) {
    // TODO: implement setCart
    throw UnimplementedError();
  }

  @override
  Stream<Cart> watchCart() {
    //This a method that gives us a snapshot every time the data changes
    //We need to convert the snapshot's value from dynamic to Cart
    final record = store.record(cartItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Cart.fromJson(snapshot.value as String);
      } else {
        return const Cart();
      }
    });
  }
}
