import 'package:prime_top_front/features/coating_types/data/models/coating_type_model.dart';

abstract class CoatingTypesRemoteDataSource {
  Future<List<CoatingTypeModel>> getCoatingTypes({String? sort});
}

