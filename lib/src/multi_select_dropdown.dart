import 'package:flutter/material.dart';
import 'models/multi_select_option.dart';

class MultiSelectDropdown<T> extends StatefulWidget {
  final List<MultiSelectOption<T>> items;
  final List<T> initialValues;
  final Function(List<T>) onSelectionChanged;

  // Customization props
  final String title;
  final String hintText;
  final String labelText;
  final String searchHintText;
  final Color? dropdownMenuColor;
  final Color? selectedItemColor;
  final bool sortByLabel;
  final bool showSearch;
  final int? maxSelection;
  final double? spaceBtLabelAndField;
  final TextStyle? hintTextStyle;
  final TextStyle? selectAllTextStyle;
  final TextStyle? clearAllTextStyle;
  final TextStyle? searchHintTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? dropDownTitleStyle;
  final TextStyle? listLabelTextStyle;
  final TextStyle? doneTextStyle;
  final BoxDecoration? inputFieldDecoration;
  final InputDecoration? searchFieldDecoration;
  final Icon? dropDownIcon;
  final CrossAxisAlignment labelTextPosition;
  final EdgeInsetsGeometry? searchFieldPadding;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    this.initialValues = const [],
    this.title = "Select Items",
    this.hintText = "Select options",
    this.labelText = "Label Text",
    this.searchHintText = "Search...",
    this.labelTextPosition = CrossAxisAlignment.start,
    this.sortByLabel = true,
    this.showSearch = true,
    this.dropdownMenuColor,
    this.selectedItemColor,
    this.maxSelection,
    this.hintTextStyle,
    this.selectAllTextStyle,
    this.clearAllTextStyle,
    this.doneTextStyle,
    this.searchHintTextStyle,
    this.labelTextStyle,
    this.dropDownTitleStyle,
    this.listLabelTextStyle,
    this.inputFieldDecoration,
    this.searchFieldDecoration,
    this.dropDownIcon,
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

  //search function
  void _filterSearch(String query) {
    setState(() {
      _filteredOptions = _allOptions
          .where((item) => item.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  //select all function
  void _handleSelectAll(bool? selected) {
    setState(() {
      if (selected == true) {
        for (var item in _filteredOptions) {
          if (!_selectedValues.contains(item.value)) {
            // Respect maxSelection limit even during "Select All"
            if (widget.maxSelection == null || _selectedValues.length < widget.maxSelection!) {
              _selectedValues.add(item.value);
            }
          }
        }
      } else {
        // Only clear items that are currently visible in the search
        for (var item in _filteredOptions) {
          _selectedValues.remove(item.value);
        }
      }
      widget.onSelectionChanged(_selectedValues);
    });
  }
  //dropdown code
  void _showDropdown() {
    // Reset search when opening
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
              title: Text(widget.title,style: widget.dropDownTitleStyle,),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Search Bar ---
                    Visibility(
                      visible: widget.showSearch,
                        child: Column(children: [
                          TextField(
                            controller: _searchController,
                            decoration: widget.searchFieldDecoration ?? InputDecoration(
                              hintText: widget.searchHintText,
                              hintStyle: widget.searchHintTextStyle,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (val) {
                              _filterSearch(val);
                              setDialogState(() {});
                            },
                          ),
                          const SizedBox(height: 10),
                    ],)),
                    // --- Action Bar (Select All / Clear All) ---
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
                            Text("Select All", style: widget.selectAllTextStyle ?? TextStyle(fontSize: 13)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _selectedValues.clear());
                            widget.onSelectionChanged(_selectedValues);
                            setDialogState(() {});
                          },
                          child: Text("Clear All", style: widget.clearAllTextStyle ?? TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                    const Divider(),
                    // --- Options List ---
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredOptions.length,
                        itemBuilder: (context, index) {
                          final item = _filteredOptions[index];
                          final bool isSelected = _selectedValues.contains(item.value);

                          return CheckboxListTile(
                            title: Text(item.label,style: widget.listLabelTextStyle),
                            value: isSelected,
                            activeColor: widget.selectedItemColor,
                            onChanged: (bool? checked) {
                              if (checked == true) {
                                // Check for max selection limit
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
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Done",style: widget.doneTextStyle,),
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
        Text( widget.labelText ,style : widget.labelTextStyle ?? TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: widget.spaceBtLabelAndField),
        GestureDetector(
          onTap: _showDropdown,
          child: Container(

            padding: widget.searchFieldPadding ??  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: widget.inputFieldDecoration ?? BoxDecoration(
              color:  Colors.grey.withAlpha(25),
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
                        label: Text(item.label, style: const TextStyle(fontSize: 12)),
                        backgroundColor: (widget.selectedItemColor ?? Theme.of(context).primaryColor).withAlpha(50),
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