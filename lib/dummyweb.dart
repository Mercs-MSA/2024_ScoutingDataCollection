import 'dart:typed_data';

// ignore: camel_case_types
class document {
  static _Body? body;

  static dynamic createElement(String tag) {
    document.body = _Body();
    return HTMLAnchorElement();
  }
}

class _Body {
  void appendChild(dynamic element) {}
  void removeChild(dynamic element) {}
}

class HTMLAnchorElement {
  String href = '';
  String style = '';
  String download = '';

  void click() {}
}
