class ProfileAggregationModel {
  final int total;
  final int male;
  final int female;
  final int newProfilesCount;

  ProfileAggregationModel({
    required this.total,
    required this.male,
    required this.female,
    required this.newProfilesCount,
  });

  factory ProfileAggregationModel.fromJson(Map<String, dynamic> json) {
    return ProfileAggregationModel(
      total: json['total'] ?? 0,
      male: json['male'] ?? 0,
      female: json['female'] ?? 0,
      newProfilesCount: json['newProfilesCount'] ?? 0,
    );
  }
}
