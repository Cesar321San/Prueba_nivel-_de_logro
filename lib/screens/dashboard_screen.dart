import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuASDibst-QLz03fGL0l-YCX0f3PMkJ8I3dyF9C39OBGKqpPHMFu2hZJ5TNh0L-qABRmPcf3ApPx4cJmHhIeSfHK6-seqrycAsxC-Q14VttKjIvkzphCAUX-L4K4sgrRVAVT_QgLNi3Ihz2kboKRatdeyQIT1nvaYDh8HXiVCaG2tWdldu1dYbvwh4m3kQhHcVHuIYfgs-lUAMU3M_0HO_iNpEicns4QiHEwOdkZ0CkBa9uND8H2jLW-viU1UaL9Ku5C1YDb52O6W4zN',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Bienvenido, Admin',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // TODO: Implement notifications
                    },
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Asistencia de Hoy',
                            value: '95%',
                            trend: '+2% vs ayer',
                            trendIcon: Icons.arrow_upward,
                            trendColor: Colors.green,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Aprobaciones Pendientes',
                            value: '3',
                            trend: 'Ausencias por revisar',
                            trendColor: Colors.orange,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Quick Actions Title
                    Text(
                      'Acciones Rápidas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action Cards Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: [
                        _ActionCard(
                          icon: Icons.task_alt,
                          title: 'Registrar Asistencia',
                          description: 'Acceder a la pantalla de marcado',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pushNamed(context, '/attendance');
                          },
                        ),
                        _ActionCard(
                          icon: Icons.groups,
                          title: 'Ver Listas',
                          description: 'Ver listas de personal y estudiantes',
                          isDark: isDark,
                          onTap: () {
                            Navigator.pushNamed(context, '/attendance-list');
                          },
                        ),
                        _ActionCard(
                          icon: Icons.bar_chart,
                          title: 'Generar Reportes',
                          description: 'Crear y ver reportes de asistencia',
                          isDark: isDark,
                          onTap: () {
                            // TODO: Navigate to reports
                          },
                        ),
                        _ActionCard(
                          icon: Icons.verified_user,
                          title: 'Gestionar Justificaciones',
                          description: 'Revisar solicitudes de ausencia',
                          isDark: isDark,
                          onTap: () {
                            // TODO: Navigate to justifications
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(currentIndex: 0),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData? trendIcon;
  final Color trendColor;
  final bool isDark;

  const _StatCard({
    required this.title,
    required this.value,
    required this.trend,
    this.trendIcon,
    required this.trendColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.textDark : AppColors.textLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (trendIcon != null) ...[
                Icon(
                  trendIcon,
                  size: 16,
                  color: trendColor,
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  trend,
                  style: TextStyle(
                    color: trendColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard,
                label: 'Panel',
                isActive: currentIndex == 0,
                isDark: isDark,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.description,
                label: 'Reportes',
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
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryLight10 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? AppColors.primary
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
