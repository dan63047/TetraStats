import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';

final NumberFormat comparef = NumberFormat("+#,###.###;-#,###.###")..maximumFractionDigits = 3;
final NumberFormat intf = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0);
final NumberFormat f4 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 4);
final NumberFormat f3 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 3);
final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
final NumberFormat f2l = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2)..minimumFractionDigits = 0;
final NumberFormat f0 = NumberFormat.decimalPattern(LocaleSettings.currentLocale.languageCode);
final NumberFormat percentage = NumberFormat.percentPattern(LocaleSettings.currentLocale.languageCode)..maximumFractionDigits = 2;