part of 'stock_cubit.dart';

class StockState extends Equatable {
  const StockState({
    required this.status,
    this.response,
    this.errorMessage,
    this.filters = const StockFilters(),
  });

  const StockState.initial()
      : status = StockStatus.initial,
        response = null,
        errorMessage = null,
        filters = const StockFilters();

  final StockStatus status;
  final AvailableStocksResponse? response;
  final String? errorMessage;
  final StockFilters filters;

  StockState copyWith({
    StockStatus? status,
    AvailableStocksResponse? response,
    String? errorMessage,
    StockFilters? filters,
  }) {
    return StockState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [status, response, errorMessage, filters];
}
