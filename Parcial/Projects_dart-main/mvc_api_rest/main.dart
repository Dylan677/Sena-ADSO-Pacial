import 'config/console_session.dart';
import './views/user_view.dart';
import './views/auth_view.dart';
import './views/role_view.dart';
import './views/user_status_view.dart';
import 'dart:io';

void main() async {
  clearScreen();
  await menuLogin();
}

void clearScreen() {
  if (Platform.isWindows) {
    // For Windows systems, use the 'cls' command
    Process.runSync('cls', [], runInShell: true);
  } else {
    // For Unix-like systems, use ANSI escape codes to clear the screen
    stdout.write('\x1B[2J\x1B[0;0H');
  }
}

Future<void> menuLogin() async {
  AuthView authView = AuthView();
  if (await ConsoleSession.isLogged()) {
    final session = await ConsoleSession.loadSession();
    clearScreen();
    print('✅  Welcome back! ✅ ');
    Map<String, dynamic>? validatedSession =
        await authView.validateToken(session!['token'] ?? '');
    if (validatedSession == null) {
      print('⚠️ Session expired. Please log in again. ⚠️');
      await ConsoleSession.closeSession();
      await authView.onloadView('');
      // After login/register, check if now logged in
      await menuLogin();
      return;
    } else {
      print(
          '✅ Session is valid. Welcome back, ${validatedSession['user']}! ✅');
      await activeSessionMenu(session);
    }
  } else {
    print('👋 No active session. Please log in.');
    await authView.onloadView('');
    // After login/register, check if now logged in
    if (await ConsoleSession.isLogged()) {
      await menuLogin();
    }
  }
}

Future<void> activeSessionMenu(Map<String, dynamic>? session) async {
  bool running = true;
  while (running) {
    clearScreen();
    print('\n✅ === ACTIVE LOGIN ===✅ ');
    print('user: ${session!['user']}');
    print('1. Module Users');
    print('2. Module Roles');
    print('3. Module Users Status');
    print('4. Close Session');
    print('5. Exit');
    stdout.write('Options: ');
    final opcion = stdin.readLineSync();
    switch (opcion) {
      case '1':
        print('📋 Users module');
        UserView userView = UserView();
        await userView.onloadView(session['token']);
        break;
      case '2':
        print('📋 Roles module');
        RoleView roleView = RoleView();
        await roleView.onloadView(session['token']);
        break;
      case '3':
        print('📋 User Status module');
        UserStatusView userStatusView = UserStatusView();
        await userStatusView.onloadView(session['token']);
        break;
      case '4':
        await ConsoleSession.closeSession();
        print('👋 Session closed');
        running = false;
        break;
      case '5':
        print('👋 ¡Good bye!');
        running = false;
        break;
    }
  }
}
