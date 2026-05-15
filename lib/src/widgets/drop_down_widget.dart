import 'package:flutter/material.dart';
import '../../flutter_multiselect_plus.dart';
import 'multi_selection_option_widget.dart';

/// A widget that displays the content of the multi-select dropdown menu.
///
/// This widget is typically shown as an overlay and contains a search bar,
/// a list of selectable options, and action buttons like "Select All",
/// "Clear All", and "Done".
class DropDownWidget<T> extends StatelessWidget {
  /// The full list of options available for selection.
  final List<MultiSelectOption<T>> itemList;

  /// The list of currently selected values.
  final List<T> selectedValues;

  /// The fixed width of the dropdown menu.
  final double? width;

  /// The text style for the labels of the items in the list.
  final TextStyle? listLabelTextStyle;

  /// Internal padding for the "Select All" and "Clear All" section.
  final EdgeInsetsGeometry? selectClearAllPadding;

  /// Style for the "Select All" button text.
  final TextStyle? selectAllTextStyle;

  /// Style for the "Clear All" button text.
  final TextStyle? clearAllTextStyle;

  /// Style for the [searchHintText].
  final TextStyle? searchHintTextStyle;

  /// Placeholder text for the search input field inside the dropdown.
  final String searchHintText;

  /// Toggle to show or hide the search bar inside the dropdown.
  final bool showSearch;

  /// Controller for the search input field.
  final TextEditingController searchController;

  /// Controller for the scrollable list of options.
  final ScrollController listScrollController;

  /// Callback triggered when the search query changes.
  final ValueChanged<String>? onSearchChange;

  /// Callback triggered when the clear search icon is tapped.
  final VoidCallback? onClearSearchIcon;

  /// Callback triggered when an option in the list is tapped.
  final Function(T) onItemTap;

  /// Callback triggered when the "Select All" checkbox is toggled.
  final Function(bool?) onSelectAll;

  /// Callback triggered when the "Clear All" button is tapped.
  final VoidCallback onClearAll;

  /// Whether the dropdown allows only a single selection.
  final bool isSingleSelect;

  /// The color used for the active/selected items.
  final Color? selectedItemColor;

  /// Message displayed when the search query returns no matching items.
  final String noResultText;

  /// Style for the [noResultText] message.
  final TextStyle? noResultTextStyle;

  /// Color of the icon shown when no search results are found.
  final Color? noSearchIconColor;

  /// The size of the "no results" icon.
  final double? noSearchIconSize;

  /// The maximum height of the dropdown menu.
  final double dropdownHeight;

  /// The title text displayed at the top of the dropdown (not currently used in internal UI but passed from parent).
  final String title;

  /// The background color of the dropdown menu.
  final Color? dropdownMenuColor;

  /// Custom input decoration for the search text field.
  final InputDecoration? searchFieldDecoration;

  /// Style for the "Done" action button text.
  final TextStyle? doneTextStyle;

  /// Callback triggered when the "Done" button is tapped.
  final VoidCallback onDone;

  /// A custom widget to display between items in the list.
  final Widget? separatorWidget;

  const DropDownWidget({
    required this.itemList,
    required this.selectedValues,
    required this.searchController,
    required this.listScrollController,
    this.separatorWidget,
    this.searchHintText = "Search...",
    this.onClearSearchIcon,
    this.selectClearAllPadding,
    this.width,
    this.listLabelTextStyle,
    this.showSearch = true,
    this.selectAllTextStyle,
    this.clearAllTextStyle,
    this.searchHintTextStyle,
    this.onSearchChange,
    required this.onItemTap,
    required this.onSelectAll,
    required this.onClearAll,
    required this.onDone,
    this.isSingleSelect = false,
    this.selectedItemColor,
    this.noResultText = "No results found",
    this.noResultTextStyle,
    this.noSearchIconColor,
    this.noSearchIconSize,
    this.dropdownHeight = 400,
    this.title = "Select Items",
    this.dropdownMenuColor,
    this.searchFieldDecoration,
    this.doneTextStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAllSelected = itemList.isNotEmpty &&
        itemList.every((item) => selectedValues.contains(item.value));

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: dropdownMenuColor ?? Theme.of(context).cardColor,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: dropdownHeight,
          minHeight: 100,
        ),
        width: width ?? 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// search bar
            if (showSearch)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                  decoration: searchFieldDecoration ??
                      InputDecoration(
                        hintText: searchHintText,
                        hintStyle: searchHintTextStyle ??
                            TextStyle(color: Theme.of(context).hintColor),
                        prefixIcon: Icon(Icons.search,
                            color: Theme.of(context).iconTheme.color),
                        suffixIcon: searchController.text.isNotEmpty
                            ? InkWell(
                                onTap: onClearSearchIcon,
                                child: Icon(Icons.cancel,
                                    color: Theme.of(context).iconTheme.color),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                  controller: searchController,
                  onChanged: onSearchChange,
                ),
              ),

            /// select all / clear all
            if (!isSingleSelect)
              Padding(
                padding: selectClearAllPadding ??
                    const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: isAllSelected, onChanged: onSelectAll),
                        Text(
                          "Select All",
                          style: (selectAllTextStyle ??
                                  const TextStyle(fontSize: 14))
                              .copyWith(
                            color: selectAllTextStyle?.color ??
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: onClearAll,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (clearAllTextStyle?.color ?? Colors.red)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Clear All",
                          style: (clearAllTextStyle ??
                                  const TextStyle(fontSize: 12))
                              .copyWith(
                            color: clearAllTextStyle?.color ?? Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            /// options list
            Expanded(
              child: itemList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: noSearchIconSize ?? 48,
                            color: noSearchIconColor ?? Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            noResultText,
                            style: noResultTextStyle ??
                                const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Scrollbar(
                      controller: listScrollController,
                      child: ListView.separated(
                        controller: listScrollController,
                        padding: EdgeInsets.zero,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          final item = itemList[index];
                          return MultiSelectOptionWidget(
                            isSingleSelect: isSingleSelect,
                            textStyle: listLabelTextStyle,
                            item: item,
                            isSelected: selectedValues.contains(item.value),
                            selectedColor: selectedItemColor,
                            onTap: () => onItemTap(item.value),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return separatorWidget ??
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              );
                        },
                      ),
                    ),
            ),

            /// footer done button
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onDone,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedItemColor ?? Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Done",
                    style: doneTextStyle ??
                        const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
