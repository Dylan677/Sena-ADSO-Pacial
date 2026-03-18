import '../controllers/role_controller.dart';
import '../models/role_model.dart';
import 'dart:io';

class RoleView {
  final RoleController _controller = RoleController();

  onloadView(String token) async {
    await printMenu(token);
  }

  Future<void> printMenu(String token) async {
    bool running = true;
    while (running) {
      print("\n✅ === ROLE MODULE ===✅ ");
      print('1. Show Roles');
      print('2. Show Role by ID');
      print('3. Create Role');
      print('4. Update Role');
      print('5. Delete Role');
      print('6. Back');
      stdout.write('Options: ');
      final opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          await showAllRoles(token);
          break;
        case '2':
          stdout.write('Enter Role ID: ');
          final roleId = int.tryParse(stdin.readLineSync()!) ?? 0;
          if (roleId <= 0) {
            print('❌ Invalid Role ID. Please enter a positive integer.');
            break;
          }
          await showRoleById(roleId, token);
          break;
        case '3':
          stdout.write('Enter Role Name: ');
          final roleName = stdin.readLineSync()!;
          stdout.write('Enter Role Description: ');
          final roleDescription = stdin.readLineSync()!;
          Map<String, dynamic> roleData = {
            'name': roleName,
            'description': roleDescription,
          };
          await addRole(token, roleData);
          break;
        case '4':
          stdout.write('Enter Role ID to Update: ');
          final roleId = int.tryParse(stdin.readLineSync()!) ?? 0;
          stdout.write('Enter new Role Name: ');
          final roleName = stdin.readLineSync()!;
          stdout.write('Enter new Role Description: ');
          final roleDescription = stdin.readLineSync()!;
          Map<String, dynamic> roleData = {
            'name': roleName,
            'description': roleDescription,
          };
          await updateRole(token, roleData, roleId);
          break;
        case '5':
          stdout.write('Enter Role ID to Delete: ');
          final roleId = int.tryParse(stdin.readLineSync()!) ?? 0;
          await deleteRole(token, roleId);
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

  Future<void> showAllRoles(String token) async {
    print('📋 Loading roles...');
    List<Role> roles = await _controller.getAllRoles(token);
    if (roles.isNotEmpty) {
      print('✅ Found ${roles.length} roles:');
      for (var i = 0; i < roles.length; i++) {
        print('${i + 1}. ${roles[i]}');
      }
    } else {
      print('❌ No roles found');
    }
  }

  Future<void> showRoleById(int id, String token) async {
    print('🔍 Searching role with ID: $id');
    Role? role = await _controller.getRoleById(id, token);
    if (role != null) {
      print(role);
    } else {
      print('❌ Role not found with ID: $id');
    }
  }

  Future<void> addRole(String token, Map<String, dynamic> roleData) async {
    dynamic result = await _controller.createRole(roleData, token);
    if (result != null) {
      print('✅ Role created successfully:');
      print(result);
    } else {
      print('❌ Could not create role');
    }
  }

  Future<void> updateRole(
      String token, Map<String, dynamic> roleData, int roleId) async {
    dynamic result = await _controller.updateRole(roleData, token, roleId);
    if (result != null) {
      print('✅ Role updated successfully:');
      print(result);
    } else {
      print('❌ Could not update role');
    }
  }

  Future<void> deleteRole(String token, int roleId) async {
    dynamic result = await _controller.deleteRole(roleId, token);
    if (result != null) {
      print('✅ Role deleted successfully');
      print(result);
    } else {
      print('❌ Could not delete role');
    }
  }
}
