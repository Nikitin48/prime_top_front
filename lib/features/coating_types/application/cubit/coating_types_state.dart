import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';

class CoatingTypesState extends Equatable {
  const CoatingTypesState({
    this.coatingTypes = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<CoatingType> coatingTypes;
  final bool isLoading;
  final String? errorMessage;

  CoatingTypesState copyWith({
    List<CoatingType>? coatingTypes,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CoatingTypesState(
      coatingTypes: coatingTypes ?? this.coatingTypes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [coatingTypes, isLoading, errorMessage];
}
