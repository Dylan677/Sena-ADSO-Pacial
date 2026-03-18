import '../controllers/user_status_controller.dart';
import '../models/user_status_model.dart';
import 'dart:io';

class UserStatusView {
  final UserStatusController _controller = UserStatusController();

  onloadView(String token) async {
    await printMenu(token);
  }

  Future<void> printMenu(String token) async {
    bool running = true;
    while (running) {
      print("\n✅ === USER STATUS MODULE ===✅ ");
      print('1. Show User Statuses');
      print('2. Show User Status by ID');
      print('3. Create User Status');
      print('4. Update User Status');
      print('5. Delete User Status');
      print('6. Back');
      stdout.write('Options: ');
      final opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          await showAllUserStatuses(token);
          break;
        case '2':
          stdout.write('Enter User Status ID: ');
          final statusId = int.tryParse(stdin.readLineSync()!) ?? 0;
          if (statusId <= 0) {
            print(
                '❌ Invalid User Status ID. Please enter a positive integer.');
            break;
          }
          await showUserStatusById(statusId, token);
          break;
        case '3':
          stdout.write('Enter User Status Name: ');
          final statusName = stdin.readLineSync()!;
          stdout.write('Enter User Status Description: ');
          final statusDescription = stdin.readLineSync()!;
          Map<String, dynamic> statusData = {
            'name': statusName,
            'description': statusDescription,
          };
          await addUserStatus(token, statusData);
          break;
        case '4':
          stdout.write('Enter User Status ID to Update: ');
          final statusId = int.tryParse(stdin.readLineSync()!) ?? 0;
          stdout.write('Enter new User Status Name: ');
          final statusName = stdin.readLineSync()!;
          stdout.write('Enter new User Status Description: ');
          final statusDescription = stdin.readLineSync()!;
          Map<String, dynamic> statusData = {
            'name': statusName,
            'description': statusDescription,
          };
          await updateUserStatus(token, statusData, statusId);
          break;
        case '5':
          stdout.write('Enter User Status ID to Delete: ');
          final statusId = int.tryParse(stdin.readLineSync()!) ?? 0;
          await deleteUserStatus(token, statusId);
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

  Future<void> showAllUserStatuses(String token) async {
    print('📋 Loading user statuses...');
    List<UserStatus> statuses = await _controller.getAllUserStatuses(token);
    if (statuses.isNotEmpty) {
      print('✅ Found ${statuses.length} user statuses:');
      for (var i = 0; i < statuses.length; i++) {
        print('${i + 1}. ${statuses[i]}');
      }
    } else {
      print('❌ No user statuses found');
    }
  }

  Future<void> showUserStatusById(int id, String token) async {
    print('🔍 Searching user status with ID: $id');
    UserStatus? status = await _controller.getUserStatusById(id, token);
    if (status != null) {
      print(status);
    } else {
      print('❌ User Status not found with ID: $id');
    }
  }

  Future<void> addUserStatus(
      String token, Map<String, dynamic> statusData) async {
    dynamic result = await _controller.createUserStatus(statusData, token);
    if (result != null) {
      print('✅ User Status created successfully:');
      print(result);
    } else {
      print('❌ Could not create user status');
    }
  }

  Future<void> updateUserStatus(
      String token, Map<String, dynamic> statusData, int statusId) async {
    dynamic result =
        await _controller.updateUserStatus(statusData, token, statusId);
    if (result != null) {
      print('✅ User Status updated successfully:');
      print(result);
    } else {
      print('❌ Could not update user status');
    }
  }

  Future<void> deleteUserStatus(String token, int statusId) async {
    dynamic result = await _controller.deleteUserStatus(statusId, token);
    if (result != null) {
      print('✅ User Status deleted successfully');
      print(result);
    } else {
      print('❌ Could not delete user status');
    }
  }
}
