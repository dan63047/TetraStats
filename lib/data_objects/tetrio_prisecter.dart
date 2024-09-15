class Prisecter {
  late final num pri;
  late final num sec;
  late final num ter;

  Prisecter(this.pri, this.sec, this.ter);

  @override
  String toString() {
    return "${pri}:${sec}:${ter}";
  }

  Prisecter.fromJson(Map<String, dynamic> json){
    pri = json['pri'];
    sec = json['sec'];
    ter = json['ter'];
  }
}