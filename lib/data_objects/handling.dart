// ignore_for_file: hash_and_equals

class Handling {
  late num arr;
  late num das;
  late num sdf;
  late num dcd;
  late bool cancel;
  late bool safeLock;

  Handling({required this.arr, required this.das, required this.sdf, required this.dcd, required this.cancel, required this.safeLock});

  Handling.fromJson(Map<String, dynamic> json) {
    arr = json['arr'];
    das = json['das'];
    dcd = json['dcd'];
    sdf = json['sdf'];
    safeLock = json['safelock'];
    cancel = json['cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['arr'] = arr.toDouble();
    data['das'] = das.toDouble();
    data['dcd'] = dcd.toDouble();
    data['sdf'] = sdf.toDouble();
    data['safelock'] = safeLock;
    data['cancel'] = cancel;
    return data;
  }
}
