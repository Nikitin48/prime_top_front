import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/home/presentation/widgets/landing_sections.dart';
import 'package:prime_top_front/features/home/presentation/widgets/popular_products_section.dart';
import 'package:prime_top_front/features/home/presentation/widgets/recent_orders_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          const HomeHeroSection(),
          const PopularProductsSection(),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final isAdmin = authState.status == AuthStatus.authenticated && authState.user?.isAdmin == true;
              if (isAdmin) {
                return const SizedBox.shrink();
              }
              return const RecentOrdersSection();
            },
          ),
        ],
      ),
    );
  }
}
