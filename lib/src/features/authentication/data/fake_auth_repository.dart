import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/delay.dart';
import '../domain/app_user.dart';

//Fake authentication system
class FakeAuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  //This method observers state changes
  Stream<AppUser?> authStateChanges() => _authState.stream;
  //This is use to read the current state just once: null or not
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    _createNewUser(email);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);

    _createNewUser(email);
  }

  Future<void> signOut() async {
    await delay(addDelay);
    // throw Exception('Connection Failed');
    _authState.value = null;
  }

  void dispose() => {_authState.close()};

  void _createNewUser(String email) {
    _authState.value =
        AppUser(uid: email.split('').reversed.join(), email: email);
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() {
    auth.dispose();
  });
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>(((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}));
