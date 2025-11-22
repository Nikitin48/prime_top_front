import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_order_detail_cubit.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';

class AdminOrderEditSection extends StatefulWidget {
  const AdminOrderEditSection({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  State<AdminOrderEditSection> createState() => _AdminOrderEditSectionState();
}

class _AdminOrderEditSectionState extends State<AdminOrderEditSection> {
  String? _selectedStatus;
  DateTime? _selectedShippedDate;
  DateTime? _selectedDeliveredDate;
  final _cancelReasonController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
    _cancelReasonController.text = widget.order.cancelReason ?? '';
  }

  @override
  void dispose() {
    _cancelReasonController.dispose();
    super.dispose();
  }

  Future<void> _updateOrder() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final status = _selectedStatus != widget.order.status ? _selectedStatus : null;
      String? shippedAt;
      String? deliveredAt;
      String? cancelReason;

      if (_selectedShippedDate != null) {
        shippedAt = DateFormat('yyyy-MM-dd').format(_selectedShippedDate!);
      }
      if (_selectedDeliveredDate != null) {
        deliveredAt = DateFormat('yyyy-MM-dd').format(_selectedDeliveredDate!);
      }
      if (_selectedStatus == 'cancelled' && _cancelReasonController.text.trim().isNotEmpty) {
        cancelReason = _cancelReasonController.text.trim();
      }

      await context.read<AdminOrderDetailCubit>().updateOrder(
            orderId: widget.order.id,
            status: status,
            shippedAt: shippedAt,
            deliveredAt: deliveredAt,
            cancelReason: cancelReason,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заказ успешно обновлен'),
            backgroundColor: ColorName.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка обновления заказа: $e'),
            backgroundColor: ColorName.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isShippedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isShippedDate
          ? (_selectedShippedDate ?? DateTime.now())
          : (_selectedDeliveredDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isShippedDate) {
          _selectedShippedDate = picked;
        } else {
          _selectedDeliveredDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Управление заказом',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: InputDecoration(
              labelText: 'Статус заказа',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDark
                  ? ColorName.darkThemeBackgroundSecondary
                  : ColorName.backgroundSecondary,
            ),
            items: const [
              DropdownMenuItem(value: 'created', child: Text('Создан')),
              DropdownMenuItem(value: 'pending', child: Text('Ожидает подтверждения')),
              DropdownMenuItem(value: 'processing', child: Text('В производстве')),
              DropdownMenuItem(value: 'shipped', child: Text('Отгружен')),
              DropdownMenuItem(value: 'delivered', child: Text('Доставлен')),
              DropdownMenuItem(value: 'cancelled', child: Text('Отменён')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(context, true),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedShippedDate != null
                        ? DateFormat('dd.MM.yyyy').format(_selectedShippedDate!)
                        : 'Дата отправки',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(context, false),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDeliveredDate != null
                        ? DateFormat('dd.MM.yyyy').format(_selectedDeliveredDate!)
                        : 'Дата доставки',
                  ),
                ),
              ),
            ],
          ),
          if (_selectedStatus == 'cancelled') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _cancelReasonController,
              decoration: InputDecoration(
                labelText: 'Причина отмены',
                hintText: 'Введите причину отмены заказа',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: isDark
                    ? ColorName.darkThemeBackgroundSecondary
                    : ColorName.backgroundSecondary,
              ),
              maxLines: 3,
              maxLength: 100,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUpdating ? null : _updateOrder,
              icon: _isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isUpdating ? 'Обновление...' : 'Сохранить изменения'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: ColorName.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
