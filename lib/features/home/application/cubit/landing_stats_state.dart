import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/home/domain/entities/landing_stats.dart';

class LandingStatsState extends Equatable {
  const LandingStatsState({
    this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  final LandingStats? stats;
  final bool isLoading;
  final String? errorMessage;

  LandingStatsState copyWith({
    LandingStats? stats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LandingStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [stats, isLoading, errorMessage];
}
