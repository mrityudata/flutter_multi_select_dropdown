import 'package:flutter/widgets.dart';

class MultiSelectOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  MultiSelectOption({
    required this.value,
    required this.label,
    this.icon,
  });
}
