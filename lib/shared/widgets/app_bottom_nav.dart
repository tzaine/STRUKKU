// lib/shared/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strukku/core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const AppBottomNav({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/analytics')) return 2;
    if (location.startsWith('/reminders')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _locationToIndex(currentLocation);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              iconFilled: Icons.home_rounded,
              label: 'Home',
              selected: currentIndex == 0,
              onTap: () => context.go('/home'),
            ),
            _NavItem(
              icon: Icons.receipt_long_outlined,
              iconFilled: Icons.receipt_long_rounded,
              label: 'Riwayat',
              selected: currentIndex == 1,
              onTap: () => context.go('/history'),
            ),

            // ─── FAB Camera ───────────────────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: () => context.go('/camera'),
                onLongPress: () async {
                  // Long press → gallery picker
                  context.go('/camera');
                },
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),

            _NavItem(
              icon: Icons.bar_chart_outlined,
              iconFilled: Icons.bar_chart_rounded,
              label: 'Analitik',
              selected: currentIndex == 2,
              onTap: () => context.go('/analytics'),
            ),
            _NavItem(
              icon: Icons.notifications_outlined,
              iconFilled: Icons.notifications_rounded,
              label: 'Reminder',
              selected: currentIndex == 3,
              onTap: () => context.go('/reminders'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconFilled;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconFilled,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                selected ? iconFilled : icon,
                key: ValueKey(selected),
                size: 24,
                color: selected ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
