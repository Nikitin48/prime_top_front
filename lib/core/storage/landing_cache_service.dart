import 'dart:convert';

import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';
import 'package:prime_top_front/features/home/domain/entities/landing_stats.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local cache for landing page metrics and products.
class LandingCacheService {
  static const String _statsKey = 'landing_stats_cache';
  static const String _popularProductsKey = 'landing_popular_products_cache';

  Future<void> saveLandingStats(LandingStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, dynamic>{
      'projects': stats.projects,
      'series': stats.series,
      'orders_per_day': stats.ordersPerDay,
      'logistics_hubs': stats.logisticsHubs,
      'clients': stats.clients,
    };
    await prefs.setString(_statsKey, jsonEncode(data));
  }

  Future<LandingStats?> loadLandingStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    if (raw == null) {
      return null;
    }
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return LandingStats(
        projects: data['projects'] as int? ?? 0,
        series: data['series'] as int? ?? 0,
        ordersPerDay: data['orders_per_day'] as int? ?? 0,
        logisticsHubs: data['logistics_hubs'] as int? ?? 0,
        clients: data['clients'] as int? ?? 0,
      );
    } catch (_) {
      await prefs.remove(_statsKey);
      return null;
    }
  }

  Future<void> savePopularProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = products
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'color_code': product.colorCode,
              'price': product.price,
              'coating_type': {
                'id': product.coatingType.id,
                'name': product.coatingType.name,
                'nomenclature': product.coatingType.nomenclature,
              },
            })
        .toList();
    await prefs.setString(_popularProductsKey, jsonEncode(encoded));
  }

  Future<List<Product>> loadPopularProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_popularProductsKey);
    if (raw == null) {
      return [];
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) {
        final map = item as Map<String, dynamic>;
        final coatingTypeMap = map['coating_type'] as Map<String, dynamic>? ?? {};
        return Product(
          id: map['id'] as int? ?? 0,
          name: map['name'] as String? ?? '',
          colorCode: map['color_code'] as int? ?? 0,
          price: map['price'] as int? ?? 0,
          coatingType: CoatingType(
            id: coatingTypeMap['id'] as int? ?? 0,
            name: coatingTypeMap['name'] as String? ?? '',
            nomenclature: coatingTypeMap['nomenclature'] as String? ?? '',
          ),
        );
      }).toList();
    } catch (_) {
      await prefs.remove(_popularProductsKey);
      return [];
    }
  }
}
