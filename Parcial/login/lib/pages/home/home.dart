import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../../widgets/navigation_drawer.dart';
import '../../widgets/navigation_bottom.dart';
import '../user/user.dart';
import '../auth/change_password.dart';
import '../auth/login.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String password;
  final String role;

  const HomeScreen({
    super.key,
    required this.username,
    required this.password,
    required this.role,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(username: widget.username, role: widget.role),
      UserScreen(username: widget.username, password: widget.password, role: widget.role),
      const ChangePasswordScreen(),
    ];
  }

  void _onDrawerItemSelected(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: _getTitle(),
        showBackButton: false,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: CustomDrawer(
        username: widget.username,
        onItemSelected: _onDrawerItemSelected,
        onLogout: _logout,
        currentIndex: _currentIndex,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Inicio';
      case 1:
        return 'Perfil';
      case 2:
        return 'Configuracion';
      default:
        return 'Mi App';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeContent — bienvenida + resumen del sistema
// ─────────────────────────────────────────────────────────────────────────────
class HomeContent extends StatelessWidget {
  final String username;
  final String role;

  const HomeContent({super.key, required this.username, required this.role});

  Color _getRoleColor(String r) {
    switch (r.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'client':
        return Colors.blue;
      case 'test':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // ── Bienvenida ────────────────────────────────────────────────────────
        Text(
          'Bienvenido, $username!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Chip(
          avatar: const Icon(Icons.admin_panel_settings, size: 18),
          label: Text(
            'Rol: $role',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: _getRoleColor(role).withOpacity(0.15),
          side: BorderSide(color: _getRoleColor(role), width: 1.5),
        ),
        const SizedBox(height: 28),

        // ── Tarjetas de estadísticas ──────────────────────────────────────────
        const Text(
          'Resumen del sistema',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(icon: Icons.people, label: 'Usuarios', value: '12', color: Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: Icons.check_circle, label: 'Activos', value: '9', color: Colors.green)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(icon: Icons.warning_amber_rounded, label: 'Inactivos', value: '3', color: Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: Icons.bar_chart, label: 'Módulos', value: '8', color: Colors.purple)),
          ],
        ),
        const SizedBox(height: 24),

        // ── Accesos rápidos ───────────────────────────────────────────────────
        const Text(
          'Accesos rápidos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Gestión de perfil'),
                  subtitle: Text('Actualiza tu información personal'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.lock_reset, color: Colors.orange),
                  title: Text('Cambiar contraseña'),
                  subtitle: Text('Mantén tu cuenta segura'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.purple),
                  title: Text('Soporte'),
                  subtitle: Text('¿Necesitas ayuda?'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatCard — tarjeta de estadística reutilizable
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
