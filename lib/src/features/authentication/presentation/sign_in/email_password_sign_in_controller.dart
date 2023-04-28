import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'email_password_sign_in_state.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController(
      {required EmailPasswordSignInFormType formType,
      required this.authRepository})
      : super(EmailPasswordSignInState(formType: formType));
  final FakeAuthRepository authRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) {
    switch (state.formType) {
      case EmailPasswordSignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(formType: formType, value: AsyncValue.data(null));
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInController, EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, formType) {
  final authRepository = ref.watch(authRepositoryProvider);
  return EmailPasswordSignInController(
      formType: formType, authRepository: authRepository);
});
