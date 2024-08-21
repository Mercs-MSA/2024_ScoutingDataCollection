import 'dart:convert';

Map<String, dynamic> getForm(String data) {
  return jsonDecode(data);
}

List<String> extractSectionNames(Map<String, dynamic> configData) {
  List<String> names = [];

  // Check if sections exist and is a list
  if (configData.containsKey('sections') && configData['sections'] is List) {
    List<dynamic> sections = configData['sections'];
    for (var section in sections) {
      if (section is Map<String, dynamic> && section.containsKey('name')) {
        names.add(section['name']);
      }
    }
  }

  return names;
}
