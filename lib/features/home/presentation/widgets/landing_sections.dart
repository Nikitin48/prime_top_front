import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/home/application/cubit/landing_stats_cubit.dart';
import 'package:prime_top_front/features/home/application/cubit/landing_stats_state.dart';
import 'package:prime_top_front/features/home/application/cubit/popular_products_cubit.dart';
import 'package:prime_top_front/features/home/application/cubit/popular_products_state.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorName.primary, ColorName.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
}

class _HeroFact extends StatelessWidget {
  const _HeroFact({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class PrimeTopDirectionsSection extends StatelessWidget {
  const PrimeTopDirectionsSection({super.key});

  static const _items = [
    _DirectionCardData(
      title: 'Архитектура и фасады',
      description:
          'Серии с высокой стойкостью к ультрафиолету и коррозии. Структуры, матовые и металлизированные покрытия для жилых и общественных объектов.',
      tag: 'Facade / DTM',
    ),
    _DirectionCardData(
      title: 'Индустриальные проекты',
      description:
          'PrimeTop DuraCoat защищает металл от химии и механики. Работаем с машиностроением, транспортом и энергетикой.',
      tag: 'Industrial',
    ),
    _DirectionCardData(
      title: 'Спецэффекты и бренд-дизайн',
      description:
          'Soft-touch, хамелеоны, искры и текстуры под натуральные материалы. Подбираем эксклюзив под бренд и сертифицируем партии.',
      tag: 'FX Lab',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: 'Производственные направления PrimeTop',
      subtitle:
          'Мы совмещаем лабораторию, производство и цифровой сервис, чтобы каждому клиенту было удобно работать.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width > 1050
              ? 3
              : width > 700
                  ? 2
                  : 1;
          const spacing = 24.0;
          final cardWidth = crossAxisCount == 1
              ? width
              : (width - spacing * (crossAxisCount - 1)) / crossAxisCount;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: _items
                .map(
                  (data) => SizedBox(
                    width: cardWidth,
                    child: _DirectionCard(data: data),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _DirectionCardData {
  const _DirectionCardData({
    required this.title,
    required this.description,
    required this.tag,
  });

  final String title;
  final String description;
  final String tag;
}

class _DirectionCard extends StatelessWidget {
  const _DirectionCard({required this.data});

  final _DirectionCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [ColorName.primary.withValues(alpha: 0.07), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorName.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              data.tag,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ColorName.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ColorName.textSecondary),
          ),
        ],
      ),
    );
  }
}

class LandingStatsSection extends StatelessWidget {
  const LandingStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      backgroundColor: ColorName.backgroundSecondary,
      child: BlocBuilder<LandingStatsCubit, LandingStatsState>(
        builder: (context, state) {
          if (state.isLoading && state.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = state.stats;
          final items = [
            _StatTileData(
              label: 'реализованных проектов',
              value: (stats?.projects ?? 0).toString(),
            ),
            _StatTileData(
              label: 'серий в каталоге',
              value: (stats?.series ?? 0).toString(),
            ),
            _StatTileData(
              label: 'заявок в день',
              value: (stats?.ordersPerDay ?? 0).toString(),
            ),
            _StatTileData(
              label: 'логистических хабов',
              value: (stats?.logisticsHubs ?? 0).toString(),
            ),
            _StatTileData(
              label: 'активных клиентов',
              value: (stats?.clients ?? 0).toString(),
            ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Цифры PrimeTop',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: items.map((item) => _StatTile(data: item)).toList(),
              ),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: ColorName.danger),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatTileData {
  const _StatTileData({required this.label, required this.value});
  final String label;
  final String value;
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.data});

  final _StatTileData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: ColorName.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ColorName.textSecondary),
          ),
        ],
      ),
    );
  }
}

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: 'Популярные заказы',
      child: BlocBuilder<PopularProductsCubit, PopularProductsState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.products.isEmpty) {
            return Text(
              state.errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ColorName.danger),
            );
          }
          final products = state.products;
          if (products.isEmpty) {
            return Text(
              'Пока нет статистики по заявкам. Загляните позже.',
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 1050
                  ? 3
                  : width > 700
                  ? 2
                  : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.2,
                ),
                itemCount: products.length,
                itemBuilder: (_, index) =>
                    _PopularProductCard(product: products[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class _PopularProductCard extends StatelessWidget {
  const _PopularProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final accent = RalColorHelper.getRalColor(product.colorCode);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Серия ${product.coatingType.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'RAL ${product.colorCode}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ColorName.textSecondary),
          ),
          const Spacer(),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () => context.go('/products/${product.id}'),
                child: const Text('Подробнее'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _openAuthOrOrders(context),
                child: const Text('Сделать заказ'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({super.key});

  static const _items = [
    _ShowcaseItem(
      title: 'Цифровой каталог',
      description:
          'Показываем остатки, статусы и истории серий. Гость видит витрину, клиент — персональные условия и доступ к менеджеру.',
    ),
    _ShowcaseItem(
      title: 'Онлайн сопровождение',
      description:
          'Заявки, резервы и документы в одном кабинете. Менеджер получает уведомления и ускоряет отгрузку.',
    ),
    _ShowcaseItem(
      title: 'нтеграция со складом',
      description:
          'Данные приходят из pgAdmin/БД. Мы показываем популярные товары и прогнозируем потребность.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      backgroundColor: ColorName.backgroundSecondary,
      title: 'Платформа для гостей и клиентов',
      subtitle:
          'Гость знакомится с продукцией, авторизованный клиент управляет заказами и складами.',
      child: Column(
        children: _items.map((item) => _ShowcaseCard(data: item)).toList(),
      ),
    );
  }
}

class _ShowcaseItem {
  const _ShowcaseItem({required this.title, required this.description});
  final String title;
  final String description;
}

class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({required this.data});

  final _ShowcaseItem data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: ColorName.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorName.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCtaSection extends StatelessWidget {
  const HomeCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ColorName.primary, ColorName.secondary],
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Готовы подключить PrimeTop к проекту?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Оставьте заявку — мы подключим демо-доступ, подберём серию и подготовим заказ.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ColorName.primary,
                  ),
                  onPressed: () => context.read<MenuCubit>().openMenu(),
                  child: const Text('Открыть меню покрытий'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () => _openAuthOrOrders(context),
                  child: const Text('Связаться с менеджером'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection({
    this.title,
    this.subtitle,
    this.backgroundColor,
    required this.child,
  });

  final String? title;
  final String? subtitle;
  final Color? backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorName.textSecondary,
                  ),
                ),
              ],
              if (title != null || subtitle != null) const SizedBox(height: 32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

void _openAuthOrOrders(BuildContext context) {
  final authState = context.read<AuthCubit>().state;
  if (authState.status == AuthStatus.authenticated) {
    context.go('/orders');
    return;
  }
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const AuthDialog(),
  );
}



