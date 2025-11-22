import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';

abstract class CoatingTypesRepository {
  Future<List<CoatingType>> getCoatingTypes({String? sort});
}
