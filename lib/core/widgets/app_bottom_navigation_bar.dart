import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/theme/themes.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/presentation/widgets/auth_dialog.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return ListenableBuilder(
      listenable: router.routerDelegate,
      builder: (context, _) {
        final location = router.routerDelegate.currentConfiguration.uri.path;
        final authState = context.watch<AuthCubit>().state;
        final isAuthenticated = authState.status == AuthStatus.authenticated;
        final isAdmin = isAuthenticated && authState.user?.isAdmin == true;

    return Container(
      decoration: BoxDecoration(
        gradient: Themes.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Главная',
                isActive: location == '/',
                onTap: () => context.goNamed('home'),
              ),
              if (isAdmin) ...[
                _BottomNavItem(
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long,
                  label: 'Все заказы',
                  isActive: location == '/admin/orders' || location.startsWith('/admin/orders/'),
                  onTap: () => context.goNamed('admin_orders'),
                ),
                _BottomNavItem(
                  icon: Icons.inventory_2_outlined,
                  activeIcon: Icons.inventory_2,
                  label: 'Остатки',
                  isActive: location == '/admin/stocks' || location.startsWith('/admin/stocks/'),
                  onTap: () => context.goNamed('admin_stocks'),
                ),
                _BottomNavItem(
                  icon: Icons.analytics_outlined,
                  activeIcon: Icons.analytics,
                  label: 'Анализы',
                  isActive: location == '/admin/analytics' || location.startsWith('/admin/analytics/'),
                  onTap: () => context.goNamed('analytics'),
                ),
              ] else if (isAuthenticated) ...[
                _BottomNavItem(
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: 'Заказы',
                  isActive: location == '/orders' || location.startsWith('/orders/'),
                  onTap: () => context.goNamed('orders'),
                ),
                _BottomNavItem(
                  icon: Icons.warehouse_outlined,
                  activeIcon: Icons.warehouse,
                  label: 'Остатки',
                  isActive: location == '/stock',
                  onTap: () => context.goNamed('stock'),
                ),
                _BottomNavItem(
                  icon: Icons.shopping_basket_outlined,
                  activeIcon: Icons.shopping_basket,
                  label: 'Корзина',
                  isActive: location == '/cart',
                  onTap: () => context.goNamed('cart'),
                ),
              ],
              _BottomNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Профиль',
                isActive: location == '/profile',
                onTap: () {
                  if (isAuthenticated) {
                    context.goNamed('profile');
                  } else {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => const AuthDialog(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      height: 1.2,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
