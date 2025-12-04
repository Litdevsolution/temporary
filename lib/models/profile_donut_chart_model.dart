class ProfileDonutChartModel {
  final int id;
  final String name;
  final int count;

  ProfileDonutChartModel({
    required this.id,
    required this.name,
    required this.count,
  });

  factory ProfileDonutChartModel.fromJson(Map<String, dynamic> json) {
    return ProfileDonutChartModel(
      id: json['nationality']?['id'] ?? 0,
      name: json['nationality']?['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
