# Flutter Multiselect Plus

A highly customizable, searchable multiselect dropdown for Flutter. Effortlessly handle multiple or single selections with support for generic types, "Select All" logic, and professional overlay UI.

## 📸 Previews

| Multi-Select Mode | Single-Select Mode |
| :---: | :---: |
| ![Multi](https://raw.githubusercontent.com/mrityudata/flutter_multiselect_plus/main/screenshots/selected_items.png) | ![Single](https://raw.githubusercontent.com/mrityudata/flutter_multiselect_plus/main/screenshots/selecting_priority.png) |

| Search Functionality | Max Selection Limit | 
| :---: | :---: |
| ![Search](https://raw.githubusercontent.com/mrityudata/flutter_multiselect_plus/main/screenshots/searching_item.png) | ![Limit](https://raw.githubusercontent.com/mrityudata/flutter_multiselect_plus/main/screenshots/selecting_days.png) |

## 🚀 Key Features

*   **Modern Overlay UI**: No more boring dialogs. The menu floats over your UI and stays anchored to the field.
*   **Multi & Single Select**: Support for both modes with automatic UI switching (Checkbox vs Radio).
*   **Generic Type Support**: Use with Strings, Integers, or custom Data Models.
*   **Searchable with Debounce**: Built-in search bar with a 300ms delay for high-performance filtering.
*   **Smart Positioning**: Automatically detects screen boundaries and opens upwards if there's no space below.
*   **Icon Support**: Add leading icons to your selection items for a better UX.
*   **Fully Customizable**: Deeply customize colors, text styles, chip decorations, and the "Done" action button.
*   **Dark Mode Ready**: Automatically integrates with your app's `ThemeData`.

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_multiselect_plus: ^1.1.0
```

## 🛠 Usage

### Multi-Select Example
```dart
MultiSelectDropdown<String>(
  items: [
    MultiSelectOption(value: 'dart', label: 'Dart', icon: Icons.code),
    MultiSelectOption(value: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
  ],
  onSelectionChanged: (selectedValues) {
    print(selectedValues);
  },
)
```

### Single-Select Example
```dart
MultiSelectDropdown<int>(
  isSingleSelect: true,
  items: [
    MultiSelectOption(value: 1, label: 'High Priority'),
    MultiSelectOption(value: 2, label: 'Low Priority'),
  ],
  onSelectionChanged: (value) {
    print(value);
  },
)
```

## 🎨 Customization parameters

| Parameter | Description |
| :--- | :--- |
| `isSingleSelect` | Toggle between Multi and Single selection modes. |
| `dropdownHeight` | Set the maximum height for the dropdown menu. |
| `selectedItemColor` | The color used for checkboxes, radio buttons, and active icons. |
| `onMaxSelectionLimitReached` | Callback triggered when the user tries to select more than `maxSelection`. |
| `doneTextStyle` | Custom styling for the "Done" action button. |
| `showSearch` | Show or hide the search bar. |
| `sortByLabel` | Alphabetically sort items by their label. |

## 📝 License

This project is licensed under the BSD-3-Clause License - see the [LICENSE](LICENSE) file for details.
