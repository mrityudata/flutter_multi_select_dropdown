import 'package:flutter/material.dart';
import 'package:flutter_multiselect_plus/flutter_multiselect_plus.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PackagePreview(),
  ));
}

class PackagePreview extends StatefulWidget {
  const PackagePreview({super.key});

  @override
  State<PackagePreview> createState() => _PackagePreviewState();
}

class _PackagePreviewState extends State<PackagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "MultiSelect Dropdown Plus",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("1. Modern Multi-Select with Icons"),
            MultiSelectDropdown<String>(
              items: [
                MultiSelectOption(value: 'dart', label: 'Dart', icon: Icons.code),
                MultiSelectOption(value: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
                MultiSelectOption(value: 'android', label: 'Android', icon: Icons.android),
                MultiSelectOption(value: 'ios', label: 'iOS', icon: Icons.apple),
                MultiSelectOption(value: 'web', label: 'Web', icon: Icons.web),
                MultiSelectOption(value: 'desktop', label: 'Desktop', icon: Icons.desktop_mac),
              ],
              onSelectionChanged: (selected) => debugPrint("Selected: $selected"),
              labelText: "Select Technology Stack",
              hintText: "Choose technologies...",
              selectedItemColor: Colors.deepPurple,
              chipColor: Colors.deepPurple.withValues(alpha: 0.1),
              chipTextStyle: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
              dropdownHeight: 300,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("2. Clean Single Select Mode"),
            MultiSelectDropdown<String>(
              items: [
                MultiSelectOption(value: 'high', label: 'High Priority', icon: Icons.priority_high),
                MultiSelectOption(value: 'medium', label: 'Medium Priority', icon: Icons.low_priority),
                MultiSelectOption(value: 'low', label: 'Low Priority', icon: Icons.arrow_downward),
              ],
              isSingleSelect: true,
              onSelectionChanged: (selected) => debugPrint("Priority: $selected"),
              labelText: "Ticket Priority",
              hintText: "Select priority level",
              selectedItemColor: Colors.orange,
              inputFieldDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 1.5),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("3. Custom Limit (Max 2 Items)"),
            MultiSelectDropdown<String>(
              items: [
                MultiSelectOption(value: 'monday', label: 'Monday'),
                MultiSelectOption(value: 'tuesday', label: 'Tuesday'),
                MultiSelectOption(value: 'wednesday', label: 'Wednesday'),
                MultiSelectOption(value: 'thursday', label: 'Thursday'),
                MultiSelectOption(value: 'friday', label: 'Friday'),
              ],
              maxSelection: 2,
              onSelectionChanged: (selected) => debugPrint("Days: $selected"),
              labelText: "Select Work Days (Max 2)",
              hintText: "Pick your days",
              selectedItemColor: Colors.teal,
              onMaxSelectionLimitReached: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Slow down! Only 2 days allowed."),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("4. Full Custom Search & UI"),
            MultiSelectDropdown<String>(
              items: List.generate(
                20,
                (index) => MultiSelectOption(
                  value: 'item_$index',
                  label: 'Custom Item #${index + 1}',
                ),
              ),
              onSelectionChanged: (selected) {},
              labelText: "Long List Search",
              hintText: "Search from 20 items...",
              showSearch: true,
              sortByLabel: true,
              dropdownHeight: 350,
              searchHintText: "Start typing to filter...",
              selectedItemColor: Colors.pink,
              title: "Available Options",
              dropDownTitleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
              doneTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
