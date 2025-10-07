import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../providers/auth_provider.dart';

class StatisticsScreen extends StatelessWidget {
  final Group group;

  const StatisticsScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê chi tiêu'),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: context.read<AuthProvider>().getGroupExpenses(group.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final expenses = snapshot.data ?? [];

          if (expenses.isEmpty) {
            return const Center(
              child: Text('Chưa có chi tiêu nào để thống kê'),
            );
          }

          // Tính toán tổng chi tiêu theo người
          final Map<String, double> totalByPerson = {};
          for (final expense in expenses) {
            final amountPerPerson = expense.amount / expense.splitBetween.length;
            for (final person in expense.splitBetween) {
              totalByPerson[person] = (totalByPerson[person] ?? 0) + amountPerPerson;
            }
          }

          // Tính toán tổng chi tiêu theo người trả
          final Map<String, double> paidByPerson = {};
          for (final expense in expenses) {
            paidByPerson[expense.paidBy] = (paidByPerson[expense.paidBy] ?? 0) + expense.amount;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiêu theo người',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: PieChart(
                            PieChartData(
                              sections: totalByPerson.entries.map((entry) {
                                return PieChartSectionData(
                                  value: entry.value,
                                  title: '${entry.key}\n${entry.value.toStringAsFixed(2)}',
                                  radius: 100,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiêu theo người trả',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: paidByPerson.values.reduce((a, b) => a > b ? a : b) * 1.2,
                              barGroups: paidByPerson.entries.map((entry) {
                                return BarChartGroupData(
                                  x: paidByPerson.keys.toList().indexOf(entry.key),
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value,
                                      color: Colors.blue,
                                      width: 20,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final person = paidByPerson.keys.elementAt(value.toInt());
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          person,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toStringAsFixed(0),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 