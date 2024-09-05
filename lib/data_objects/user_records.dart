// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';

class UserRecords{
  String id;
  RecordSingle? sprint;
  RecordSingle? blitz;
  TetrioZen zen;

  UserRecords(this.id, this.sprint, this.blitz, this.zen);
}
