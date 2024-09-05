// ignore_for_file: hash_and_equals

class RecordExtras{

}

class ZenithExtras extends RecordExtras{
  List<String> mods = [];

  ZenithExtras.fromJson(Map<String, dynamic> json){
    for (var mod in json["mods"]) {
      mods.add(mod);
    }
  }
}
