// ignore_for_file: hash_and_equals

class Distinguishment {
  late String type;
  String? detail;
  String? header;
  String? text;
  String? footer;

  Distinguishment({required this.type, this.detail, this.header, this.footer});

  Distinguishment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    detail = json['detail'];
    text = json['text'];
    header = json['header'];
    footer = json['footer'];
  }

  @override
  bool operator ==(covariant Distinguishment other) => type == other.type && detail == other.detail && header == other.header && footer == other.footer;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['detail'] = detail;
    if (text != null) data['text'] = text;
    data['header'] = header;
    data['footer'] = footer;
    return data;
  }
}
