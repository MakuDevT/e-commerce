@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  group('submit', () {
    test(
      ''' 
    Given formType is signIn 
    When signInWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
     ''',
      () async {
        //setup
        final authRepository = MockAuthRepository();

        when(() => authRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer((_) => Future.value());

        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );

        //expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            ),
          ]),
        );
        //run
        final result = await controller.submit(testEmail, testPassword);
        //verify
        expect(result, true);
      },
    );

    test(
      ''' 
    Given formType is register 
    When createUserWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
     ''',
      () async {
        //setup
        final authRepository = MockAuthRepository();

        when(() => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer((_) => Future.value());

        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );

        //expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null),
            ),
          ]),
        );
        //run
        final result = await controller.submit(testEmail, testPassword);
        //verify
        expect(result, true);
      },
    );

    test(
      ''' 
    Given formType is register 
    When createUserWithEmailAndPassword fails
    Then return false
    And state is AsyncError
     ''',
      () async {
        //setup
        final authRepository = MockAuthRepository();
        final exception = Exception('Connection Failed');
        when(() => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenThrow(exception);

        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );

        //expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.register);
              expect(state.value.hasError, true);
              return true;
            })
          ]),
        );
        //run
        final result = await controller.submit(testEmail, testPassword);
        //verify
        expect(result, false);
      },
    );
  });
  group('updateFormType', () {
    test(
      ''' 
    Given formType is signIn 
    When called with register
    Then state.formType is
  
     ''',
      () async {
        //setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );
        //run
        controller.updateFormType(EmailPasswordSignInFormType.register);
        //run
        expect(
            controller.debugState,
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncData(null)));
      },
    );

    test(
      ''' 
    Given formType is register 
    When called with signIn 
    Then state.formType is signIn
   
     ''',
      () async {
        //setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );
        //run
        controller.updateFormType(EmailPasswordSignInFormType.signIn);
        //run
        expect(
            controller.debugState,
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncData(null)));
      },
    );
  });
}
