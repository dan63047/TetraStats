import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

final NumberFormat secs = NumberFormat("00.###", LocaleSettings.currentLocale.languageCode);
final NumberFormat fixedSecs = NumberFormat("00.000", LocaleSettings.currentLocale.languageCode);
final NumberFormat nonsecs = NumberFormat("00", LocaleSettings.currentLocale.languageCode);
final NumberFormat nonsecs3 = NumberFormat("000", LocaleSettings.currentLocale.languageCode);
final NumberFormat _timeInSec = NumberFormat("#,###.###s.", LocaleSettings.currentLocale.languageCode);

/// Returns string, that represents time difference between [dateTime] and now
String relativeDateTime(DateTime dateTime){
  Duration difference = dateTime.difference(DateTime.now());
  bool inPast = difference.isNegative;
  Duration absDifference = difference.abs();
  double timeInterval;

  // years
  timeInterval = absDifference.inSeconds / 31536000; 
  if (timeInterval >= 100.0) {
    return inPast ? "${timeInterval.truncate()} years ago" : "in ${timeInterval.truncate()} years";
  } else if (timeInterval >= 10.0) {
    return inPast ? "${f1.format(timeInterval)} years ago" : "in ${f1.format(timeInterval)} years";
  } else if (timeInterval >= 1.0) {
    return inPast ? "${f2.format(timeInterval)} years ago" : "in ${f2.format(timeInterval)} years";
  }

  // months
  timeInterval = absDifference.inSeconds / 2592000; 
  if (timeInterval >= 10.0) {
    return inPast ? "${timeInterval.truncate()} months ago" : "in ${timeInterval.truncate()} months";
  } else if (timeInterval >= 1.0) {
    return inPast ? "${f1.format(timeInterval)} months ago" : "in ${f1.format(timeInterval)} months";
  }

  // days
  timeInterval = absDifference.inSeconds / 86400; 
  if (timeInterval >= 10.0) {
    return inPast ? "${timeInterval.truncate()} days ago" : "in ${timeInterval.truncate()} days";
  } else if (timeInterval >= 1.0) {
    return inPast ? "${f1.format(timeInterval)} days ago" : "in ${f1.format(timeInterval)} days";
  }

  // hours
  timeInterval = absDifference.inSeconds / 3600; 
  if (timeInterval >= 10.0) {
    return inPast ? "${timeInterval.truncate()} hours ago" : "in ${timeInterval.truncate()} hours";
  } else if (timeInterval >= 1.0) {
    return inPast ? "${f1.format(timeInterval)} hours ago" : "in ${f1.format(timeInterval)} hours";
  }

  // minutes
  timeInterval = absDifference.inSeconds / 60; 
  if (timeInterval >= 10.0) {
    return inPast ? "${timeInterval.truncate()} minutes ago" : "in ${timeInterval.truncate()} minutes";
  } else if (timeInterval >= 1.0) {
    return inPast ? "${f1.format(timeInterval)} minutes ago" : "in ${f1.format(timeInterval)} minutes";
  }

  // seconds
  timeInterval = absDifference.inMilliseconds / 1000; 
  if (timeInterval >= 10.0) {
    return inPast ? "${timeInterval.truncate()} seconds ago" : "in ${timeInterval.truncate()} seconds";
  } else {
    return inPast ? "${f1.format(timeInterval)} seconds ago" : "in ${f1.format(timeInterval)} seconds";
  }
}

/// Takes number of [microseconds] and returns readable 40 lines time
String get40lTime(int microseconds){
  return microseconds > 60000000 ? "${(microseconds/1000000/60).floor()}:${(secs.format(microseconds /1000000 % 60))}" : _timeInSec.format(microseconds / 1000000);
}

String getMoreNormalTime(Duration time){
  return "${nonsecs.format(time.inMinutes)}:${(fixedSecs.format(time.inMilliseconds/1000%60))}";
}

/// Readable [a] - [b], without sign
String readableTimeDifference(Duration a, Duration b){
  Duration result = a - b;
  
  return NumberFormat("0.000s;0.000s", LocaleSettings.currentLocale.languageCode).format(result.inMilliseconds/1000);
}

String countdown(Duration difference){
  return "${difference.inDays}d ${nonsecs.format(difference.inHours%24)}h ${nonsecs.format(difference.inMinutes%60)}m ${secs.format(difference.inSeconds%60)}s";
}

String playtime(Duration difference){
  if (difference.inHours > 0) return "${intf.format(difference.inHours)}h ${nonsecs.format(difference.inMinutes%60)}m";
  else if (difference.inMinutes > 0) return "${difference.inMinutes}m ${nonsecs.format(difference.inSeconds%60)}s";
  else return "${secs.format(difference.inMilliseconds/1000)}s";
}