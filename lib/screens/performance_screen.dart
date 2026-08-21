import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/Performance_model.dart';
import '../server/Api.dart';
import '../theme.dart';

class PerformanceTab extends StatefulWidget {
  const PerformanceTab({super.key});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> {
  List<FlSpot> _getSpots(List<PerformanceModel> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].rate));
    }
    return spots;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<PerformanceModel>>(
          future: ApiService().getUserPerformance(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
            }

            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No performance data yet.", style: TextStyle(color: Colors.white)));
            }

            final data = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    "Learning Progress",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 16, left: 10, top: 24, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.white.withOpacity(0.1),
                            strokeWidth: 1,
                          ),
                        ),

                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < data.length) {
                                  String shortDate = data[index].date.substring(5, 10);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(shortDate, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(), style: const TextStyle(color: Colors.white70, fontSize: 12));
                              },
                            ),
                          ),
                        ),

                        borderData: FlBorderData(show: false),

                        minX: 0,
                        maxX: (data.length - 1).toDouble(),
                        minY: 0,
                        maxY: 100,

                        lineBarsData: [
                          LineChartBarData(
                            spots: _getSpots(data),
                            isCurved: true,
                            curveSmoothness: 0.1,
                            color: Colors.amber,
                            barWidth: 4,
                            isStrokeCapRound: true,

                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                // اللون الافتراضي للنقطة الأولى (عشان مفيش نقطة قبلها نقارن بيها)
                                Color dotColor = Colors.amber;

                                // بنبدأ المقارنة من النقطة التانية
                                if (index > 0) {
                                  double previousScore = barData.spots[index - 1].y; // نتيجة اليوم اللي قبله
                                  double currentScore = spot.y; // نتيجة اليوم الحالي

                                  if (currentScore > previousScore) {
                                    dotColor = Colors.green; // مستواه اتحسن
                                  } else if (currentScore < previousScore) {
                                    dotColor = Colors.red; // مستواه نزل
                                  } else {
                                    dotColor = Colors.amber; // مستواه ثابت
                                  }
                                }

                                // رسم النقطة باللون اللي حددناه
                                return FlDotCirclePainter(
                                  radius: 5,
                                  color: dotColor,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.amber.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,)
              ],
            );
          },
        ),
      ),
    );
  }
}