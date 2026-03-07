import 'package:flutter/material.dart';

class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: const WidgetStatePropertyAll(Color(0xFFF1F7F4)),
          dataRowMinHeight: 62,
          dataRowMaxHeight: 72,
          headingTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF143225),
              ),
          columnSpacing: 18,
          horizontalMargin: 14,
          dividerThickness: 0.6,
          border: TableBorder.all(
            color: const Color(0x12000000),
            borderRadius: BorderRadius.circular(14),
          ),
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
