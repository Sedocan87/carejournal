import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/services/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<List<LogEntry>> _getSymptomEntries() async {
    final maps = await DatabaseService.instance.getLogEntries();
    final entries = List.generate(maps.length, (i) => LogEntry.fromMap(maps[i]));
    return entries.where((entry) => entry.entryType == 'symptom').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<List<LogEntry>>(
        future: _getSymptomEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No symptom entries to display.'));
          }

          final symptomEntries = snapshot.data!;
          final spots = symptomEntries.asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            return FlSpot(index.toDouble(), entry.data!['severity'].toDouble());
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
              ),
            ),
          );
        },
      ),
    );
  }
}
