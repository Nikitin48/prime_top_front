import 'package:go_router/go_router.dart';
import 'package:prime_top_front/features/home/presentation/pages/home_page.dart';
import 'package:prime_top_front/features/orders/presentation/pages/my_orders_page.dart';
import 'package:prime_top_front/features/orders/presentation/pages/order_history_page.dart';
import 'package:prime_top_front/features/profile/presentation/pages/client_profile_page.dart';
import 'package:prime_top_front/features/stock/presentation/pages/stock_page.dart';

final GoRouter appRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const MyOrdersPage(),
    ),
    GoRoute(
      path: '/orders/history',
      name: 'orders_history',
      builder: (context, state) => const OrderHistoryPage(),
    ),
    GoRoute(
      path: '/stock',
      name: 'stock',
      builder: (context, state) => const StockPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ClientProfilePage(),
    ),
  ],
);


