import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../backend/records.dart';
import '../../backend/Categories.dart';
import '../../backend/database_helper.dart';
import 'package:provider/provider.dart';

class ExpensesAnalyticsCard extends StatefulWidget {
  const ExpensesAnalyticsCard({Key? key}) : super(key: key);

  @override
  State<ExpensesAnalyticsCard> createState() => _ExpensesAnalyticsCardState();
}

class _ExpensesAnalyticsCardState extends State<ExpensesAnalyticsCard> {
  String selectedPeriod = 'month';

  List<PeriodOption> periodOptions = [
    PeriodOption(id: 'week', label: 'This Week'),
    PeriodOption(id: 'month', label: 'This Month'),
    PeriodOption(id: 'year', label: 'This Year'),
  ];

  Map<int, double> _calculateCategoryTotals(List<Record> records) {
    Map<int, double> totals = {};

    for (var record in records) {
      if (record.amount < 0) { // Only count expenses (negative amounts)
        totals[record.categoryId] = (totals[record.categoryId] ?? 0) + record.amount.abs();
      }
    }
    return totals;
  }

  bool _isRecordInPeriod(Record record) {
    final now = DateTime.now();
    final recordDate = record.dateTime;

    switch (selectedPeriod) {
      case 'week':
        return recordDate.isAfter(now.subtract(const Duration(days: 7)));
      case 'month':
        return recordDate.year == now.year && recordDate.month == now.month;
      case 'year':
        return recordDate.year == now.year;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceState>(
      builder: (context, financeState, child) {
        // Filter records based on selected period
        final filteredRecords = financeState.records
            .where(_isRecordInPeriod)
            .toList();

        // Calculate category totals
        final categoryTotals = _calculateCategoryTotals(filteredRecords);

        // Calculate total expenses
        final totalExpenses = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);

        // Create pie chart sections
        final sections = categoryTotals.entries.map((entry) {
          final category = categories[entry.key];
          return PieChartSectionData(
            color: category.color,
            value: entry.value,
            title: '', // Empty title for clean look
            radius: 40,
            showTitle: false,
          );
        }).toList();

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5, top: 3,bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'EXPENSES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to detailed view
                      },
                      child: const Row(
                        children: [
                          Text(
                            'SHOW MORE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Divider(height: 1, thickness: 0.3),
                ),
                const SizedBox(height: 8),

                // Period Selection
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: periodOptions.map((option) {
                      final isSelected = selectedPeriod == option.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(option.label),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => selectedPeriod = option.id);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Chart Section
                SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 80,
                          sectionsSpace: 2,
                        ),
                      ),
                      // Center Text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total Spent',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${totalExpenses.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Legend
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: categoryTotals.entries.map((entry) {
                    final category = categories[entry.key];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: category.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '\$${entry.value.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PeriodOption {
  final String id;
  final String label;

  PeriodOption({required this.id, required this.label});
}