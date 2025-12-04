import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart'; // Make sure you import this

class DonutChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  final List<Color>? colorList;

  const DonutChartWidget({
    super.key,
    required this.dataMap,
    this.colorList,
  });

  @override
  Widget build(BuildContext context) {
    final colors = colorList ?? [Colors.lightBlue];

    double screenWidth = MediaQuery.of(context).size.width;
    double chartWidth = screenWidth * 0.5;
    chartWidth = chartWidth > 400 ? 400 : chartWidth;

    return Row(
      children: [
        SizedBox(
          width: chartWidth,
          height: chartWidth,
          child: PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartType: ChartType.ring,
            ringStrokeWidth: 40,
            chartRadius: chartWidth / 2,
            colorList: colors,
            legendOptions: const LegendOptions(
              showLegends: false,
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: true, // ✅ show numbers
              showChartValuesInPercentage: true, // ✅ show as percentage
              showChartValuesOutside: true, // ✅ show labels outside the ring
              decimalPlaces: 2, // ✅ two digits after the decimal point (e.g., 45.23%)
            ),
          ),
        ),


        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: dataMap.entries.map((entry) {
            final value = entry.value;
            final formattedValue = NumberFormat('#,###').format(value);
            final colorIndex = dataMap.keys.toList().indexOf(entry.key) % colors.length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: colors[colorIndex],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$formattedValue ${entry.key}', // ✅ Value + key
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
