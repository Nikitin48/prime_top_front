import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/assets.gen.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/home/presentation/widgets/icon_with_label.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Row(
        children: [
          Assets.logo.logoPrimeTop.image(height: 65, fit: BoxFit.contain),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onOpenMenu,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 56,
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Поиск',
                    prefixIcon: const Icon(Icons.search),
                    isDense: false,
                    filled: true,
                    fillColor: ColorName.backgroundSecondary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  onSubmitted: (value) {
                    // Implement search logic here
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: IconWithLabel(
              icon: Icons.shopping_cart_outlined,
              label: 'Мои заказы',
              onTap: () => context.goNamed('orders'),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: IconWithLabel(
              icon: Icons.warehouse_outlined,
              label: 'Остатки',
              onTap: () => context.goNamed('stock'),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: IconWithLabel(
              icon: Icons.history_outlined,
              label: 'История',
              onTap: () => context.goNamed('orders_history'),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: IconWithLabel(
              icon: Icons.person_outline,
              label: 'Профиль',
              onTap: () => context.goNamed('profile'),
            ),
          ),
        ],
      ),
    );
  }
}


