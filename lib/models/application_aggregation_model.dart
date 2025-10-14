class ApplicationAggregationModel {
  final int total;
  final int male;
  final int female;
  final int newProfilesCount;

  ApplicationAggregationModel({
    required this.total,
    required this.male,
    required this.female,
    required this.newProfilesCount,
  });

  factory ApplicationAggregationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationAggregationModel(
      total: json['total'] ?? 0,
      male: json['male'] ?? 0,
      female: json['female'] ?? 0,
      newProfilesCount: json['newProfilesCount'] ?? 0,
    );
  }
}
