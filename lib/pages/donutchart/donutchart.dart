import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DonutChartWidget extends StatelessWidget {
  final double sumIncome;
  final double sumExpense;

  const DonutChartWidget({
    super.key,
    required this.sumIncome,
    required this.sumExpense,
  });

  @override
  Widget build(BuildContext context) {

    Map<String, double> dataMap = {
      "ລາຍຮັບ": sumIncome,
      "ລາຍຈ່າຍ": sumExpense,
    };

    final colorList = <Color>[
      Colors.green,
      Colors.amber,
    ];

    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartType: ChartType.ring,
      ringStrokeWidth: 40,
      chartRadius: MediaQuery.of(context).size.width / 2.2,
      colorList: colorList,
      legendOptions: const LegendOptions(
        legendPosition: LegendPosition.right,
        showLegendsInRow: false,
        legendTextStyle: TextStyle(fontSize: 14),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValuesInPercentage: true,
        showChartValuesOutside: true,
      ),
    );
  }
}
