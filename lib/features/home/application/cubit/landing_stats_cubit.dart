import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/storage/landing_cache_service.dart';
import 'package:prime_top_front/features/home/application/cubit/landing_stats_state.dart';
import 'package:prime_top_front/features/home/domain/repositories/landing_repository.dart';

class LandingStatsCubit extends Cubit<LandingStatsState> {
  LandingStatsCubit(
    this._repository,
    this._cacheService,
  ) : super(const LandingStatsState());

  final LandingRepository _repository;
  final LandingCacheService _cacheService;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final stats = await _repository.getLandingStats();
      await _cacheService.saveLandingStats(stats);
      emit(state.copyWith(stats: stats, isLoading: false, errorMessage: null));
    } on Exception {
      final cached = await _cacheService.loadLandingStats();
      if (cached != null) {
        emit(state.copyWith(stats: cached, isLoading: false, errorMessage: null));
        return;
      }
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Не удалось загрузить статистику. Попробуйте позже.',
        ),
      );
    }
  }
}
