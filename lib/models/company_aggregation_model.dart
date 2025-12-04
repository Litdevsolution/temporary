class CompanyAggregationModel {
  final int totalCount;

  CompanyAggregationModel({
    required this.totalCount,
  });

  factory CompanyAggregationModel.fromJson(Map<String, dynamic> json) {
    return CompanyAggregationModel(
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
