import 'package:flutter/material.dart';
import 'package:prime_top_front/core/config/api_config.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/core/router/router.dart';
import 'package:prime_top_front/core/storage/auth_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/theme/cubit/theme_cubit.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/data/auth_repository_impl.dart';
import 'package:prime_top_front/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/coating_types_cubit.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/coating_types/data/coating_types_repository_impl.dart';
import 'package:prime_top_front/features/coating_types/data/datasources/coating_types_remote_data_source_impl.dart';
import 'package:prime_top_front/features/products/application/cubit/product_detail_cubit.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/data/products_repository_impl.dart';
import 'package:prime_top_front/features/products/data/datasources/products_remote_data_source_impl.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_cubit.dart';
import 'package:prime_top_front/features/orders/application/cubit/order_detail_cubit.dart';
import 'package:prime_top_front/features/orders/data/orders_repository_impl.dart';
import 'package:prime_top_front/features/orders/data/datasources/orders_remote_data_source_impl.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_cubit.dart';
import 'package:prime_top_front/features/cart/data/cart_repository_impl.dart';
import 'package:prime_top_front/features/cart/data/datasources/cart_remote_data_source_impl.dart';
import 'package:prime_top_front/features/home/application/cubit/top_products_cubit.dart';
import 'package:prime_top_front/features/home/data/top_products_repository_impl.dart';
import 'package:prime_top_front/features/home/data/datasources/top_products_remote_data_source_impl.dart';
import 'package:prime_top_front/features/stock/application/cubit/stock_cubit.dart';
import 'package:prime_top_front/features/stock/data/stock_repository_impl.dart';
import 'package:prime_top_front/features/stock/data/datasources/stock_remote_data_source_impl.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_stocks_cubit.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_orders_cubit.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_order_detail_cubit.dart';
import 'package:prime_top_front/features/admin/data/admin_repository_impl.dart';
import 'package:prime_top_front/features/admin/data/datasources/admin_remote_data_source_impl.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final networkClient = HttpClient(baseUrl: ApiConfig.baseUrl);
    
    final authStorageService = AuthStorageService();
    final authRemoteDataSource = AuthRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);

    final coatingTypesRemoteDataSource = CoatingTypesRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final coatingTypesRepository = CoatingTypesRepositoryImpl(coatingTypesRemoteDataSource);

    final productsRemoteDataSource = ProductsRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final productsRepository = ProductsRepositoryImpl(productsRemoteDataSource);

    final topProductsRemoteDataSource = TopProductsRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final topProductsRepository = TopProductsRepositoryImpl(topProductsRemoteDataSource);

    final stockRemoteDataSource = StockRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final stockRepository = StockRepositoryImpl(stockRemoteDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(authRepository, authStorageService),
        ),
        BlocProvider<MenuCubit>(create: (_) => MenuCubit()),
        BlocProvider<CoatingTypesCubit>(
          create: (_) => CoatingTypesCubit(coatingTypesRepository),
        ),
        BlocProvider<ProductsCubit>(
          create: (_) => ProductsCubit(productsRepository),
        ),
        BlocProvider<ProductDetailCubit>(
          create: (_) => ProductDetailCubit(productsRepository),
        ),
        BlocProvider<TopProductsCubit>(
          create: (_) => TopProductsCubit(topProductsRepository),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) {
            final authCubit = context.read<AuthCubit>();
            final ordersRemoteDataSource = OrdersRemoteDataSourceImpl(
              networkClient: networkClient,
              baseUrl: ApiConfig.baseUrl,
              getAuthToken: () => authCubit.state.user?.token,
            );
            final ordersRepository = OrdersRepositoryImpl(ordersRemoteDataSource);
            return OrdersCubit(ordersRepository);
          },
        ),
        BlocProvider<OrderDetailCubit>(
          create: (context) {
            final authCubit = context.read<AuthCubit>();
            final ordersRemoteDataSource = OrdersRemoteDataSourceImpl(
              networkClient: networkClient,
              baseUrl: ApiConfig.baseUrl,
              getAuthToken: () => authCubit.state.user?.token,
            );
            final ordersRepository = OrdersRepositoryImpl(ordersRemoteDataSource);
            return OrderDetailCubit(ordersRepository);
          },
        ),
        BlocProvider<CartCubit>(
          create: (context) {
            final authCubit = context.read<AuthCubit>();
            final cartRemoteDataSource = CartRemoteDataSourceImpl(
              networkClient: networkClient,
              baseUrl: ApiConfig.baseUrl,
              getAuthToken: () => authCubit.state.user?.token,
            );
            final cartRepository = CartRepositoryImpl(
              cartRemoteDataSource,
              productsRepository: productsRepository,
            );
            return CartCubit(cartRepository);
          },
        ),
        BlocProvider<StockCubit>(
          create: (_) => StockCubit(stockRepository),
        ),
        BlocProvider<AdminStocksCubit>(
          create: (context) {
            final authCubit = context.read<AuthCubit>();
            final adminRemoteDataSource = AdminRemoteDataSourceImpl(
              networkClient: networkClient,
              baseUrl: ApiConfig.baseUrl,
              getAuthToken: () => authCubit.state.user?.token,
            );
            final adminRepository = AdminRepositoryImpl(adminRemoteDataSource);
            return AdminStocksCubit(adminRepository);
          },
        ),
        BlocProvider<AdminOrdersCubit>(
          create: (context) {
            final authCubit = context.read<AuthCubit>();
            final adminRemoteDataSource = AdminRemoteDataSourceImpl(
              networkClient: networkClient,
              baseUrl: ApiConfig.baseUrl,
              getAuthToken: () => authCubit.state.user?.token,
            );
            final adminRepository = AdminRepositoryImpl(adminRemoteDataSource);
            return AdminOrdersCubit(adminRepository);
          },
        ),
        BlocProvider<AdminOrderDetailCubit>(
          create: (context) {
            final authCubit = context.read<AuthCubit>();
            final adminRemoteDataSource = AdminRemoteDataSourceImpl(
              networkClient: networkClient,
              baseUrl: ApiConfig.baseUrl,
              getAuthToken: () => authCubit.state.user?.token,
            );
            final adminRepository = AdminRepositoryImpl(adminRemoteDataSource);
            return AdminOrderDetailCubit(adminRepository);
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'PrimeTop Web',
            theme: state.theme,
            darkTheme: state.darkTheme,
            themeMode: state.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
