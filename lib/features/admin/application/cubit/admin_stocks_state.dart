part of 'admin_stocks_cubit.dart';

enum AdminStocksStatus { initial, loading, success, failure }

class AdminStocksState extends Equatable {
  const AdminStocksState({
    required this.status,
    this.stocks = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  const AdminStocksState.initial()
      : status = AdminStocksStatus.initial,
        stocks = const [],
        totalCount = 0,
        errorMessage = null;

  final AdminStocksStatus status;
  final List<AdminStock> stocks;
  final int totalCount;
  final String? errorMessage;

  AdminStocksState copyWith({
    AdminStocksStatus? status,
    List<AdminStock>? stocks,
    int? totalCount,
    String? errorMessage,
  }) {
    return AdminStocksState(
      status: status ?? this.status,
      stocks: stocks ?? this.stocks,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stocks, totalCount, errorMessage];
}
