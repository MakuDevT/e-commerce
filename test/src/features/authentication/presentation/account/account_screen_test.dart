import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../auth_robot.dart';

//TODO: Refactor the mock methods to robots
void main() {
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout, success', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await tester.runAsync(() async {
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
    });
    r.expectLogoutDialogNotFound();
    r.expectErrorNotAlertFound();
  });
  testWidgets('Confirm logout failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection Failed');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertFound();
  });
  testWidgets('Confirm logout loading state', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    when(authRepository.signOut).thenAnswer(
      (_) => Future.delayed(const Duration(seconds: 1)),
    );
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await r.pumpAccountScreen(authRepository: authRepository);
    await tester.runAsync(() async {
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
    });
    r.expectCircularProgressIndicator();
  });
}

/////// Code For Non Robot Widget Test ////////
// // pump
// await tester.pumpWidget(
//   const ProviderScope(
//     child: MaterialApp(
//       home: AccountScreen(),
//     ),
//   ),
// );
// // find logout button and tap it
// final logoutButton = find.text('Logout');
// expect(logoutButton, findsOneWidget);
// await tester.tap(logoutButton);
// await tester.pump();

// // expect that the logout dialog is presented
// final dialogTitle = find.text('Are you sure?');
// expect(dialogTitle, findsOneWidget);

// // find cancel button and tap it
// final cancelButton = find.text('Cancel');
// expect(cancelButton, findsOneWidget);
// await tester.tap(cancelButton);
// // await tester.pump();

// // expect that the logout dialog is no longer visible
// // expect(dialogTitle, findsNothing);
