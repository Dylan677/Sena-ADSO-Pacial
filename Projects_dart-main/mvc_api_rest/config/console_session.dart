import 'dart:io';
import 'dart:convert';

class ConsoleSession {
  static const String _sessionFile = 'session.json';

  // Salve file with session data
  static Future<void> saveSession(String user, String token) async {
    final Map<String, dynamic> session = {
      'user': user,
      'token': token,
      'isLogged': true,
      'lastAccess': DateTime.now().toIso8601String(),
    };

    final File archive = File(_sessionFile);
    await archive.writeAsString(json.encode(session));
  }

  // Load session from archive
  static Future<Map<String, dynamic>?> loadSession() async {
    try {
      final File archive = File(_sessionFile);
      if (await archive.exists()) {
        final content = await archive.readAsString();
        //print('✅ Session loaded successfully for token: ${json.decode(content)['token']}');

        return json.decode(content);
      }
    } catch (e) {
      print('Error cargando sesión: $e');
    }
    return null;
  }

  // Check if there is an active session
  static Future<bool> isLogged() async {
    final session = await loadSession();
    return session != null && session['isLogged'] == true;
  }

  // Close Session (delete archive)
  // static Future<void> closeSession() async {
  //   final File archive = File(_sessionFile);
  //   if (await archive.exists()) {
  //     await archive.delete();
  //   }
  // }
  static Future<void> closeSession() async {
    final session = await loadSession();
    if (session != null && session['isLogged'] == true) {
      final updatedSession = {
        ...session,
        'isLogged': false,
      };
      final File archive = File(_sessionFile);
      await archive.writeAsString(json.encode(updatedSession));
    }
  }
}
