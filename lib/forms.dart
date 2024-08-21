import 'dart:convert';

Map<String, dynamic> getForm(String data) {
  return jsonDecode(data);
}
