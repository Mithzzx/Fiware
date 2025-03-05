import 'package:flutter/material.dart';
import '../backend/Categories.dart';
import '../backend/records.dart';

class RecordDetailsPage extends StatelessWidget {
  final Record record;

  const RecordDetailsPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final category = categories[record.categoryId];
    final amountText = record.amount < 0
        ? '-\$${record.amount.abs().toStringAsFixed(2)}'
        : '\$${record.amount.toStringAsFixed(2)}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: category.icon,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      record.accountName,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Amount: $amountText',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${record.dateTime}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Notes: ${record.notes}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
