import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/coating_types/data/datasources/coating_types_remote_data_source.dart';
import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';
import 'package:prime_top_front/features/coating_types/domain/repositories/coating_types_repository.dart';

class CoatingTypesRepositoryImpl implements CoatingTypesRepository {
  CoatingTypesRepositoryImpl(this._remoteDataSource);

  final CoatingTypesRemoteDataSource _remoteDataSource;

  @override
  Future<List<CoatingType>> getCoatingTypes({String? sort}) async {
    try {
      final models = await _remoteDataSource.getCoatingTypes(sort: sort);
      return models.map((model) => model.toEntity()).toList();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении типов покрытий: $e');
    }
  }
}

