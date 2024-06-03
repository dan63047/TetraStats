// p1nkl0bst3r data objects

class Cutoffs{
  Map<String, double> tr;
  Map<String, double> glicko;

  Cutoffs(this.tr, this.glicko);
}

class TopTr{
  String id;
  double? tr;

  TopTr(this.id, this.tr);
}