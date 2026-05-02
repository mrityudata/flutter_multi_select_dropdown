import 'package:flutter/material.dart';
import 'package:flutter_multiselect_dropdown/flutter_multiselect_dropdown.dart';

void main(){
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PackagePreview()
  ));
}

class PackagePreview extends StatelessWidget {
  const PackagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multiselect Dropdown Example"),centerTitle: true,backgroundColor: Colors.orangeAccent,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            MultiSelectDropdown<String>(
              labelText: "Fruit List",
              searchHintText: "Search fruits",
              title: "Fruits",
              hintText: "Select fruits",
              showSearch: true,
              labelTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5
              ),
              searchHintTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
              ),
              hintTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
              ),
                dropDownTitleStyle : TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5
            ),
              listLabelTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
              ),
              selectAllTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
              ),
              clearAllTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
              ),
              doneTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
              ),
              inputFieldDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 2)
              ),
              chipColor: Colors.orangeAccent,
              items: [
                MultiSelectOption(value: "apple", label: "Apple"),
                MultiSelectOption(value: "banana", label: "Banana"),
                MultiSelectOption(value: "cherry", label: "Cherry"),
                MultiSelectOption(value: "date", label: "Date"),
                MultiSelectOption(value: "mango", label: "Mango"),
                MultiSelectOption(value: "kiwi", label: "Kiwi"),
                MultiSelectOption(value: "orange", label: "Orange"),
                MultiSelectOption(value: "watermelon", label: "Watermelon"),
                MultiSelectOption(value: "starfruit", label: "Starfruit"),
                MultiSelectOption(value: "strawberry", label: "Strawberry"),
                MultiSelectOption(value: "pineapple", label: "Pineapple"),
                MultiSelectOption(value: "grapes", label: "Grapes"),
              ],
              maxSelection: null,
              sortByLabel: false,
              onSelectionChanged: (selectedValues) {
                debugPrint("User selected: $selectedValues");
              },
            ),
          ],
        ),
      ),
    );
  }
}