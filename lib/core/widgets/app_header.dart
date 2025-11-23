import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/assets.gen.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/home/presentation/widgets/icon_with_label.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_state.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    final horizontalPadding = isMobile ? 16.0 : isTablet ? 24.0 : 40.0;
    final verticalPadding = isMobile ? 12.0 : 20.0;
    final spacing = isMobile ? 8.0 : 12.0;

    final logoHeight = isTablet ? 55.0 : 65.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, verticalPadding),
      child: Row(
        children: [
          if (!isMobile) ...[
            InkWell(
              onTap: () => context.goNamed('home'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Assets.logo.logoPrimeTop.image(height: logoHeight, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: spacing),
          ],
          
          BlocBuilder<MenuCubit, MenuState>(
            builder: (context, menuState) {
              return _CatalogButton(
                onPressed: onOpenMenu,
                isActive: menuState.isOpen,
              );
            },
          ),
          SizedBox(width: spacing),
          
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 200),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: isMobile ? 44.0 : isTablet ? 48.0 : 56.0,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      prefixIcon: const Icon(Icons.search),
                      isDense: false,
                      filled: true,
                      fillColor: ColorName.backgroundSecondary,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: isMobile ? 12.0 : isTablet ? 14.0 : 18.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        context.goNamed(
                          'search',
                          queryParameters: {'q': value.trim()},
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          
          if (!isMobile)
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final isAuthenticated = authState.status == AuthStatus.authenticated;
                final isAdmin = isAuthenticated && authState.user?.isAdmin == true;
                final showLabels = isDesktop;
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAuthenticated) ...[
                      if (isAdmin) ...[
                        SizedBox(width: spacing),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: showLabels
                              ? IconWithLabel(
                                  icon: Icons.receipt_long_outlined,
                                  label: 'Все заказы',
                                  onTap: () => context.goNamed('admin_orders'),
                                )
                              : _IconButton(
                                  icon: Icons.receipt_long_outlined,
                                  tooltip: 'Все заказы',
                                  onTap: () => context.goNamed('admin_orders'),
                                ),
                        ),
                        SizedBox(width: spacing),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: showLabels
                              ? IconWithLabel(
                                  icon: Icons.inventory_2_outlined,
                                  label: 'Управление остатками',
                                  onTap: () => context.goNamed('admin_stocks'),
                                )
                              : _IconButton(
                                  icon: Icons.inventory_2_outlined,
                                  tooltip: 'Управление остатками',
                                  onTap: () => context.goNamed('admin_stocks'),
                                ),
                        ),
                        SizedBox(width: spacing),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: showLabels
                              ? IconWithLabel(
                                  icon: Icons.analytics_outlined,
                                  label: 'Анализ',
                                  onTap: () => context.goNamed('analytics'),
                                )
                              : _IconButton(
                                  icon: Icons.analytics_outlined,
                                  tooltip: 'Анализ',
                                  onTap: () => context.goNamed('analytics'),
                                ),
                        ),
                      ] else ...[
                        SizedBox(width: spacing),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: showLabels
                              ? IconWithLabel(
                                  icon: Icons.shopping_cart_outlined,
                                  label: 'Мои заказы',
                                  onTap: () => context.goNamed('orders'),
                                )
                              : _IconButton(
                                  icon: Icons.shopping_cart_outlined,
                                  tooltip: 'Мои заказы',
                                  onTap: () => context.goNamed('orders'),
                                ),
                        ),
                        SizedBox(width: spacing),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: showLabels
                              ? IconWithLabel(
                                  icon: Icons.warehouse_outlined,
                                  label: 'Остатки',
                                  onTap: () => context.goNamed('stock'),
                                )
                              : _IconButton(
                                  icon: Icons.warehouse_outlined,
                                  tooltip: 'Остатки',
                                  onTap: () => context.goNamed('stock'),
                                ),
                        ),
                        SizedBox(width: spacing),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: showLabels
                              ? IconWithLabel(
                                  icon: Icons.shopping_basket_outlined,
                                  label: 'Корзина',
                                  onTap: () => context.goNamed('cart'),
                                )
                              : _IconButton(
                                  icon: Icons.shopping_basket_outlined,
                                  tooltip: 'Корзина',
                                  onTap: () => context.goNamed('cart'),
                                ),
                        ),
                      ],
                    ],
                    SizedBox(width: spacing),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: showLabels
                          ? IconWithLabel(
                              icon: Icons.person_outline,
                              label: 'Профиль',
                              onTap: () {
                                if (authState.status == AuthStatus.authenticated) {
                                  context.goNamed('profile');
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => const AuthDialog(),
                                  );
                                }
                              },
                            )
                          : _IconButton(
                              icon: Icons.person_outline,
                              tooltip: 'Профиль',
                              onTap: () {
                                if (authState.status == AuthStatus.authenticated) {
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
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CatalogButton extends StatefulWidget {
  const _CatalogButton({
    required this.onPressed,
    required this.isActive,
  });

  final VoidCallback onPressed;
  final bool isActive;

  @override
  State<_CatalogButton> createState() => _CatalogButtonState();
}

class _CatalogButtonState extends State<_CatalogButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.white;
    final Color hoverColor = Color.lerp(Colors.white, ColorName.primary, 0.35)!;
    final Color currentColor = _isHovered || widget.isActive ? hoverColor : baseColor;
    final Color activeBg = Colors.white.withOpacity(0.12);
    final Color backgroundColor = widget.isActive || _isHovered ? activeBg : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Icon(
            Icons.menu,
            color: currentColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatefulWidget {
  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.white;
    final Color hoverColor = Color.lerp(Colors.white, ColorName.primary, 0.35)!;
    final Color currentColor = _isHovered ? hoverColor : baseColor;
    final Color hoverBg = _isHovered ? Colors.white.withOpacity(0.12) : Colors.transparent;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: hoverBg,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              widget.icon,
              color: currentColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
