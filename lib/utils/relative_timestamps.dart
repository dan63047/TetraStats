import 'package:tetra_stats/utils/numers_formats.dart';

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