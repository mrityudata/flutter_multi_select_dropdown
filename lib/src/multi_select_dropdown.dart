import 'package:flutter/material.dart';
import 'models/multi_select_option.dart';

/// A highly customizable Multiselect Dropdown widget for Flutter.
///
/// Supports generic types [T], searching, "Select All" functionality,
/// and extensive styling options for both the input field and the dropdown dialog.
class MultiSelectDropdown<T> extends StatefulWidget {
  /// The full list of options available for selection.
  final List<MultiSelectOption<T>> items;

  /// The values that should be pre-selected when the widget is initialized.
  final List<T> initialValues;

  /// Callback function triggered whenever the selection list changes.
  final Function(List<T>) onSelectionChanged;

  /// The title text displayed at the top of the dropdown dialog.
  final String title;

  /// Text displayed in the input field when no items are selected.
  final String hintText;

  /// The label text displayed above the input field.
  final String labelText;

  /// Placeholder text for the search input field inside the dropdown.
  final String searchHintText;

  /// Message displayed when the search query returns no matching items.
  final String noResultText;

  /// Background color of the dropdown dialog menu.
  final Color? dropdownMenuColor;

  /// Color used for the checkbox and active elements (chips, icons).
  final Color? selectedItemColor;

  /// Color of the icon shown when no search results are found.
  final Color? noSearchIconColor;

  /// Color of the chip when user make selection.
  final Color? chipColor;

  /// Whether to automatically sort the items alphabetically by their label.
  final bool sortByLabel;

  /// Toggle to show or hide the search bar inside the dropdown.
  final bool showSearch;

  /// The maximum number of items allowed to be selected.
  final int? maxSelection;

  /// The vertical spacing between the [labelText] and the input field.
  final double? spaceBtLabelAndField;

  /// The size of the "no results" icon.
  final double? noSearchIconSize;

  /// Style for the [hintText].
  final TextStyle? hintTextStyle;

  /// Style for the "Select All" button text.
  final TextStyle? selectAllTextStyle;

  /// Style for the "Clear All" button text.
  final TextStyle? clearAllTextStyle;

  /// Style for the [searchHintText].
  final TextStyle? searchHintTextStyle;

  /// Style for the [labelText] displayed above the field.
  final TextStyle? labelTextStyle;

  /// style for the chip text
  final TextStyle? chipTextStyle;

  /// Style for the [title] of the dropdown dialog.
  final TextStyle? dropDownTitleStyle;

  /// Style for the labels of the items inside the list.
  final TextStyle? listLabelTextStyle;

  /// Style for the "Done" action button text.
  final TextStyle? doneTextStyle;

  /// Style for the [noResultText] message.
  final TextStyle? noResultTextStyle;

  /// Custom decoration for the main input field container.
  final BoxDecoration? inputFieldDecoration;

  /// Custom input decoration for the search text field.
  final InputDecoration? searchFieldDecoration;

  /// Custom icon to represent the dropdown trigger (defaults to arrow_drop_down).
  final Icon? dropDownIcon;

  /// Position of the [labelText] (Start, Center, or End).
  final CrossAxisAlignment labelTextPosition;

  /// Internal padding for the input field.
  final EdgeInsetsGeometry? searchFieldPadding;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    this.initialValues = const [],
    this.title = "Select Items",
    this.hintText = "Select options",
    this.labelText = "Label Text",
    this.searchHintText = "Search...",
    this.noResultText = "No results found",
    this.labelTextPosition = CrossAxisAlignment.start,
    this.sortByLabel = true,
    this.showSearch = true,
    this.dropdownMenuColor,
    this.selectedItemColor,
    this.chipColor,
    this.chipTextStyle,
    this.noSearchIconColor,
    this.maxSelection,
    this.hintTextStyle,
    this.selectAllTextStyle,
    this.clearAllTextStyle,
    this.doneTextStyle,
    this.searchHintTextStyle,
    this.labelTextStyle,
    this.noResultTextStyle,
    this.dropDownTitleStyle,
    this.listLabelTextStyle,
    this.inputFieldDecoration,
    this.searchFieldDecoration,
    this.dropDownIcon,
    this.noSearchIconSize,
    this.spaceBtLabelAndField = 5,
    this.searchFieldPadding,
    required this.onSelectionChanged,
  });

  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  late List<T> _selectedValues;
  late List<MultiSelectOption<T>> _allOptions;
  List<MultiSelectOption<T>> _filteredOptions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);
    _allOptions = List.from(widget.items);

    if (widget.sortByLabel) {
      _allOptions.sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    }
    _filteredOptions = _allOptions;
  }

  /// Filters the visible options based on the user's search [query].
  void _filterSearch(String query) {
    setState(() {
      _filteredOptions = _allOptions
          .where((item) => item.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// Handles the "Select All" logic.
  ///
  /// If [selected] is true, it attempts to select all items currently
  /// visible in the filtered list while respecting [maxSelection].
  void _handleSelectAll(bool? selected) {
    setState(() {
      if (selected == true) {
        for (var item in _filteredOptions) {
          if (!_selectedValues.contains(item.value)) {
            if (widget.maxSelection == null || _selectedValues.length < widget.maxSelection!) {
              _selectedValues.add(item.value);
            }
          }
        }
      } else {
        for (var item in _filteredOptions) {
          _selectedValues.remove(item.value);
        }
      }
      widget.onSelectionChanged(_selectedValues);
    });
  }

  /// Displays the selection dialog containing the search bar and option list.
  void _showDropdown() {
    _searchController.clear();
    _filteredOptions = _allOptions;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isAllSelected = _filteredOptions.isNotEmpty &&
                _filteredOptions.every((item) => _selectedValues.contains(item.value));

            return AlertDialog(
              backgroundColor: widget.dropdownMenuColor ?? DialogThemeData().backgroundColor,
              title: Text(widget.title, style: widget.dropDownTitleStyle),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Search Bar Section
                    Visibility(
                        visible: widget.showSearch,
                        child: Column(
                          children: [
                            TextField(
                              controller: _searchController,
                              decoration: widget.searchFieldDecoration ??
                                  InputDecoration(
                                    hintText: widget.searchHintText,
                                    hintStyle: widget.searchHintTextStyle,
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                      icon: const Icon(Icons.clear_rounded),
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterSearch('');
                                        setDialogState(() {});
                                      },
                                    )
                                        : null,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                              onChanged: (val) {
                                _filterSearch(val);
                                setDialogState(() {});
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        )),

                    /// Action Bar (Select All / Clear All)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isAllSelected,
                              activeColor: widget.selectedItemColor,
                              onChanged: (val) {
                                _handleSelectAll(val);
                                setDialogState(() {});
                              },
                            ),
                            Text("Select All", style: widget.selectAllTextStyle ?? const TextStyle(fontSize: 13)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _selectedValues.clear());
                            widget.onSelectionChanged(_selectedValues);
                            setDialogState(() {});
                          },
                          child: Text("Clear All", style: widget.clearAllTextStyle ?? const TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                    const Divider(),

                    /// Scrollable Options List
                    Flexible(
                      child: _filteredOptions.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredOptions.length,
                        itemBuilder: (context, index) {
                          final item = _filteredOptions[index];
                          final bool isSelected = _selectedValues.contains(item.value);

                          return CheckboxListTile(
                            title: Text(item.label, style: widget.listLabelTextStyle),
                            value: isSelected,
                            activeColor: widget.selectedItemColor,
                            onChanged: (bool? checked) {
                              if (checked == true) {
                                if (widget.maxSelection != null && _selectedValues.length >= widget.maxSelection!) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Max ${widget.maxSelection} items allowed")),
                                  );
                                  return;
                                }
                                setState(() => _selectedValues.add(item.value));
                              } else {
                                setState(() => _selectedValues.remove(item.value));
                              }
                              widget.onSelectionChanged(_selectedValues);
                              setDialogState(() {});
                            },
                          );
                        },
                      )
                          : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                color: widget.noSearchIconColor ?? Colors.black,
                                size: widget.noSearchIconSize ?? 40),
                            const SizedBox(height: 8),
                            Text(
                              widget.noResultText,
                              style: widget.noResultTextStyle ?? const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Done", style: widget.doneTextStyle),
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
    return Column(
      crossAxisAlignment: widget.labelTextPosition,
      children: [
        Text(widget.labelText, style: widget.labelTextStyle ?? const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: widget.spaceBtLabelAndField),
        GestureDetector(
          onTap: _showDropdown,
          child: Container(
            padding: widget.searchFieldPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: widget.inputFieldDecoration ??
                BoxDecoration(
                  color: Colors.grey.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
            child: Row(
              children: [
                Expanded(
                  child: _selectedValues.isEmpty
                      ? Text(widget.hintText, style: widget.hintTextStyle)
                      : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _allOptions
                        .where((item) => _selectedValues.contains(item.value))
                        .map(
                          (item) => Chip(
                        label: Text(item.label, style: widget.chipTextStyle ?? const TextStyle(fontSize: 12)),
                        backgroundColor: widget.chipColor ?? (widget.selectedItemColor ?? Theme.of(context).primaryColor).withAlpha(50),
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
                widget.dropDownIcon ?? const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}