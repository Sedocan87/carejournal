import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/services/database_service.dart';
import 'package:carejournal/widgets/empty_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<List<LogEntry>> _symptomEntriesFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _symptomEntriesFuture = _getSymptomEntries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        future: _symptomEntriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyState(
              message: "Log a few symptom entries, and your personal health charts will appear here.",
              icon: Icons.show_chart_outlined,
            );
          }

          final symptomEntries = snapshot.data!;
          final spots = symptomEntries.asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            return FlSpot(index.toDouble(), entry.data!['severity'].toDouble());
          }).toList();

          _controller.forward();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots.sublist(0, (spots.length * value).toInt()),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
