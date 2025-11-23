part of 'analytics_cubit.dart';

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.isLoading = false,
    this.errorMessage,
    this.topProducts,
    this.topSeries,
    this.topCoatingTypes,
    this.dateFrom,
    this.dateTo,
  });

  final bool isLoading;
  final String? errorMessage;
  final TopProducts? topProducts;
  final TopSeries? topSeries;
  final TopCoatingTypes? topCoatingTypes;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  AnalyticsState copyWith({
    bool? isLoading,
    String? errorMessage,
    TopProducts? topProducts,
    TopSeries? topSeries,
    TopCoatingTypes? topCoatingTypes,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      topProducts: topProducts ?? this.topProducts,
      topSeries: topSeries ?? this.topSeries,
      topCoatingTypes: topCoatingTypes ?? this.topCoatingTypes,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        topProducts,
        topSeries,
        topCoatingTypes,
        dateFrom,
        dateTo,
      ];
}
