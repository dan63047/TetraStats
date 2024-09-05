// p1nkl0bst3r data objects

class Cutoffs{
  DateTime ts;
  Map<String, double> tr;
  Map<String, double> glicko;
  Map<String, double> gxe;

  Cutoffs(this.ts, this.tr, this.glicko, this.gxe);
}

class TopTr{
  String id;
  double? tr;

  TopTr(this.id, this.tr);
}