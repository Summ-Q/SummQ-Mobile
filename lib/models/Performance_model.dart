class PerformanceModel {
  final String date;
  final double rate;

  PerformanceModel({required this.date, required this.rate});

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      date: json['date'],
      rate: (json['count'] as num).toDouble(),
    );
  }
}