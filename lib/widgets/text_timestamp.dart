import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';

final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();

String timestamp(DateTime dateTime){
  int timestampMode = prefs.getInt("timestampMode")??0;
  return timestampMode == 2 ? relativeDateTime(dateTime) : dateFormat.format(timestampMode == 1 ? dateTime.toLocal() : dateTime);
}

// class TextTimestamp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return;
//   }
  
// }