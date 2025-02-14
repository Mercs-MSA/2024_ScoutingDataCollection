// ignore: camel_case_types
class document {
  static Body? body;

  static dynamic createElement(String tag) {
    document.body = Body();
    return HTMLAnchorElement();
  }
}

class Body {
  void appendChild(dynamic element) {}
  void removeChild(dynamic element) {}
}

class HTMLAnchorElement {
  String href = '';
  String style = '';
  String download = '';

  void click() {}
}
