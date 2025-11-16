import 'package:flutter/material.dart';
import 'package:prime_top_front/core/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/theme/cubit/theme_cubit.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/data/auth_repository_impl.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepositoryImpl())),
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
