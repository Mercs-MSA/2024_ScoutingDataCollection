import 'package:flutter/material.dart';

/// FormCheckTile widget class
class FormCheckTile {
  final String id;
  final String name;
  final bool tristate;

  FormCheckTile({required this.id, required this.name, required this.tristate});

  /// Function to return the actual widget
  Widget toWidget() {
    return CheckboxListTile(
      title: Text(name),
      value: tristate ? null : false, // Using null for tristate
      tristate: tristate,
      onChanged: (bool? value) {},
    );
  }
}

/// FormDivider widget class
class FormDivider {
  final String direction;

  FormDivider({required this.direction});

  /// Function to return the actual widget
  Widget toWidget() {
    return direction == 'vertical'
        ? const VerticalDivider(thickness: 1)
        : const Divider(thickness: 1);
  }
}

/// FormLayout widget class that handles recursive layouts
class FormLayout {
  final String mode; // 'row' or 'column'
  final List<dynamic> content;

  FormLayout({required this.mode, required this.content});

  /// Function to return the actual widget
  Widget toWidget() {
    List<Widget> children = content.map((item) {
      // Determine widget type
      print(item);
      if (item is CheckboxListTile) {
        return Expanded(child: item);
      } else if (item is VerticalDivider) {
        return item;
      } else if (item is Divider) {
        return item;
      } else if (item is Column) {
        return item;
      } else if (item is FormLayout) {
        return item.toWidget(); // Recursively handle nested layouts
      } else {
        return const SizedBox(); // Fallback widget if type is unknown
      }
    }).toList();

    // Return Row or Column based on mode
    return mode == 'row' ? Row(children: children) : Column(children: children);
  }
}

// Helper function to generate a widget based on JSON-like data
Widget generateWidgetFromData(Map<String, dynamic> data) {
  if (data['type'] == 'checkbox_tile') {
    // Create FormCheckTile
    return FormCheckTile(
      id: data['id'],
      name: data['name'],
      tristate: data['tristate'],
    ).toWidget();
  } else if (data['type'] == 'divider') {
    // Create FormDivider
    return FormDivider(
      direction: data['direction'],
    ).toWidget();
  } else if (data['type'] == 'layout') {
    // Create FormLayout
    List<dynamic> contentData = data['content'];
    List<Widget> contentWidgets = contentData.map<Widget>((item) {
      return generateWidgetFromData(item);
    }).toList();

    print(contentWidgets);
    return FormLayout(
      mode: data['mode'],
      content: contentWidgets,
    ).toWidget();
  } else {
    return const SizedBox(); // Fallback if type is unknown
  }
}

// Function to generate a page from a list of data
Widget generatePageFromData(Map<String, dynamic> pageData) {
  List<Widget> widgets = pageData["tabs"][0]["content"].map<Widget>((item) {
    return generateWidgetFromData(item);
  }).toList();

  // Returning a Column with the widgets for a full page
  return ListView(children: widgets);
}
