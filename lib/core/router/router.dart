import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/theme/themes.dart';
import 'package:prime_top_front/features/home/presentation/pages/home_page.dart';
import 'package:prime_top_front/features/home/presentation/widgets/home_drawer.dart';
import 'package:prime_top_front/core/widgets/app_header.dart';
import 'package:prime_top_front/core/widgets/app_footer.dart';
import 'package:prime_top_front/features/orders/presentation/pages/my_orders_page.dart';
import 'package:prime_top_front/features/orders/presentation/pages/order_detail_page.dart';
import 'package:prime_top_front/features/orders/presentation/pages/order_history_page.dart';
import 'package:prime_top_front/features/profile/presentation/pages/client_profile_page.dart';
import 'package:prime_top_front/features/stock/presentation/pages/stock_page.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_state.dart';
import 'package:prime_top_front/features/coating_types/presentation/widgets/coating_types_menu.dart';
import 'package:prime_top_front/features/products/presentation/pages/product_detail_page.dart';
import 'package:prime_top_front/features/products/presentation/pages/products_by_coating_type_page.dart';
import 'package:prime_top_front/features/cart/presentation/pages/cart_page.dart';

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
                        gradient: Themes.primaryGradient,
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
          path: '/orders/:orderId',
          name: 'order_detail',
          pageBuilder: (context, state) {
            final orderIdParam = state.pathParameters['orderId'];
            if (orderIdParam == null) {
              return const NoTransitionPage(child: HomePage());
            }
            final orderId = int.tryParse(orderIdParam);
            if (orderId == null) {
              return const NoTransitionPage(child: HomePage());
            }
            return NoTransitionPage(
              child: OrderDetailPage(orderId: orderId),
            );
          },
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
            final productIdParam = state.pathParameters['productId'];
            if (productIdParam == null) {
              return const NoTransitionPage(child: HomePage());
            }
            final productId = int.tryParse(productIdParam);
            if (productId == null) {
              return const NoTransitionPage(child: HomePage());
            }
            return NoTransitionPage(
              child: ProductDetailPage(productId: productId),
            );
          },
        ),
        GoRoute(
          path: '/products/coating-type/:coatingTypeId',
          name: 'products_by_coating_type',
          pageBuilder: (context, state) {
            final coatingTypeIdParam = state.pathParameters['coatingTypeId'];
            if (coatingTypeIdParam == null) {
              return const NoTransitionPage(child: HomePage());
            }
            final coatingTypeId = int.tryParse(coatingTypeIdParam);
            if (coatingTypeId == null) {
              return const NoTransitionPage(child: HomePage());
            }
            final coatingTypeName = state.uri.queryParameters['name'];
            return NoTransitionPage(
              child: ProductsByCoatingTypePage(
                coatingTypeId: coatingTypeId,
                coatingTypeName: coatingTypeName,
              ),
            );
          },
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) => const NoTransitionPage(child: CartPage()),
        ),
      ],
    ),
  ],
);


