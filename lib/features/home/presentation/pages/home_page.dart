import 'package:flutter/material.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/home/presentation/widgets/landing_sections.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HomeHeroSection(),
            PrimeTopDirectionsSection(),
            LandingStatsSection(),
            PopularProductsSection(),
            ShowcaseSection(),
            HomeCtaSection(),
          ],
        ),
      ),
    );
  }
}
