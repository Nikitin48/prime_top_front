import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    this.dateFrom,
    this.dateTo,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _dateFrom = widget.dateFrom;
    _dateTo = widget.dateTo;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Фильтры'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Дата от'),
              subtitle: Text(_dateFrom?.toString().split(' ')[0] ?? 'Не выбрано'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateFrom ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _dateFrom = date);
                }
              },
            ),
            ListTile(
              title: const Text('Дата до'),
              subtitle: Text(_dateTo?.toString().split(' ')[0] ?? 'Не выбрано'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateTo ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _dateTo = date);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _dateFrom = null;
              _dateTo = null;
            });
          },
          child: const Text('Сбросить'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'dateFrom': _dateFrom,
              'dateTo': _dateTo,
            });
          },
          child: const Text('Применить'),
        ),
      ],
    );
  }
}

