import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';

class UserScreen extends StatelessWidget {
  final String username;
  final String password;
  final String role;

  const UserScreen({
    super.key,
    required this.username,
    required this.password,
    required this.role,
  });

  Color get _roleColor {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'client':
        return Colors.blue;
      case 'test':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData get _roleIcon {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.verified_user;
      case 'client':
        return Icons.person;
      case 'test':
        return Icons.science;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mi Perfil',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabecera con color dinámico según rol
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_roleColor.withOpacity(0.8), _roleColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: Icon(_roleIcon, size: 56, color: _roleColor),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Badge de rol
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white60, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_roleIcon, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          role,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tarjeta de información
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 4),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        icon: Icons.person,
                        label: 'Usuario',
                        value: username,
                        iconColor: Colors.indigo,
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      _buildInfoTile(
                        icon: Icons.lock_outline,
                        label: 'Contraseña',
                        value: '${'•' * password.length} (${password.length} caracteres)',
                        iconColor: Colors.teal,
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      _buildInfoTile(
                        icon: _roleIcon,
                        label: 'Rol asignado',
                        value: role,
                        iconColor: _roleColor,
                        valueBold: true,
                        valueColor: _roleColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool valueBold = false,
    Color? valueColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: iconColor.withOpacity(0.12),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
          color: valueColor ?? Colors.black87,
        ),
      ),
    );
  }
}
