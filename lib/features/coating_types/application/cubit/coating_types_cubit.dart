import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/coating_types_state.dart';
import 'package:prime_top_front/features/coating_types/domain/repositories/coating_types_repository.dart';

class CoatingTypesCubit extends Cubit<CoatingTypesState> {
  CoatingTypesCubit(this._repository) : super(const CoatingTypesState());

  final CoatingTypesRepository _repository;

  Future<void> loadCoatingTypes({String? sort}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final coatingTypes = await _repository.getCoatingTypes(sort: sort);
      emit(state.copyWith(
        coatingTypes: coatingTypes,
        isLoading: false,
        errorMessage: null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка загрузки типов покрытий',
      ));
    }
  }
}

