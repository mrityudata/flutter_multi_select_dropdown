import 'package:flutter/material.dart';
import 'package:flutter_multiselect_dropdown/src/models/multi_select_option.dart';

class MultiSelectDropdown<T> extends StatefulWidget {
  final List<MultiSelectOption<T>> items;
  final List<T> initialValues;
  final Function(List<T>) onSelectionChanged;

  // Customization props
  final String title;
  final String hintText;
  final Color? dropdownMenuColor;
  final Color? selectedItemColor;
  final bool sortByLabel;
  final Color? fieldBackgroundColor;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    this.initialValues = const [],
    this.title = "Select Items",
    this.sortByLabel = true,
    this.dropdownMenuColor,
    this.hintText = "Select options",
    this.fieldBackgroundColor,
    required this.onSelectionChanged,
    this.selectedItemColor,
  });
  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  late List<T> _selectedValues;
  late List<MultiSelectOption<T>> _displayItems;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);
    _displayItems = List.from(widget.items);

    if (widget.sortByLabel) {
      _displayItems.sort((a, b) => a.label.compareTo(b.label));
    }
  }

  void _toggleSelectAll(bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedValues = _displayItems.map((e) => e.value).toList();
      } else {
        _selectedValues.clear();
      }
      widget.onSelectionChanged(_selectedValues);
    });
  }

  void _showDropdown() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isAllSelected =
                _selectedValues.length == _displayItems.length;

            return AlertDialog(
              backgroundColor:
                  widget.dropdownMenuColor ?? DialogThemeData().backgroundColor,
              title: Text(widget.title),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Select All Toggle
                    CheckboxListTile(
                      title: const Text(
                        "Select All",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: isAllSelected,
                      activeColor: widget.selectedItemColor,
                      onChanged: (val) {
                        setState(() => _toggleSelectAll(val));
                        setDialogState(() {}); // Refresh dialog state
                      },
                    ),
                    const Divider(),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _displayItems.length,
                        itemBuilder: (context, index) {
                          final item = _displayItems[index];
                          final bool isSelected = _selectedValues.contains(
                            item.value,
                          );

                          return CheckboxListTile(
                            title: Text(item.label),
                            value: isSelected,
                            activeColor: widget.selectedItemColor,
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedValues.add(item.value);
                                } else {
                                  _selectedValues.remove(item.value);
                                }
                                widget.onSelectionChanged(_selectedValues);
                              });
                              setDialogState(() {}); // Refresh dialog state
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              widget.fieldBackgroundColor ?? Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Expanded(
              child: _selectedValues.isEmpty
                  ? Text(
                      widget.hintText,
                      style: const TextStyle(color: Colors.grey),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _displayItems
                          .where((item) => _selectedValues.contains(item.value))
                          .map(
                            (item) => Chip(
                              label: Text(
                                item.label,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor:
                                  (widget.selectedItemColor ??
                                          Theme.of(context).primaryColor)
                                      .withValues(alpha: 0.2),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () {
                                setState(() {
                                  _selectedValues.remove(item.value);
                                  widget.onSelectionChanged(_selectedValues);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
