import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/assets.gen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 96,
        titleSpacing: 8,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
          child: Row(
            children: [
              Assets.logo.logoPrimeTop.image(height: 65, fit: BoxFit.contain),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Меню',
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    height: 52,
                    child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      prefixIcon: const Icon(Icons.search),
                      isDense: false,
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
              _IconWithLabel(
                icon: Icons.shopping_cart_outlined,
                label: 'Мои заказы',
                onTap: () => context.goNamed('orders'),
              ),
              const SizedBox(width: 10),
              _IconWithLabel(
                icon: Icons.warehouse_outlined,
                label: 'Остатки',
                onTap: () => context.goNamed('stock'),
              ),
              const SizedBox(width: 10),
              _IconWithLabel(
                icon: Icons.history_outlined,
                label: 'История',
                onTap: () => context.goNamed('orders_history'),
              ),
              const SizedBox(width: 10),
              _IconWithLabel(
                icon: Icons.person_outline,
                label: 'Профиль',
                onTap: () => context.goNamed('profile'),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Главная'),
                onTap: () => Navigator.of(context).pop(),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Настройки'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Помощь'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: const Text(''),
        ),
      ),
    );
  }
}

class _IconWithLabel extends StatelessWidget {
  const _IconWithLabel({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          tooltip: label,
          onPressed: onTap,
          constraints: const BoxConstraints(),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}


