import 'package:prime_top_front/features/home/domain/entities/landing_stats.dart';

class LandingStatsModel extends LandingStats {
  const LandingStatsModel({
    required super.projects,
    required super.series,
    required super.ordersPerDay,
    required super.logisticsHubs,
    required super.clients,
  });

  factory LandingStatsModel.fromJson(Map<String, dynamic> json) {
    return LandingStatsModel(
      projects: json['projects'] as int? ?? 0,
      series: json['series'] as int? ?? 0,
      ordersPerDay: json['orders_per_day'] as int? ?? 0,
      logisticsHubs: json['logistics_hubs'] as int? ?? 0,
      clients: json['clients'] as int? ?? 0,
    );
  }
}
