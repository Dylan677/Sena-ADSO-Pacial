import '../controllers/auth_controller.dart';
import 'dart:io';

class AuthView {
  final AuthController _controller = AuthController();
  final token = '';

  onloadView(String token) async {
    await printMenu(token);
  }

  Future<Map<String, dynamic>?> validateToken(String token) {
    Map<String, dynamic> tokenData = {
      'token': token,
    };
    return _controller.validateToken(tokenData);
  }

  Future<void> printMenu(String token) async {
    bool running = true;
    while (running) {
      print('\n✅ === LOGIN ===✅ ');
      print('1. Login');
      print('2. Register');
      print('3. Change Password');
      print('4. Exit');
      stdout.write('Options: ');
      final opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          stdout.write('Enter User Email: ');
          final userEmail = stdin.readLineSync()!;
          stdout.write('Enter User Password: ');
          final userPassword = stdin.readLineSync()!;
          Map<String, dynamic> userData = {
            'api_user': userEmail,
            'api_password': userPassword,
          };
          String loginToken = await loginUser(userData);
          if (loginToken.isNotEmpty) {
            running = false; // Exit menu after successful login
          }
          break;
        case '2':
          await registerUser();
          break;
        case '3':
          print('🔒 Change Password feature is not implemented yet.');
          break;
        case '4':
          print('👋 ¡Good bye!');
          running = false;
          return;
        default:
          print('❌ Invalid option, try again.');
      }
    }
  }

  // Method to handle user login
  Future<String> loginUser(Map<String, dynamic> userData) async {
    print('🔍 Buscando usuario con datos: $userData');

    String token = await _controller.login(userData);
    if (token.isNotEmpty) {
      print('✅ Login successful. Token: $token');
      return token;
    } else {
      print('❌ Login failed. Please check your credentials and try again.');
      return '';
    }
  }

  // Method to handle user registration
  Future<void> registerUser() async {
    print('\n📝 === REGISTER NEW API USER ===');
    stdout.write('Enter Email: ');
    final userEmail = stdin.readLineSync()!;
    stdout.write('Enter Password: ');
    final userPassword = stdin.readLineSync()!;
    stdout.write('Enter Role (Admin / Read-only): ');
    final userRole = stdin.readLineSync()!;
    stdout.write('Enter Status (Active / Inactive): ');
    final userStatus = stdin.readLineSync()!;

    Map<String, dynamic> userData = {
      'user': userEmail,
      'password': userPassword,
      'role': userRole,
      'status': userStatus,
    };

    print('🔍 Registering user...');
    Map<String, dynamic>? result = await _controller.register(userData);
    if (result != null) {
      print('✅ User registered successfully!');
      print('   Data: $result');
      print('   You can now login with your credentials.');
    } else {
      print('❌ Registration failed. Please try again.');
    }
  }
}
