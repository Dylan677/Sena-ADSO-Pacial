import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import 'dart:io';

class UserView {
  final UserController _controller = UserController();
  onloadView(String token) async {
    await printMenu(token);
  }

  Future<void> printMenu(String token) async {
    bool running = true;
    while (running) {
      print("\n✅ === USER MODULE ===✅ ");
      print('1. Show Users');
      print('2. Show User by ID');
      print('3. Create User');
      print('4. Update User');
      print('5. Delete User');
      print('6. Back');
      stdout.write('Options: ');
      final opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          await showAllUsers(token);
          break;
        case '2':
          stdout.write('Enter User ID: ');
          final userId = int.tryParse(stdin.readLineSync()!) ?? 0;
          if (userId <= 0) {
            print('❌ Invalid User ID. Please enter a positive integer.');
            break;
          }
          await showUserById(userId, token);
          break;
        case '3':
          stdout.write('Enter User Name: ');
          final userName = stdin.readLineSync()!;
          stdout.write('Enter User Email: ');
          final userEmail = stdin.readLineSync()!;
          stdout.write('Enter User Password: ');
          final userPassword = stdin.readLineSync()!;
          stdout.write('Enter User Role (integer): ');
          final userRole = int.tryParse(stdin.readLineSync()!) ?? 0;
          stdout.write('Enter User Status (integer): ');
          final userStatus = int.tryParse(stdin.readLineSync()!) ?? 0;
          Map<String, dynamic> userData = {
            'user': userName,
            'email': userEmail,
            'password': userPassword,
            'role': userRole,
            'status': userStatus,
          };
          await addUsers(token, userData);
          break;
        case '4':
          stdout.write('Enter User ID: ');
          final userId = int.tryParse(stdin.readLineSync()!) ?? 0;
          stdout.write('Enter User Name to Update: ');
          final userName = stdin.readLineSync()!;
          stdout.write('Enter update status (integer): ');
          final userStatus = int.tryParse(stdin.readLineSync()!) ?? 0;
          stdout.write('Enter update role (integer): ');
          final userRole = int.tryParse(stdin.readLineSync()!) ?? 0;

          Map<String, dynamic> userData = {
            'user': userName,
            'status': userStatus,
            'role': userRole,
          };
          await updateUsers(token, userData, userId);
          break;
        case '5':
          stdout.write('Enter User ID to Delete: ');
          final userId = int.tryParse(stdin.readLineSync()!) ?? 0;
          await deleteUsers(token, userId);
          break;
        case '6':
          print('👋 Back to main menu');
          running = false;
          break;
        default:
          print('❌ Invalid option, try again.');
      }
    }
  }

  // Método para mostrar un usuario específico
  Future<void> showUserById(int id, String token) async {
    print('🔍 Buscando usuario con ID: $id');

    List<User?> users = await _controller.getUserById(id, token);

    if (users.isNotEmpty && users[0] != null) {
      User user = users[0]!;
      print(user);
    } else {
      print('❌ No se encontró el usuario con ID: $id');
    }
  }

  // Método para mostrar todos los usuarios
  Future<void> showAllUsers(String token) async {
    print('📋 Cargando lista de usuarios...');
    List<User> users = await _controller.getAllUsers(token);
    if (users.isNotEmpty) {
      print('✅ Se encontraron ${users.length} usuarios:');
      for (var i = 0; i < users.length; i++) {
        print('${i + 1}. ${users[i]}');
      }
    } else {
      print('❌ No hay usuarios para mostrar');
    }
  }

  // Método para crear un nuevo usuario
  Future<void> addUsers(String token, Map<String, dynamic> userData) async {
    dynamic users = await _controller.createUser(userData, token);
    if (users != null) {
      print('✅ Se creó el usuario correctamente:');
      print(users);
    } else {
      print('❌ No se pudo crear el usuario');
    }
  }

  // Método para actualizar un usuario existente
  Future<void> updateUsers(
      String token, Map<String, dynamic> userData, int userId) async {
    dynamic users = await _controller.updateUser(userData, token, userId);
    if (users != null) {
      print('✅ Se actualizó el usuario correctamente:');
      print(users);
    } else {
      print('❌ No se pudo actualizar el usuario');
    }
  }

  // Método para eliminar un usuario existente
  Future<void> deleteUsers(String token, int userId) async {
    dynamic users = await _controller.deleteUser(userId, token);
    if (users != null) {
      print('✅ Se eliminó el usuario correctamente:');
      print(users);
    } else {
      print('❌ No se pudo eliminar el usuario');
    }
  }
}
