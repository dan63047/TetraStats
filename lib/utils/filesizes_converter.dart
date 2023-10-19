import 'dart:math';
import 'package:intl/intl.dart';

String bytesToSize(int num){
    if (num.toString().length<= 4) return "$num B";
    List<String> postfixs = ["K", "M", "G", "T", "P", "E"];
    int nl = num.toString().length-1;
    int scale = min((nl / 3).truncate(), postfixs.length);
    double newNum = num / pow(1024, scale);
    int decimalLength = nl / 3 <= postfixs.length ? 2 - nl % 3 : 0;
    return "${NumberFormat.decimalPatternDigits(decimalDigits: decimalLength).format(newNum)} ${postfixs[scale-1]}iB";
}
    