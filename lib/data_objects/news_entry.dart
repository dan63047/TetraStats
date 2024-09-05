// ignore_for_file: hash_and_equals

class NewsEntry {
  late String type;
  late Map<String, dynamic> data;
  late DateTime timestamp;

  NewsEntry({required this.type, required this.data, required this.timestamp});

  NewsEntry.fromJson(Map<String, dynamic> json){
    type = json["type"];
    data = json["data"];
    timestamp = DateTime.parse(json['ts']);
  }
}
