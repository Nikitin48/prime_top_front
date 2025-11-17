import 'package:flutter/material.dart';
import 'package:prime_top_front/core/config/api_config.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/core/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/theme/cubit/theme_cubit.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/data/auth_repository_impl.dart';
import 'package:prime_top_front/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/coating_types_cubit.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/coating_types/data/coating_types_repository_impl.dart';
import 'package:prime_top_front/features/coating_types/data/datasources/coating_types_remote_data_source_impl.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/data/products_repository_impl.dart';
import 'package:prime_top_front/features/products/data/datasources/products_remote_data_source_impl.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Инициализация зависимостей
    final networkClient = HttpClient(baseUrl: ApiConfig.baseUrl);
    
    // Auth dependencies
    final authRemoteDataSource = AuthRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);

    // Coating types dependencies
    final coatingTypesRemoteDataSource = CoatingTypesRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final coatingTypesRepository = CoatingTypesRepositoryImpl(coatingTypesRemoteDataSource);

    // Products dependencies
    final productsRemoteDataSource = ProductsRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
    );
    final productsRepository = ProductsRepositoryImpl(productsRemoteDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(authRepository)),
        BlocProvider<MenuCubit>(create: (_) => MenuCubit()),
        BlocProvider<CoatingTypesCubit>(
          create: (_) => CoatingTypesCubit(coatingTypesRepository),
        ),
        BlocProvider<ProductsCubit>(
          create: (_) => ProductsCubit(productsRepository),
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
