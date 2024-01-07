import 'package:flutter/material.dart';

class DemoSearchDropdown extends StatefulWidget {
  const DemoSearchDropdown({super.key});

  @override
  State<DemoSearchDropdown> createState() => _DemoSearchDropdownState();
}

class _DemoSearchDropdownState extends State<DemoSearchDropdown> {
  late String selectedItem;
  late List<String> items;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    selectedItem = '';
    items = [
      'Apple',
      'Banana',
      'Cherry',
      'Date',
      'Elderberry',
      'Fig',
      'Grapes',
      'Honeydew'
    ];
    searchController = TextEditingController();
  }

  List<String> _getFilteredItems(String query) {
    return items.where((String item) {
      return item.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown with Search Filter'),
      ),
      body: Center(
        child: PopupMenuButton<String>(
          initialValue: selectedItem,
          onSelected: (String newValue) {
            /* widget.onSelected(newValue); */
            setState(() {
              selectedItem = newValue;
            });
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                enabled: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              ..._getFilteredItems(searchController.text).map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ];
          },
          child: Container(
            height: 50,
            width: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(selectedItem),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
