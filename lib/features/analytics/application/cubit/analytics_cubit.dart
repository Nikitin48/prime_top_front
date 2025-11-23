import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/top_products.dart';
import '../../domain/entities/top_series.dart';
import '../../domain/entities/top_coating_types.dart';
import '../../domain/repositories/analytics_repository.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._repository) : super(const AnalyticsState());

  final AnalyticsRepository _repository;

  Future<void> loadAllData({
    DateTime? dateFrom,
    DateTime? dateTo,
    int? clientId,
    int? coatingTypeId,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      dateFrom: dateFrom,
      dateTo: dateTo,
    ));

    try {
      final from = dateFrom?.toIso8601String().split('T')[0];
      final to = dateTo?.toIso8601String().split('T')[0];

      final results = await Future.wait([
        _repository.getTopProducts(
          createdFrom: from,
          createdTo: to,
          clientId: clientId,
          coatingTypeId: coatingTypeId,
          limit: 10,
        ),
        _repository.getTopSeries(
          createdFrom: from,
          createdTo: to,
          clientId: clientId,
          limit: 10,
        ),
        _repository.getTopCoatingTypes(
          createdFrom: from,
          createdTo: to,
          clientId: clientId,
        ),
      ]);

      emit(state.copyWith(
        isLoading: false,
        topProducts: results[0] as TopProducts,
        topSeries: results[1] as TopSeries,
        topCoatingTypes: results[2] as TopCoatingTypes,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

}
