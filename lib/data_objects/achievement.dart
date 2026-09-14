// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/tetrio_prisecter.dart';

class Achievement {
  int? k;
  int? o;
  Map<String, dynamic>? u;
  int? rt;
  int? vt;
  int? min;
  int? deci;
  String? name;
  String? object;
  String? category;
  bool? hidden;
  int? art;
  bool? nolb;
  String? desc;
  String? n;
  String? sId;
  double? v;
  late int? a;
  DateTime? t;
  int? pos;
  int? total;
  int? rank;
  Prisecter? prisecter;

  Achievement(
      {required this.k,
      this.o,
      this.u,
      required this.rt,
      required this.vt,
      required this.min,
      required this.deci,
      required this.name,
      this.object,
      required this.category,
      required this.hidden,
      required this.art,
      required this.nolb,
      required this.desc,
      required this.n,
      this.sId,
      this.v,
      required this.a,
      this.t,
      this.pos,
      this.total,
      this.rank,
      this.prisecter});

  @override
  String toString(){
    return "${name}: ${v}";
  }

  Achievement.fromJson(Map<String, dynamic> json) {
    k = json['k'];
    o = json['o'];
    rt = json['rt'];
    vt = json['vt'];
    min = json['min'];
    deci = json['deci'];
    name = json['name'];
    object = json['object'];
    category = json['category'];
    hidden = json['hidden'];
    art = json['art'];
    nolb = json['nolb'];
    desc = json['desc'];
    n = json['n'];
    sId = json['_id'];
    v = json['v']?.toDouble();
    a = json['a'];
    t = json['t'] != null ? DateTime.parse(json['t']) : null;
    pos = json['pos'];
    total = json['total'];
    rank = json['rank'];
    if (json.containsKey('u')) u = json['u'];
    if (json.containsKey('p')) prisecter = Prisecter.fromJson(json['p']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['k'] = k;
    data['o'] = o;
    data['rt'] = rt;
    data['vt'] = vt;
    data['min'] = min;
    data['deci'] = deci;
    data['name'] = name;
    data['object'] = object;
    data['category'] = category;
    data['hidden'] = hidden;
    data['art'] = art;
    data['nolb'] = nolb;
    data['desc'] = desc;
    data['n'] = n;
    data['_id'] = sId;
    data['v'] = v;
    data['a'] = a;
    data['t'] = t.toString();
    data['pos'] = pos;
    data['total'] = total;
    data['rank'] = rank;
    return data;
  }
}
