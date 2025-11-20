import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/theme/themes.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';


class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      decoration: const BoxDecoration(
        gradient:LinearGradient(
    colors: [ColorName.primary, ColorName.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.88],
  ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(56)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PrimeTop — порошковые покрытия и цифровой сервис',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Разрабатываем и производим покрытия для фасадов, индустрии и спецэффектов. '
                    'Своя лаборатория, складская сеть и менеджеры, которые ведут проект от первой заявки до поставки.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        onPressed: () => _openAuthOrOrders(context),
                        child: const Text('Сделать заказ'),
                      ),
                    ],
                  ),
                ],
              );

              final infoCard = Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _HeroFact(
                      title: '15+ лет опыта',
                      description:
                          'Лаборатория PrimeTop тестирует каждую серию и адаптирует рецептуры.',
                    ),
                    SizedBox(height: 16),
                    _HeroFact(
                      title: 'Складская сеть',
                      description:
                          'Прогнозируем резервы и отправляем покрытия из 5 логистических хабов.',
                    ),
                    SizedBox(height: 16),
                    _HeroFact(
                      title: 'RAL и кастом',
                      description:
                          'Подбираем оттенки, текстуры и защитные свойства под климат и брендбук.',
                    ),
                  ],
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [copy, const SizedBox(height: 32), infoCard],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: copy),
                  const SizedBox(width: 32),
                  SizedBox(width: 360, child: infoCard),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openAuthOrOrders(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState.status == AuthStatus.authenticated) {
      context.goNamed('orders');
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => const AuthDialog(),
      );
    }
  }
}

class _HeroFact extends StatelessWidget {
  const _HeroFact({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

