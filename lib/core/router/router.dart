import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/home/presentation/pages/home_page.dart';
import 'package:prime_top_front/features/home/presentation/widgets/home_drawer.dart';
import 'package:prime_top_front/core/widgets/app_header.dart';
import 'package:prime_top_front/core/widgets/app_footer.dart';
import 'package:prime_top_front/features/orders/presentation/pages/my_orders_page.dart';
import 'package:prime_top_front/features/orders/presentation/pages/order_history_page.dart';
import 'package:prime_top_front/features/profile/presentation/pages/client_profile_page.dart';
import 'package:prime_top_front/features/stock/presentation/pages/stock_page.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_state.dart';
import 'package:prime_top_front/features/coating_types/presentation/widgets/coating_types_menu.dart';
import 'package:prime_top_front/features/products/presentation/pages/product_detail_page.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
        return BlocBuilder<MenuCubit, MenuState>(
          builder: (context, menuState) {
            return Stack(
              children: [
                Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 96,
                    titleSpacing: 8,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorName.primary, ColorName.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    title: AppHeader(
                      onOpenMenu: () => context.read<MenuCubit>().toggleMenu(),
                    ),
                  ),
                  drawer: const HomeDrawer(),
                  body: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Контент страницы
                              child,
                              // Footer внизу контента
                              const AppFooter(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (menuState.isOpen)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 96, // Status bar + AppBar
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CoatingTypesMenu(
                      onClose: () => context.read<MenuCubit>().closeMenu(),
                    ),
                  ),
              ],
            );
          },
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/orders',
          name: 'orders',
          pageBuilder: (context, state) => const NoTransitionPage(child: MyOrdersPage()),
        ),
        GoRoute(
          path: '/orders/history',
          name: 'orders_history',
          pageBuilder: (context, state) => const NoTransitionPage(child: OrderHistoryPage()),
        ),
        GoRoute(
          path: '/stock',
          name: 'stock',
          pageBuilder: (context, state) => const NoTransitionPage(child: StockPage()),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ClientProfilePage()),
        ),
        GoRoute(
          path: '/products/:productId',
          name: 'product_detail',
          pageBuilder: (context, state) {
            final productId = int.parse(state.pathParameters['productId']!);
            return NoTransitionPage(
              child: ProductDetailPage(productId: productId),
            );
          },
        ),
      ],
    ),
  ],
);


