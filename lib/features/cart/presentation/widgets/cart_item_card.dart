import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart_item.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
    this.isRemoving = false,
  });

  final CartItem cartItem;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final bool isRemoving;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late TextEditingController _quantityController;
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.cartItem.quantity;
    _quantityController = TextEditingController(text: _currentQuantity.toString());
  }

  @override
  void didUpdateWidget(CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartItem.quantity != widget.cartItem.quantity) {
      _currentQuantity = widget.cartItem.quantity;
      _quantityController.text = _currentQuantity.toString();
    }
    
    if (widget.cartItem.series != null) {
      final maxQuantity = widget.cartItem.series!.availableQuantity.toInt();
      if (_currentQuantity > maxQuantity) {
        _currentQuantity = maxQuantity;
        _quantityController.text = maxQuantity.toString();
        widget.onQuantityChanged(maxQuantity);
      }
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleQuantityChange(String value) {
    if (value.isEmpty) {
      return;
    }
    
    final quantity = int.tryParse(value);
    if (quantity == null) {
      _quantityController.text = _currentQuantity.toString();
      return;
    }

    final maxQuantity = widget.cartItem.series != null
        ? widget.cartItem.series!.availableQuantity.toInt()
        : 100000;

    if (quantity < 1) {
      _quantityController.text = '1';
      widget.onQuantityChanged(1);
      _currentQuantity = 1;
      return;
    }
    
    if (quantity > maxQuantity) {
      _quantityController.text = maxQuantity.toString();
      widget.onQuantityChanged(maxQuantity);
      _currentQuantity = maxQuantity;
      return;
    }

    if (quantity != _currentQuantity) {
      _currentQuantity = quantity;
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalPrice = widget.cartItem.quantity * widget.cartItem.product.price;

    return Card(
      color: isDark
          ? ColorName.darkThemeCardBackground
          : ColorName.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? ColorName.darkThemeBorderSoft
              : ColorName.borderSoft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: RalColorHelper.getRalColor(widget.cartItem.product.colorCode),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? ColorName.darkThemeBorderSoft
                      : ColorName.borderSoft,
                  width: 1,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.cartItem.product.coatingType.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                    ),
                  ),
                  if (widget.cartItem.series != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Серия: ${widget.cartItem.series!.name ?? 'Серия #${widget.cartItem.series!.id}'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14,
                          color: isDark
                              ? ColorName.darkThemeTextSecondary
                              : ColorName.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Остаток на складе: ${widget.cartItem.series!.availableQuantity.toStringAsFixed(1)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? ColorName.darkThemeTextSecondary
                                : ColorName.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorName.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: ColorName.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Данный товар будет отправлен на производство',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ColorName.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${widget.cartItem.product.price} ₽ за шт.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: widget.isRemoving
                        ? ColorName.danger.withOpacity(0.5)
                        : ColorName.danger,
                  ),
                  onPressed: widget.isRemoving ? null : widget.onRemove,
                  tooltip: 'Удалить',
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    final maxQuantity = widget.cartItem.series != null
                        ? widget.cartItem.series!.availableQuantity.toInt()
                        : 100000;
                    final maxLength = maxQuantity.toString().length;
                    
                    return SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(maxLength),
                        ],
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? ColorName.darkThemeBorderSoft
                              : ColorName.borderSoft,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? ColorName.darkThemeBorderSoft
                              : ColorName.borderSoft,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: ColorName.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? ColorName.darkThemeCardBackground
                          : ColorName.backgroundSecondary,
                    ),
                    onChanged: _handleQuantityChange,
                    onSubmitted: (value) {
                      _handleQuantityChange(value);
                    },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalPrice ₽',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
