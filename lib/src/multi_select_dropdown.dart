import 'dart:async'; // Added for Timer
import 'package:flutter/material.dart';
import 'package:flutter_multiselect_plus/src/widgets/drop_down_widget.dart';
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

  ///Snack bar background color
  final Color? snackBarBackgroundColor;

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

  /// Style for the [labelText] displayed above the field.
  final TextStyle? labelTextStyle;

  /// Style for the [hintText] displayed in the dropdown.
  final TextStyle? searchHintTextStyle;

  /// style for the chip text
  final TextStyle? chipTextStyle;

  ///style for the done text on drop down
  final TextStyle? doneTextStyle;

  /// Style for the [title] of the dropdown dialog.
  final TextStyle? dropDownTitleStyle;

  /// Style for the labels of the items inside the list.
  final TextStyle? listLabelTextStyle;

  /// Style for the warning snack bar of max selection.
  final TextStyle? maxSelectionSnackBarTextStyle;

  /// Style for the [noResultText] message.
  final TextStyle? noResultTextStyle;

  /// Custom decoration for the main input field container.
  final BoxDecoration? inputFieldDecoration;

  /// Custom input decoration for the search text field.
  final InputDecoration? searchFieldDecoration;

  /// Custom icon to represent the dropdown trigger (defaults to arrow_drop_down).
  final Icon? dropDownIcon;

  /// The maximum height of the dropdown menu.
  final double dropdownHeight;

  /// Position of the [labelText] (Start, Center, or End).
  final CrossAxisAlignment labelTextPosition;

  /// Style for the "Select All" button text.
  final TextStyle? selectAllTextStyle;

  /// Style for the "Clear All" button text.
  final TextStyle? clearAllTextStyle;

  /// Internal padding for the input field.
  final EdgeInsetsGeometry? searchFieldPadding;

  /// Internal padding for the input field.
  final EdgeInsetsGeometry? selectClearAllPadding;

  /// Whether the dropdown allows only a single selection.
  final bool isSingleSelect;

  /// Callback triggered when max selection limit is reached.
  final VoidCallback? onMaxSelectionLimitReached;

  ///separator widget
  final Widget? separatorWidget;

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
    this.isSingleSelect = false,
    this.onMaxSelectionLimitReached,
    this.dropdownMenuColor,
    this.selectedItemColor,
    this.separatorWidget,
    this.chipColor,
    this.snackBarBackgroundColor,
    this.chipTextStyle,
    this.searchHintTextStyle,
    this.doneTextStyle,
    this.noSearchIconColor,
    this.maxSelection,
    this.hintTextStyle,
    this.selectClearAllPadding,
    this.labelTextStyle,
    this.noResultTextStyle,
    this.dropDownTitleStyle,
    this.listLabelTextStyle,
    this.selectAllTextStyle,
    this.clearAllTextStyle,
    this.maxSelectionSnackBarTextStyle,
    this.inputFieldDecoration,
    this.searchFieldDecoration,
    this.dropDownIcon,
    this.dropdownHeight = 400,
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
  final ScrollController _scrollController = ScrollController();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  Timer? _debounce;

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

  @override
  void didUpdateWidget(covariant MultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items || oldWidget.sortByLabel != widget.sortByLabel) {
      _allOptions = List.from(widget.items);
      if (widget.sortByLabel) {
        _allOptions.sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
      }
      _filteredOptions = _allOptions;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Filters the visible options based on the user's search [query].
  void _filterSearch(String query) {
    _filteredOptions = _allOptions
        .where((item) => item.label.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Handles the "Select All" logic.
  ///
  /// If [selected] is true, it attempts to select all items currently
  /// visible in the filtered list while respecting [maxSelection].
  void _handleSelectAll(bool? selected) {
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
  }

  /// Displays the selection dropdown as an overlay.
  void _showDropdown() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isOpen = false;
        _searchController.clear();
        _filteredOptions = _allOptions;
      });
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final availableHeightBelow = MediaQuery.of(context).size.height - offset.dy - size.height;
    final dropdownHeight = widget.dropdownHeight;

    bool showAbove = availableHeightBelow < dropdownHeight &&
        offset.dy > availableHeightBelow;

    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setOverlayState) {
          return Stack(
            children: [
              GestureDetector(
                onTap: _showDropdown,
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor:
                      showAbove ? Alignment.topLeft : Alignment.bottomLeft,
                  followerAnchor:
                      showAbove ? Alignment.bottomLeft : Alignment.topLeft,
                  offset: Offset(0, showAbove ? -10 : 10),
                  child: DropDownWidget(
                    listScrollController: _scrollController,
                    separatorWidget : widget.separatorWidget,
                    doneTextStyle: widget.doneTextStyle,
                    onDone: _showDropdown,
                    searchHintText: widget.searchHintText,
                    isSingleSelect: widget.isSingleSelect,
                    listLabelTextStyle: widget.listLabelTextStyle,
                    selectedItemColor: widget.selectedItemColor,
                    noResultText: widget.noResultText,
                    noResultTextStyle: widget.noResultTextStyle,
                    noSearchIconColor: widget.noSearchIconColor,
                    noSearchIconSize: widget.noSearchIconSize,
                    dropdownHeight: widget.dropdownHeight,
                    itemList: _filteredOptions,
                    selectedValues: _selectedValues,
                    selectClearAllPadding: widget.selectClearAllPadding,
                    searchHintTextStyle: widget.searchHintTextStyle,
                    width: size.width,
                    searchController: _searchController,
                    showSearch: widget.showSearch,
                    clearAllTextStyle: widget.clearAllTextStyle,
                    selectAllTextStyle: widget.selectAllTextStyle,
                    onSearchChange: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        setOverlayState(() {
                          _filterSearch(value);
                        });
                      });
                    },
                    onClearSearchIcon: () {
                      setOverlayState(() {
                        _searchController.clear();
                        _filterSearch('');
                      });
                    },
                    onItemTap: (value) {
                      setOverlayState(() {
                        if (widget.isSingleSelect) {
                          _selectedValues = [value];
                          _showDropdown(); // Close dropdown on selection
                        } else {
                          if (_selectedValues.contains(value)) {
                            _selectedValues.remove(value);
                          } else {
                            if (widget.maxSelection == null ||
                                _selectedValues.length <
                                    widget.maxSelection!) {
                              _selectedValues.add(value);
                            } else {
                              if (widget.onMaxSelectionLimitReached != null) {
                                widget.onMaxSelectionLimitReached!();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        widget.snackBarBackgroundColor ??
                                            Colors.grey,
                                    content: Text(
                                        "You can only select ${widget.maxSelection} items",
                                        style: widget
                                            .maxSelectionSnackBarTextStyle),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          }
                        }
                        widget.onSelectionChanged(_selectedValues);
                      });
                      setState(() {}); // Update the main field chips
                    },
                    onSelectAll: (checked) {
                      setOverlayState(() {
                        _handleSelectAll(checked);
                      });
                      setState(() {});
                    },
                    onClearAll: () {
                      setOverlayState(() {
                        _selectedValues.clear();
                        widget.onSelectionChanged(_selectedValues);
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.labelTextPosition,
      children: [
        Text(widget.labelText, style: widget.labelTextStyle ?? const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: widget.spaceBtLabelAndField),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
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
                      : widget.isSingleSelect
                          ? Text(
                              _allOptions.firstWhere((item) => _selectedValues.contains(item.value)).label,
                              style: widget.chipTextStyle,
                            )
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
        )],
    );
  }
}