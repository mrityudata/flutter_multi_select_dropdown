## 1.1.0

* **Major UI Update**: Migrated from `AlertDialog` to a modern **Overlay-based Dropdown** for a more seamless user experience.
* **New Feature**: Added **Single Select Mode** with automatic UI switching to Radio button style.
* **New Feature**: Added **Icon support** for dropdown items.
* **New Feature**: Added **Dynamic Positioning** (Dropdown automatically opens above if there is no space below).
* **Performance**: Implemented **Search Debouncing** (300ms) to improve performance on large lists.
* **Customization**: Added `dropdownHeight` parameter to control the maximum height of the dropdown.
* **Customization**: Added `onMaxSelectionLimitReached` callback for custom handling when the limit is hit.
* **UX**: Added an optional **"Done" button** in the dropdown footer for better accessibility.
* **Theme Support**: Improved integration with Flutter's `ThemeData` for automatic Dark Mode support.
* **Documentation**: Added full Dart documentation comments for all classes and properties.

## 1.0.0

* **Initial Release**:
* Full-featured Multiselect Dropdown with generic type support.
* Built-in Search/Filtering logic.
* Select All and Clear All functionality.
* Customizable Max Selection limit.
* Extensive UI customization (Colors, TextStyles, Decorations, and Chips).
