import 'package:flutter/material.dart';
import 'package:flutter_multiselect_plus/flutter_multiselect_plus.dart';


class MultiSelectOptionWidget<T> extends StatelessWidget {
  final MultiSelectOption<T> item;
  final bool isSelected;
  final bool isSingleSelect;
  final Color? selectedColor;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  const MultiSelectOptionWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.isSingleSelect = false,
    required this.onTap,
    this.selectedColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? Theme.of(context).primaryColor).withAlpha(20)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 20,
                color: isSelected
                    ? (selectedColor ?? Theme.of(context).primaryColor)
                    : Colors.grey,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item.label,
                style: textStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: isSingleSelect ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isSingleSelect ? null : BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? (selectedColor ?? Theme.of(context).primaryColor)
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
                color: isSelected
                    ? (selectedColor ?? Theme.of(context).primaryColor)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      isSingleSelect ? Icons.circle : Icons.check,
                      size: isSingleSelect ? 8 : 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
