class ApplicationQuantityAggregationModel {
  final int total;
  final int male;
  final int female;

  ApplicationQuantityAggregationModel({
    required this.total,
    required this.male,
    required this.female,
  });

  factory ApplicationQuantityAggregationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationQuantityAggregationModel(
      total: json['totalProfiles'] ?? 0,
      male: json['maleProfiles'] ?? 0,
      female: json['femaleProfiles'] ?? 0,
    );
  }
}
