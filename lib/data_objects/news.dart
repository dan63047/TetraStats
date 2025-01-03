// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/news_entry.dart';

class News{
  late String id;
  late List<NewsEntry> news;

  News(this.id, this.news);

  News.fromJson(Map<String, dynamic> json, String? userID){
    id = userID != null ? "user_$userID" : json['news'].first['stream'];
    news = [for (var entry in json['news']) NewsEntry.fromJson(entry)];
  }
}
