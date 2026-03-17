import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/appbar.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();

  bool _isLoading = false;
  bool _showAdminCode = false; // Muestra el campo solo si elige Admin

  // Código secreto requerido para el rol Admin
  static const String _adminSecret = '123698745';

  final Map<String, int> _roles = {
    'Admin': 1,
    'Client': 2,
    'Test': 4,
  };
  String? _selectedRole;

  Future<void> _registrer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un rol'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar código admin
    if (_selectedRole == 'Admin' &&
        _adminCodeController.text != _adminSecret) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Código de administrador incorrecto'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final baseUrl = kIsWeb ? 'localhost' : '10.0.2.2';
      final url = Uri.parse('http://$baseUrl:3000/api_v1/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'status': 1,
          'role': _roles[_selectedRole],
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Usuario registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        final userData = {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'Rol': _selectedRole ?? '',
        };
        Navigator.pop(context, userData);
      } else {
        final body = jsonDecode(response.body);
        final errorMsg = body['error'] ?? 'Error desconocido';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $errorMsg'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Registrar usuario',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset('assets/img/logos/stamp.webp', height: 100),
              const SizedBox(height: 20),

              // Usuario
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingrese un usuario' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese un email';
                  if (!v.contains('@')) return 'Correo no válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contraseña
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese una contraseña';
                  if (v.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Confirme su contraseña' : null,
              ),
              const SizedBox(height: 16),

              // Selector de rol
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  prefixIcon: Icon(Icons.admin_panel_settings),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seleccione un rol'),
                items: _roles.keys.map((roleName) {
                  return DropdownMenuItem<String>(
                    value: roleName,
                    child: Row(
                      children: [
                        Icon(
                          roleName == 'Admin'
                              ? Icons.verified_user
                              : roleName == 'Client'
                                  ? Icons.person
                                  : Icons.science,
                          size: 18,
                          color: roleName == 'Admin'
                              ? Colors.red
                              : roleName == 'Client'
                                  ? Colors.blue
                                  : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(roleName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                    _showAdminCode = value == 'Admin';
                    if (!_showAdminCode) _adminCodeController.clear();
                  });
                },
                validator: (v) =>
                    (v == null) ? 'Seleccione un rol' : null,
              ),

              // Campo de código Admin (solo aparece si elige Admin)
              if (_showAdminCode) ...[
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red.shade700, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Acceso restringido',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _adminCodeController,
                        decoration: InputDecoration(
                          labelText: 'Código de administrador',
                          prefixIcon: Icon(Icons.key,
                              color: Colors.red.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade700, width: 2),
                          ),
                        ),
                        obscureText: true,
                        validator: (v) {
                          if (_selectedRole == 'Admin') {
                            if (v == null || v.isEmpty) {
                              return 'Ingrese el código de administrador';
                            }
                            if (v != _adminSecret) {
                              return '❌ Código incorrecto';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registrer,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Registrar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _cancel,
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
