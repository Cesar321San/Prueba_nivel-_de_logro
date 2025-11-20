import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';

class AttendanceRegistrationScreen extends StatefulWidget {
  const AttendanceRegistrationScreen({super.key});

  @override
  State<AttendanceRegistrationScreen> createState() => _AttendanceRegistrationScreenState();
}

class _AttendanceRegistrationScreenState extends State<AttendanceRegistrationScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String _selectedUser = 'Esther Howard';
  String _lastClockIn = '08:02 AM';
  String _status = 'Trabajando';
  bool _isClockedIn = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  void _handleClockInOut() {
    setState(() {
      _isClockedIn = !_isClockedIn;
      if (_isClockedIn) {
        _lastClockIn = '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')} ${_currentTime.hour >= 12 ? 'PM' : 'AM'}';
        _status = 'Trabajando';
      } else {
        _status = 'Fuera';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isClockedIn ? 'Entrada registrada exitosamente' : 'Salida registrada exitosamente'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUserSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Usuario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCnjXoJS4lbBy9AS-_nJD0mLmL_R4iA5p9EJ6dcu6XhJ1laTbk1BSDz_pLyApQjUgzy_ILHVjpRZMWP9yM2H2-BlCy0uySdNb3D9OyH-cDxVHm-VecilgAm6v7Fw6w22B2MHISDvbTmbNBLKoXy8pGdKyfHy39VRBNWqmEJUwrJo4iUV05dSqPmd-o0e0FbW6KEtgLT0xPbWL_zVgnEfJtGTI0Ej6yk8pmzm50bAzbSARSokRWu5Bh57sr8UuscK2MQ_dMpuHvTcIuN',
                  ),
                ),
                title: const Text('Esther Howard'),
                onTap: () {
                  setState(() {
                    _selectedUser = 'Esther Howard';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('Juan Pérez'),
                onTap: () {
                  setState(() {
                    _selectedUser = 'Juan Pérez';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('María García'),
                onTap: () {
                  setState(() {
                    _selectedUser = 'María García';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBAqRuHqKEKVHL_53S_rBafh3R5mWJkqkHm33fNIrhy9RcZ7dsD3AJFAjYv52UwSTtOab3p7vW-2V1g3b1kMl98bROrVXHHMjdegrc6aIlWBZZi-IvgyJVUZ4LV5E3dAh5Bv3RWxqNyZw9VN7cckE0DoUaiE8iXOoBt3zo2BE-Ec63NAdiPnRANkf9nMgZiiOcatcH7P06Hx0k8-PY0dykpnmbaV6HcwCnInebNyTpwaVDYqQLKn3Y1nzOLW_4JNIx6WmkAVj6kuUwI',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Registro de Asistencia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // User Selection
                    InkWell(
                      onTap: _showUserSelector,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1A2233) : const Color(0xFFF4F7FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCnjXoJS4lbBy9AS-_nJD0mLmL_R4iA5p9EJ6dcu6XhJ1laTbk1BSDz_pLyApQjUgzy_ILHVjpRZMWP9yM2H2-BlCy0uySdNb3D9OyH-cDxVHm-VecilgAm6v7Fw6w22B2MHISDvbTmbNBLKoXy8pGdKyfHy39VRBNWqmEJUwrJo4iUV05dSqPmd-o0e0FbW6KEtgLT0xPbWL_zVgnEfJtGTI0Ej6yk8pmzm50bAzbSARSokRWu5Bh57sr8UuscK2MQ_dMpuHvTcIuN',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _selectedUser,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.unfold_more,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Digital Clock
                    Text(
                      _formatTime(_currentTime),
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Date
                    Text(
                      _formatDate(_currentTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.history,
                            title: 'Última Entrada',
                            value: _lastClockIn,
                            iconColor: AppColors.primary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.work,
                            title: 'Estado',
                            value: _status,
                            iconColor: _isClockedIn ? Colors.green : Colors.orange,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // Clock In/Out Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _handleClockInOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isClockedIn ? Colors.red : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    _isClockedIn ? 'Marcar Salida' : 'Marcar Entrada',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(currentIndex: 0, isDark: isDark),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final bool isDark;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2233) : const Color(0xFFF4F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;

  const _BottomNavBar({
    required this.currentIndex,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2233) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Inicio',
              isActive: currentIndex == 0,
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _NavItem(
              icon: Icons.event_note,
              label: 'Historial',
              isActive: currentIndex == 1,
              isDark: isDark,
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.person,
              label: 'Perfil',
              isActive: currentIndex == 2,
              isDark: isDark,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive
                ? AppColors.primary
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? AppColors.primary
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
