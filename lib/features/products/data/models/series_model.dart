import 'package:prime_top_front/features/products/data/models/analyses_model.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';

class SeriesModel extends Series {
  const SeriesModel({
    required super.id,
    super.name,
    super.productionDate,
    super.expireDate,
    AnalysesModel? analyses,
  }) : _analysesModel = analyses,
       super(analyses: analyses);

  final AnalysesModel? _analysesModel;

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    }

    return SeriesModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      productionDate: parseDate(json['production_date'] as String?),
      expireDate: parseDate(json['expire_date'] as String?),
      analyses: json['analyses'] != null
          ? AnalysesModel.fromJson(json['analyses'] as Map<String, dynamic>?)
          : null,
    );
  }

  Series toEntity() {
    return Series(
      id: id,
      name: name,
      productionDate: productionDate,
      expireDate: expireDate,
      analyses: _analysesModel?.toEntity(),
    );
  }
}

