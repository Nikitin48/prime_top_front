class CoatingType {
  const CoatingType({
    required this.id,
    required this.name,
    required this.nomenclature,
  });

  final int id;
  final String name;
  final String nomenclature;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoatingType &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          nomenclature == other.nomenclature;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ nomenclature.hashCode;

  @override
  String toString() => '$name ($nomenclature)';
}
