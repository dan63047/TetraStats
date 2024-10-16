/// Generated file. Do not edit.
///
/// Original: res/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 1818 (606 per locale)
///
/// Built on 2024-09-30 at 21:23 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	ru(languageCode: 'ru', build: _StringsRu.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	Map<String, String> get locales => {
		'en': 'English',
		'ru': 'Russian (Русский)',
		'zh-CN': 'Simplified Chinese (简体中文)',
	};
	String get tetraLeague => 'Tetra League';
	String get tlRecords => 'TL Records';
	String get history => 'History';
	String get sprint => '40 Lines';
	String get blitz => 'Blitz';
	String get recent => 'Recent';
	String get recentRuns => 'Recent runs';
	String blitzScore({required Object p}) => '${p} points';
	String get openSPreplay => 'Open replay in TETR.IO';
	String get downloadSPreplay => 'Download replay';
	String get other => 'Other';
	String get distinguishment => 'Distinguishment';
	String get zen => 'Zen';
	String get bio => 'Bio';
	String get news => 'News';
	late final _StringsNewsPartsEn newsParts = _StringsNewsPartsEn._(_root);
	String get openSearch => 'Search player';
	String get closeSearch => 'Close search';
	String get searchHint => 'Nickname, ID or Discord userID (with "ds:" prefix)';
	String get refresh => 'Refresh';
	String get fetchAndsaveTLHistory => 'Get player history';
	String get fetchAndSaveOldTLmatches => 'Get Tetra League matches history';
	String fetchAndsaveTLHistoryResult({required Object number}) => '${number} states was found';
	String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} matches was found';
	String get showStoredData => 'Show stored data';
	String get statsCalc => 'Stats Calculator';
	String get settings => 'Settings';
	String get track => 'Track';
	String get stopTracking => 'Stop\ntracking';
	String get becameTracked => 'Added to tracking list!';
	String get compare => 'Compare';
	String get stoppedBeingTracked => 'Removed from tracking list!';
	String get tlLeaderboard => 'Tetra League leaderboard';
	String get noRecords => 'No records';
	String noOldRecords({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'No records',
		one: 'Only ${n} record',
		two: 'Only ${n} records',
		few: 'Only ${n} records',
		many: 'Only ${n} records',
		other: 'Only ${n} records',
	);
	String get noRecord => 'No record';
	String get botRecord => 'Bots are not allowed to set records';
	String get anonRecord => 'Guests are not allowed to set records';
	String get notEnoughData => 'Not enough data';
	String get noHistorySaved => 'No history saved';
	String get pseudoTooltipHeaderInit => 'Hover over point';
	String get pseudoTooltipFooterInit => 'to see detailed data';
	String obtainDate({required Object date}) => 'Obtained ${date}';
	String fetchDate({required Object date}) => 'Fetched ${date}';
	String get exactGametime => 'Exact gametime';
	String get bigRedBanned => 'BANNED';
	String get normalBanned => 'Banned';
	String get bigRedBadStanding => 'BAD STANDING';
	String get copiedToClipboard => 'Copied to clipboard!';
	String get playerRoleAccount => ' account ';
	String get wasFromBeginning => 'that was from very beginning';
	String get created => 'created';
	String get botCreatedBy => 'by';
	String get notSupporter => 'Not a supporter';
	String get assignedManualy => 'That badge was assigned manualy by TETR.IO admins';
	String supporter({required Object tier}) => 'Supporter tier ${tier}';
	String comparingWith({required Object newDate, required Object oldDate}) => 'Data from ${newDate} comparing with ${oldDate}';
	String get top => 'Top';
	String get topRank => 'Top rank';
	String verdictGeneral({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} than ${rank} rank average';
	String get verdictBetter => 'better';
	String get verdictWorse => 'worse';
	String get smooth => 'Smooth';
	String get postSeason => 'Off-season';
	String get seasonStarts => 'Season starts in:';
	String get nanow => 'Not avaliable for now...';
	String seasonEnds({required Object countdown}) => 'Season ends in ${countdown}';
	String get seasonEnded => 'Season has ended';
	String gamesUntilRanked({required Object left}) => '${left} games until being ranked';
	String numOfVictories({required Object wins}) => '~${wins} victories';
	String get promotionOnNextWin => 'Promotion on next win';
	String numOfdefeats({required Object losses}) => '~${losses} defeats';
	String get demotionOnNextLoss => 'Demotion on next loss';
	String get nerdStats => 'Nerd Stats';
	String get playersYouTrack => 'Players you track';
	String get formula => 'Formula';
	String get exactValue => 'Exact value';
	String get neverPlayedTL => 'That user never played Tetra League';
	String get botTL => 'Bots are not allowed to play Tetra League';
	String get anonTL => 'Guests are not allowed to play Tetra League';
	String get quickPlay => 'Quick Play';
	String get expert => 'Expert';
	String get withMods => 'With mods';
	String withModsPlural({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'with ${n} mods',
		one: 'with ${n} mod',
		two: 'with ${n} mods',
		few: 'with ${n} mods',
		many: 'with ${n} mods',
		other: 'with ${n} mods',
	);
	String get exportDB => 'Export local database';
	String get exportDBDescription => 'It contains states and Tetra League records of the tracked players and list of tracked players.';
	String get desktopExportAlertTitle => 'Desktop export';
	String get desktopExportText => 'It seems like you using this app on desktop. Check your documents folder, you should find "TetraStats.db". Copy it somewhere';
	String get androidExportAlertTitle => 'Android export';
	String androidExportText({required Object exportedDB}) => 'Exported.\n${exportedDB}';
	String get importDB => 'Import local database';
	String get importDBDescription => 'Restore your backup. Notice that already stored database will be overwritten.';
	String get importWrongFileType => 'Wrong file type';
	String get importCancelled => 'Operation was cancelled';
	String get importSuccess => 'Import successful';
	String get yourID => 'Your TETR.IO account';
	String get yourIDAlertTitle => 'Your nickname in TETR.IO';
	String get yourIDText => 'When app loads, it will retrieve data for this account';
	String get language => 'Language';
	String get updateInBackground => 'Update stats in the background';
	String get updateInBackgroundDescription => 'While Tetra Stats is running, it can update stats of the current player when cache expires';
	String get customization => 'Customization';
	String get customizationDescription => 'Change appearance of different things in Tetra Stats UI';
	String get oskKagari => 'Osk Kagari gimmick';
	String get oskKagariDescription => 'If on, osk\'s rank on main view will be rendered as :kagari:';
	String get AccentColor => 'Accent color';
	String get AccentColorDescription => 'Almost all interactive UI elements highlighted with this color';
	String get timestamps => 'Timestamps';
	String get timestampsDescription => 'You can choose, in which way timestamps shows time';
	String get timestampsAbsoluteGMT => 'Absolute (GMT)';
	String get timestampsAbsoluteLocalTime => 'Absolute (Your timezone)';
	String get timestampsRelative => 'Relative';
	String get rating => 'Main representation of rating';
	String get ratingDescription => 'TR is not linear, while Glicko does not have boundaries and percentile is volatile';
	String get ratingLBposition => 'LB position';
	String get sheetbotGraphs => 'Sheetbot-like behavior for radar graphs';
	String get sheetbotGraphsDescription => 'If on, points on the graphs can appear on the opposite half of the graph if value is negative';
	String get lbStats => 'Show leaderboard based stats';
	String get lbStatsDescription => 'That will impact on loading times, but will allow you to see position on LB by stats and comparison with average values';
	String get aboutApp => 'About app';
	String aboutAppText({required Object appName, required Object packageName, required Object version, required Object buildNumber}) => '${appName} (${packageName}) Version ${version} Build ${buildNumber}\n\nDeveloped by dan63047\nFormulas provided by kerrmunism\nHistory provided by p1nkl0bst3r\nTETR.IO replay grabber API by szy';
	String stateViewTitle({required Object nickname, required Object date}) => '${nickname} account on ${date}';
	String statesViewTitle({required Object number, required Object nickname}) => '${number} states of ${nickname} account';
	String matchesViewTitle({required Object nickname}) => '${nickname} TL matches';
	String statesViewEntry({required Object level, required Object glicko, required Object rd, required Object games}) => '${level} TR, ${glicko}±${rd} Glicko, ${games} игр сыграно';
	String stateRemoved({required Object date}) => '${date} state was removed from database!';
	String matchRemoved({required Object date}) => '${date} match was removed from database!';
	String get viewAllMatches => 'View all matches';
	String get trackedPlayersViewTitle => 'Stored data';
	String get trackedPlayersZeroEntrys => 'Empty list. Press "Track" button in previous view to add current player here';
	String get trackedPlayersOneEntry => 'There is only one player';
	String trackedPlayersManyEntrys({required Object numberOfPlayers}) => 'There are ${numberOfPlayers} players';
	String trackedPlayersEntry({required Object nickname, required Object numberOfStates}) => '${nickname}: ${numberOfStates} states';
	String trackedPlayersDescription({required Object firstStateDate, required Object lastStateDate}) => 'From ${firstStateDate} until ${lastStateDate}';
	String trackedPlayersStatesDeleted({required Object nickname}) => '${nickname} states was removed from database!';
	String get duplicatedFix => 'Remove duplicated TL mathces';
	String get compressDB => 'Compress DB';
	String SpaceSaved({required Object size}) => 'Space saved: ${size}';
	String averageXrank({required Object rankLetter}) => 'Average ${rankLetter} rank';
	String get vs => 'vs';
	String get inTLmatch => 'in TL match';
	String get downloadReplay => 'Download .ttrm replay';
	String get openReplay => 'Open replay in TETR.IO';
	String replaySaved({required Object path}) => 'Replay saved to ${path}';
	String get match => 'Match';
	String get timeWeightedmatch => 'Match (time-weighted)';
	String roundNumber({required Object n}) => 'Round ${n}';
	String get statsFor => 'Stats for';
	String get numberOfRounds => 'Number of rounds';
	String get matchLength => 'Match Length';
	String get roundLength => 'Round Length';
	String get matchStats => 'Match stats';
	String get timeWeightedmatchStats => 'Time-weighted match stats';
	String get replayIssue => 'Can\'t process replay';
	String get matchIsTooOld => 'Replay is not available';
	String get winner => 'Winner';
	String get registred => 'Registred';
	String get playedTL => 'Played Tetra League';
	String get winChance => 'Win Chance';
	String get byGlicko => 'By Glicko';
	String get byEstTR => 'By Est. TR';
	String compareViewNoValues({required Object avgR}) => 'Please, enter username, user ID, APM-PPS-VS values (divider doesn\'t matter, only order matter) or ${avgR} (where R is rank) to both fields';
	String compareViewWrongValue({required Object value}) => 'Falied to assign ${value}';
	String get mostRecentOne => 'Most recent one';
	String get yes => 'Yes';
	String get no => 'No';
	String get daysLater => 'days later';
	String get dayseBefore => 'days before';
	String get fromBeginning => 'From beginning';
	String get calc => 'Calc';
	String get calcViewNoValues => 'Enter values to calculate the stats';
	String get rankAveragesViewTitle => 'Ranks cutoffs';
	String get sprintAndBlitsViewTitle => '40 lines and Blitz averages';
	String sprintAndBlitsRelevance({required Object date}) => 'Relevance: ${date}';
	String get rank => 'Rank';
	String get averages => 'Averages';
	String get lbViewZeroEntrys => 'Empty list';
	String get lbViewOneEntry => 'There is only one player';
	String lbViewManyEntrys({required Object numberOfPlayers}) => 'There are ${numberOfPlayers}';
	String get everyoneAverages => 'Values for leaderboard';
	String get sortBy => 'Sort by';
	String get reversed => 'Reversed';
	String get country => 'Country';
	String rankAverages({required Object rank}) => 'Values for ${rank} rank';
	String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '${n} players',
		one: '${n} player',
		two: '${n} players',
		few: '${n} players',
		many: '${n} players',
		other: '${n} players',
	);
	String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '${n} games',
		one: '${n} game',
		two: '${n} games',
		few: '${n} games',
		many: '${n} games',
		other: '${n} games',
	);
	String gamesPlayed({required Object games}) => '${games} played';
	String get chart => 'Chart';
	String get entries => 'Entries';
	String get minimums => 'Minimums';
	String get maximums => 'Maximums';
	String get lowestValues => 'Lowest Values';
	String get averageValues => 'Average Values';
	String get highestValues => 'Highest Values';
	String forPlayer({required Object username}) => 'for player ${username}';
	String currentAxis({required Object axis}) => '${axis} axis:';
	String get p1nkl0bst3rAlert => 'That data was retrived from third party API maintained by p1nkl0bst3r';
	String get notForWeb => 'Function is not available for web version';
	late final _StringsGraphsEn graphs = _StringsGraphsEn._(_root);
	late final _StringsStatCellNumEn statCellNum = _StringsStatCellNumEn._(_root);
	Map<String, String> get playerRole => {
		'user': 'User',
		'banned': 'Banned',
		'bot': 'Bot',
		'sysop': 'System operator',
		'admin': 'Admin',
		'mod': 'Moderator',
		'halfmod': 'Community moderator',
		'anon': 'Anonymous',
	};
	late final _StringsNumOfGameActionsEn numOfGameActions = _StringsNumOfGameActionsEn._(_root);
	late final _StringsPopupActionsEn popupActions = _StringsPopupActionsEn._(_root);
	late final _StringsErrorsEn errors = _StringsErrorsEn._(_root);
	Map<String, String> get countries => {
		'': 'Worldwide',
		'AF': 'Afghanistan',
		'AX': 'Åland Islands',
		'AL': 'Albania',
		'DZ': 'Algeria',
		'AS': 'American Samoa',
		'AD': 'Andorra',
		'AO': 'Angola',
		'AI': 'Anguilla',
		'AQ': 'Antarctica',
		'AG': 'Antigua and Barbuda',
		'AR': 'Argentina',
		'AM': 'Armenia',
		'AW': 'Aruba',
		'AU': 'Australia',
		'AT': 'Austria',
		'AZ': 'Azerbaijan',
		'BS': 'Bahamas',
		'BH': 'Bahrain',
		'BD': 'Bangladesh',
		'BB': 'Barbados',
		'BY': 'Belarus',
		'BE': 'Belgium',
		'BZ': 'Belize',
		'BJ': 'Benin',
		'BM': 'Bermuda',
		'BT': 'Bhutan',
		'BO': 'Bolivia, Plurinational State of',
		'BA': 'Bosnia and Herzegovina',
		'BW': 'Botswana',
		'BV': 'Bouvet Island',
		'BR': 'Brazil',
		'IO': 'British Indian Ocean Territory',
		'BN': 'Brunei Darussalam',
		'BG': 'Bulgaria',
		'BF': 'Burkina Faso',
		'BI': 'Burundi',
		'KH': 'Cambodia',
		'CM': 'Cameroon',
		'CA': 'Canada',
		'CV': 'Cape Verde',
		'BQ': 'Caribbean Netherlands',
		'KY': 'Cayman Islands',
		'CF': 'Central African Republic',
		'TD': 'Chad',
		'CL': 'Chile',
		'CN': 'China',
		'CX': 'Christmas Island',
		'CC': 'Cocos (Keeling) Islands',
		'CO': 'Colombia',
		'KM': 'Comoros',
		'CG': 'Congo',
		'CD': 'Congo, the Democratic Republic of the',
		'CK': 'Cook Islands',
		'CR': 'Costa Rica',
		'CI': 'Côte d\'Ivoire',
		'HR': 'Croatia',
		'CU': 'Cuba',
		'CW': 'Curaçao',
		'CY': 'Cyprus',
		'CZ': 'Czech Republic',
		'DK': 'Denmark',
		'DJ': 'Djibouti',
		'DM': 'Dominica',
		'DO': 'Dominican Republic',
		'EC': 'Ecuador',
		'EG': 'Egypt',
		'SV': 'El Salvador',
		'GB-ENG': 'England',
		'GQ': 'Equatorial Guinea',
		'ER': 'Eritrea',
		'EE': 'Estonia',
		'ET': 'Ethiopia',
		'EU': 'Europe',
		'FK': 'Falkland Islands (Malvinas)',
		'FO': 'Faroe Islands',
		'FJ': 'Fiji',
		'FI': 'Finland',
		'FR': 'France',
		'GF': 'French Guiana',
		'PF': 'French Polynesia',
		'TF': 'French Southern Territories',
		'GA': 'Gabon',
		'GM': 'Gambia',
		'GE': 'Georgia',
		'DE': 'Germany',
		'GH': 'Ghana',
		'GI': 'Gibraltar',
		'GR': 'Greece',
		'GL': 'Greenland',
		'GD': 'Grenada',
		'GP': 'Guadeloupe',
		'GU': 'Guam',
		'GT': 'Guatemala',
		'GG': 'Guernsey',
		'GN': 'Guinea',
		'GW': 'Guinea-Bissau',
		'GY': 'Guyana',
		'HT': 'Haiti',
		'HM': 'Heard Island and McDonald Islands',
		'VA': 'Holy See (Vatican City State)',
		'HN': 'Honduras',
		'HK': 'Hong Kong',
		'HU': 'Hungary',
		'IS': 'Iceland',
		'IN': 'India',
		'ID': 'Indonesia',
		'IR': 'Iran, Islamic Republic of',
		'IQ': 'Iraq',
		'IE': 'Ireland',
		'IM': 'Isle of Man',
		'IL': 'Israel',
		'IT': 'Italy',
		'JM': 'Jamaica',
		'JP': 'Japan',
		'JE': 'Jersey',
		'JO': 'Jordan',
		'KZ': 'Kazakhstan',
		'KE': 'Kenya',
		'KI': 'Kiribati',
		'KP': 'Korea, Democratic People\'s Republic of',
		'KR': 'Korea, Republic of',
		'XK': 'Kosovo',
		'KW': 'Kuwait',
		'KG': 'Kyrgyzstan',
		'LA': 'Lao People\'s Democratic Republic',
		'LV': 'Latvia',
		'LB': 'Lebanon',
		'LS': 'Lesotho',
		'LR': 'Liberia',
		'LY': 'Libya',
		'LI': 'Liechtenstein',
		'LT': 'Lithuania',
		'LU': 'Luxembourg',
		'MO': 'Macao',
		'MK': 'Macedonia, the former Yugoslav Republic of',
		'MG': 'Madagascar',
		'MW': 'Malawi',
		'MY': 'Malaysia',
		'MV': 'Maldives',
		'ML': 'Mali',
		'MT': 'Malta',
		'MH': 'Marshall Islands',
		'MQ': 'Martinique',
		'MR': 'Mauritania',
		'MU': 'Mauritius',
		'YT': 'Mayotte',
		'MX': 'Mexico',
		'FM': 'Micronesia, Federated States of',
		'MD': 'Moldova, Republic of',
		'MC': 'Monaco',
		'ME': 'Montenegro',
		'MA': 'Morocco',
		'MN': 'Mongolia',
		'MS': 'Montserrat',
		'MZ': 'Mozambique',
		'MM': 'Myanmar',
		'NA': 'Namibia',
		'NR': 'Nauru',
		'NP': 'Nepal',
		'NL': 'Netherlands',
		'AN': 'Netherlands Antilles',
		'NC': 'New Caledonia',
		'NZ': 'New Zealand',
		'NI': 'Nicaragua',
		'NE': 'Niger',
		'NG': 'Nigeria',
		'NU': 'Niue',
		'NF': 'Norfolk Island',
		'GB-NIR': 'Northern Ireland',
		'MP': 'Northern Mariana Islands',
		'NO': 'Norway',
		'OM': 'Oman',
		'PK': 'Pakistan',
		'PW': 'Palau',
		'PS': 'Palestine',
		'PA': 'Panama',
		'PG': 'Papua New Guinea',
		'PY': 'Paraguay',
		'PE': 'Peru',
		'PH': 'Philippines',
		'PN': 'Pitcairn',
		'PL': 'Poland',
		'PT': 'Portugal',
		'PR': 'Puerto Rico',
		'QA': 'Qatar',
		'RE': 'Réunion',
		'RO': 'Romania',
		'RU': 'Russian Federation',
		'RW': 'Rwanda',
		'BL': 'Saint Barthélemy',
		'SH': 'Saint Helena, Ascension and Tristan da Cunha',
		'KN': 'Saint Kitts and Nevis',
		'LC': 'Saint Lucia',
		'MF': 'Saint Martin',
		'PM': 'Saint Pierre and Miquelon',
		'VC': 'Saint Vincent and the Grenadines',
		'WS': 'Samoa',
		'SM': 'San Marino',
		'ST': 'Sao Tome and Principe',
		'SA': 'Saudi Arabia',
		'GB-SCT': 'Scotland',
		'SN': 'Senegal',
		'RS': 'Serbia',
		'SC': 'Seychelles',
		'SL': 'Sierra Leone',
		'SG': 'Singapore',
		'SX': 'Sint Maarten (Dutch part)',
		'SK': 'Slovakia',
		'SI': 'Slovenia',
		'SB': 'Solomon Islands',
		'SO': 'Somalia',
		'ZA': 'South Africa',
		'GS': 'South Georgia and the South Sandwich Islands',
		'SS': 'South Sudan',
		'ES': 'Spain',
		'LK': 'Sri Lanka',
		'SD': 'Sudan',
		'SR': 'Suriname',
		'SJ': 'Svalbard and Jan Mayen Islands',
		'SZ': 'Swaziland',
		'SE': 'Sweden',
		'CH': 'Switzerland',
		'SY': 'Syrian Arab Republic',
		'TW': 'Taiwan',
		'TJ': 'Tajikistan',
		'TZ': 'Tanzania, United Republic of',
		'TH': 'Thailand',
		'TL': 'Timor-Leste',
		'TG': 'Togo',
		'TK': 'Tokelau',
		'TO': 'Tonga',
		'TT': 'Trinidad and Tobago',
		'TN': 'Tunisia',
		'TR': 'Turkey',
		'TM': 'Turkmenistan',
		'TC': 'Turks and Caicos Islands',
		'TV': 'Tuvalu',
		'UG': 'Uganda',
		'UA': 'Ukraine',
		'AE': 'United Arab Emirates',
		'GB': 'United Kingdom',
		'US': 'United States',
		'UY': 'Uruguay',
		'UM': 'US Minor Outlying Islands',
		'UZ': 'Uzbekistan',
		'VU': 'Vanuatu',
		'VE': 'Venezuela, Bolivarian Republic of',
		'VN': 'Vietnam',
		'VG': 'Virgin Islands, British',
		'VI': 'Virgin Islands, U.S.',
		'GB-WLS': 'Wales',
		'WF': 'Wallis and Futuna Islands',
		'EH': 'Western Sahara',
		'YE': 'Yemen',
		'ZM': 'Zambia',
		'ZW': 'Zimbabwe',
		'XX': 'Unknown',
		'XM': 'The Moon',
	};
}

// Path: newsParts
class _StringsNewsPartsEn {
	_StringsNewsPartsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get leaderboardStart => 'Got ';
	String get leaderboardMiddle => 'on ';
	String get personalbest => 'Got a new PB in ';
	String get personalbestMiddle => 'of ';
	String get badgeStart => 'Obtained a ';
	String get badgeEnd => 'badge';
	String get rankupStart => 'Obtained ';
	String rankupMiddle({required Object r}) => '${r} rank ';
	String get rankupEnd => 'in Tetra League';
	String get tetoSupporter => 'TETR.IO supporter';
	String get supporterStart => 'Become a ';
	String get supporterGiftStart => 'Received the gift of ';
	String unknownNews({required Object type}) => 'Unknown news of type ${type}';
}

// Path: graphs
class _StringsGraphsEn {
	_StringsGraphsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get attack => 'Attack';
	String get speed => 'Speed';
	String get defense => 'Defense';
	String get cheese => 'Cheese';
}

// Path: statCellNum
class _StringsStatCellNumEn {
	_StringsStatCellNumEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get xpLevel => 'XP Level';
	String get xpProgress => 'Progress to next level';
	String xpFrom0ToLevel({required Object n}) => 'Progress from 0 XP to level ${n}';
	String get xpLeft => 'XP left';
	String get hoursPlayed => 'Hours\nPlayed';
	String get onlineGames => 'Online\nGames';
	String get gamesWon => 'Games\nWon';
	String get totalGames => 'Total Games Played';
	String get totalWon => 'Total Games Won';
	String get friends => 'Friends';
	String get apm => 'Attack\nPer Minute';
	String get vs => 'Versus\nScore';
	String get recordLB => 'Leaderboard placement';
	String get lbp => 'Leaderboard\nplacement';
	String get lbpShort => '№ in LB';
	String get lbpc => 'Country LB\nplacement';
	String get lbpcShort => '№ in local LB';
	String get gamesPlayed => 'Games\nplayed';
	String get gamesWonTL => 'Games\nWon';
	String get winrate => 'Winrate';
	String get level => 'Level';
	String get score => 'Score';
	String get spp => 'Score\nPer Piece';
	String get pieces => 'Pieces\nPlaced';
	String get pps => 'Pieces\nPer Second';
	String get finesseFaults => 'Finesse\nFaults';
	String get finessePercentage => 'Finesse\nPercentage';
	String get keys => 'Key\nPresses';
	String get kpp => 'KP Per\nPiece';
	String get kps => 'KP Per\nSecond';
	String get tr => 'Tetra Rating';
	String get rd => 'Rating Deviation';
	String get app => 'Attack Per Piece';
	String get appDescription => '(Abbreviated as APP) Main efficiency metric. Tells how many attack you producing per piece';
	String get vsapmDescription => 'Basically, tells how much and how efficient you using garbage in your attacks';
	String get dss => 'Downstack\nPer Second';
	String get dssDescription => '(Abbreviated as DS/S) Downstack per Second measures how many garbage lines you clear in a second.';
	String get dsp => 'Downstack\nPer Piece';
	String get dspDescription => '(Abbreviated as DS/P) Downstack per Piece measures how many garbage lines you clear per piece.';
	String get appdsp => 'APP + DS/P';
	String get appdspDescription => 'Just a sum of Attack per Piece and Downstack per Piece.';
	String get cheese => 'Cheese\nIndex';
	String get cheeseDescription => '(Abbreviated as Cheese) Cheese Index is an approximation how much clean / cheese garbage player sends. Lower = more clean. Higher = more cheese.\nInvented by kerrmunism';
	String get gbe => 'Garbage\nEfficiency';
	String get gbeDescription => '(Abbreviated as Gb Eff.) Garbage Efficiency measures how well player uses their garbage. Higher = better or they use their garbage more. Lower = they mostly send their garbage back at cheese or rarely clear garbage.\nInvented by Zepheniah and Dragonboy.';
	String get nyaapp => 'Weighted\nAPP';
	String get nyaappDescription => '(Abbreviated as wAPP) Essentially, a measure of your ability to send cheese while still maintaining a high APP.\nInvented by Wertj.';
	String get area => 'Area';
	String get areaDescription => 'How much space your shape takes up on the graph, if you exclude the cheese and vs/apm sections';
	String get estOfTR => 'Estimated TR';
	String get estOfTRShort => 'Est. TR';
	String get accOfEst => 'Accuracy';
	String get accOfEstShort => 'Acc.';
}

// Path: numOfGameActions
class _StringsNumOfGameActionsEn {
	_StringsNumOfGameActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get pc => 'All Clears';
	String get hold => 'Holds';
	String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '${n} key presses',
		one: '${n} key press',
		two: '${n} key presses',
		few: '${n} key presses',
		many: '${n} key presses',
		other: '${n} key presses',
	);
	String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '${n} T-spins total',
		one: '${n} T-spin total',
		two: '${n} T-spins total',
		few: '${n} T-spins total',
		many: '${n} T-spins total',
		other: '${n} T-spins total',
	);
	String lineClears({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '${n} lines cleared',
		one: '${n} line cleared',
		two: '${n} lines cleared',
		few: '${n} lines cleared',
		many: '${n} lines cleared',
		other: '${n} lines cleared',
	);
}

// Path: popupActions
class _StringsPopupActionsEn {
	_StringsPopupActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancel => 'Cancel';
	String get submit => 'Submit';
	String get ok => 'OK';
}

// Path: errors
class _StringsErrorsEn {
	_StringsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String connection({required Object code, required Object message}) => 'Some issue with connection: ${code} ${message}';
	String get noSuchUser => 'No such user';
	String get noSuchUserSub => 'Either you mistyped something, or the account no longer exists';
	String get discordNotAssigned => 'No user assigned to given Discord ID';
	String get discordNotAssignedSub => 'Make sure you provided valid ID';
	String get history => 'History for that player is missing';
	String get actionSuggestion => 'Perhaps, you want to';
	String get p1nkl0bst3rTLmatches => 'No Tetra League matches was found';
	String get clientException => 'No internet connection';
	String get forbidden => 'Your IP address is blocked';
	String forbiddenSub({required Object nickname}) => 'If you are using VPN or Proxy, turn it off. If this does not help, reach out to ${nickname}';
	String get tooManyRequests => 'You have been rate limited.';
	String get tooManyRequestsSub => 'Wait a few moments and try again';
	String get internal => 'Something happened on the tetr.io side';
	String get internalSub => 'osk, probably, already aware about it';
	String get internalWebVersion => 'Something happened on the tetr.io side (or on oskware_bridge, idk honestly)';
	String get internalWebVersionSub => 'If osk status page says that everything is ok, let dan63047 know about this issue';
	String get oskwareBridge => 'Something happened with oskware_bridge';
	String get oskwareBridgeSub => 'Let dan63047 know';
	String get p1nkl0bst3rForbidden => 'Third party API blocked your IP address';
	String get p1nkl0bst3rTooManyRequests => 'Too many requests to third party API. Try again later';
	String get p1nkl0bst3rinternal => 'Something happened on the p1nkl0bst3r side';
	String get p1nkl0bst3rinternalWebVersion => 'Something happened on the p1nkl0bst3r side (or on oskware_bridge, idk honestly)';
	String get replayAlreadySaved => 'Replay already saved';
	String get replayExpired => 'Replay expired and not available anymore';
	String get replayRejected => 'Third party API blocked your IP address';
}

// Path: <root>
class _StringsRu implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsRu.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsRu _root = this; // ignore: unused_field

	// Translations
	@override Map<String, String> get locales => {
		'en': 'Английский (English)',
		'ru': 'Русский',
		'zh-CN': 'Упрощенный Китайский (简体中文)',
	};
	@override String get tetraLeague => 'Тетра Лига';
	@override String get tlRecords => 'Матчи ТЛ';
	@override String get history => 'История';
	@override String get sprint => '40 линий';
	@override String get blitz => 'Блиц';
	@override String get recent => 'Недавно';
	@override String get recentRuns => 'Недавние';
	@override String blitzScore({required Object p}) => '${p} очков';
	@override String get openSPreplay => 'Открыть повтор в TETR.IO';
	@override String get downloadSPreplay => 'Скачать повтор';
	@override String get other => 'Другое';
	@override String get distinguishment => 'Заслуга';
	@override String get zen => 'Дзен';
	@override String get bio => 'Биография';
	@override String get news => 'Новости';
	@override late final _StringsNewsPartsRu newsParts = _StringsNewsPartsRu._(_root);
	@override String get openSearch => 'Искать игрока';
	@override String get closeSearch => 'Закрыть поиск';
	@override String get searchHint => 'Ник, ID или ID в Discord (с префиксом "ds:")';
	@override String get refresh => 'Обновить';
	@override String get fetchAndsaveTLHistory => 'Получить историю игрока';
	@override String get fetchAndSaveOldTLmatches => 'Получить старые матчи Тетра Лиги';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '${number} состояний было найдено';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} старых матчей было найдено';
	@override String get showStoredData => 'Показать сохранённые данные';
	@override String get statsCalc => 'Калькулятор статистики';
	@override String get settings => 'Настройки';
	@override String get track => 'Отслеживать';
	@override String get stopTracking => 'Перестать\nотслеживать';
	@override String get becameTracked => 'Добавлен в список отслеживания!';
	@override String get stoppedBeingTracked => 'Удалён из списка отслеживания!';
	@override String get compare => 'Сравнить';
	@override String get tlLeaderboard => 'Рейтинговая таблица';
	@override String get noRecords => 'Нет записей';
	@override String noOldRecords({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: 'Нет записей',
		one: 'Всего один матч',
		two: 'Всего ${n} матча',
		few: 'Всего ${n} матча',
		many: 'Всего ${n} матчей',
		other: '${n} матчей',
	);
	@override String get noRecord => 'Нет рекорда';
	@override String get botRecord => 'Ботам нельзя ставить рекорды';
	@override String get anonRecord => 'Гостям нельзя ставить рекорды';
	@override String get notEnoughData => 'Недостаточно данных';
	@override String get noHistorySaved => 'Нет сохранённой истории';
	@override String get pseudoTooltipHeaderInit => 'Наведите курсор на точку';
	@override String get pseudoTooltipFooterInit => 'чтобы узнать подробности';
	@override String obtainDate({required Object date}) => 'Получено ${date}';
	@override String fetchDate({required Object date}) => 'На момент ${date}';
	@override String get exactGametime => 'Время, проведённое в игре';
	@override String get bigRedBanned => 'ЗАБАНЕН';
	@override String get normalBanned => 'Забанен';
	@override String get bigRedBadStanding => 'ПЛОХАЯ РЕПУТАЦИЯ';
	@override String get copiedToClipboard => 'Скопировано в буфер обмена!';
	@override String get playerRoleAccount => ', аккаунт которого ';
	@override String get wasFromBeginning => 'существовал с самого начала';
	@override String get created => 'создан';
	@override String get botCreatedBy => 'игроком';
	@override String get notSupporter => 'Нет саппортерки';
	@override String supporter({required Object tier}) => 'Саппортерка ${tier} уровня';
	@override String get assignedManualy => 'Этот значок был присвоен вручную администрацией TETR.IO';
	@override String comparingWith({required Object newDate, required Object oldDate}) => 'Данные от ${newDate} в сравнении с данными от ${oldDate}';
	@override String get top => 'Топ';
	@override String get topRank => 'Топ ранг';
	@override String verdictGeneral({required Object verdict, required Object rank, required Object n}) => '${verdict} среднего ${rank} ранга на ${n}';
	@override String get verdictBetter => 'Лучше';
	@override String get verdictWorse => 'Хуже';
	@override String get smooth => 'Гладкий';
	@override String get postSeason => 'Внесезонье';
	@override String get seasonStarts => 'Сезон начнётся через:';
	@override String get nanow => 'Пока недоступно...';
	@override String seasonEnds({required Object countdown}) => 'Сезон закончится через ${countdown}';
	@override String get seasonEnded => 'Сезон закончился';
	@override String gamesUntilRanked({required Object left}) => '${left} матчей до получения рейтинга';
	@override String numOfVictories({required Object wins}) => '~${wins} побед';
	@override String get promotionOnNextWin => 'Повышение после следующей победы';
	@override String numOfdefeats({required Object losses}) => '~${losses} поражений';
	@override String get demotionOnNextLoss => 'Понижение после следующего поражения';
	@override String get nerdStats => 'Для задротов';
	@override String get playersYouTrack => 'Отслеживаемые игроки';
	@override String get formula => 'Формула';
	@override String get exactValue => 'Точное значение';
	@override String get neverPlayedTL => 'Этот игрок никогда не играл в Тетра Лигу';
	@override String get botTL => 'Ботам нельзя играть в Тетра Лигу';
	@override String get anonTL => 'Гостям нельзя играть в Тетра Лигу';
	@override String get quickPlay => 'Быстрая Игра';
	@override String get expert => 'Эксперт';
	@override String get withMods => 'С модами';
	@override String withModsPlural({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: 'с ${n} модами',
		one: 'с ${n} модом',
		two: 'с ${n} модами',
		few: 'с ${n} модами',
		many: 'с ${n} модами',
		other: 'с ${n} модами',
	);
	@override String get exportDB => 'Экспортировать локальную базу данных';
	@override String get exportDBDescription => 'Она содержит состояния аккаунтов и их матчей в Тетра Лиге для отслеживаемых игроков и список таких игроков.';
	@override String get desktopExportAlertTitle => 'Экспорт на десктопе';
	@override String get desktopExportText => 'Похоже, вы используете десктопную версию. Проверьте папку "Документы", там вы должны найти файл "TetraStats.db". Скопируйте его куда-нибудь';
	@override String get androidExportAlertTitle => 'Экспорт на Android';
	@override String androidExportText({required Object exportedDB}) => 'Экспортировано.\n${exportedDB}';
	@override String get importDB => 'Импортировать локальную базу данных';
	@override String get importDBDescription => 'Восстановите свою резеврную копию. Обратите внимание, что текущая база данных будет перезаписана.';
	@override String get importWrongFileType => 'Неверный тип файла';
	@override String get importCancelled => 'Операция была отменена';
	@override String get importSuccess => 'Успешно импортировано';
	@override String get yourID => 'Ваш аккаунт в TETR.IO';
	@override String get yourIDAlertTitle => 'Ваш ник в TETR.IO';
	@override String get yourIDText => 'При запуске приложения оно будет получать статистику этого игрока.';
	@override String get language => 'Язык (Language)';
	@override String get updateInBackground => 'Обновлять статистику в фоне';
	@override String get updateInBackgroundDescription => 'Пока Tetra Stats работает, он может обновлять статистику самостоятельно когда кеш истекает';
	@override String get customization => 'Кастомизация';
	@override String get customizationDescription => 'Измените внешний вид пользовательского интерфейса Tetra Stats';
	@override String get oskKagari => '"Оск Кагари" прикол';
	@override String get oskKagariDescription => 'Если включено, вместо настоящего ранга оска будет рендерится :kagari:';
	@override String get AccentColor => 'Цветовой акцент';
	@override String get AccentColorDescription => 'Почти все интерактивные элементы пользовательского интерфейса окрашены в этот цвет';
	@override String get timestamps => 'Метки времени';
	@override String get timestampsDescription => 'Вы можете выбрать, каким образом метки времени показывают время';
	@override String get timestampsAbsoluteGMT => 'Абсолютные (GMT)';
	@override String get timestampsAbsoluteLocalTime => 'Абсолютные (Ваш часовой пояс)';
	@override String get timestampsRelative => 'Относительные';
	@override String get rating => 'Основное представление рейтинга';
	@override String get ratingDescription => 'TR нелинеен, тогда как Glicko не имеет границ, а положение в таблице лидеров волатильно';
	@override String get ratingLBposition => 'Позиция в рейтинге';
	@override String get sheetbotGraphs => 'Графики-радары как у sheetBot';
	@override String get sheetbotGraphsDescription => 'Если включено, точки на графике могут появляться на противоположной стороне графика если значение отрицательное';
	@override String get lbStats => 'Показывать статистику, основанную на рейтинговой таблице';
	@override String get lbStatsDescription => 'Это повлияет на время загрузки, но позволит видеть положение в рейтинге и сравнение со средними значениями по рангу по каждой стате';
	@override String get aboutApp => 'О приложении';
	@override String aboutAppText({required Object appName, required Object packageName, required Object version, required Object buildNumber}) => '${appName} (${packageName}) Версия ${version} Сборка ${buildNumber}\n\nРазработал dan63047\nФормулы предоставил kerrmunism\nИсторию предоставляет p1nkl0bst3r\nВозможность скачивать повторы из TETR.IO предоставляет szy';
	@override String stateViewTitle({required Object nickname, required Object date}) => 'Аккаунт ${nickname} ${date}';
	@override String statesViewTitle({required Object number, required Object nickname}) => '${number} состояний аккаунта ${nickname}';
	@override String matchesViewTitle({required Object nickname}) => 'Матчи аккаунта ${nickname}';
	@override String statesViewEntry({required Object level, required Object glicko, required Object rd, required Object games}) => '${level} TR, ${glicko}±${rd} Glicko, ${games} игр сыграно';
	@override String stateRemoved({required Object date}) => 'Состояние от ${date} было удалено из локальной базы данных!';
	@override String matchRemoved({required Object date}) => 'Матч от ${date} был удален из локальной базы данных!';
	@override String get viewAllMatches => 'Все матчи';
	@override String get trackedPlayersViewTitle => 'Сохранённые данные';
	@override String get trackedPlayersZeroEntrys => 'Пустой список. Вернитесь на предыдущий экран и нажмите кнопку "Отслеживать", чтобы текущий игрок появился здесь';
	@override String get trackedPlayersOneEntry => 'В списке только один игрок';
	@override String trackedPlayersManyEntrys({required Object numberOfPlayers}) => 'В списке ${numberOfPlayers} игроков';
	@override String trackedPlayersEntry({required Object nickname, required Object numberOfStates}) => '${nickname}: ${numberOfStates} состояний';
	@override String trackedPlayersDescription({required Object firstStateDate, required Object lastStateDate}) => 'Начиная с ${firstStateDate} и заканчивая ${lastStateDate}';
	@override String trackedPlayersStatesDeleted({required Object nickname}) => 'Состояния аккаунта ${nickname} были удалены из локальной базы данных!';
	@override String get duplicatedFix => 'Удалить дубликаты матчей в Тетра Лиге';
	@override String get compressDB => 'Сжать базу данных';
	@override String SpaceSaved({required Object size}) => 'Места освобождено: ${size}';
	@override String averageXrank({required Object rankLetter}) => 'Средний ${rankLetter} ранг';
	@override String get vs => 'против';
	@override String get inTLmatch => 'в матче ТЛ';
	@override String get downloadReplay => 'Скачать .ttrm повтор';
	@override String get openReplay => 'Открыть повтор в TETR.IO';
	@override String replaySaved({required Object path}) => 'Повтор сохранён по пути ${path}';
	@override String get match => 'Матч';
	@override String get timeWeightedmatch => 'Матч (взвешенная по времени)';
	@override String roundNumber({required Object n}) => 'Раунд ${n}';
	@override String get statsFor => 'Статистика за';
	@override String get numberOfRounds => 'Количество раундов';
	@override String get matchLength => 'Продолжительность матча';
	@override String get roundLength => 'Продолжительность раунда';
	@override String get matchStats => 'Статистика матча';
	@override String get timeWeightedmatchStats => 'Взвешенная по времени cтатистика матча';
	@override String get replayIssue => 'Ошибка обработки повтора';
	@override String get matchIsTooOld => 'Информация о повторе недоступна';
	@override String get winner => 'Победитель';
	@override String get registred => 'Зарегистрирован';
	@override String get playedTL => 'Играл в Тетра Лигу';
	@override String get winChance => 'Шансы на победу';
	@override String get byGlicko => 'По Glicko';
	@override String get byEstTR => 'По расч. TR';
	@override String compareViewNoValues({required Object avgR}) => 'Пожалуйста, введите никнейм, ID, APM-PPS-VS (неважно, какой разделитель, важен порядок) или ${avgR} (где R это ранг), в оба поля';
	@override String compareViewWrongValue({required Object value}) => 'Не удалось получить ${value}';
	@override String get mostRecentOne => 'Самый последний';
	@override String get yes => 'Да';
	@override String get no => 'Нет';
	@override String get daysLater => 'дней позже';
	@override String get dayseBefore => 'дней раньше';
	@override String get fromBeginning => 'С начала';
	@override String get calc => 'Считать';
	@override String get calcViewNoValues => 'Введите значения, чтобы посчитать статистику';
	@override String get rankAveragesViewTitle => 'Требования рангов';
	@override String get sprintAndBlitsViewTitle => 'Средние результаты 40 линий и блица';
	@override String sprintAndBlitsRelevance({required Object date}) => 'Актуальность: ${date}';
	@override String get rank => 'Ранг';
	@override String get averages => 'Средние значения';
	@override String get lbViewZeroEntrys => 'Рейтинговая таблица пуста';
	@override String get lbViewOneEntry => 'В рейтинговой таблице всего один игрок';
	@override String lbViewManyEntrys({required Object numberOfPlayers}) => 'В рейтинговой таблице находится ${numberOfPlayers}';
	@override String get everyoneAverages => 'Значения таблицы';
	@override String get sortBy => 'Cортировать по';
	@override String get reversed => 'Наоборот';
	@override String get country => 'Страна';
	@override String rankAverages({required Object rank}) => 'Значения для ${rank} ранга';
	@override String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} игроков',
		one: '${n} игрок',
		two: '${n} игрока',
		few: '${n} игрока',
		many: '${n} игроков',
		other: '${n} игроков',
	);
	@override String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} игр',
		one: '${n} игра',
		two: '${n} игры',
		few: '${n} игры',
		many: '${n} игр',
		other: '${n} игр',
	);
	@override String gamesPlayed({required Object games}) => '${games} сыграно';
	@override String get chart => 'График';
	@override String get entries => 'Список';
	@override String get minimums => 'Минимумы';
	@override String get maximums => 'Максимумы';
	@override String get lowestValues => 'Самые низкие показатели';
	@override String get averageValues => 'Средние значения показателей';
	@override String get highestValues => 'Самые высокие показатели';
	@override String forPlayer({required Object username}) => 'для игрока ${username}';
	@override String currentAxis({required Object axis}) => 'Ось ${axis}:';
	@override String get p1nkl0bst3rAlert => 'Эти данные были получены из стороннего API, который поддерживается p1nkl0bst3r';
	@override String get notForWeb => 'Функция недоступна для веб версии';
	@override late final _StringsGraphsRu graphs = _StringsGraphsRu._(_root);
	@override late final _StringsStatCellNumRu statCellNum = _StringsStatCellNumRu._(_root);
	@override Map<String, String> get playerRole => {
		'user': 'Пользователь',
		'banned': 'Заблокированный пользователь',
		'bot': 'Бот',
		'sysop': 'Системный оператор',
		'admin': 'Администратор',
		'mod': 'Модератор',
		'halfmod': 'Модератор сообщества',
		'anon': 'Аноним',
	};
	@override late final _StringsNumOfGameActionsRu numOfGameActions = _StringsNumOfGameActionsRu._(_root);
	@override late final _StringsPopupActionsRu popupActions = _StringsPopupActionsRu._(_root);
	@override late final _StringsErrorsRu errors = _StringsErrorsRu._(_root);
	@override Map<String, String> get countries => {
		'': 'Во всём мире',
		'AF': 'Афганистан',
		'AX': 'Аландские острова',
		'AL': 'Албания',
		'DZ': 'Алжир',
		'AS': 'Американское Самоа',
		'AD': 'Андорра',
		'AO': 'Ангола',
		'AI': 'Ангилья',
		'AQ': 'Антарктида',
		'AG': 'Антигуа и Барбуда',
		'AR': 'Аргентина',
		'AM': 'Армения',
		'AW': 'Аруба',
		'AU': 'Австралия',
		'AT': 'Австрия',
		'AZ': 'Азербайджан',
		'BS': 'Багамские острова',
		'BH': 'Бахрейн',
		'BD': 'Бангладеш',
		'BB': 'Барбадос',
		'BY': 'Беларусь',
		'BE': 'Бельгия',
		'BZ': 'Белиз',
		'BJ': 'Бенин',
		'BM': 'Бермуды',
		'BT': 'Бутан',
		'BO': 'Боливия, Многонациональное Государство',
		'BA': 'Босния и Герцеговина',
		'BW': 'Ботсвана',
		'BV': 'Остров Буве',
		'BR': 'Бразилия',
		'IO': 'Британская территория в Индийском океане',
		'BN': 'Бруней-Даруссалам',
		'BG': 'Болгария',
		'BF': 'Буркина-Фасо',
		'BI': 'Бурунди',
		'KH': 'Камбоджа',
		'CM': 'Камерун',
		'CA': 'Канада',
		'CV': 'Кабо-Верде',
		'BQ': 'Карибские Нидерланды',
		'KY': 'Каймановы острова',
		'CF': 'Центральноафриканская Республика',
		'TD': 'Чад',
		'CL': 'Чили',
		'CN': 'Китай',
		'CX': 'Остров Рождества',
		'CC': 'Кокосовые острова',
		'CO': 'Колумбия',
		'KM': 'Коморские острова',
		'CG': 'Конго',
		'CD': 'Конго, Демократическая Республика',
		'CK': 'Острова Кука',
		'CR': 'Коста-Рика',
		'CI': 'Берег Слоновой Кости',
		'HR': 'Хорватия',
		'CU': 'Куба',
		'CW': 'Кюрасао',
		'CY': 'Кипр',
		'CZ': 'Чешская Республика',
		'DK': 'Дания',
		'DJ': 'Джибути',
		'DM': 'Доминика',
		'DO': 'Доминиканская Республика',
		'EC': 'Эквадор',
		'EG': 'Египет',
		'SV': 'Сальвадор',
		'GB-ENG': 'Англия',
		'GQ': 'Экваториальная Гвинея',
		'ER': 'Эритрея',
		'EE': 'Эстония',
		'ET': 'Эфиопия',
		'EU': 'Европа',
		'FK': 'Фолклендские (Мальвинские) острова',
		'FO': 'Фарерские острова',
		'FJ': 'Фиджи',
		'FI': 'Финляндия',
		'FR': 'Франция',
		'GF': 'Французская Гвиана',
		'PF': 'Французская Полинезия',
		'TF': 'Южные территории Франции',
		'GA': 'Габон',
		'GM': 'Гамбия',
		'GE': 'Грузия',
		'DE': 'Германия',
		'GH': 'Гана',
		'GI': 'Гибралтар',
		'GR': 'Греция',
		'GL': 'Гренландия',
		'GD': 'Гренада',
		'GP': 'Гваделупа',
		'GU': 'Гуам',
		'GT': 'Гватемала',
		'GG': 'Гернси',
		'GN': 'Гвинея',
		'GW': 'Гвинея-Бисау',
		'GY': 'Гайана',
		'HT': 'Гаити',
		'HM': 'Остров Херд и острова Макдональд',
		'VA': 'Святой Престол (государство-городок Ватикан)',
		'HN': 'Гондурас',
		'HK': 'Гонконг',
		'HU': 'Венгрия',
		'IS': 'Исландия',
		'IN': 'Индия',
		'ID': 'Индонезия',
		'IR': 'Иран, Исламская Республика',
		'IQ': 'Ирак',
		'IE': 'Ирландия',
		'IM': 'Остров Мэн',
		'IL': 'Израиль',
		'IT': 'Италия',
		'JM': 'Ямайка',
		'JP': 'Япония',
		'JE': 'Джерси',
		'JO': 'Иордания',
		'KZ': 'Казахстан',
		'KE': 'Кения',
		'KI': 'Кирибати',
		'KP': 'Корея, Народно-Демократическая Республика',
		'KR': 'Корея, Республика',
		'XK': 'Косово',
		'KW': 'Кувейт',
		'KG': 'Кыргызстан',
		'LA': 'Лаосская Народно-Демократическая Республика',
		'LV': 'Латвия',
		'LB': 'Ливан',
		'LS': 'Лесото',
		'LR': 'Либерия',
		'LY': 'Ливия',
		'LI': 'Лихтенштейн',
		'LT': 'Литва',
		'LU': 'Люксембург',
		'MO': 'Макао',
		'MK': 'Македония, бывшая югославская республика',
		'MG': 'Мадагаскар',
		'MW': 'Малави',
		'MY': 'Малайзия',
		'MV': 'Мальдивы',
		'ML': 'Мали',
		'MT': 'Мальта',
		'MH': 'Маршалловы острова',
		'MQ': 'Мартиника',
		'MR': 'Мавритания',
		'MU': 'Маврикий',
		'YT': 'Майотта',
		'MX': 'Мексика',
		'FM': 'Микронезия, Федеративные Штаты',
		'MD': 'Молдова, Республика',
		'MC': 'Монако',
		'ME': 'Черногория',
		'MA': 'Марокко',
		'MN': 'Монголия',
		'MS': 'Монтсеррат',
		'MZ': 'Мозамбик',
		'MM': 'Мьянма',
		'NA': 'Намибия',
		'NR': 'Науру',
		'NP': 'Непал',
		'NL': 'Нидерланды',
		'AN': 'Нидерландские Антильские острова',
		'NC': 'Новая Каледония',
		'NZ': 'Новая Зеландия',
		'NI': 'Никарагуа',
		'NE': 'Нигер',
		'NG': 'Нигерия',
		'NU': 'Ниуэ',
		'NF': 'Остров Норфолк',
		'GB-NIR': 'Северная Ирландия',
		'MP': 'Северные Марианские острова',
		'NO': 'Норвегия',
		'OM': 'Оман',
		'PK': 'Пакистан',
		'PW': 'Палау',
		'PS': 'Палестина',
		'PA': 'Панама',
		'PG': 'Папуа-Новая Гвинея',
		'PY': 'Парагвай',
		'PE': 'Перу',
		'PH': 'Филиппины',
		'PN': 'Питкэрн',
		'PL': 'Польша',
		'PT': 'Португалия',
		'PR': 'Пуэрто-Рико',
		'QA': 'Катар',
		'RE': 'Реюньон',
		'RO': 'Румыния',
		'RU': 'Российская Федерация',
		'RW': 'Руанда',
		'BL': 'Сен-Бартелеми',
		'SH': 'Острова Святой Елены, Вознесения и Тристан-да-Кунья',
		'KN': 'Сент-Китс и Невис',
		'LC': 'Сент-Люсия',
		'MF': 'Сен-Мартен',
		'PM': 'Сен-Пьер и Микелон',
		'VC': 'Сент-Винсент и Гренадины',
		'WS': 'Самоа',
		'SM': 'Сан-Марино',
		'ST': 'Сан-Томе и Принсипи',
		'SA': 'Саудовская Аравия',
		'GB-SCT': 'Шотландия',
		'SN': 'Сенегал',
		'RS': 'Сербия',
		'SC': 'Сейшельские острова',
		'SL': 'Сьерра-Леоне',
		'SG': 'Сингапур',
		'SX': 'Синт-Мартен (голландская часть)',
		'SK': 'Словакия',
		'SI': 'Словения',
		'SB': 'Соломоновы острова',
		'SO': 'Сомали',
		'ZA': 'ЮАР',
		'GS': 'Южная Георгия и Южные Сандвичевы острова',
		'SS': 'Южный Судан',
		'ES': 'Испания',
		'LK': 'Шри-Ланка',
		'SD': 'Судан',
		'SR': 'Суринам',
		'SJ': 'Острова Шпицберген и Ян-Майен',
		'SZ': 'Свазиленд',
		'SE': 'Швеция',
		'CH': 'Швейцария',
		'SY': 'Сирийская Арабская Республика',
		'TW': 'Тайвань',
		'TJ': 'Таджикистан',
		'TZ': 'Танзания, Объединенная Республика',
		'TH': 'Таиланд',
		'TL': 'Тимор-Лешти',
		'TG': 'Того',
		'TK': 'Токелау',
		'TO': 'Tonga',
		'TT': 'Тринидад и Тобаго',
		'TN': 'Тунис',
		'TR': 'Турция',
		'TM': 'Туркменистан',
		'TC': 'Острова Теркс и Кайкос',
		'ТВ': 'Тувалу',
		'UG': 'Уганда',
		'UA': 'Украина',
		'AE': 'Объединенные Арабские Эмираты',
		'GB': 'Великобритания',
		'US': 'Соединенные Штаты',
		'UY': 'Уругвай',
		'UM': 'Малые периферийные острова США',
		'UZ': 'Узбекистан',
		'VU': 'Вануату',
		'VE': 'Венесуэла, Боливарианская Республика',
		'VN': 'Вьетнам',
		'VG': 'Виргинские острова, Британские',
		'VI': 'Виргинские острова, США',
		'GB-WLS': 'Уэльс',
		'WF': 'Острова Уоллис и Футуна',
		'EH': 'Западная Сахара',
		'YE': 'Йемен',
		'ZM': 'Замбия',
		'ZW': 'Зимбабве',
		'XX': 'Неизвестно',
		'XM': 'Луна',
	};
}

// Path: newsParts
class _StringsNewsPartsRu implements _StringsNewsPartsEn {
	_StringsNewsPartsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get leaderboardStart => 'Взял ';
	@override String get leaderboardMiddle => 'в таблице ';
	@override String get personalbest => 'Поставил новый ЛР в ';
	@override String get personalbestMiddle => 'с результатом в ';
	@override String get badgeStart => 'Заработал значок ';
	@override String get badgeEnd => '';
	@override String get rankupStart => 'Заработал ';
	@override String rankupMiddle({required Object r}) => '${r} ранг ';
	@override String get rankupEnd => 'в Тетра Лиге';
	@override String get tetoSupporter => 'TETR.IO supporter';
	@override String get supporterStart => 'Стал обладателем ';
	@override String get supporterGiftStart => 'Получил подарок в виде ';
	@override String unknownNews({required Object type}) => 'Неизвестная новость типа ${type}';
}

// Path: graphs
class _StringsGraphsRu implements _StringsGraphsEn {
	_StringsGraphsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get attack => 'Атака';
	@override String get speed => 'Скорость';
	@override String get defense => 'Защита';
	@override String get cheese => 'Сыр';
}

// Path: statCellNum
class _StringsStatCellNumRu implements _StringsStatCellNumEn {
	_StringsStatCellNumRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get xpLevel => 'Уровень\nопыта';
	@override String get xpProgress => 'Прогресс до следующего уровня';
	@override String xpFrom0ToLevel({required Object n}) => 'Прогресс от 0 XP до ${n} уровня';
	@override String get xpLeft => 'XP осталось';
	@override String get hoursPlayed => 'Часов\nСыграно';
	@override String get onlineGames => 'Онлайн\nИгр';
	@override String get gamesWon => 'Онлайн\nПобед';
	@override String get totalGames => 'Всего матчей';
	@override String get totalWon => 'Всего побед';
	@override String get friends => 'Друзей';
	@override String get apm => 'Атака в\nМинуту';
	@override String get vs => 'Показатель\nVersus';
	@override String get recordLB => 'Место в таблице';
	@override String get lbp => 'Положение\nв рейтинге';
	@override String get lbpShort => '№ в рейтинге';
	@override String get lbpc => 'Положение\nв рейтинге страны';
	@override String get lbpcShort => '№ по стране';
	@override String get gamesPlayed => 'Игр\nСыграно';
	@override String get gamesWonTL => 'Побед';
	@override String get winrate => 'Процент\nпобед';
	@override String get level => 'Уровень';
	@override String get score => 'Счёт';
	@override String get spp => 'Очков\nна Фигуру';
	@override String get pieces => 'Фигур\nУстановлено';
	@override String get pps => 'Фигур в\nСекунду';
	@override String get finesseFaults => 'Ошибок\nТехники';
	@override String get finessePercentage => '% Качества\nТехники';
	@override String get keys => 'Нажатий\nКлавиш';
	@override String get kpp => 'Нажатий\nна Фигуру';
	@override String get kps => 'Нажатий\nв Секунду';
	@override String get tr => 'Тетра Рейтинг';
	@override String get rd => 'Отклонение рейтинга';
	@override String get app => 'Атака на Фигуру';
	@override String get appDescription => '(Сокращенно APP) Главный показатель эффективности. Показывает, сколько атаки приходится на одну фигуру';
	@override String get vsapmDescription => 'В основном, показывает как много мусора игрок использует в своих атаках и насколько эффективно.';
	@override String get dss => 'Downstack\nв Секунду';
	@override String get dssDescription => '(Сокращенно DS/S) Downstack (спуск вниз) в Секунду показывает как много мусорных линий в среднем игрок убирает за одну секунду.';
	@override String get dsp => 'Downstack\nна Фигуру';
	@override String get dspDescription => '(Сокращенно DS/P) Downstack (спуск вниз) на Фигуру показывает как много мусорных линий в среднем игрок убирает одну фигуру.';
	@override String get appdsp => 'APP + DS/P';
	@override String get appdspDescription => 'Просто сумма Атаки на Фигуру и Downstack на Фигуру.';
	@override String get cheese => 'Индекс сыра';
	@override String get cheeseDescription => '(Сокращенно Cheese) Индекс сыра является аппроксимацией того, насколько чистый / дырявый мусор игрок отправляет. Меньше = более чистый. Больше = более дырявый.\nПридумал kerrmunism';
	@override String get gbe => 'Garbage\nEfficiency';
	@override String get gbeDescription => '(Сокращенно Gb Eff.) Garbage Efficiency показывает насколько хорошо игрок использует свой мусор. Больше = лучше (или он использует больше мусора). Меньше = в основном отправляют сыр (или он редко чистит мусор).\nПридумали Zepheniah и Dragonboy.';
	@override String get nyaapp => 'Взвешенный\nAPP';
	@override String get nyaappDescription => '(Сокращенно wAPP) По сути, показывает способность отправлять сыр, сохраняя при этом высокую эффективность.\nПридумал Wertj.';
	@override String get area => 'Area';
	@override String get areaDescription => 'Какую площадь занимает диаграмма, если не брать в расчёт индекс сыра и VS/APM';
	@override String get estOfTR => 'Расчётный TR';
	@override String get estOfTRShort => 'Расч. TR';
	@override String get accOfEst => 'Точность расчёта';
	@override String get accOfEstShort => 'Точность';
}

// Path: numOfGameActions
class _StringsNumOfGameActionsRu implements _StringsNumOfGameActionsEn {
	_StringsNumOfGameActionsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get pc => 'Все чисто';
	@override String get hold => 'В запас';
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} нажатий клавиш',
		one: '${n} нажатие на клавишу',
		two: '${n} нажатия на клавишы',
		few: '${n} нажатия на клавишы',
		many: '${n} нажатий на клавиш',
		other: '${n} нажатий на клавиш',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} T-спинов всего',
		one: 'Всего ${n} T-спин',
		two: '${n} T-спина всего',
		few: '${n} T-спина всего',
		many: '${n} T-спинов всего',
		other: '${n} T-спинов всего',
	);
	@override String lineClears({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} линий очищено',
		one: '${n} линия очищена',
		two: '${n} линии очищено',
		few: '${n} линии очищено',
		many: '${n} линий очищено',
		other: '${n} линий очищено',
	);
}

// Path: popupActions
class _StringsPopupActionsRu implements _StringsPopupActionsEn {
	_StringsPopupActionsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отменить';
	@override String get submit => 'Подтвердить';
	@override String get ok => 'OK';
}

// Path: errors
class _StringsErrorsRu implements _StringsErrorsEn {
	_StringsErrorsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String connection({required Object code, required Object message}) => 'Проблема с подключением: ${code} ${message}';
	@override String get noSuchUser => 'Нет такого пользователя';
	@override String get noSuchUserSub => 'Либо вы ошиблись при вводе, либо аккаунта больше не существует';
	@override String get discordNotAssigned => 'К данному Discord ID не привязан аккаунт';
	@override String get discordNotAssignedSub => 'Убедитесь в том, что вы вставили правильный ID';
	@override String get history => 'История данного игрока отсутствует';
	@override String get actionSuggestion => 'Возможно, вы хотите';
	@override String get p1nkl0bst3rTLmatches => 'Старых матчей Тетра Лиги не было найдено';
	@override String get clientException => 'Нет соединения с интернетом';
	@override String get forbidden => 'Ваш IP адрес заблокирован';
	@override String forbiddenSub({required Object nickname}) => 'Если у вас работает VPN или прокси, выключите его. Если это не помогло, свяжитесь с ${nickname}';
	@override String get tooManyRequests => 'Слишком много запросов';
	@override String get tooManyRequestsSub => 'Подождите немного и попробуйте снова';
	@override String get internal => 'Что-то случилось на стороне tetr.io';
	@override String get internalSub => 'Скорее всего, osk уже в курсе об этом';
	@override String get internalWebVersion => 'Что-то случилось на стороне tetr.io (или на стороне oskware_bridge, я хз если честно)';
	@override String get internalWebVersionSub => 'Если статус страница osk-а говорит, что всё ок - свяжитесь с dan63047';
	@override String get oskwareBridge => 'Что-то случилось с oskware_bridge';
	@override String get oskwareBridgeSub => 'Дайте dan63047 знать';
	@override String get p1nkl0bst3rForbidden => 'Стороннее API заблокировало ваш IP адрес';
	@override String get p1nkl0bst3rTooManyRequests => 'Слишком много запросов к стороннему API. Попробуйте позже';
	@override String get p1nkl0bst3rinternal => 'Что-то случилось на стороне p1nkl0bst3r-а';
	@override String get p1nkl0bst3rinternalWebVersion => 'Что-то случилось на стороне p1nkl0bst3r-а (или на стороне oskware_bridge, я хз если честно)';
	@override String get replayAlreadySaved => 'Повтор уже сохранён';
	@override String get replayExpired => 'Повтор истёк и больше недоступен';
	@override String get replayRejected => 'Стороннее API заблокировало ваш IP адрес';
}

// Path: <root>
class _StringsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override Map<String, String> get locales => {
		'en': '英语 (English)',
		'ru': '俄语 (Русский)',
		'zh-CN': '简体中文',
	};
	@override String get tetraLeague => 'Tetra联赛';
	@override String get tlRecords => 'Tetra联赛记录';
	@override String get history => '历史';
	@override String get sprint => '40行竞速';
	@override String get blitz => '闪电战';
	@override String get recent => '最近';
	@override String get recentRuns => '最近游玩局数';
	@override String blitzScore({required Object p}) => '${p} 分';
	@override String get openSPreplay => '在TETR.IO打开回放';
	@override String get downloadSPreplay => '下载回放';
	@override String get other => '其他';
	@override String get distinguishment => '区别';
	@override String get zen => '禅意模式';
	@override String get bio => '个人简介';
	@override String get news => '新闻';
	@override late final _StringsNewsPartsZhCn newsParts = _StringsNewsPartsZhCn._(_root);
	@override String get openSearch => '搜索玩家';
	@override String get closeSearch => '关闭搜索';
	@override String get searchHint => '昵称，ID或Discord用户ID（需要 "ds:" 前缀）';
	@override String get refresh => '刷新';
	@override String get fetchAndsaveTLHistory => '获取玩家历史';
	@override String get fetchAndSaveOldTLmatches => '获取玩家Tetra联赛历史';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '找到 ${number} 个状态';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '找到 ${number} 场Tetra联赛比赛';
	@override String get showStoredData => '显示获得的数据';
	@override String get statsCalc => '统计计算器';
	@override String get settings => '设置';
	@override String get track => '添加到\n跟踪列表';
	@override String get stopTracking => '从跟踪列表\n中移除';
	@override String get becameTracked => '已添加到跟踪列表！';
	@override String get compare => '对比';
	@override String get stoppedBeingTracked => '已从跟踪列表中移除！';
	@override String get tlLeaderboard => 'Tetra联赛排行榜';
	@override String get noRecords => '无记录';
	@override String noOldRecords({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '无记录',
		one: '只有 ${n} 个记录',
		two: '只有 ${n} 个记录',
		few: '只有 ${n} 个记录',
		many: '只有 ${n} 个记录',
		other: '只有 ${n} 个记录',
	);
	@override String get noRecord => '没有记录';
	@override String get botRecord => '机器人不予参加排位赛';
	@override String get anonRecord => '匿名用户不予参加排位赛';
	@override String get notEnoughData => '没有足够的数据';
	@override String get noHistorySaved => '没有保存历史';
	@override String get pseudoTooltipHeaderInit => '将鼠标放在点上';
	@override String get pseudoTooltipFooterInit => '以查看详细信息';
	@override String obtainDate({required Object date}) => '在 ${date} 获得';
	@override String fetchDate({required Object date}) => 'Fetched ${date}';
	@override String get exactGametime => '实际游玩时长';
	@override String get bigRedBanned => '该账号封禁中';
	@override String get normalBanned => '封禁';
	@override String get bigRedBadStanding => '信誉不佳';
	@override String get copiedToClipboard => '已复制';
	@override String get playerRoleAccount => '账号';
	@override String get wasFromBeginning => '在很久很久以前';
	@override String get created => '创建于';
	@override String get botCreatedBy => '';
	@override String get notSupporter => '非会员';
	@override String get assignedManualy => '该勋章由 TETR.IO 管理员手动分配';
	@override String supporter({required Object tier}) => '会员等级 ${tier}';
	@override String comparingWith({required Object newDate, required Object oldDate}) => '${newDate} 时的数据与 ${oldDate} 比较';
	@override String get top => '前';
	@override String get topRank => '最高段位';
	@override String verdictGeneral({required Object rank, required Object verdict, required Object n}) => '比 ${rank} 段平均数据${verdict} ${n}';
	@override String get verdictBetter => '好';
	@override String get verdictWorse => '差';
	@override String get smooth => '平滑';
	@override String get postSeason => '淡季';
	@override String get seasonStarts => '下一赛即将开始于：';
	@override String get nanow => '暂未完成，敬请等待！';
	@override String seasonEnds({required Object countdown}) => '赛季将会在 ${countdown} 后结束';
	@override String get seasonEnded => 'Season has ended';
	@override String gamesUntilRanked({required Object left}) => '还有 ${left} 场比赛获取段位';
	@override String numOfVictories({required Object wins}) => '~${wins} 场胜局';
	@override String get promotionOnNextWin => '下一次胜利即可升段';
	@override String numOfdefeats({required Object losses}) => '~${losses} 场败局';
	@override String get demotionOnNextLoss => '下一次失败即可掉段';
	@override String get nerdStats => '详细信息';
	@override String get playersYouTrack => '跟踪';
	@override String get formula => '公式';
	@override String get exactValue => '实际值';
	@override String get neverPlayedTL => '此用户没有参与Tetra联赛';
	@override String get botTL => '机器人不予参加Tetra联赛';
	@override String get anonTL => '匿名用户不予参加Tetra联赛';
	@override String get quickPlay => '快速游戏';
	@override String get expert => '专家';
	@override String get withMods => '带着模组';
	@override String withModsPlural({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '带着 ${n} 个模组',
		one: '带着 ${n} 个模组',
		two: '带着 ${n} 个模组',
		few: '带着 ${n} 个模组',
		many: '带着 ${n} 个模组',
		other: '带着 ${n} 个模组',
	);
	@override String get exportDB => '导出本地数据';
	@override String get exportDBDescription => '它包含跟踪的玩家的状态和Tetra联赛记录和跟踪列表。';
	@override String get desktopExportAlertTitle => '桌面导出';
	@override String get desktopExportText => '您好像在使用桌面版。请查看你的“文档”文件夹，你应该能找到“TetraStats.db”。把它复制到一个地方';
	@override String get androidExportAlertTitle => '安卓导出';
	@override String androidExportText({required Object exportedDB}) => '导出成功\n${exportedDB}';
	@override String get importDB => '导入本地数据';
	@override String get importDBDescription => '恢复您的备份。请注意，已存储的数据库将被覆盖。';
	@override String get importWrongFileType => '文件类型错误';
	@override String get importCancelled => '已取消';
	@override String get importSuccess => '导入成功';
	@override String get yourID => '你的 TETR.IO 用户';
	@override String get yourIDAlertTitle => '你的 TETR.IO 昵称';
	@override String get yourIDText => '当程序加载，它将显示此用户的数据';
	@override String get language => '语言';
	@override String get updateInBackground => '自动升级数据';
	@override String get updateInBackgroundDescription => '当 Tetra Stats 运行时，它可以在缓存过期时更新当前玩家的统计数据';
	@override String get customization => '自定义';
	@override String get customizationDescription => '更改 Tetra Stats UI 中不同事物的外观';
	@override String get oskKagari => 'osk 特有的 Kagari 段位';
	@override String get oskKagariDescription => '如果打开，主视图上的 osk 段位将显示为 :kagari:';
	@override String get AccentColor => '主题色';
	@override String get AccentColorDescription => '几乎所有交互式 UI 元素都用此颜色突出显示';
	@override String get timestamps => '时间';
	@override String get timestampsDescription => '您可以选择显示时间的方式';
	@override String get timestampsAbsoluteGMT => '绝对 (GMT)';
	@override String get timestampsAbsoluteLocalTime => '绝对 (你的时区)';
	@override String get timestampsRelative => '相对';
	@override String get rating => '评级主要表现';
	@override String get ratingDescription => 'TR 不是线性的，而 Glicko 没有边界，百分位数易挥发';
	@override String get ratingLBposition => 'LB 位置';
	@override String get sheetbotGraphs => 'Sheetbot式雷达图';
	@override String get sheetbotGraphsDescription => '若开启，雷达图上的点为负时可以出现在对面';
	@override String get lbStats => '显示基于排行榜的数据';
	@override String get lbStatsDescription => '这会影响加载时间，但允许您通过统计数据查看排行榜上的位置并与平均值进行比较';
	@override String get aboutApp => '关于';
	@override String aboutAppText({required Object appName, required Object packageName, required Object version, required Object buildNumber}) => '${appName} (${packageName}) ${version} 版 Build ${buildNumber}\n\n由 dan63047 制作\n由 kerrmunism 提供公式\n由 p1nkl0bst3r 提供历史\nTETR.IO 回放抓取器 API 由 szy 制作';
	@override String stateViewTitle({required Object nickname, required Object date}) => '${nickname} 在 ${date}';
	@override String statesViewTitle({required Object nickname, required Object number}) => '${nickname} 的 ${number} 个状态';
	@override String matchesViewTitle({required Object nickname}) => '${nickname} 的Tetra联赛历史';
	@override String statesViewEntry({required Object level, required Object glicko, required Object rd, required Object games}) => '${level} TR, ${glicko}±${rd} Glicko, ${games} 次游戏';
	@override String stateRemoved({required Object date}) => '成功移除 ${date} 的状态！';
	@override String matchRemoved({required Object date}) => '成功移除 ${date} 的比赛！';
	@override String get viewAllMatches => '查看所有比赛';
	@override String get trackedPlayersViewTitle => '获取的数据';
	@override String get trackedPlayersZeroEntrys => '列表为空。 点击 “添加到跟踪列表” 可以将玩家放在这里';
	@override String get trackedPlayersOneEntry => '只有 1 个玩家';
	@override String trackedPlayersManyEntrys({required Object numberOfPlayers}) => '${numberOfPlayers} 个玩家';
	@override String trackedPlayersEntry({required Object nickname, required Object numberOfStates}) => '${nickname}：${numberOfStates} 个状态';
	@override String trackedPlayersDescription({required Object firstStateDate, required Object lastStateDate}) => '从 ${firstStateDate} 到 ${lastStateDate}';
	@override String trackedPlayersStatesDeleted({required Object nickname}) => '成功从数据库中移除 ${nickname} 个状态！';
	@override String get duplicatedFix => '删除重复的 TL 匹配项';
	@override String get compressDB => '压缩数据库';
	@override String SpaceSaved({required Object size}) => '保存空白：${size}';
	@override String averageXrank({required Object rankLetter}) => '平均 ${rankLetter} 段';
	@override String get vs => 'vs';
	@override String get inTLmatch => '在Tetra联赛中';
	@override String get downloadReplay => '下载 .ttrm 回放';
	@override String get openReplay => '在 TETR.IO 打开回放';
	@override String replaySaved({required Object path}) => '已保存回放至 ${path}';
	@override String get match => '比赛';
	@override String get timeWeightedmatch => '比赛（时间加权）';
	@override String roundNumber({required Object n}) => '第 ${n} 回合';
	@override String get statsFor => '数据：';
	@override String get numberOfRounds => '回合数';
	@override String get matchLength => '比赛时长';
	@override String get roundLength => '回合时长';
	@override String get matchStats => '比赛数据';
	@override String get timeWeightedmatchStats => '时间加权比赛数据';
	@override String get replayIssue => '无法处理回放';
	@override String get matchIsTooOld => '无回放';
	@override String get winner => '赢家';
	@override String get registred => '注册日期';
	@override String get playedTL => '游玩过Tetra联赛';
	@override String get winChance => '胜利机会';
	@override String get byGlicko => '靠Glicko';
	@override String get byEstTR => '靠预测TR';
	@override String compareViewNoValues({required Object avgR}) => '请输入用户名，用户IO，APM-PPS-VS值 （分隔符不重要，只需要顺序）或者${avgR}（R是一个段位）到两个字段';
	@override String compareViewWrongValue({required Object value}) => '获取 ${value} 失败';
	@override String get mostRecentOne => '最接近的';
	@override String get yes => '是';
	@override String get no => '否';
	@override String get daysLater => '天后';
	@override String get dayseBefore => '天前';
	@override String get fromBeginning => '开服';
	@override String get calc => '计算器';
	@override String get calcViewNoValues => '输入值以计算数据';
	@override String get rankAveragesViewTitle => '段位分隔符';
	@override String get sprintAndBlitsViewTitle => '竞速与闪电战平均数据';
	@override String sprintAndBlitsRelevance({required Object date}) => '数据来自${date}';
	@override String get rank => '段位';
	@override String get averages => '平均';
	@override String get lbViewZeroEntrys => '空';
	@override String get lbViewOneEntry => '只有一个玩家';
	@override String lbViewManyEntrys({required Object numberOfPlayers}) => '有 ${numberOfPlayers}';
	@override String get everyoneAverages => 'Tetra联赛散点图';
	@override String get sortBy => '排序依据';
	@override String get reversed => '反向';
	@override String get country => '地区';
	@override String rankAverages({required Object rank}) => '${rank}段位散点图';
	@override String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '${n} 个玩家',
		one: '${n} 个玩家',
		two: '${n} 个玩家',
		few: '${n} 个玩家',
		many: '${n} 个玩家',
		other: '${n} 个玩家',
	);
	@override String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '${n} 场游戏',
		one: '${n} 场游戏',
		two: '${n} 场游戏',
		few: '${n} 场游戏',
		many: '${n} 场游戏',
		other: '${n} 场游戏',
	);
	@override String gamesPlayed({required Object games}) => '${games} 场游戏';
	@override String get chart => '列表';
	@override String get entries => '条目';
	@override String get minimums => '最小值';
	@override String get maximums => '最大值';
	@override String get lowestValues => '最小值';
	@override String get averageValues => '平均值';
	@override String get highestValues => '最大值';
	@override String forPlayer({required Object username}) => '来自用户 ${username}';
	@override String currentAxis({required Object axis}) => '${axis} 轴：';
	@override String get p1nkl0bst3rAlert => '该数据是从 p1nkl0bst3r 维护的第三方 API 中检索的';
	@override String get notForWeb => '浏览器版本暂不支持函数';
	@override late final _StringsGraphsZhCn graphs = _StringsGraphsZhCn._(_root);
	@override late final _StringsStatCellNumZhCn statCellNum = _StringsStatCellNumZhCn._(_root);
	@override Map<String, String> get playerRole => {
		'user': '用户',
		'banned': '封禁',
		'bot': '机器人',
		'sysop': '系统管理员',
		'admin': '管理员',
		'mod': '管理员',
		'halfmod': '社区管理员',
		'anon': '匿名',
	};
	@override late final _StringsNumOfGameActionsZhCn numOfGameActions = _StringsNumOfGameActionsZhCn._(_root);
	@override late final _StringsPopupActionsZhCn popupActions = _StringsPopupActionsZhCn._(_root);
	@override late final _StringsErrorsZhCn errors = _StringsErrorsZhCn._(_root);
	@override Map<String, String> get countries => {
		'': '无',
		'AF': '阿富汗',
		'AX': '奥兰群岛',
		'AL': '阿尔巴尼亚',
		'DZ': '阿尔及利亚',
		'AS': '美属萨摩亚',
		'AD': '安道尔',
		'AO': '安哥拉',
		'AI': '安圭拉',
		'AQ': '南极洲',
		'AG': '安提瓜和巴布达',
		'AR': '阿根廷',
		'AM': '亚美尼亚',
		'AW': '阿鲁巴',
		'AU': '澳大利亚',
		'AT': '奥地利',
		'AZ': '阿塞拜疆',
		'BS': '巴哈马',
		'BH': '巴林',
		'BD': '孟加拉国',
		'BB': '巴巴多斯',
		'BY': '白俄罗斯',
		'BE': '比利时',
		'BZ': '伯利兹',
		'BJ': '贝宁',
		'BM': '百慕大',
		'BT': '不丹',
		'BO': '玻利维亚多民族国',
		'BA': '波斯尼亚和黑塞哥维那',
		'BW': '博茨瓦纳',
		'BV': '布韦岛',
		'BR': '巴西',
		'IO': '英属印度洋领地',
		'BN': '文莱达鲁萨兰国',
		'BG': '保加利亚',
		'BF': '布基纳法索',
		'BI': '布隆迪',
		'KH': '柬埔寨',
		'CM': '喀麦隆',
		'CA': '加拿大',
		'CV': '佛得角',
		'BQ': '荷兰加勒比区',
		'KY': '开曼群岛',
		'CF': '中非',
		'TD': '乍得',
		'CL': '智利',
		'CN': '中国',
		'CX': '圣诞岛',
		'CC': '科科斯（基林）群岛',
		'CO': '哥伦比亚',
		'KM': '科摩罗',
		'CG': '刚果（布）/刚果共和国',
		'CD': '刚果（金）/刚果民主共和国',
		'CK': '库克群岛',
		'CR': '哥斯达黎加',
		'CI': '科特迪瓦',
		'HR': '克罗地亚',
		'CU': '古巴',
		'CW': '库拉索',
		'CY': '塞浦路斯',
		'CZ': '捷克',
		'DK': '丹麦',
		'DJ': '吉布提',
		'DM': '多米尼加',
		'DO': '多米尼加共和国',
		'EC': '厄瓜多尔',
		'EG': '埃及',
		'SV': '萨尔瓦多',
		'GB-ENG': '英格兰',
		'GQ': '赤道几内亚',
		'ER': '厄立特里亚',
		'EE': '爱沙尼亚',
		'ET': '埃塞俄比亚',
		'EU': '欧洲',
		'FK': '福克兰群岛/马尔维纳斯群岛',
		'FO': '法罗群岛',
		'FJ': '斐济',
		'FI': '芬兰',
		'FR': '法国',
		'GF': '法属圭亚那',
		'PF': '法属波利尼西亚',
		'TF': '法属南部领地',
		'GA': '加蓬',
		'GM': '冈比亚',
		'GE': '格鲁吉亚',
		'DE': '德国',
		'GH': '加纳',
		'GI': '直布罗陀',
		'GR': '希腊',
		'GL': '格陵兰岛',
		'GD': '格林纳达',
		'GP': '瓜德罗普岛',
		'GU': '关岛',
		'GT': '危地马拉',
		'GG': '根西岛',
		'GN': '几内亚',
		'GW': '几内亚比绍',
		'GY': '圭亚那',
		'HT': '海地',
		'HM': '赫德岛和麦克唐纳群岛',
		'VA': '梵蒂冈',
		'HN': '洪都拉斯',
		'HK': '中国香港',
		'HU': '匈牙利',
		'IS': '冰岛',
		'IN': '印度',
		'ID': '印度尼西亚',
		'IR': '伊朗',
		'IQ': '伊拉克',
		'IE': '爱尔兰',
		'IM': '马恩岛',
		'IL': '以色列',
		'IT': '意大利',
		'JM': '牙买加',
		'JP': '日本',
		'JE': 'Jersey',
		'JO': '约旦',
		'KZ': '哈萨克斯坦',
		'KE': '肯尼亚',
		'KI': '基里巴斯',
		'KP': '朝鲜',
		'KR': '韩国',
		'XK': '科索沃',
		'KW': '科威特',
		'KG': '吉尔吉斯斯坦',
		'LA': '老挝',
		'LV': '拉脱维亚',
		'LB': '黎巴嫩',
		'LS': '莱索托',
		'LR': '利比里亚',
		'LY': '利比亚',
		'LI': '列支敦士登',
		'LT': '立陶宛',
		'LU': '卢森堡',
		'MO': '中国澳门',
		'MK': '马其顿',
		'MG': '马达加斯加',
		'MW': '马拉维',
		'MY': '马来西亚',
		'MV': '马尔代夫',
		'ML': '马里',
		'MT': '马耳他',
		'MH': '马绍尔群岛',
		'MQ': '马提尼克岛',
		'MR': '毛里塔尼亚',
		'MU': '毛里求斯',
		'YT': '马约特岛',
		'MX': '墨西哥',
		'FM': '密克罗尼西亚联邦',
		'MD': '摩尔多瓦共和国',
		'MC': '摩纳哥',
		'ME': '黑山',
		'MA': '摩洛哥',
		'MN': '蒙古',
		'MS': '蒙特塞拉特',
		'MZ': '莫桑比克',
		'MM': '缅甸',
		'NA': '纳米比亚',
		'NR': '瑙鲁',
		'NP': '尼泊尔',
		'NL': '尼德兰',
		'AN': '荷属安的列斯',
		'NC': '新喀里多尼亚',
		'NZ': '新西兰',
		'NI': '尼加拉瓜',
		'NE': '尼日尔',
		'NG': '尼日利亚',
		'NU': '纽埃',
		'NF': '诺福克岛',
		'GB-NIR': '北爱尔兰',
		'MP': '北马里亚纳群岛',
		'NO': '挪威',
		'OM': '阿曼',
		'PK': '巴基斯坦',
		'PW': '帕劳',
		'PS': '巴勒斯坦',
		'PA': '巴拿马',
		'PG': '巴布亚新几内亚',
		'PY': '巴拉圭',
		'PE': '秘鲁',
		'PH': '菲律宾',
		'PN': '皮特凯恩',
		'PL': '波兰',
		'PT': '葡萄牙',
		'PR': '波多黎各',
		'QA': '卡塔尔',
		'RE': '留尼汪',
		'RO': '罗马尼亚',
		'RU': '俄罗斯联邦',
		'RW': '卢旺达',
		'BL': '圣巴泰勒米',
		'SH': '圣赫勒拿,阿森松和特里斯坦-达库尼亚',
		'KN': '圣基茨和尼维斯',
		'LC': '圣卢西亚',
		'MF': '圣马丁',
		'PM': '圣皮埃尔和密克隆群岛',
		'VC': '圣文森特和格林纳丁斯',
		'WS': '萨摩亚',
		'SM': '圣马力诺',
		'ST': '圣多美和普林西比',
		'SA': '沙特阿拉伯',
		'GB-SCT': '苏格兰',
		'SN': '塞内加尔',
		'RS': '塞尔维亚',
		'SC': '塞舌尔',
		'SL': '塞拉利昂',
		'SG': '新加坡',
		'SX': '荷属圣马丁',
		'SK': '斯洛伐克',
		'SI': '斯洛文尼亚',
		'SB': '所罗门群岛',
		'SO': '索马里',
		'ZA': '南非',
		'GS': '南乔治亚和南桑威奇群岛',
		'SS': '南苏丹',
		'ES': '西班牙',
		'LK': '斯里兰卡',
		'SD': '苏丹',
		'SR': '苏里南',
		'SJ': '斯瓦尔巴和扬马延群岛',
		'SZ': '斯威士兰',
		'SE': '瑞典',
		'CH': '瑞士',
		'SY': '叙利亚',
		'TW': '中国台湾',
		'TJ': '塔吉克斯坦',
		'TZ': '坦桑尼亚',
		'TH': '泰国',
		'TL': '东帝汶',
		'TG': '多哥',
		'TK': '托克劳',
		'TO': '汤加',
		'TT': '特立尼达和多巴哥',
		'TN': '突尼斯',
		'TR': '土耳其',
		'TM': '土库曼斯坦',
		'TC': '特克斯和凯科斯群岛',
		'TV': '图瓦卢',
		'UG': '乌干达',
		'UA': '乌克兰',
		'AE': '阿拉伯联合酋长国',
		'GB': '英国',
		'US': '美国',
		'UY': '乌拉圭',
		'UM': '美国小岛屿',
		'UZ': '乌兹别克斯坦',
		'VU': '瓦努阿图',
		'VE': '委内瑞拉玻利瓦尔共和国',
		'VN': '越南',
		'VG': '英属维尔京群岛',
		'VI': '美属维尔京群岛',
		'GB-WLS': '威尔士',
		'WF': '瓦利斯和富图纳群岛',
		'EH': '西撒哈拉',
		'YE': '也门',
		'ZM': '赞比亚',
		'ZW': '津巴布韦',
		'XX': '未知',
		'XM': '月球',
	};
}

// Path: newsParts
class _StringsNewsPartsZhCn implements _StringsNewsPartsEn {
	_StringsNewsPartsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get leaderboardStart => '取得 ';
	@override String get leaderboardMiddle => '于 ';
	@override String get personalbest => '在 ';
	@override String get personalbestMiddle => ' 中取得了新的个人最好成绩 ';
	@override String get badgeStart => '获得勋章 ';
	@override String get badgeEnd => '';
	@override String get rankupStart => '达成 ';
	@override String rankupMiddle({required Object r}) => '${r} 段位 ';
	@override String get rankupEnd => '';
	@override String get tetoSupporter => 'TETR.IO 会员';
	@override String get supporterStart => '成为了 ';
	@override String get supporterGiftStart => '被赠送了 ';
	@override String unknownNews({required Object type}) => '未知新闻 ${type}';
}

// Path: graphs
class _StringsGraphsZhCn implements _StringsGraphsEn {
	_StringsGraphsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get attack => '攻击';
	@override String get speed => '速度';
	@override String get defense => '防御';
	@override String get cheese => '奶酪层';
}

// Path: statCellNum
class _StringsStatCellNumZhCn implements _StringsStatCellNumEn {
	_StringsStatCellNumZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get xpLevel => 'XP等级';
	@override String get xpProgress => '到下一等级的进度';
	@override String xpFrom0ToLevel({required Object n}) => '从 0 到 ${n} 等级的进度';
	@override String get xpLeft => 'XP 还有';
	@override String get hoursPlayed => '小时游玩';
	@override String get onlineGames => '在线游戏场次';
	@override String get gamesWon => '获胜场次';
	@override String get totalGames => '总在线游戏场次';
	@override String get totalWon => '总在线游戏获胜场次';
	@override String get friends => '好友';
	@override String get apm => '每分\n发送垃圾行';
	@override String get vs => 'VS\n分数';
	@override String get recordLB => '名次';
	@override String get lbp => '名次';
	@override String get lbpShort => '名次';
	@override String get lbpc => '地区\n名次';
	@override String get lbpcShort => '地区名次';
	@override String get gamesPlayed => '游戏\n场次';
	@override String get gamesWonTL => '获胜\n场次';
	@override String get winrate => '胜率';
	@override String get level => '等级';
	@override String get score => '分数';
	@override String get spp => '每块\n得分';
	@override String get pieces => '放置\n块数';
	@override String get pps => '每秒\n放置块数';
	@override String get finesseFaults => '非极简\n操作';
	@override String get finessePercentage => '极简率';
	@override String get keys => '按键';
	@override String get kpp => '每块\n按键';
	@override String get kps => '每秒\n按键';
	@override String get tr => 'Tetra分数';
	@override String get rd => '偏移值';
	@override String get app => '每块发送垃圾行数';
	@override String get appDescription => '(Attack per Piece, 简称APP) 主要效率指标。表示玩家每块可以发动多少次攻击';
	@override String get vsapmDescription => '基本上可以告诉你在攻击中利用垃圾行的效率';
	@override String get dss => '每秒\n挖掘';
	@override String get dssDescription => '(Downstack per Second, 简称 DS/S) 测量一秒钟内清除多少条垃圾行。';
	@override String get dsp => '每块\n挖掘';
	@override String get dspDescription => '(Downstack per Piece, 简称 DS/P) 测量每一块清除多少条垃圾行。';
	@override String get appdsp => 'APP + DS/P';
	@override String get appdspDescription => '只是每块发送垃圾行数与每块挖掘之和。';
	@override String get cheese => '垃圾行\n混乱指数';
	@override String get cheeseDescription => '(Cheese Index, 简称Cheese) 是玩家发出的垃圾行有多整齐/混乱的近似值。低数据代表整齐，高数据代表混乱。\n由 kerrmunism 发明';
	@override String get gbe => '垃圾行\n效率';
	@override String get gbeDescription => '(Garbage Efficity, 简称Gb Eff.) 测量玩家如何很好地利用他们收到的垃圾行。高数据代表更好或者他们更多地用TA的垃圾行，低数据代表TA大多将垃圾行送回奶酪层，或者很少清理垃圾行。\n由 Zepheniah 与 Dragonboy 发明。';
	@override String get nyaapp => '加权\nAPP';
	@override String get nyaappDescription => '(Weighted APP, 简称wAPP) 在本质上是在衡量您在保持高 APP 的同时发送奶酪的能力。\n由 Wertj 发明。';
	@override String get area => '面积';
	@override String get areaDescription => '如果排除 Cheese 和 vs/apm 部分，您的形状在图表上占据了多少空间';
	@override String get estOfTR => '预测 TR';
	@override String get estOfTRShort => '预测 TR';
	@override String get accOfEst => '预测实际差量';
	@override String get accOfEstShort => '预测实际差量';
}

// Path: numOfGameActions
class _StringsNumOfGameActionsZhCn implements _StringsNumOfGameActionsEn {
	_StringsNumOfGameActionsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get pc => '全消数';
	@override String get hold => '暂存数';
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '${n} 次按键',
		one: '${n} 次按键',
		two: '${n} 次按键',
		few: '${n} 次按键',
		many: '${n} 次按键',
		other: '${n} 次按键',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '共 ${n} 次T旋',
		one: '共 ${n} 次T旋',
		two: '共 ${n} 次T旋',
		few: '共 ${n} 次T旋',
		many: '共 ${n} 次T旋',
		other: '共 ${n} 次T旋',
	);
	@override String lineClears({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '清除了 ${n} 行',
		one: '清除了 ${n} 行',
		two: '清除了 ${n} 行',
		few: '清除了 ${n} 行',
		many: '清除了 ${n} 行',
		other: '清除了 ${n} 行',
	);
}

// Path: popupActions
class _StringsPopupActionsZhCn implements _StringsPopupActionsEn {
	_StringsPopupActionsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get submit => '确定';
	@override String get ok => '彳亍';
}

// Path: errors
class _StringsErrorsZhCn implements _StringsErrorsEn {
	_StringsErrorsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String connection({required Object code, required Object message}) => '连接错误： ${code} ${message}';
	@override String get noSuchUser => '没有这样的用户';
	@override String get noSuchUserSub => '检查用户名的拼写是否错误，也许用户不存在';
	@override String get discordNotAssigned => '没有用户绑定到该Discord ID';
	@override String get discordNotAssignedSub => '您必须输入合法的ID';
	@override String get history => '此玩家没有历史';
	@override String get actionSuggestion => '你也许想';
	@override String get p1nkl0bst3rTLmatches => '没有比赛';
	@override String get clientException => '连接不到网络';
	@override String get forbidden => '你的IP地址被封禁';
	@override String forbiddenSub({required Object nickname}) => '请关闭您的VPN。若问题仍然存在，请联系 ${nickname}';
	@override String get tooManyRequests => '您申请的请求过多';
	@override String get tooManyRequestsSub => '等一会再试吧';
	@override String get internal => 'tetr.io 似乎出错了';
	@override String get internalSub => 'osk，也许，要被';
	@override String get internalWebVersion => 'tetr.io 或者 oskware_bridge 似乎出错了';
	@override String get internalWebVersionSub => '如果 osk 说没有什么问题，请让dan63047知道';
	@override String get oskwareBridge => 'oskware_bridge 似乎出错了';
	@override String get oskwareBridgeSub => '请让 dan63047 知道';
	@override String get p1nkl0bst3rForbidden => '第三方API封禁了你的IP地址';
	@override String get p1nkl0bst3rTooManyRequests => '第三方API……太多请求了。';
	@override String get p1nkl0bst3rinternal => 'p1nkl0bst3r 那边似乎出错了';
	@override String get p1nkl0bst3rinternalWebVersion => 'p1nkl0bst3r (或 on oskware_bridge, 其实我并不知道) 那边似乎出错了';
	@override String get replayAlreadySaved => '你已保存此回放';
	@override String get replayExpired => '回放已过期';
	@override String get replayRejected => '第三方API封禁了你的IP地址';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'English';
			case 'locales.ru': return 'Russian (Русский)';
			case 'locales.zh-CN': return 'Simplified Chinese (简体中文)';
			case 'tetraLeague': return 'Tetra League';
			case 'tlRecords': return 'TL Records';
			case 'history': return 'History';
			case 'sprint': return '40 Lines';
			case 'blitz': return 'Blitz';
			case 'recent': return 'Recent';
			case 'recentRuns': return 'Recent runs';
			case 'blitzScore': return ({required Object p}) => '${p} points';
			case 'openSPreplay': return 'Open replay in TETR.IO';
			case 'downloadSPreplay': return 'Download replay';
			case 'other': return 'Other';
			case 'distinguishment': return 'Distinguishment';
			case 'zen': return 'Zen';
			case 'bio': return 'Bio';
			case 'news': return 'News';
			case 'newsParts.leaderboardStart': return 'Got ';
			case 'newsParts.leaderboardMiddle': return 'on ';
			case 'newsParts.personalbest': return 'Got a new PB in ';
			case 'newsParts.personalbestMiddle': return 'of ';
			case 'newsParts.badgeStart': return 'Obtained a ';
			case 'newsParts.badgeEnd': return 'badge';
			case 'newsParts.rankupStart': return 'Obtained ';
			case 'newsParts.rankupMiddle': return ({required Object r}) => '${r} rank ';
			case 'newsParts.rankupEnd': return 'in Tetra League';
			case 'newsParts.tetoSupporter': return 'TETR.IO supporter';
			case 'newsParts.supporterStart': return 'Become a ';
			case 'newsParts.supporterGiftStart': return 'Received the gift of ';
			case 'newsParts.unknownNews': return ({required Object type}) => 'Unknown news of type ${type}';
			case 'openSearch': return 'Search player';
			case 'closeSearch': return 'Close search';
			case 'searchHint': return 'Nickname, ID or Discord userID (with "ds:" prefix)';
			case 'refresh': return 'Refresh';
			case 'fetchAndsaveTLHistory': return 'Get player history';
			case 'fetchAndSaveOldTLmatches': return 'Get Tetra League matches history';
			case 'fetchAndsaveTLHistoryResult': return ({required Object number}) => '${number} states was found';
			case 'fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '${number} matches was found';
			case 'showStoredData': return 'Show stored data';
			case 'statsCalc': return 'Stats Calculator';
			case 'settings': return 'Settings';
			case 'track': return 'Track';
			case 'stopTracking': return 'Stop\ntracking';
			case 'becameTracked': return 'Added to tracking list!';
			case 'compare': return 'Compare';
			case 'stoppedBeingTracked': return 'Removed from tracking list!';
			case 'tlLeaderboard': return 'Tetra League leaderboard';
			case 'noRecords': return 'No records';
			case 'noOldRecords': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: 'No records',
				one: 'Only ${n} record',
				two: 'Only ${n} records',
				few: 'Only ${n} records',
				many: 'Only ${n} records',
				other: 'Only ${n} records',
			);
			case 'noRecord': return 'No record';
			case 'botRecord': return 'Bots are not allowed to set records';
			case 'anonRecord': return 'Guests are not allowed to set records';
			case 'notEnoughData': return 'Not enough data';
			case 'noHistorySaved': return 'No history saved';
			case 'pseudoTooltipHeaderInit': return 'Hover over point';
			case 'pseudoTooltipFooterInit': return 'to see detailed data';
			case 'obtainDate': return ({required Object date}) => 'Obtained ${date}';
			case 'fetchDate': return ({required Object date}) => 'Fetched ${date}';
			case 'exactGametime': return 'Exact gametime';
			case 'bigRedBanned': return 'BANNED';
			case 'normalBanned': return 'Banned';
			case 'bigRedBadStanding': return 'BAD STANDING';
			case 'copiedToClipboard': return 'Copied to clipboard!';
			case 'playerRoleAccount': return ' account ';
			case 'wasFromBeginning': return 'that was from very beginning';
			case 'created': return 'created';
			case 'botCreatedBy': return 'by';
			case 'notSupporter': return 'Not a supporter';
			case 'assignedManualy': return 'That badge was assigned manualy by TETR.IO admins';
			case 'supporter': return ({required Object tier}) => 'Supporter tier ${tier}';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => 'Data from ${newDate} comparing with ${oldDate}';
			case 'top': return 'Top';
			case 'topRank': return 'Top rank';
			case 'verdictGeneral': return ({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} than ${rank} rank average';
			case 'verdictBetter': return 'better';
			case 'verdictWorse': return 'worse';
			case 'smooth': return 'Smooth';
			case 'postSeason': return 'Off-season';
			case 'seasonStarts': return 'Season starts in:';
			case 'nanow': return 'Not avaliable for now...';
			case 'seasonEnds': return ({required Object countdown}) => 'Season ends in ${countdown}';
			case 'seasonEnded': return 'Season has ended';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} games until being ranked';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} victories';
			case 'promotionOnNextWin': return 'Promotion on next win';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} defeats';
			case 'demotionOnNextLoss': return 'Demotion on next loss';
			case 'nerdStats': return 'Nerd Stats';
			case 'playersYouTrack': return 'Players you track';
			case 'formula': return 'Formula';
			case 'exactValue': return 'Exact value';
			case 'neverPlayedTL': return 'That user never played Tetra League';
			case 'botTL': return 'Bots are not allowed to play Tetra League';
			case 'anonTL': return 'Guests are not allowed to play Tetra League';
			case 'quickPlay': return 'Quick Play';
			case 'expert': return 'Expert';
			case 'withMods': return 'With mods';
			case 'withModsPlural': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: 'with ${n} mods',
				one: 'with ${n} mod',
				two: 'with ${n} mods',
				few: 'with ${n} mods',
				many: 'with ${n} mods',
				other: 'with ${n} mods',
			);
			case 'exportDB': return 'Export local database';
			case 'exportDBDescription': return 'It contains states and Tetra League records of the tracked players and list of tracked players.';
			case 'desktopExportAlertTitle': return 'Desktop export';
			case 'desktopExportText': return 'It seems like you using this app on desktop. Check your documents folder, you should find "TetraStats.db". Copy it somewhere';
			case 'androidExportAlertTitle': return 'Android export';
			case 'androidExportText': return ({required Object exportedDB}) => 'Exported.\n${exportedDB}';
			case 'importDB': return 'Import local database';
			case 'importDBDescription': return 'Restore your backup. Notice that already stored database will be overwritten.';
			case 'importWrongFileType': return 'Wrong file type';
			case 'importCancelled': return 'Operation was cancelled';
			case 'importSuccess': return 'Import successful';
			case 'yourID': return 'Your TETR.IO account';
			case 'yourIDAlertTitle': return 'Your nickname in TETR.IO';
			case 'yourIDText': return 'When app loads, it will retrieve data for this account';
			case 'language': return 'Language';
			case 'updateInBackground': return 'Update stats in the background';
			case 'updateInBackgroundDescription': return 'While Tetra Stats is running, it can update stats of the current player when cache expires';
			case 'customization': return 'Customization';
			case 'customizationDescription': return 'Change appearance of different things in Tetra Stats UI';
			case 'oskKagari': return 'Osk Kagari gimmick';
			case 'oskKagariDescription': return 'If on, osk\'s rank on main view will be rendered as :kagari:';
			case 'AccentColor': return 'Accent color';
			case 'AccentColorDescription': return 'Almost all interactive UI elements highlighted with this color';
			case 'timestamps': return 'Timestamps';
			case 'timestampsDescription': return 'You can choose, in which way timestamps shows time';
			case 'timestampsAbsoluteGMT': return 'Absolute (GMT)';
			case 'timestampsAbsoluteLocalTime': return 'Absolute (Your timezone)';
			case 'timestampsRelative': return 'Relative';
			case 'rating': return 'Main representation of rating';
			case 'ratingDescription': return 'TR is not linear, while Glicko does not have boundaries and percentile is volatile';
			case 'ratingLBposition': return 'LB position';
			case 'sheetbotGraphs': return 'Sheetbot-like behavior for radar graphs';
			case 'sheetbotGraphsDescription': return 'If on, points on the graphs can appear on the opposite half of the graph if value is negative';
			case 'lbStats': return 'Show leaderboard based stats';
			case 'lbStatsDescription': return 'That will impact on loading times, but will allow you to see position on LB by stats and comparison with average values';
			case 'aboutApp': return 'About app';
			case 'aboutAppText': return ({required Object appName, required Object packageName, required Object version, required Object buildNumber}) => '${appName} (${packageName}) Version ${version} Build ${buildNumber}\n\nDeveloped by dan63047\nFormulas provided by kerrmunism\nHistory provided by p1nkl0bst3r\nTETR.IO replay grabber API by szy';
			case 'stateViewTitle': return ({required Object nickname, required Object date}) => '${nickname} account on ${date}';
			case 'statesViewTitle': return ({required Object number, required Object nickname}) => '${number} states of ${nickname} account';
			case 'matchesViewTitle': return ({required Object nickname}) => '${nickname} TL matches';
			case 'statesViewEntry': return ({required Object level, required Object glicko, required Object rd, required Object games}) => '${level} TR, ${glicko}±${rd} Glicko, ${games} игр сыграно';
			case 'stateRemoved': return ({required Object date}) => '${date} state was removed from database!';
			case 'matchRemoved': return ({required Object date}) => '${date} match was removed from database!';
			case 'viewAllMatches': return 'View all matches';
			case 'trackedPlayersViewTitle': return 'Stored data';
			case 'trackedPlayersZeroEntrys': return 'Empty list. Press "Track" button in previous view to add current player here';
			case 'trackedPlayersOneEntry': return 'There is only one player';
			case 'trackedPlayersManyEntrys': return ({required Object numberOfPlayers}) => 'There are ${numberOfPlayers} players';
			case 'trackedPlayersEntry': return ({required Object nickname, required Object numberOfStates}) => '${nickname}: ${numberOfStates} states';
			case 'trackedPlayersDescription': return ({required Object firstStateDate, required Object lastStateDate}) => 'From ${firstStateDate} until ${lastStateDate}';
			case 'trackedPlayersStatesDeleted': return ({required Object nickname}) => '${nickname} states was removed from database!';
			case 'duplicatedFix': return 'Remove duplicated TL mathces';
			case 'compressDB': return 'Compress DB';
			case 'SpaceSaved': return ({required Object size}) => 'Space saved: ${size}';
			case 'averageXrank': return ({required Object rankLetter}) => 'Average ${rankLetter} rank';
			case 'vs': return 'vs';
			case 'inTLmatch': return 'in TL match';
			case 'downloadReplay': return 'Download .ttrm replay';
			case 'openReplay': return 'Open replay in TETR.IO';
			case 'replaySaved': return ({required Object path}) => 'Replay saved to ${path}';
			case 'match': return 'Match';
			case 'timeWeightedmatch': return 'Match (time-weighted)';
			case 'roundNumber': return ({required Object n}) => 'Round ${n}';
			case 'statsFor': return 'Stats for';
			case 'numberOfRounds': return 'Number of rounds';
			case 'matchLength': return 'Match Length';
			case 'roundLength': return 'Round Length';
			case 'matchStats': return 'Match stats';
			case 'timeWeightedmatchStats': return 'Time-weighted match stats';
			case 'replayIssue': return 'Can\'t process replay';
			case 'matchIsTooOld': return 'Replay is not available';
			case 'winner': return 'Winner';
			case 'registred': return 'Registred';
			case 'playedTL': return 'Played Tetra League';
			case 'winChance': return 'Win Chance';
			case 'byGlicko': return 'By Glicko';
			case 'byEstTR': return 'By Est. TR';
			case 'compareViewNoValues': return ({required Object avgR}) => 'Please, enter username, user ID, APM-PPS-VS values (divider doesn\'t matter, only order matter) or ${avgR} (where R is rank) to both fields';
			case 'compareViewWrongValue': return ({required Object value}) => 'Falied to assign ${value}';
			case 'mostRecentOne': return 'Most recent one';
			case 'yes': return 'Yes';
			case 'no': return 'No';
			case 'daysLater': return 'days later';
			case 'dayseBefore': return 'days before';
			case 'fromBeginning': return 'From beginning';
			case 'calc': return 'Calc';
			case 'calcViewNoValues': return 'Enter values to calculate the stats';
			case 'rankAveragesViewTitle': return 'Ranks cutoffs';
			case 'sprintAndBlitsViewTitle': return '40 lines and Blitz averages';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => 'Relevance: ${date}';
			case 'rank': return 'Rank';
			case 'averages': return 'Averages';
			case 'lbViewZeroEntrys': return 'Empty list';
			case 'lbViewOneEntry': return 'There is only one player';
			case 'lbViewManyEntrys': return ({required Object numberOfPlayers}) => 'There are ${numberOfPlayers}';
			case 'everyoneAverages': return 'Values for leaderboard';
			case 'sortBy': return 'Sort by';
			case 'reversed': return 'Reversed';
			case 'country': return 'Country';
			case 'rankAverages': return ({required Object rank}) => 'Values for ${rank} rank';
			case 'players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} players',
				one: '${n} player',
				two: '${n} players',
				few: '${n} players',
				many: '${n} players',
				other: '${n} players',
			);
			case 'games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} games',
				one: '${n} game',
				two: '${n} games',
				few: '${n} games',
				many: '${n} games',
				other: '${n} games',
			);
			case 'gamesPlayed': return ({required Object games}) => '${games} played';
			case 'chart': return 'Chart';
			case 'entries': return 'Entries';
			case 'minimums': return 'Minimums';
			case 'maximums': return 'Maximums';
			case 'lowestValues': return 'Lowest Values';
			case 'averageValues': return 'Average Values';
			case 'highestValues': return 'Highest Values';
			case 'forPlayer': return ({required Object username}) => 'for player ${username}';
			case 'currentAxis': return ({required Object axis}) => '${axis} axis:';
			case 'p1nkl0bst3rAlert': return 'That data was retrived from third party API maintained by p1nkl0bst3r';
			case 'notForWeb': return 'Function is not available for web version';
			case 'graphs.attack': return 'Attack';
			case 'graphs.speed': return 'Speed';
			case 'graphs.defense': return 'Defense';
			case 'graphs.cheese': return 'Cheese';
			case 'statCellNum.xpLevel': return 'XP Level';
			case 'statCellNum.xpProgress': return 'Progress to next level';
			case 'statCellNum.xpFrom0ToLevel': return ({required Object n}) => 'Progress from 0 XP to level ${n}';
			case 'statCellNum.xpLeft': return 'XP left';
			case 'statCellNum.hoursPlayed': return 'Hours\nPlayed';
			case 'statCellNum.onlineGames': return 'Online\nGames';
			case 'statCellNum.gamesWon': return 'Games\nWon';
			case 'statCellNum.totalGames': return 'Total Games Played';
			case 'statCellNum.totalWon': return 'Total Games Won';
			case 'statCellNum.friends': return 'Friends';
			case 'statCellNum.apm': return 'Attack\nPer Minute';
			case 'statCellNum.vs': return 'Versus\nScore';
			case 'statCellNum.recordLB': return 'Leaderboard placement';
			case 'statCellNum.lbp': return 'Leaderboard\nplacement';
			case 'statCellNum.lbpShort': return '№ in LB';
			case 'statCellNum.lbpc': return 'Country LB\nplacement';
			case 'statCellNum.lbpcShort': return '№ in local LB';
			case 'statCellNum.gamesPlayed': return 'Games\nplayed';
			case 'statCellNum.gamesWonTL': return 'Games\nWon';
			case 'statCellNum.winrate': return 'Winrate';
			case 'statCellNum.level': return 'Level';
			case 'statCellNum.score': return 'Score';
			case 'statCellNum.spp': return 'Score\nPer Piece';
			case 'statCellNum.pieces': return 'Pieces\nPlaced';
			case 'statCellNum.pps': return 'Pieces\nPer Second';
			case 'statCellNum.finesseFaults': return 'Finesse\nFaults';
			case 'statCellNum.finessePercentage': return 'Finesse\nPercentage';
			case 'statCellNum.keys': return 'Key\nPresses';
			case 'statCellNum.kpp': return 'KP Per\nPiece';
			case 'statCellNum.kps': return 'KP Per\nSecond';
			case 'statCellNum.tr': return 'Tetra Rating';
			case 'statCellNum.rd': return 'Rating Deviation';
			case 'statCellNum.app': return 'Attack Per Piece';
			case 'statCellNum.appDescription': return '(Abbreviated as APP) Main efficiency metric. Tells how many attack you producing per piece';
			case 'statCellNum.vsapmDescription': return 'Basically, tells how much and how efficient you using garbage in your attacks';
			case 'statCellNum.dss': return 'Downstack\nPer Second';
			case 'statCellNum.dssDescription': return '(Abbreviated as DS/S) Downstack per Second measures how many garbage lines you clear in a second.';
			case 'statCellNum.dsp': return 'Downstack\nPer Piece';
			case 'statCellNum.dspDescription': return '(Abbreviated as DS/P) Downstack per Piece measures how many garbage lines you clear per piece.';
			case 'statCellNum.appdsp': return 'APP + DS/P';
			case 'statCellNum.appdspDescription': return 'Just a sum of Attack per Piece and Downstack per Piece.';
			case 'statCellNum.cheese': return 'Cheese\nIndex';
			case 'statCellNum.cheeseDescription': return '(Abbreviated as Cheese) Cheese Index is an approximation how much clean / cheese garbage player sends. Lower = more clean. Higher = more cheese.\nInvented by kerrmunism';
			case 'statCellNum.gbe': return 'Garbage\nEfficiency';
			case 'statCellNum.gbeDescription': return '(Abbreviated as Gb Eff.) Garbage Efficiency measures how well player uses their garbage. Higher = better or they use their garbage more. Lower = they mostly send their garbage back at cheese or rarely clear garbage.\nInvented by Zepheniah and Dragonboy.';
			case 'statCellNum.nyaapp': return 'Weighted\nAPP';
			case 'statCellNum.nyaappDescription': return '(Abbreviated as wAPP) Essentially, a measure of your ability to send cheese while still maintaining a high APP.\nInvented by Wertj.';
			case 'statCellNum.area': return 'Area';
			case 'statCellNum.areaDescription': return 'How much space your shape takes up on the graph, if you exclude the cheese and vs/apm sections';
			case 'statCellNum.estOfTR': return 'Estimated TR';
			case 'statCellNum.estOfTRShort': return 'Est. TR';
			case 'statCellNum.accOfEst': return 'Accuracy';
			case 'statCellNum.accOfEstShort': return 'Acc.';
			case 'playerRole.user': return 'User';
			case 'playerRole.banned': return 'Banned';
			case 'playerRole.bot': return 'Bot';
			case 'playerRole.sysop': return 'System operator';
			case 'playerRole.admin': return 'Admin';
			case 'playerRole.mod': return 'Moderator';
			case 'playerRole.halfmod': return 'Community moderator';
			case 'playerRole.anon': return 'Anonymous';
			case 'numOfGameActions.pc': return 'All Clears';
			case 'numOfGameActions.hold': return 'Holds';
			case 'numOfGameActions.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} key presses',
				one: '${n} key press',
				two: '${n} key presses',
				few: '${n} key presses',
				many: '${n} key presses',
				other: '${n} key presses',
			);
			case 'numOfGameActions.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} T-spins total',
				one: '${n} T-spin total',
				two: '${n} T-spins total',
				few: '${n} T-spins total',
				many: '${n} T-spins total',
				other: '${n} T-spins total',
			);
			case 'numOfGameActions.lineClears': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} lines cleared',
				one: '${n} line cleared',
				two: '${n} lines cleared',
				few: '${n} lines cleared',
				many: '${n} lines cleared',
				other: '${n} lines cleared',
			);
			case 'popupActions.cancel': return 'Cancel';
			case 'popupActions.submit': return 'Submit';
			case 'popupActions.ok': return 'OK';
			case 'errors.connection': return ({required Object code, required Object message}) => 'Some issue with connection: ${code} ${message}';
			case 'errors.noSuchUser': return 'No such user';
			case 'errors.noSuchUserSub': return 'Either you mistyped something, or the account no longer exists';
			case 'errors.discordNotAssigned': return 'No user assigned to given Discord ID';
			case 'errors.discordNotAssignedSub': return 'Make sure you provided valid ID';
			case 'errors.history': return 'History for that player is missing';
			case 'errors.actionSuggestion': return 'Perhaps, you want to';
			case 'errors.p1nkl0bst3rTLmatches': return 'No Tetra League matches was found';
			case 'errors.clientException': return 'No internet connection';
			case 'errors.forbidden': return 'Your IP address is blocked';
			case 'errors.forbiddenSub': return ({required Object nickname}) => 'If you are using VPN or Proxy, turn it off. If this does not help, reach out to ${nickname}';
			case 'errors.tooManyRequests': return 'You have been rate limited.';
			case 'errors.tooManyRequestsSub': return 'Wait a few moments and try again';
			case 'errors.internal': return 'Something happened on the tetr.io side';
			case 'errors.internalSub': return 'osk, probably, already aware about it';
			case 'errors.internalWebVersion': return 'Something happened on the tetr.io side (or on oskware_bridge, idk honestly)';
			case 'errors.internalWebVersionSub': return 'If osk status page says that everything is ok, let dan63047 know about this issue';
			case 'errors.oskwareBridge': return 'Something happened with oskware_bridge';
			case 'errors.oskwareBridgeSub': return 'Let dan63047 know';
			case 'errors.p1nkl0bst3rForbidden': return 'Third party API blocked your IP address';
			case 'errors.p1nkl0bst3rTooManyRequests': return 'Too many requests to third party API. Try again later';
			case 'errors.p1nkl0bst3rinternal': return 'Something happened on the p1nkl0bst3r side';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'Something happened on the p1nkl0bst3r side (or on oskware_bridge, idk honestly)';
			case 'errors.replayAlreadySaved': return 'Replay already saved';
			case 'errors.replayExpired': return 'Replay expired and not available anymore';
			case 'errors.replayRejected': return 'Third party API blocked your IP address';
			case 'countries.': return 'Worldwide';
			case 'countries.AF': return 'Afghanistan';
			case 'countries.AX': return 'Åland Islands';
			case 'countries.AL': return 'Albania';
			case 'countries.DZ': return 'Algeria';
			case 'countries.AS': return 'American Samoa';
			case 'countries.AD': return 'Andorra';
			case 'countries.AO': return 'Angola';
			case 'countries.AI': return 'Anguilla';
			case 'countries.AQ': return 'Antarctica';
			case 'countries.AG': return 'Antigua and Barbuda';
			case 'countries.AR': return 'Argentina';
			case 'countries.AM': return 'Armenia';
			case 'countries.AW': return 'Aruba';
			case 'countries.AU': return 'Australia';
			case 'countries.AT': return 'Austria';
			case 'countries.AZ': return 'Azerbaijan';
			case 'countries.BS': return 'Bahamas';
			case 'countries.BH': return 'Bahrain';
			case 'countries.BD': return 'Bangladesh';
			case 'countries.BB': return 'Barbados';
			case 'countries.BY': return 'Belarus';
			case 'countries.BE': return 'Belgium';
			case 'countries.BZ': return 'Belize';
			case 'countries.BJ': return 'Benin';
			case 'countries.BM': return 'Bermuda';
			case 'countries.BT': return 'Bhutan';
			case 'countries.BO': return 'Bolivia, Plurinational State of';
			case 'countries.BA': return 'Bosnia and Herzegovina';
			case 'countries.BW': return 'Botswana';
			case 'countries.BV': return 'Bouvet Island';
			case 'countries.BR': return 'Brazil';
			case 'countries.IO': return 'British Indian Ocean Territory';
			case 'countries.BN': return 'Brunei Darussalam';
			case 'countries.BG': return 'Bulgaria';
			case 'countries.BF': return 'Burkina Faso';
			case 'countries.BI': return 'Burundi';
			case 'countries.KH': return 'Cambodia';
			case 'countries.CM': return 'Cameroon';
			case 'countries.CA': return 'Canada';
			case 'countries.CV': return 'Cape Verde';
			case 'countries.BQ': return 'Caribbean Netherlands';
			case 'countries.KY': return 'Cayman Islands';
			case 'countries.CF': return 'Central African Republic';
			case 'countries.TD': return 'Chad';
			case 'countries.CL': return 'Chile';
			case 'countries.CN': return 'China';
			case 'countries.CX': return 'Christmas Island';
			case 'countries.CC': return 'Cocos (Keeling) Islands';
			case 'countries.CO': return 'Colombia';
			case 'countries.KM': return 'Comoros';
			case 'countries.CG': return 'Congo';
			case 'countries.CD': return 'Congo, the Democratic Republic of the';
			case 'countries.CK': return 'Cook Islands';
			case 'countries.CR': return 'Costa Rica';
			case 'countries.CI': return 'Côte d\'Ivoire';
			case 'countries.HR': return 'Croatia';
			case 'countries.CU': return 'Cuba';
			case 'countries.CW': return 'Curaçao';
			case 'countries.CY': return 'Cyprus';
			case 'countries.CZ': return 'Czech Republic';
			case 'countries.DK': return 'Denmark';
			case 'countries.DJ': return 'Djibouti';
			case 'countries.DM': return 'Dominica';
			case 'countries.DO': return 'Dominican Republic';
			case 'countries.EC': return 'Ecuador';
			case 'countries.EG': return 'Egypt';
			case 'countries.SV': return 'El Salvador';
			case 'countries.GB-ENG': return 'England';
			case 'countries.GQ': return 'Equatorial Guinea';
			case 'countries.ER': return 'Eritrea';
			case 'countries.EE': return 'Estonia';
			case 'countries.ET': return 'Ethiopia';
			case 'countries.EU': return 'Europe';
			case 'countries.FK': return 'Falkland Islands (Malvinas)';
			case 'countries.FO': return 'Faroe Islands';
			case 'countries.FJ': return 'Fiji';
			case 'countries.FI': return 'Finland';
			case 'countries.FR': return 'France';
			case 'countries.GF': return 'French Guiana';
			case 'countries.PF': return 'French Polynesia';
			case 'countries.TF': return 'French Southern Territories';
			case 'countries.GA': return 'Gabon';
			case 'countries.GM': return 'Gambia';
			case 'countries.GE': return 'Georgia';
			case 'countries.DE': return 'Germany';
			case 'countries.GH': return 'Ghana';
			case 'countries.GI': return 'Gibraltar';
			case 'countries.GR': return 'Greece';
			case 'countries.GL': return 'Greenland';
			case 'countries.GD': return 'Grenada';
			case 'countries.GP': return 'Guadeloupe';
			case 'countries.GU': return 'Guam';
			case 'countries.GT': return 'Guatemala';
			case 'countries.GG': return 'Guernsey';
			case 'countries.GN': return 'Guinea';
			case 'countries.GW': return 'Guinea-Bissau';
			case 'countries.GY': return 'Guyana';
			case 'countries.HT': return 'Haiti';
			case 'countries.HM': return 'Heard Island and McDonald Islands';
			case 'countries.VA': return 'Holy See (Vatican City State)';
			case 'countries.HN': return 'Honduras';
			case 'countries.HK': return 'Hong Kong';
			case 'countries.HU': return 'Hungary';
			case 'countries.IS': return 'Iceland';
			case 'countries.IN': return 'India';
			case 'countries.ID': return 'Indonesia';
			case 'countries.IR': return 'Iran, Islamic Republic of';
			case 'countries.IQ': return 'Iraq';
			case 'countries.IE': return 'Ireland';
			case 'countries.IM': return 'Isle of Man';
			case 'countries.IL': return 'Israel';
			case 'countries.IT': return 'Italy';
			case 'countries.JM': return 'Jamaica';
			case 'countries.JP': return 'Japan';
			case 'countries.JE': return 'Jersey';
			case 'countries.JO': return 'Jordan';
			case 'countries.KZ': return 'Kazakhstan';
			case 'countries.KE': return 'Kenya';
			case 'countries.KI': return 'Kiribati';
			case 'countries.KP': return 'Korea, Democratic People\'s Republic of';
			case 'countries.KR': return 'Korea, Republic of';
			case 'countries.XK': return 'Kosovo';
			case 'countries.KW': return 'Kuwait';
			case 'countries.KG': return 'Kyrgyzstan';
			case 'countries.LA': return 'Lao People\'s Democratic Republic';
			case 'countries.LV': return 'Latvia';
			case 'countries.LB': return 'Lebanon';
			case 'countries.LS': return 'Lesotho';
			case 'countries.LR': return 'Liberia';
			case 'countries.LY': return 'Libya';
			case 'countries.LI': return 'Liechtenstein';
			case 'countries.LT': return 'Lithuania';
			case 'countries.LU': return 'Luxembourg';
			case 'countries.MO': return 'Macao';
			case 'countries.MK': return 'Macedonia, the former Yugoslav Republic of';
			case 'countries.MG': return 'Madagascar';
			case 'countries.MW': return 'Malawi';
			case 'countries.MY': return 'Malaysia';
			case 'countries.MV': return 'Maldives';
			case 'countries.ML': return 'Mali';
			case 'countries.MT': return 'Malta';
			case 'countries.MH': return 'Marshall Islands';
			case 'countries.MQ': return 'Martinique';
			case 'countries.MR': return 'Mauritania';
			case 'countries.MU': return 'Mauritius';
			case 'countries.YT': return 'Mayotte';
			case 'countries.MX': return 'Mexico';
			case 'countries.FM': return 'Micronesia, Federated States of';
			case 'countries.MD': return 'Moldova, Republic of';
			case 'countries.MC': return 'Monaco';
			case 'countries.ME': return 'Montenegro';
			case 'countries.MA': return 'Morocco';
			case 'countries.MN': return 'Mongolia';
			case 'countries.MS': return 'Montserrat';
			case 'countries.MZ': return 'Mozambique';
			case 'countries.MM': return 'Myanmar';
			case 'countries.NA': return 'Namibia';
			case 'countries.NR': return 'Nauru';
			case 'countries.NP': return 'Nepal';
			case 'countries.NL': return 'Netherlands';
			case 'countries.AN': return 'Netherlands Antilles';
			case 'countries.NC': return 'New Caledonia';
			case 'countries.NZ': return 'New Zealand';
			case 'countries.NI': return 'Nicaragua';
			case 'countries.NE': return 'Niger';
			case 'countries.NG': return 'Nigeria';
			case 'countries.NU': return 'Niue';
			case 'countries.NF': return 'Norfolk Island';
			case 'countries.GB-NIR': return 'Northern Ireland';
			case 'countries.MP': return 'Northern Mariana Islands';
			case 'countries.NO': return 'Norway';
			case 'countries.OM': return 'Oman';
			case 'countries.PK': return 'Pakistan';
			case 'countries.PW': return 'Palau';
			case 'countries.PS': return 'Palestine';
			case 'countries.PA': return 'Panama';
			case 'countries.PG': return 'Papua New Guinea';
			case 'countries.PY': return 'Paraguay';
			case 'countries.PE': return 'Peru';
			case 'countries.PH': return 'Philippines';
			case 'countries.PN': return 'Pitcairn';
			case 'countries.PL': return 'Poland';
			case 'countries.PT': return 'Portugal';
			case 'countries.PR': return 'Puerto Rico';
			case 'countries.QA': return 'Qatar';
			case 'countries.RE': return 'Réunion';
			case 'countries.RO': return 'Romania';
			case 'countries.RU': return 'Russian Federation';
			case 'countries.RW': return 'Rwanda';
			case 'countries.BL': return 'Saint Barthélemy';
			case 'countries.SH': return 'Saint Helena, Ascension and Tristan da Cunha';
			case 'countries.KN': return 'Saint Kitts and Nevis';
			case 'countries.LC': return 'Saint Lucia';
			case 'countries.MF': return 'Saint Martin';
			case 'countries.PM': return 'Saint Pierre and Miquelon';
			case 'countries.VC': return 'Saint Vincent and the Grenadines';
			case 'countries.WS': return 'Samoa';
			case 'countries.SM': return 'San Marino';
			case 'countries.ST': return 'Sao Tome and Principe';
			case 'countries.SA': return 'Saudi Arabia';
			case 'countries.GB-SCT': return 'Scotland';
			case 'countries.SN': return 'Senegal';
			case 'countries.RS': return 'Serbia';
			case 'countries.SC': return 'Seychelles';
			case 'countries.SL': return 'Sierra Leone';
			case 'countries.SG': return 'Singapore';
			case 'countries.SX': return 'Sint Maarten (Dutch part)';
			case 'countries.SK': return 'Slovakia';
			case 'countries.SI': return 'Slovenia';
			case 'countries.SB': return 'Solomon Islands';
			case 'countries.SO': return 'Somalia';
			case 'countries.ZA': return 'South Africa';
			case 'countries.GS': return 'South Georgia and the South Sandwich Islands';
			case 'countries.SS': return 'South Sudan';
			case 'countries.ES': return 'Spain';
			case 'countries.LK': return 'Sri Lanka';
			case 'countries.SD': return 'Sudan';
			case 'countries.SR': return 'Suriname';
			case 'countries.SJ': return 'Svalbard and Jan Mayen Islands';
			case 'countries.SZ': return 'Swaziland';
			case 'countries.SE': return 'Sweden';
			case 'countries.CH': return 'Switzerland';
			case 'countries.SY': return 'Syrian Arab Republic';
			case 'countries.TW': return 'Taiwan';
			case 'countries.TJ': return 'Tajikistan';
			case 'countries.TZ': return 'Tanzania, United Republic of';
			case 'countries.TH': return 'Thailand';
			case 'countries.TL': return 'Timor-Leste';
			case 'countries.TG': return 'Togo';
			case 'countries.TK': return 'Tokelau';
			case 'countries.TO': return 'Tonga';
			case 'countries.TT': return 'Trinidad and Tobago';
			case 'countries.TN': return 'Tunisia';
			case 'countries.TR': return 'Turkey';
			case 'countries.TM': return 'Turkmenistan';
			case 'countries.TC': return 'Turks and Caicos Islands';
			case 'countries.TV': return 'Tuvalu';
			case 'countries.UG': return 'Uganda';
			case 'countries.UA': return 'Ukraine';
			case 'countries.AE': return 'United Arab Emirates';
			case 'countries.GB': return 'United Kingdom';
			case 'countries.US': return 'United States';
			case 'countries.UY': return 'Uruguay';
			case 'countries.UM': return 'US Minor Outlying Islands';
			case 'countries.UZ': return 'Uzbekistan';
			case 'countries.VU': return 'Vanuatu';
			case 'countries.VE': return 'Venezuela, Bolivarian Republic of';
			case 'countries.VN': return 'Vietnam';
			case 'countries.VG': return 'Virgin Islands, British';
			case 'countries.VI': return 'Virgin Islands, U.S.';
			case 'countries.GB-WLS': return 'Wales';
			case 'countries.WF': return 'Wallis and Futuna Islands';
			case 'countries.EH': return 'Western Sahara';
			case 'countries.YE': return 'Yemen';
			case 'countries.ZM': return 'Zambia';
			case 'countries.ZW': return 'Zimbabwe';
			case 'countries.XX': return 'Unknown';
			case 'countries.XM': return 'The Moon';
			default: return null;
		}
	}
}

extension on _StringsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'Английский (English)';
			case 'locales.ru': return 'Русский';
			case 'locales.zh-CN': return 'Упрощенный Китайский (简体中文)';
			case 'tetraLeague': return 'Тетра Лига';
			case 'tlRecords': return 'Матчи ТЛ';
			case 'history': return 'История';
			case 'sprint': return '40 линий';
			case 'blitz': return 'Блиц';
			case 'recent': return 'Недавно';
			case 'recentRuns': return 'Недавние';
			case 'blitzScore': return ({required Object p}) => '${p} очков';
			case 'openSPreplay': return 'Открыть повтор в TETR.IO';
			case 'downloadSPreplay': return 'Скачать повтор';
			case 'other': return 'Другое';
			case 'distinguishment': return 'Заслуга';
			case 'zen': return 'Дзен';
			case 'bio': return 'Биография';
			case 'news': return 'Новости';
			case 'newsParts.leaderboardStart': return 'Взял ';
			case 'newsParts.leaderboardMiddle': return 'в таблице ';
			case 'newsParts.personalbest': return 'Поставил новый ЛР в ';
			case 'newsParts.personalbestMiddle': return 'с результатом в ';
			case 'newsParts.badgeStart': return 'Заработал значок ';
			case 'newsParts.badgeEnd': return '';
			case 'newsParts.rankupStart': return 'Заработал ';
			case 'newsParts.rankupMiddle': return ({required Object r}) => '${r} ранг ';
			case 'newsParts.rankupEnd': return 'в Тетра Лиге';
			case 'newsParts.tetoSupporter': return 'TETR.IO supporter';
			case 'newsParts.supporterStart': return 'Стал обладателем ';
			case 'newsParts.supporterGiftStart': return 'Получил подарок в виде ';
			case 'newsParts.unknownNews': return ({required Object type}) => 'Неизвестная новость типа ${type}';
			case 'openSearch': return 'Искать игрока';
			case 'closeSearch': return 'Закрыть поиск';
			case 'searchHint': return 'Ник, ID или ID в Discord (с префиксом "ds:")';
			case 'refresh': return 'Обновить';
			case 'fetchAndsaveTLHistory': return 'Получить историю игрока';
			case 'fetchAndSaveOldTLmatches': return 'Получить старые матчи Тетра Лиги';
			case 'fetchAndsaveTLHistoryResult': return ({required Object number}) => '${number} состояний было найдено';
			case 'fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '${number} старых матчей было найдено';
			case 'showStoredData': return 'Показать сохранённые данные';
			case 'statsCalc': return 'Калькулятор статистики';
			case 'settings': return 'Настройки';
			case 'track': return 'Отслеживать';
			case 'stopTracking': return 'Перестать\nотслеживать';
			case 'becameTracked': return 'Добавлен в список отслеживания!';
			case 'stoppedBeingTracked': return 'Удалён из списка отслеживания!';
			case 'compare': return 'Сравнить';
			case 'tlLeaderboard': return 'Рейтинговая таблица';
			case 'noRecords': return 'Нет записей';
			case 'noOldRecords': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: 'Нет записей',
				one: 'Всего один матч',
				two: 'Всего ${n} матча',
				few: 'Всего ${n} матча',
				many: 'Всего ${n} матчей',
				other: '${n} матчей',
			);
			case 'noRecord': return 'Нет рекорда';
			case 'botRecord': return 'Ботам нельзя ставить рекорды';
			case 'anonRecord': return 'Гостям нельзя ставить рекорды';
			case 'notEnoughData': return 'Недостаточно данных';
			case 'noHistorySaved': return 'Нет сохранённой истории';
			case 'pseudoTooltipHeaderInit': return 'Наведите курсор на точку';
			case 'pseudoTooltipFooterInit': return 'чтобы узнать подробности';
			case 'obtainDate': return ({required Object date}) => 'Получено ${date}';
			case 'fetchDate': return ({required Object date}) => 'На момент ${date}';
			case 'exactGametime': return 'Время, проведённое в игре';
			case 'bigRedBanned': return 'ЗАБАНЕН';
			case 'normalBanned': return 'Забанен';
			case 'bigRedBadStanding': return 'ПЛОХАЯ РЕПУТАЦИЯ';
			case 'copiedToClipboard': return 'Скопировано в буфер обмена!';
			case 'playerRoleAccount': return ', аккаунт которого ';
			case 'wasFromBeginning': return 'существовал с самого начала';
			case 'created': return 'создан';
			case 'botCreatedBy': return 'игроком';
			case 'notSupporter': return 'Нет саппортерки';
			case 'supporter': return ({required Object tier}) => 'Саппортерка ${tier} уровня';
			case 'assignedManualy': return 'Этот значок был присвоен вручную администрацией TETR.IO';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => 'Данные от ${newDate} в сравнении с данными от ${oldDate}';
			case 'top': return 'Топ';
			case 'topRank': return 'Топ ранг';
			case 'verdictGeneral': return ({required Object verdict, required Object rank, required Object n}) => '${verdict} среднего ${rank} ранга на ${n}';
			case 'verdictBetter': return 'Лучше';
			case 'verdictWorse': return 'Хуже';
			case 'smooth': return 'Гладкий';
			case 'postSeason': return 'Внесезонье';
			case 'seasonStarts': return 'Сезон начнётся через:';
			case 'nanow': return 'Пока недоступно...';
			case 'seasonEnds': return ({required Object countdown}) => 'Сезон закончится через ${countdown}';
			case 'seasonEnded': return 'Сезон закончился';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} матчей до получения рейтинга';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} побед';
			case 'promotionOnNextWin': return 'Повышение после следующей победы';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} поражений';
			case 'demotionOnNextLoss': return 'Понижение после следующего поражения';
			case 'nerdStats': return 'Для задротов';
			case 'playersYouTrack': return 'Отслеживаемые игроки';
			case 'formula': return 'Формула';
			case 'exactValue': return 'Точное значение';
			case 'neverPlayedTL': return 'Этот игрок никогда не играл в Тетра Лигу';
			case 'botTL': return 'Ботам нельзя играть в Тетра Лигу';
			case 'anonTL': return 'Гостям нельзя играть в Тетра Лигу';
			case 'quickPlay': return 'Быстрая Игра';
			case 'expert': return 'Эксперт';
			case 'withMods': return 'С модами';
			case 'withModsPlural': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: 'с ${n} модами',
				one: 'с ${n} модом',
				two: 'с ${n} модами',
				few: 'с ${n} модами',
				many: 'с ${n} модами',
				other: 'с ${n} модами',
			);
			case 'exportDB': return 'Экспортировать локальную базу данных';
			case 'exportDBDescription': return 'Она содержит состояния аккаунтов и их матчей в Тетра Лиге для отслеживаемых игроков и список таких игроков.';
			case 'desktopExportAlertTitle': return 'Экспорт на десктопе';
			case 'desktopExportText': return 'Похоже, вы используете десктопную версию. Проверьте папку "Документы", там вы должны найти файл "TetraStats.db". Скопируйте его куда-нибудь';
			case 'androidExportAlertTitle': return 'Экспорт на Android';
			case 'androidExportText': return ({required Object exportedDB}) => 'Экспортировано.\n${exportedDB}';
			case 'importDB': return 'Импортировать локальную базу данных';
			case 'importDBDescription': return 'Восстановите свою резеврную копию. Обратите внимание, что текущая база данных будет перезаписана.';
			case 'importWrongFileType': return 'Неверный тип файла';
			case 'importCancelled': return 'Операция была отменена';
			case 'importSuccess': return 'Успешно импортировано';
			case 'yourID': return 'Ваш аккаунт в TETR.IO';
			case 'yourIDAlertTitle': return 'Ваш ник в TETR.IO';
			case 'yourIDText': return 'При запуске приложения оно будет получать статистику этого игрока.';
			case 'language': return 'Язык (Language)';
			case 'updateInBackground': return 'Обновлять статистику в фоне';
			case 'updateInBackgroundDescription': return 'Пока Tetra Stats работает, он может обновлять статистику самостоятельно когда кеш истекает';
			case 'customization': return 'Кастомизация';
			case 'customizationDescription': return 'Измените внешний вид пользовательского интерфейса Tetra Stats';
			case 'oskKagari': return '"Оск Кагари" прикол';
			case 'oskKagariDescription': return 'Если включено, вместо настоящего ранга оска будет рендерится :kagari:';
			case 'AccentColor': return 'Цветовой акцент';
			case 'AccentColorDescription': return 'Почти все интерактивные элементы пользовательского интерфейса окрашены в этот цвет';
			case 'timestamps': return 'Метки времени';
			case 'timestampsDescription': return 'Вы можете выбрать, каким образом метки времени показывают время';
			case 'timestampsAbsoluteGMT': return 'Абсолютные (GMT)';
			case 'timestampsAbsoluteLocalTime': return 'Абсолютные (Ваш часовой пояс)';
			case 'timestampsRelative': return 'Относительные';
			case 'rating': return 'Основное представление рейтинга';
			case 'ratingDescription': return 'TR нелинеен, тогда как Glicko не имеет границ, а положение в таблице лидеров волатильно';
			case 'ratingLBposition': return 'Позиция в рейтинге';
			case 'sheetbotGraphs': return 'Графики-радары как у sheetBot';
			case 'sheetbotGraphsDescription': return 'Если включено, точки на графике могут появляться на противоположной стороне графика если значение отрицательное';
			case 'lbStats': return 'Показывать статистику, основанную на рейтинговой таблице';
			case 'lbStatsDescription': return 'Это повлияет на время загрузки, но позволит видеть положение в рейтинге и сравнение со средними значениями по рангу по каждой стате';
			case 'aboutApp': return 'О приложении';
			case 'aboutAppText': return ({required Object appName, required Object packageName, required Object version, required Object buildNumber}) => '${appName} (${packageName}) Версия ${version} Сборка ${buildNumber}\n\nРазработал dan63047\nФормулы предоставил kerrmunism\nИсторию предоставляет p1nkl0bst3r\nВозможность скачивать повторы из TETR.IO предоставляет szy';
			case 'stateViewTitle': return ({required Object nickname, required Object date}) => 'Аккаунт ${nickname} ${date}';
			case 'statesViewTitle': return ({required Object number, required Object nickname}) => '${number} состояний аккаунта ${nickname}';
			case 'matchesViewTitle': return ({required Object nickname}) => 'Матчи аккаунта ${nickname}';
			case 'statesViewEntry': return ({required Object level, required Object glicko, required Object rd, required Object games}) => '${level} TR, ${glicko}±${rd} Glicko, ${games} игр сыграно';
			case 'stateRemoved': return ({required Object date}) => 'Состояние от ${date} было удалено из локальной базы данных!';
			case 'matchRemoved': return ({required Object date}) => 'Матч от ${date} был удален из локальной базы данных!';
			case 'viewAllMatches': return 'Все матчи';
			case 'trackedPlayersViewTitle': return 'Сохранённые данные';
			case 'trackedPlayersZeroEntrys': return 'Пустой список. Вернитесь на предыдущий экран и нажмите кнопку "Отслеживать", чтобы текущий игрок появился здесь';
			case 'trackedPlayersOneEntry': return 'В списке только один игрок';
			case 'trackedPlayersManyEntrys': return ({required Object numberOfPlayers}) => 'В списке ${numberOfPlayers} игроков';
			case 'trackedPlayersEntry': return ({required Object nickname, required Object numberOfStates}) => '${nickname}: ${numberOfStates} состояний';
			case 'trackedPlayersDescription': return ({required Object firstStateDate, required Object lastStateDate}) => 'Начиная с ${firstStateDate} и заканчивая ${lastStateDate}';
			case 'trackedPlayersStatesDeleted': return ({required Object nickname}) => 'Состояния аккаунта ${nickname} были удалены из локальной базы данных!';
			case 'duplicatedFix': return 'Удалить дубликаты матчей в Тетра Лиге';
			case 'compressDB': return 'Сжать базу данных';
			case 'SpaceSaved': return ({required Object size}) => 'Места освобождено: ${size}';
			case 'averageXrank': return ({required Object rankLetter}) => 'Средний ${rankLetter} ранг';
			case 'vs': return 'против';
			case 'inTLmatch': return 'в матче ТЛ';
			case 'downloadReplay': return 'Скачать .ttrm повтор';
			case 'openReplay': return 'Открыть повтор в TETR.IO';
			case 'replaySaved': return ({required Object path}) => 'Повтор сохранён по пути ${path}';
			case 'match': return 'Матч';
			case 'timeWeightedmatch': return 'Матч (взвешенная по времени)';
			case 'roundNumber': return ({required Object n}) => 'Раунд ${n}';
			case 'statsFor': return 'Статистика за';
			case 'numberOfRounds': return 'Количество раундов';
			case 'matchLength': return 'Продолжительность матча';
			case 'roundLength': return 'Продолжительность раунда';
			case 'matchStats': return 'Статистика матча';
			case 'timeWeightedmatchStats': return 'Взвешенная по времени cтатистика матча';
			case 'replayIssue': return 'Ошибка обработки повтора';
			case 'matchIsTooOld': return 'Информация о повторе недоступна';
			case 'winner': return 'Победитель';
			case 'registred': return 'Зарегистрирован';
			case 'playedTL': return 'Играл в Тетра Лигу';
			case 'winChance': return 'Шансы на победу';
			case 'byGlicko': return 'По Glicko';
			case 'byEstTR': return 'По расч. TR';
			case 'compareViewNoValues': return ({required Object avgR}) => 'Пожалуйста, введите никнейм, ID, APM-PPS-VS (неважно, какой разделитель, важен порядок) или ${avgR} (где R это ранг), в оба поля';
			case 'compareViewWrongValue': return ({required Object value}) => 'Не удалось получить ${value}';
			case 'mostRecentOne': return 'Самый последний';
			case 'yes': return 'Да';
			case 'no': return 'Нет';
			case 'daysLater': return 'дней позже';
			case 'dayseBefore': return 'дней раньше';
			case 'fromBeginning': return 'С начала';
			case 'calc': return 'Считать';
			case 'calcViewNoValues': return 'Введите значения, чтобы посчитать статистику';
			case 'rankAveragesViewTitle': return 'Требования рангов';
			case 'sprintAndBlitsViewTitle': return 'Средние результаты 40 линий и блица';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => 'Актуальность: ${date}';
			case 'rank': return 'Ранг';
			case 'averages': return 'Средние значения';
			case 'lbViewZeroEntrys': return 'Рейтинговая таблица пуста';
			case 'lbViewOneEntry': return 'В рейтинговой таблице всего один игрок';
			case 'lbViewManyEntrys': return ({required Object numberOfPlayers}) => 'В рейтинговой таблице находится ${numberOfPlayers}';
			case 'everyoneAverages': return 'Значения таблицы';
			case 'sortBy': return 'Cортировать по';
			case 'reversed': return 'Наоборот';
			case 'country': return 'Страна';
			case 'rankAverages': return ({required Object rank}) => 'Значения для ${rank} ранга';
			case 'players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} игроков',
				one: '${n} игрок',
				two: '${n} игрока',
				few: '${n} игрока',
				many: '${n} игроков',
				other: '${n} игроков',
			);
			case 'games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} игр',
				one: '${n} игра',
				two: '${n} игры',
				few: '${n} игры',
				many: '${n} игр',
				other: '${n} игр',
			);
			case 'gamesPlayed': return ({required Object games}) => '${games} сыграно';
			case 'chart': return 'График';
			case 'entries': return 'Список';
			case 'minimums': return 'Минимумы';
			case 'maximums': return 'Максимумы';
			case 'lowestValues': return 'Самые низкие показатели';
			case 'averageValues': return 'Средние значения показателей';
			case 'highestValues': return 'Самые высокие показатели';
			case 'forPlayer': return ({required Object username}) => 'для игрока ${username}';
			case 'currentAxis': return ({required Object axis}) => 'Ось ${axis}:';
			case 'p1nkl0bst3rAlert': return 'Эти данные были получены из стороннего API, который поддерживается p1nkl0bst3r';
			case 'notForWeb': return 'Функция недоступна для веб версии';
			case 'graphs.attack': return 'Атака';
			case 'graphs.speed': return 'Скорость';
			case 'graphs.defense': return 'Защита';
			case 'graphs.cheese': return 'Сыр';
			case 'statCellNum.xpLevel': return 'Уровень\nопыта';
			case 'statCellNum.xpProgress': return 'Прогресс до следующего уровня';
			case 'statCellNum.xpFrom0ToLevel': return ({required Object n}) => 'Прогресс от 0 XP до ${n} уровня';
			case 'statCellNum.xpLeft': return 'XP осталось';
			case 'statCellNum.hoursPlayed': return 'Часов\nСыграно';
			case 'statCellNum.onlineGames': return 'Онлайн\nИгр';
			case 'statCellNum.gamesWon': return 'Онлайн\nПобед';
			case 'statCellNum.totalGames': return 'Всего матчей';
			case 'statCellNum.totalWon': return 'Всего побед';
			case 'statCellNum.friends': return 'Друзей';
			case 'statCellNum.apm': return 'Атака в\nМинуту';
			case 'statCellNum.vs': return 'Показатель\nVersus';
			case 'statCellNum.recordLB': return 'Место в таблице';
			case 'statCellNum.lbp': return 'Положение\nв рейтинге';
			case 'statCellNum.lbpShort': return '№ в рейтинге';
			case 'statCellNum.lbpc': return 'Положение\nв рейтинге страны';
			case 'statCellNum.lbpcShort': return '№ по стране';
			case 'statCellNum.gamesPlayed': return 'Игр\nСыграно';
			case 'statCellNum.gamesWonTL': return 'Побед';
			case 'statCellNum.winrate': return 'Процент\nпобед';
			case 'statCellNum.level': return 'Уровень';
			case 'statCellNum.score': return 'Счёт';
			case 'statCellNum.spp': return 'Очков\nна Фигуру';
			case 'statCellNum.pieces': return 'Фигур\nУстановлено';
			case 'statCellNum.pps': return 'Фигур в\nСекунду';
			case 'statCellNum.finesseFaults': return 'Ошибок\nТехники';
			case 'statCellNum.finessePercentage': return '% Качества\nТехники';
			case 'statCellNum.keys': return 'Нажатий\nКлавиш';
			case 'statCellNum.kpp': return 'Нажатий\nна Фигуру';
			case 'statCellNum.kps': return 'Нажатий\nв Секунду';
			case 'statCellNum.tr': return 'Тетра Рейтинг';
			case 'statCellNum.rd': return 'Отклонение рейтинга';
			case 'statCellNum.app': return 'Атака на Фигуру';
			case 'statCellNum.appDescription': return '(Сокращенно APP) Главный показатель эффективности. Показывает, сколько атаки приходится на одну фигуру';
			case 'statCellNum.vsapmDescription': return 'В основном, показывает как много мусора игрок использует в своих атаках и насколько эффективно.';
			case 'statCellNum.dss': return 'Downstack\nв Секунду';
			case 'statCellNum.dssDescription': return '(Сокращенно DS/S) Downstack (спуск вниз) в Секунду показывает как много мусорных линий в среднем игрок убирает за одну секунду.';
			case 'statCellNum.dsp': return 'Downstack\nна Фигуру';
			case 'statCellNum.dspDescription': return '(Сокращенно DS/P) Downstack (спуск вниз) на Фигуру показывает как много мусорных линий в среднем игрок убирает одну фигуру.';
			case 'statCellNum.appdsp': return 'APP + DS/P';
			case 'statCellNum.appdspDescription': return 'Просто сумма Атаки на Фигуру и Downstack на Фигуру.';
			case 'statCellNum.cheese': return 'Индекс сыра';
			case 'statCellNum.cheeseDescription': return '(Сокращенно Cheese) Индекс сыра является аппроксимацией того, насколько чистый / дырявый мусор игрок отправляет. Меньше = более чистый. Больше = более дырявый.\nПридумал kerrmunism';
			case 'statCellNum.gbe': return 'Garbage\nEfficiency';
			case 'statCellNum.gbeDescription': return '(Сокращенно Gb Eff.) Garbage Efficiency показывает насколько хорошо игрок использует свой мусор. Больше = лучше (или он использует больше мусора). Меньше = в основном отправляют сыр (или он редко чистит мусор).\nПридумали Zepheniah и Dragonboy.';
			case 'statCellNum.nyaapp': return 'Взвешенный\nAPP';
			case 'statCellNum.nyaappDescription': return '(Сокращенно wAPP) По сути, показывает способность отправлять сыр, сохраняя при этом высокую эффективность.\nПридумал Wertj.';
			case 'statCellNum.area': return 'Area';
			case 'statCellNum.areaDescription': return 'Какую площадь занимает диаграмма, если не брать в расчёт индекс сыра и VS/APM';
			case 'statCellNum.estOfTR': return 'Расчётный TR';
			case 'statCellNum.estOfTRShort': return 'Расч. TR';
			case 'statCellNum.accOfEst': return 'Точность расчёта';
			case 'statCellNum.accOfEstShort': return 'Точность';
			case 'playerRole.user': return 'Пользователь';
			case 'playerRole.banned': return 'Заблокированный пользователь';
			case 'playerRole.bot': return 'Бот';
			case 'playerRole.sysop': return 'Системный оператор';
			case 'playerRole.admin': return 'Администратор';
			case 'playerRole.mod': return 'Модератор';
			case 'playerRole.halfmod': return 'Модератор сообщества';
			case 'playerRole.anon': return 'Аноним';
			case 'numOfGameActions.pc': return 'Все чисто';
			case 'numOfGameActions.hold': return 'В запас';
			case 'numOfGameActions.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} нажатий клавиш',
				one: '${n} нажатие на клавишу',
				two: '${n} нажатия на клавишы',
				few: '${n} нажатия на клавишы',
				many: '${n} нажатий на клавиш',
				other: '${n} нажатий на клавиш',
			);
			case 'numOfGameActions.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} T-спинов всего',
				one: 'Всего ${n} T-спин',
				two: '${n} T-спина всего',
				few: '${n} T-спина всего',
				many: '${n} T-спинов всего',
				other: '${n} T-спинов всего',
			);
			case 'numOfGameActions.lineClears': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} линий очищено',
				one: '${n} линия очищена',
				two: '${n} линии очищено',
				few: '${n} линии очищено',
				many: '${n} линий очищено',
				other: '${n} линий очищено',
			);
			case 'popupActions.cancel': return 'Отменить';
			case 'popupActions.submit': return 'Подтвердить';
			case 'popupActions.ok': return 'OK';
			case 'errors.connection': return ({required Object code, required Object message}) => 'Проблема с подключением: ${code} ${message}';
			case 'errors.noSuchUser': return 'Нет такого пользователя';
			case 'errors.noSuchUserSub': return 'Либо вы ошиблись при вводе, либо аккаунта больше не существует';
			case 'errors.discordNotAssigned': return 'К данному Discord ID не привязан аккаунт';
			case 'errors.discordNotAssignedSub': return 'Убедитесь в том, что вы вставили правильный ID';
			case 'errors.history': return 'История данного игрока отсутствует';
			case 'errors.actionSuggestion': return 'Возможно, вы хотите';
			case 'errors.p1nkl0bst3rTLmatches': return 'Старых матчей Тетра Лиги не было найдено';
			case 'errors.clientException': return 'Нет соединения с интернетом';
			case 'errors.forbidden': return 'Ваш IP адрес заблокирован';
			case 'errors.forbiddenSub': return ({required Object nickname}) => 'Если у вас работает VPN или прокси, выключите его. Если это не помогло, свяжитесь с ${nickname}';
			case 'errors.tooManyRequests': return 'Слишком много запросов';
			case 'errors.tooManyRequestsSub': return 'Подождите немного и попробуйте снова';
			case 'errors.internal': return 'Что-то случилось на стороне tetr.io';
			case 'errors.internalSub': return 'Скорее всего, osk уже в курсе об этом';
			case 'errors.internalWebVersion': return 'Что-то случилось на стороне tetr.io (или на стороне oskware_bridge, я хз если честно)';
			case 'errors.internalWebVersionSub': return 'Если статус страница osk-а говорит, что всё ок - свяжитесь с dan63047';
			case 'errors.oskwareBridge': return 'Что-то случилось с oskware_bridge';
			case 'errors.oskwareBridgeSub': return 'Дайте dan63047 знать';
			case 'errors.p1nkl0bst3rForbidden': return 'Стороннее API заблокировало ваш IP адрес';
			case 'errors.p1nkl0bst3rTooManyRequests': return 'Слишком много запросов к стороннему API. Попробуйте позже';
			case 'errors.p1nkl0bst3rinternal': return 'Что-то случилось на стороне p1nkl0bst3r-а';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'Что-то случилось на стороне p1nkl0bst3r-а (или на стороне oskware_bridge, я хз если честно)';
			case 'errors.replayAlreadySaved': return 'Повтор уже сохранён';
			case 'errors.replayExpired': return 'Повтор истёк и больше недоступен';
			case 'errors.replayRejected': return 'Стороннее API заблокировало ваш IP адрес';
			case 'countries.': return 'Во всём мире';
			case 'countries.AF': return 'Афганистан';
			case 'countries.AX': return 'Аландские острова';
			case 'countries.AL': return 'Албания';
			case 'countries.DZ': return 'Алжир';
			case 'countries.AS': return 'Американское Самоа';
			case 'countries.AD': return 'Андорра';
			case 'countries.AO': return 'Ангола';
			case 'countries.AI': return 'Ангилья';
			case 'countries.AQ': return 'Антарктида';
			case 'countries.AG': return 'Антигуа и Барбуда';
			case 'countries.AR': return 'Аргентина';
			case 'countries.AM': return 'Армения';
			case 'countries.AW': return 'Аруба';
			case 'countries.AU': return 'Австралия';
			case 'countries.AT': return 'Австрия';
			case 'countries.AZ': return 'Азербайджан';
			case 'countries.BS': return 'Багамские острова';
			case 'countries.BH': return 'Бахрейн';
			case 'countries.BD': return 'Бангладеш';
			case 'countries.BB': return 'Барбадос';
			case 'countries.BY': return 'Беларусь';
			case 'countries.BE': return 'Бельгия';
			case 'countries.BZ': return 'Белиз';
			case 'countries.BJ': return 'Бенин';
			case 'countries.BM': return 'Бермуды';
			case 'countries.BT': return 'Бутан';
			case 'countries.BO': return 'Боливия, Многонациональное Государство';
			case 'countries.BA': return 'Босния и Герцеговина';
			case 'countries.BW': return 'Ботсвана';
			case 'countries.BV': return 'Остров Буве';
			case 'countries.BR': return 'Бразилия';
			case 'countries.IO': return 'Британская территория в Индийском океане';
			case 'countries.BN': return 'Бруней-Даруссалам';
			case 'countries.BG': return 'Болгария';
			case 'countries.BF': return 'Буркина-Фасо';
			case 'countries.BI': return 'Бурунди';
			case 'countries.KH': return 'Камбоджа';
			case 'countries.CM': return 'Камерун';
			case 'countries.CA': return 'Канада';
			case 'countries.CV': return 'Кабо-Верде';
			case 'countries.BQ': return 'Карибские Нидерланды';
			case 'countries.KY': return 'Каймановы острова';
			case 'countries.CF': return 'Центральноафриканская Республика';
			case 'countries.TD': return 'Чад';
			case 'countries.CL': return 'Чили';
			case 'countries.CN': return 'Китай';
			case 'countries.CX': return 'Остров Рождества';
			case 'countries.CC': return 'Кокосовые острова';
			case 'countries.CO': return 'Колумбия';
			case 'countries.KM': return 'Коморские острова';
			case 'countries.CG': return 'Конго';
			case 'countries.CD': return 'Конго, Демократическая Республика';
			case 'countries.CK': return 'Острова Кука';
			case 'countries.CR': return 'Коста-Рика';
			case 'countries.CI': return 'Берег Слоновой Кости';
			case 'countries.HR': return 'Хорватия';
			case 'countries.CU': return 'Куба';
			case 'countries.CW': return 'Кюрасао';
			case 'countries.CY': return 'Кипр';
			case 'countries.CZ': return 'Чешская Республика';
			case 'countries.DK': return 'Дания';
			case 'countries.DJ': return 'Джибути';
			case 'countries.DM': return 'Доминика';
			case 'countries.DO': return 'Доминиканская Республика';
			case 'countries.EC': return 'Эквадор';
			case 'countries.EG': return 'Египет';
			case 'countries.SV': return 'Сальвадор';
			case 'countries.GB-ENG': return 'Англия';
			case 'countries.GQ': return 'Экваториальная Гвинея';
			case 'countries.ER': return 'Эритрея';
			case 'countries.EE': return 'Эстония';
			case 'countries.ET': return 'Эфиопия';
			case 'countries.EU': return 'Европа';
			case 'countries.FK': return 'Фолклендские (Мальвинские) острова';
			case 'countries.FO': return 'Фарерские острова';
			case 'countries.FJ': return 'Фиджи';
			case 'countries.FI': return 'Финляндия';
			case 'countries.FR': return 'Франция';
			case 'countries.GF': return 'Французская Гвиана';
			case 'countries.PF': return 'Французская Полинезия';
			case 'countries.TF': return 'Южные территории Франции';
			case 'countries.GA': return 'Габон';
			case 'countries.GM': return 'Гамбия';
			case 'countries.GE': return 'Грузия';
			case 'countries.DE': return 'Германия';
			case 'countries.GH': return 'Гана';
			case 'countries.GI': return 'Гибралтар';
			case 'countries.GR': return 'Греция';
			case 'countries.GL': return 'Гренландия';
			case 'countries.GD': return 'Гренада';
			case 'countries.GP': return 'Гваделупа';
			case 'countries.GU': return 'Гуам';
			case 'countries.GT': return 'Гватемала';
			case 'countries.GG': return 'Гернси';
			case 'countries.GN': return 'Гвинея';
			case 'countries.GW': return 'Гвинея-Бисау';
			case 'countries.GY': return 'Гайана';
			case 'countries.HT': return 'Гаити';
			case 'countries.HM': return 'Остров Херд и острова Макдональд';
			case 'countries.VA': return 'Святой Престол (государство-городок Ватикан)';
			case 'countries.HN': return 'Гондурас';
			case 'countries.HK': return 'Гонконг';
			case 'countries.HU': return 'Венгрия';
			case 'countries.IS': return 'Исландия';
			case 'countries.IN': return 'Индия';
			case 'countries.ID': return 'Индонезия';
			case 'countries.IR': return 'Иран, Исламская Республика';
			case 'countries.IQ': return 'Ирак';
			case 'countries.IE': return 'Ирландия';
			case 'countries.IM': return 'Остров Мэн';
			case 'countries.IL': return 'Израиль';
			case 'countries.IT': return 'Италия';
			case 'countries.JM': return 'Ямайка';
			case 'countries.JP': return 'Япония';
			case 'countries.JE': return 'Джерси';
			case 'countries.JO': return 'Иордания';
			case 'countries.KZ': return 'Казахстан';
			case 'countries.KE': return 'Кения';
			case 'countries.KI': return 'Кирибати';
			case 'countries.KP': return 'Корея, Народно-Демократическая Республика';
			case 'countries.KR': return 'Корея, Республика';
			case 'countries.XK': return 'Косово';
			case 'countries.KW': return 'Кувейт';
			case 'countries.KG': return 'Кыргызстан';
			case 'countries.LA': return 'Лаосская Народно-Демократическая Республика';
			case 'countries.LV': return 'Латвия';
			case 'countries.LB': return 'Ливан';
			case 'countries.LS': return 'Лесото';
			case 'countries.LR': return 'Либерия';
			case 'countries.LY': return 'Ливия';
			case 'countries.LI': return 'Лихтенштейн';
			case 'countries.LT': return 'Литва';
			case 'countries.LU': return 'Люксембург';
			case 'countries.MO': return 'Макао';
			case 'countries.MK': return 'Македония, бывшая югославская республика';
			case 'countries.MG': return 'Мадагаскар';
			case 'countries.MW': return 'Малави';
			case 'countries.MY': return 'Малайзия';
			case 'countries.MV': return 'Мальдивы';
			case 'countries.ML': return 'Мали';
			case 'countries.MT': return 'Мальта';
			case 'countries.MH': return 'Маршалловы острова';
			case 'countries.MQ': return 'Мартиника';
			case 'countries.MR': return 'Мавритания';
			case 'countries.MU': return 'Маврикий';
			case 'countries.YT': return 'Майотта';
			case 'countries.MX': return 'Мексика';
			case 'countries.FM': return 'Микронезия, Федеративные Штаты';
			case 'countries.MD': return 'Молдова, Республика';
			case 'countries.MC': return 'Монако';
			case 'countries.ME': return 'Черногория';
			case 'countries.MA': return 'Марокко';
			case 'countries.MN': return 'Монголия';
			case 'countries.MS': return 'Монтсеррат';
			case 'countries.MZ': return 'Мозамбик';
			case 'countries.MM': return 'Мьянма';
			case 'countries.NA': return 'Намибия';
			case 'countries.NR': return 'Науру';
			case 'countries.NP': return 'Непал';
			case 'countries.NL': return 'Нидерланды';
			case 'countries.AN': return 'Нидерландские Антильские острова';
			case 'countries.NC': return 'Новая Каледония';
			case 'countries.NZ': return 'Новая Зеландия';
			case 'countries.NI': return 'Никарагуа';
			case 'countries.NE': return 'Нигер';
			case 'countries.NG': return 'Нигерия';
			case 'countries.NU': return 'Ниуэ';
			case 'countries.NF': return 'Остров Норфолк';
			case 'countries.GB-NIR': return 'Северная Ирландия';
			case 'countries.MP': return 'Северные Марианские острова';
			case 'countries.NO': return 'Норвегия';
			case 'countries.OM': return 'Оман';
			case 'countries.PK': return 'Пакистан';
			case 'countries.PW': return 'Палау';
			case 'countries.PS': return 'Палестина';
			case 'countries.PA': return 'Панама';
			case 'countries.PG': return 'Папуа-Новая Гвинея';
			case 'countries.PY': return 'Парагвай';
			case 'countries.PE': return 'Перу';
			case 'countries.PH': return 'Филиппины';
			case 'countries.PN': return 'Питкэрн';
			case 'countries.PL': return 'Польша';
			case 'countries.PT': return 'Португалия';
			case 'countries.PR': return 'Пуэрто-Рико';
			case 'countries.QA': return 'Катар';
			case 'countries.RE': return 'Реюньон';
			case 'countries.RO': return 'Румыния';
			case 'countries.RU': return 'Российская Федерация';
			case 'countries.RW': return 'Руанда';
			case 'countries.BL': return 'Сен-Бартелеми';
			case 'countries.SH': return 'Острова Святой Елены, Вознесения и Тристан-да-Кунья';
			case 'countries.KN': return 'Сент-Китс и Невис';
			case 'countries.LC': return 'Сент-Люсия';
			case 'countries.MF': return 'Сен-Мартен';
			case 'countries.PM': return 'Сен-Пьер и Микелон';
			case 'countries.VC': return 'Сент-Винсент и Гренадины';
			case 'countries.WS': return 'Самоа';
			case 'countries.SM': return 'Сан-Марино';
			case 'countries.ST': return 'Сан-Томе и Принсипи';
			case 'countries.SA': return 'Саудовская Аравия';
			case 'countries.GB-SCT': return 'Шотландия';
			case 'countries.SN': return 'Сенегал';
			case 'countries.RS': return 'Сербия';
			case 'countries.SC': return 'Сейшельские острова';
			case 'countries.SL': return 'Сьерра-Леоне';
			case 'countries.SG': return 'Сингапур';
			case 'countries.SX': return 'Синт-Мартен (голландская часть)';
			case 'countries.SK': return 'Словакия';
			case 'countries.SI': return 'Словения';
			case 'countries.SB': return 'Соломоновы острова';
			case 'countries.SO': return 'Сомали';
			case 'countries.ZA': return 'ЮАР';
			case 'countries.GS': return 'Южная Георгия и Южные Сандвичевы острова';
			case 'countries.SS': return 'Южный Судан';
			case 'countries.ES': return 'Испания';
			case 'countries.LK': return 'Шри-Ланка';
			case 'countries.SD': return 'Судан';
			case 'countries.SR': return 'Суринам';
			case 'countries.SJ': return 'Острова Шпицберген и Ян-Майен';
			case 'countries.SZ': return 'Свазиленд';
			case 'countries.SE': return 'Швеция';
			case 'countries.CH': return 'Швейцария';
			case 'countries.SY': return 'Сирийская Арабская Республика';
			case 'countries.TW': return 'Тайвань';
			case 'countries.TJ': return 'Таджикистан';
			case 'countries.TZ': return 'Танзания, Объединенная Республика';
			case 'countries.TH': return 'Таиланд';
			case 'countries.TL': return 'Тимор-Лешти';
			case 'countries.TG': return 'Того';
			case 'countries.TK': return 'Токелау';
			case 'countries.TO': return 'Tonga';
			case 'countries.TT': return 'Тринидад и Тобаго';
			case 'countries.TN': return 'Тунис';
			case 'countries.TR': return 'Турция';
			case 'countries.TM': return 'Туркменистан';
			case 'countries.TC': return 'Острова Теркс и Кайкос';
			case 'countries.ТВ': return 'Тувалу';
			case 'countries.UG': return 'Уганда';
			case 'countries.UA': return 'Украина';
			case 'countries.AE': return 'Объединенные Арабские Эмираты';
			case 'countries.GB': return 'Великобритания';
			case 'countries.US': return 'Соединенные Штаты';
			case 'countries.UY': return 'Уругвай';
			case 'countries.UM': return 'Малые периферийные острова США';
			case 'countries.UZ': return 'Узбекистан';
			case 'countries.VU': return 'Вануату';
			case 'countries.VE': return 'Венесуэла, Боливарианская Республика';
			case 'countries.VN': return 'Вьетнам';
			case 'countries.VG': return 'Виргинские острова, Британские';
			case 'countries.VI': return 'Виргинские острова, США';
			case 'countries.GB-WLS': return 'Уэльс';
			case 'countries.WF': return 'Острова Уоллис и Футуна';
			case 'countries.EH': return 'Западная Сахара';
			case 'countries.YE': return 'Йемен';
			case 'countries.ZM': return 'Замбия';
			case 'countries.ZW': return 'Зимбабве';
			case 'countries.XX': return 'Неизвестно';
			case 'countries.XM': return 'Луна';
			default: return null;
		}
	}
}

extension on _StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return '英语 (English)';
			case 'locales.ru': return '俄语 (Русский)';
			case 'locales.zh-CN': return '简体中文';
			case 'tetraLeague': return 'Tetra联赛';
			case 'tlRecords': return 'Tetra联赛记录';
			case 'history': return '历史';
			case 'sprint': return '40行竞速';
			case 'blitz': return '闪电战';
			case 'recent': return '最近';
			case 'recentRuns': return '最近游玩局数';
			case 'blitzScore': return ({required Object p}) => '${p} 分';
			case 'openSPreplay': return '在TETR.IO打开回放';
			case 'downloadSPreplay': return '下载回放';
			case 'other': return '其他';
			case 'distinguishment': return '区别';
			case 'zen': return '禅意模式';
			case 'bio': return '个人简介';
			case 'news': return '新闻';
			case 'newsParts.leaderboardStart': return '取得 ';
			case 'newsParts.leaderboardMiddle': return '于 ';
			case 'newsParts.personalbest': return '在 ';
			case 'newsParts.personalbestMiddle': return ' 中取得了新的个人最好成绩 ';
			case 'newsParts.badgeStart': return '获得勋章 ';
			case 'newsParts.badgeEnd': return '';
			case 'newsParts.rankupStart': return '达成 ';
			case 'newsParts.rankupMiddle': return ({required Object r}) => '${r} 段位 ';
			case 'newsParts.rankupEnd': return '';
			case 'newsParts.tetoSupporter': return 'TETR.IO 会员';
			case 'newsParts.supporterStart': return '成为了 ';
			case 'newsParts.supporterGiftStart': return '被赠送了 ';
			case 'newsParts.unknownNews': return ({required Object type}) => '未知新闻 ${type}';
			case 'openSearch': return '搜索玩家';
			case 'closeSearch': return '关闭搜索';
			case 'searchHint': return '昵称，ID或Discord用户ID（需要 "ds:" 前缀）';
			case 'refresh': return '刷新';
			case 'fetchAndsaveTLHistory': return '获取玩家历史';
			case 'fetchAndSaveOldTLmatches': return '获取玩家Tetra联赛历史';
			case 'fetchAndsaveTLHistoryResult': return ({required Object number}) => '找到 ${number} 个状态';
			case 'fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '找到 ${number} 场Tetra联赛比赛';
			case 'showStoredData': return '显示获得的数据';
			case 'statsCalc': return '统计计算器';
			case 'settings': return '设置';
			case 'track': return '添加到\n跟踪列表';
			case 'stopTracking': return '从跟踪列表\n中移除';
			case 'becameTracked': return '已添加到跟踪列表！';
			case 'compare': return '对比';
			case 'stoppedBeingTracked': return '已从跟踪列表中移除！';
			case 'tlLeaderboard': return 'Tetra联赛排行榜';
			case 'noRecords': return '无记录';
			case 'noOldRecords': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '无记录',
				one: '只有 ${n} 个记录',
				two: '只有 ${n} 个记录',
				few: '只有 ${n} 个记录',
				many: '只有 ${n} 个记录',
				other: '只有 ${n} 个记录',
			);
			case 'noRecord': return '没有记录';
			case 'botRecord': return '机器人不予参加排位赛';
			case 'anonRecord': return '匿名用户不予参加排位赛';
			case 'notEnoughData': return '没有足够的数据';
			case 'noHistorySaved': return '没有保存历史';
			case 'pseudoTooltipHeaderInit': return '将鼠标放在点上';
			case 'pseudoTooltipFooterInit': return '以查看详细信息';
			case 'obtainDate': return ({required Object date}) => '在 ${date} 获得';
			case 'fetchDate': return ({required Object date}) => 'Fetched ${date}';
			case 'exactGametime': return '实际游玩时长';
			case 'bigRedBanned': return '该账号封禁中';
			case 'normalBanned': return '封禁';
			case 'bigRedBadStanding': return '信誉不佳';
			case 'copiedToClipboard': return '已复制';
			case 'playerRoleAccount': return '账号';
			case 'wasFromBeginning': return '在很久很久以前';
			case 'created': return '创建于';
			case 'botCreatedBy': return '';
			case 'notSupporter': return '非会员';
			case 'assignedManualy': return '该勋章由 TETR.IO 管理员手动分配';
			case 'supporter': return ({required Object tier}) => '会员等级 ${tier}';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => '${newDate} 时的数据与 ${oldDate} 比较';
			case 'top': return '前';
			case 'topRank': return '最高段位';
			case 'verdictGeneral': return ({required Object rank, required Object verdict, required Object n}) => '比 ${rank} 段平均数据${verdict} ${n}';
			case 'verdictBetter': return '好';
			case 'verdictWorse': return '差';
			case 'smooth': return '平滑';
			case 'postSeason': return '淡季';
			case 'seasonStarts': return '下一赛即将开始于：';
			case 'nanow': return '暂未完成，敬请等待！';
			case 'seasonEnds': return ({required Object countdown}) => '赛季将会在 ${countdown} 后结束';
			case 'seasonEnded': return 'Season has ended';
			case 'gamesUntilRanked': return ({required Object left}) => '还有 ${left} 场比赛获取段位';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} 场胜局';
			case 'promotionOnNextWin': return '下一次胜利即可升段';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} 场败局';
			case 'demotionOnNextLoss': return '下一次失败即可掉段';
			case 'nerdStats': return '详细信息';
			case 'playersYouTrack': return '跟踪';
			case 'formula': return '公式';
			case 'exactValue': return '实际值';
			case 'neverPlayedTL': return '此用户没有参与Tetra联赛';
			case 'botTL': return '机器人不予参加Tetra联赛';
			case 'anonTL': return '匿名用户不予参加Tetra联赛';
			case 'quickPlay': return '快速游戏';
			case 'expert': return '专家';
			case 'withMods': return '带着模组';
			case 'withModsPlural': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '带着 ${n} 个模组',
				one: '带着 ${n} 个模组',
				two: '带着 ${n} 个模组',
				few: '带着 ${n} 个模组',
				many: '带着 ${n} 个模组',
				other: '带着 ${n} 个模组',
			);
			case 'exportDB': return '导出本地数据';
			case 'exportDBDescription': return '它包含跟踪的玩家的状态和Tetra联赛记录和跟踪列表。';
			case 'desktopExportAlertTitle': return '桌面导出';
			case 'desktopExportText': return '您好像在使用桌面版。请查看你的“文档”文件夹，你应该能找到“TetraStats.db”。把它复制到一个地方';
			case 'androidExportAlertTitle': return '安卓导出';
			case 'androidExportText': return ({required Object exportedDB}) => '导出成功\n${exportedDB}';
			case 'importDB': return '导入本地数据';
			case 'importDBDescription': return '恢复您的备份。请注意，已存储的数据库将被覆盖。';
			case 'importWrongFileType': return '文件类型错误';
			case 'importCancelled': return '已取消';
			case 'importSuccess': return '导入成功';
			case 'yourID': return '你的 TETR.IO 用户';
			case 'yourIDAlertTitle': return '你的 TETR.IO 昵称';
			case 'yourIDText': return '当程序加载，它将显示此用户的数据';
			case 'language': return '语言';
			case 'updateInBackground': return '自动升级数据';
			case 'updateInBackgroundDescription': return '当 Tetra Stats 运行时，它可以在缓存过期时更新当前玩家的统计数据';
			case 'customization': return '自定义';
			case 'customizationDescription': return '更改 Tetra Stats UI 中不同事物的外观';
			case 'oskKagari': return 'osk 特有的 Kagari 段位';
			case 'oskKagariDescription': return '如果打开，主视图上的 osk 段位将显示为 :kagari:';
			case 'AccentColor': return '主题色';
			case 'AccentColorDescription': return '几乎所有交互式 UI 元素都用此颜色突出显示';
			case 'timestamps': return '时间';
			case 'timestampsDescription': return '您可以选择显示时间的方式';
			case 'timestampsAbsoluteGMT': return '绝对 (GMT)';
			case 'timestampsAbsoluteLocalTime': return '绝对 (你的时区)';
			case 'timestampsRelative': return '相对';
			case 'rating': return '评级主要表现';
			case 'ratingDescription': return 'TR 不是线性的，而 Glicko 没有边界，百分位数易挥发';
			case 'ratingLBposition': return 'LB 位置';
			case 'sheetbotGraphs': return 'Sheetbot式雷达图';
			case 'sheetbotGraphsDescription': return '若开启，雷达图上的点为负时可以出现在对面';
			case 'lbStats': return '显示基于排行榜的数据';
			case 'lbStatsDescription': return '这会影响加载时间，但允许您通过统计数据查看排行榜上的位置并与平均值进行比较';
			case 'aboutApp': return '关于';
			case 'aboutAppText': return ({required Object appName, required Object packageName, required Object version, required Object buildNumber}) => '${appName} (${packageName}) ${version} 版 Build ${buildNumber}\n\n由 dan63047 制作\n由 kerrmunism 提供公式\n由 p1nkl0bst3r 提供历史\nTETR.IO 回放抓取器 API 由 szy 制作';
			case 'stateViewTitle': return ({required Object nickname, required Object date}) => '${nickname} 在 ${date}';
			case 'statesViewTitle': return ({required Object nickname, required Object number}) => '${nickname} 的 ${number} 个状态';
			case 'matchesViewTitle': return ({required Object nickname}) => '${nickname} 的Tetra联赛历史';
			case 'statesViewEntry': return ({required Object level, required Object glicko, required Object rd, required Object games}) => '${level} TR, ${glicko}±${rd} Glicko, ${games} 次游戏';
			case 'stateRemoved': return ({required Object date}) => '成功移除 ${date} 的状态！';
			case 'matchRemoved': return ({required Object date}) => '成功移除 ${date} 的比赛！';
			case 'viewAllMatches': return '查看所有比赛';
			case 'trackedPlayersViewTitle': return '获取的数据';
			case 'trackedPlayersZeroEntrys': return '列表为空。 点击 “添加到跟踪列表” 可以将玩家放在这里';
			case 'trackedPlayersOneEntry': return '只有 1 个玩家';
			case 'trackedPlayersManyEntrys': return ({required Object numberOfPlayers}) => '${numberOfPlayers} 个玩家';
			case 'trackedPlayersEntry': return ({required Object nickname, required Object numberOfStates}) => '${nickname}：${numberOfStates} 个状态';
			case 'trackedPlayersDescription': return ({required Object firstStateDate, required Object lastStateDate}) => '从 ${firstStateDate} 到 ${lastStateDate}';
			case 'trackedPlayersStatesDeleted': return ({required Object nickname}) => '成功从数据库中移除 ${nickname} 个状态！';
			case 'duplicatedFix': return '删除重复的 TL 匹配项';
			case 'compressDB': return '压缩数据库';
			case 'SpaceSaved': return ({required Object size}) => '保存空白：${size}';
			case 'averageXrank': return ({required Object rankLetter}) => '平均 ${rankLetter} 段';
			case 'vs': return 'vs';
			case 'inTLmatch': return '在Tetra联赛中';
			case 'downloadReplay': return '下载 .ttrm 回放';
			case 'openReplay': return '在 TETR.IO 打开回放';
			case 'replaySaved': return ({required Object path}) => '已保存回放至 ${path}';
			case 'match': return '比赛';
			case 'timeWeightedmatch': return '比赛（时间加权）';
			case 'roundNumber': return ({required Object n}) => '第 ${n} 回合';
			case 'statsFor': return '数据：';
			case 'numberOfRounds': return '回合数';
			case 'matchLength': return '比赛时长';
			case 'roundLength': return '回合时长';
			case 'matchStats': return '比赛数据';
			case 'timeWeightedmatchStats': return '时间加权比赛数据';
			case 'replayIssue': return '无法处理回放';
			case 'matchIsTooOld': return '无回放';
			case 'winner': return '赢家';
			case 'registred': return '注册日期';
			case 'playedTL': return '游玩过Tetra联赛';
			case 'winChance': return '胜利机会';
			case 'byGlicko': return '靠Glicko';
			case 'byEstTR': return '靠预测TR';
			case 'compareViewNoValues': return ({required Object avgR}) => '请输入用户名，用户IO，APM-PPS-VS值 （分隔符不重要，只需要顺序）或者${avgR}（R是一个段位）到两个字段';
			case 'compareViewWrongValue': return ({required Object value}) => '获取 ${value} 失败';
			case 'mostRecentOne': return '最接近的';
			case 'yes': return '是';
			case 'no': return '否';
			case 'daysLater': return '天后';
			case 'dayseBefore': return '天前';
			case 'fromBeginning': return '开服';
			case 'calc': return '计算器';
			case 'calcViewNoValues': return '输入值以计算数据';
			case 'rankAveragesViewTitle': return '段位分隔符';
			case 'sprintAndBlitsViewTitle': return '竞速与闪电战平均数据';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => '数据来自${date}';
			case 'rank': return '段位';
			case 'averages': return '平均';
			case 'lbViewZeroEntrys': return '空';
			case 'lbViewOneEntry': return '只有一个玩家';
			case 'lbViewManyEntrys': return ({required Object numberOfPlayers}) => '有 ${numberOfPlayers}';
			case 'everyoneAverages': return 'Tetra联赛散点图';
			case 'sortBy': return '排序依据';
			case 'reversed': return '反向';
			case 'country': return '地区';
			case 'rankAverages': return ({required Object rank}) => '${rank}段位散点图';
			case 'players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '${n} 个玩家',
				one: '${n} 个玩家',
				two: '${n} 个玩家',
				few: '${n} 个玩家',
				many: '${n} 个玩家',
				other: '${n} 个玩家',
			);
			case 'games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '${n} 场游戏',
				one: '${n} 场游戏',
				two: '${n} 场游戏',
				few: '${n} 场游戏',
				many: '${n} 场游戏',
				other: '${n} 场游戏',
			);
			case 'gamesPlayed': return ({required Object games}) => '${games} 场游戏';
			case 'chart': return '列表';
			case 'entries': return '条目';
			case 'minimums': return '最小值';
			case 'maximums': return '最大值';
			case 'lowestValues': return '最小值';
			case 'averageValues': return '平均值';
			case 'highestValues': return '最大值';
			case 'forPlayer': return ({required Object username}) => '来自用户 ${username}';
			case 'currentAxis': return ({required Object axis}) => '${axis} 轴：';
			case 'p1nkl0bst3rAlert': return '该数据是从 p1nkl0bst3r 维护的第三方 API 中检索的';
			case 'notForWeb': return '浏览器版本暂不支持函数';
			case 'graphs.attack': return '攻击';
			case 'graphs.speed': return '速度';
			case 'graphs.defense': return '防御';
			case 'graphs.cheese': return '奶酪层';
			case 'statCellNum.xpLevel': return 'XP等级';
			case 'statCellNum.xpProgress': return '到下一等级的进度';
			case 'statCellNum.xpFrom0ToLevel': return ({required Object n}) => '从 0 到 ${n} 等级的进度';
			case 'statCellNum.xpLeft': return 'XP 还有';
			case 'statCellNum.hoursPlayed': return '小时游玩';
			case 'statCellNum.onlineGames': return '在线游戏场次';
			case 'statCellNum.gamesWon': return '获胜场次';
			case 'statCellNum.totalGames': return '总在线游戏场次';
			case 'statCellNum.totalWon': return '总在线游戏获胜场次';
			case 'statCellNum.friends': return '好友';
			case 'statCellNum.apm': return '每分\n发送垃圾行';
			case 'statCellNum.vs': return 'VS\n分数';
			case 'statCellNum.recordLB': return '名次';
			case 'statCellNum.lbp': return '名次';
			case 'statCellNum.lbpShort': return '名次';
			case 'statCellNum.lbpc': return '地区\n名次';
			case 'statCellNum.lbpcShort': return '地区名次';
			case 'statCellNum.gamesPlayed': return '游戏\n场次';
			case 'statCellNum.gamesWonTL': return '获胜\n场次';
			case 'statCellNum.winrate': return '胜率';
			case 'statCellNum.level': return '等级';
			case 'statCellNum.score': return '分数';
			case 'statCellNum.spp': return '每块\n得分';
			case 'statCellNum.pieces': return '放置\n块数';
			case 'statCellNum.pps': return '每秒\n放置块数';
			case 'statCellNum.finesseFaults': return '非极简\n操作';
			case 'statCellNum.finessePercentage': return '极简率';
			case 'statCellNum.keys': return '按键';
			case 'statCellNum.kpp': return '每块\n按键';
			case 'statCellNum.kps': return '每秒\n按键';
			case 'statCellNum.tr': return 'Tetra分数';
			case 'statCellNum.rd': return '偏移值';
			case 'statCellNum.app': return '每块发送垃圾行数';
			case 'statCellNum.appDescription': return '(Attack per Piece, 简称APP) 主要效率指标。表示玩家每块可以发动多少次攻击';
			case 'statCellNum.vsapmDescription': return '基本上可以告诉你在攻击中利用垃圾行的效率';
			case 'statCellNum.dss': return '每秒\n挖掘';
			case 'statCellNum.dssDescription': return '(Downstack per Second, 简称 DS/S) 测量一秒钟内清除多少条垃圾行。';
			case 'statCellNum.dsp': return '每块\n挖掘';
			case 'statCellNum.dspDescription': return '(Downstack per Piece, 简称 DS/P) 测量每一块清除多少条垃圾行。';
			case 'statCellNum.appdsp': return 'APP + DS/P';
			case 'statCellNum.appdspDescription': return '只是每块发送垃圾行数与每块挖掘之和。';
			case 'statCellNum.cheese': return '垃圾行\n混乱指数';
			case 'statCellNum.cheeseDescription': return '(Cheese Index, 简称Cheese) 是玩家发出的垃圾行有多整齐/混乱的近似值。低数据代表整齐，高数据代表混乱。\n由 kerrmunism 发明';
			case 'statCellNum.gbe': return '垃圾行\n效率';
			case 'statCellNum.gbeDescription': return '(Garbage Efficity, 简称Gb Eff.) 测量玩家如何很好地利用他们收到的垃圾行。高数据代表更好或者他们更多地用TA的垃圾行，低数据代表TA大多将垃圾行送回奶酪层，或者很少清理垃圾行。\n由 Zepheniah 与 Dragonboy 发明。';
			case 'statCellNum.nyaapp': return '加权\nAPP';
			case 'statCellNum.nyaappDescription': return '(Weighted APP, 简称wAPP) 在本质上是在衡量您在保持高 APP 的同时发送奶酪的能力。\n由 Wertj 发明。';
			case 'statCellNum.area': return '面积';
			case 'statCellNum.areaDescription': return '如果排除 Cheese 和 vs/apm 部分，您的形状在图表上占据了多少空间';
			case 'statCellNum.estOfTR': return '预测 TR';
			case 'statCellNum.estOfTRShort': return '预测 TR';
			case 'statCellNum.accOfEst': return '预测实际差量';
			case 'statCellNum.accOfEstShort': return '预测实际差量';
			case 'playerRole.user': return '用户';
			case 'playerRole.banned': return '封禁';
			case 'playerRole.bot': return '机器人';
			case 'playerRole.sysop': return '系统管理员';
			case 'playerRole.admin': return '管理员';
			case 'playerRole.mod': return '管理员';
			case 'playerRole.halfmod': return '社区管理员';
			case 'playerRole.anon': return '匿名';
			case 'numOfGameActions.pc': return '全消数';
			case 'numOfGameActions.hold': return '暂存数';
			case 'numOfGameActions.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '${n} 次按键',
				one: '${n} 次按键',
				two: '${n} 次按键',
				few: '${n} 次按键',
				many: '${n} 次按键',
				other: '${n} 次按键',
			);
			case 'numOfGameActions.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '共 ${n} 次T旋',
				one: '共 ${n} 次T旋',
				two: '共 ${n} 次T旋',
				few: '共 ${n} 次T旋',
				many: '共 ${n} 次T旋',
				other: '共 ${n} 次T旋',
			);
			case 'numOfGameActions.lineClears': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '清除了 ${n} 行',
				one: '清除了 ${n} 行',
				two: '清除了 ${n} 行',
				few: '清除了 ${n} 行',
				many: '清除了 ${n} 行',
				other: '清除了 ${n} 行',
			);
			case 'popupActions.cancel': return '取消';
			case 'popupActions.submit': return '确定';
			case 'popupActions.ok': return '彳亍';
			case 'errors.connection': return ({required Object code, required Object message}) => '连接错误： ${code} ${message}';
			case 'errors.noSuchUser': return '没有这样的用户';
			case 'errors.noSuchUserSub': return '检查用户名的拼写是否错误，也许用户不存在';
			case 'errors.discordNotAssigned': return '没有用户绑定到该Discord ID';
			case 'errors.discordNotAssignedSub': return '您必须输入合法的ID';
			case 'errors.history': return '此玩家没有历史';
			case 'errors.actionSuggestion': return '你也许想';
			case 'errors.p1nkl0bst3rTLmatches': return '没有比赛';
			case 'errors.clientException': return '连接不到网络';
			case 'errors.forbidden': return '你的IP地址被封禁';
			case 'errors.forbiddenSub': return ({required Object nickname}) => '请关闭您的VPN。若问题仍然存在，请联系 ${nickname}';
			case 'errors.tooManyRequests': return '您申请的请求过多';
			case 'errors.tooManyRequestsSub': return '等一会再试吧';
			case 'errors.internal': return 'tetr.io 似乎出错了';
			case 'errors.internalSub': return 'osk，也许，要被';
			case 'errors.internalWebVersion': return 'tetr.io 或者 oskware_bridge 似乎出错了';
			case 'errors.internalWebVersionSub': return '如果 osk 说没有什么问题，请让dan63047知道';
			case 'errors.oskwareBridge': return 'oskware_bridge 似乎出错了';
			case 'errors.oskwareBridgeSub': return '请让 dan63047 知道';
			case 'errors.p1nkl0bst3rForbidden': return '第三方API封禁了你的IP地址';
			case 'errors.p1nkl0bst3rTooManyRequests': return '第三方API……太多请求了。';
			case 'errors.p1nkl0bst3rinternal': return 'p1nkl0bst3r 那边似乎出错了';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'p1nkl0bst3r (或 on oskware_bridge, 其实我并不知道) 那边似乎出错了';
			case 'errors.replayAlreadySaved': return '你已保存此回放';
			case 'errors.replayExpired': return '回放已过期';
			case 'errors.replayRejected': return '第三方API封禁了你的IP地址';
			case 'countries.': return '无';
			case 'countries.AF': return '阿富汗';
			case 'countries.AX': return '奥兰群岛';
			case 'countries.AL': return '阿尔巴尼亚';
			case 'countries.DZ': return '阿尔及利亚';
			case 'countries.AS': return '美属萨摩亚';
			case 'countries.AD': return '安道尔';
			case 'countries.AO': return '安哥拉';
			case 'countries.AI': return '安圭拉';
			case 'countries.AQ': return '南极洲';
			case 'countries.AG': return '安提瓜和巴布达';
			case 'countries.AR': return '阿根廷';
			case 'countries.AM': return '亚美尼亚';
			case 'countries.AW': return '阿鲁巴';
			case 'countries.AU': return '澳大利亚';
			case 'countries.AT': return '奥地利';
			case 'countries.AZ': return '阿塞拜疆';
			case 'countries.BS': return '巴哈马';
			case 'countries.BH': return '巴林';
			case 'countries.BD': return '孟加拉国';
			case 'countries.BB': return '巴巴多斯';
			case 'countries.BY': return '白俄罗斯';
			case 'countries.BE': return '比利时';
			case 'countries.BZ': return '伯利兹';
			case 'countries.BJ': return '贝宁';
			case 'countries.BM': return '百慕大';
			case 'countries.BT': return '不丹';
			case 'countries.BO': return '玻利维亚多民族国';
			case 'countries.BA': return '波斯尼亚和黑塞哥维那';
			case 'countries.BW': return '博茨瓦纳';
			case 'countries.BV': return '布韦岛';
			case 'countries.BR': return '巴西';
			case 'countries.IO': return '英属印度洋领地';
			case 'countries.BN': return '文莱达鲁萨兰国';
			case 'countries.BG': return '保加利亚';
			case 'countries.BF': return '布基纳法索';
			case 'countries.BI': return '布隆迪';
			case 'countries.KH': return '柬埔寨';
			case 'countries.CM': return '喀麦隆';
			case 'countries.CA': return '加拿大';
			case 'countries.CV': return '佛得角';
			case 'countries.BQ': return '荷兰加勒比区';
			case 'countries.KY': return '开曼群岛';
			case 'countries.CF': return '中非';
			case 'countries.TD': return '乍得';
			case 'countries.CL': return '智利';
			case 'countries.CN': return '中国';
			case 'countries.CX': return '圣诞岛';
			case 'countries.CC': return '科科斯（基林）群岛';
			case 'countries.CO': return '哥伦比亚';
			case 'countries.KM': return '科摩罗';
			case 'countries.CG': return '刚果（布）/刚果共和国';
			case 'countries.CD': return '刚果（金）/刚果民主共和国';
			case 'countries.CK': return '库克群岛';
			case 'countries.CR': return '哥斯达黎加';
			case 'countries.CI': return '科特迪瓦';
			case 'countries.HR': return '克罗地亚';
			case 'countries.CU': return '古巴';
			case 'countries.CW': return '库拉索';
			case 'countries.CY': return '塞浦路斯';
			case 'countries.CZ': return '捷克';
			case 'countries.DK': return '丹麦';
			case 'countries.DJ': return '吉布提';
			case 'countries.DM': return '多米尼加';
			case 'countries.DO': return '多米尼加共和国';
			case 'countries.EC': return '厄瓜多尔';
			case 'countries.EG': return '埃及';
			case 'countries.SV': return '萨尔瓦多';
			case 'countries.GB-ENG': return '英格兰';
			case 'countries.GQ': return '赤道几内亚';
			case 'countries.ER': return '厄立特里亚';
			case 'countries.EE': return '爱沙尼亚';
			case 'countries.ET': return '埃塞俄比亚';
			case 'countries.EU': return '欧洲';
			case 'countries.FK': return '福克兰群岛/马尔维纳斯群岛';
			case 'countries.FO': return '法罗群岛';
			case 'countries.FJ': return '斐济';
			case 'countries.FI': return '芬兰';
			case 'countries.FR': return '法国';
			case 'countries.GF': return '法属圭亚那';
			case 'countries.PF': return '法属波利尼西亚';
			case 'countries.TF': return '法属南部领地';
			case 'countries.GA': return '加蓬';
			case 'countries.GM': return '冈比亚';
			case 'countries.GE': return '格鲁吉亚';
			case 'countries.DE': return '德国';
			case 'countries.GH': return '加纳';
			case 'countries.GI': return '直布罗陀';
			case 'countries.GR': return '希腊';
			case 'countries.GL': return '格陵兰岛';
			case 'countries.GD': return '格林纳达';
			case 'countries.GP': return '瓜德罗普岛';
			case 'countries.GU': return '关岛';
			case 'countries.GT': return '危地马拉';
			case 'countries.GG': return '根西岛';
			case 'countries.GN': return '几内亚';
			case 'countries.GW': return '几内亚比绍';
			case 'countries.GY': return '圭亚那';
			case 'countries.HT': return '海地';
			case 'countries.HM': return '赫德岛和麦克唐纳群岛';
			case 'countries.VA': return '梵蒂冈';
			case 'countries.HN': return '洪都拉斯';
			case 'countries.HK': return '中国香港';
			case 'countries.HU': return '匈牙利';
			case 'countries.IS': return '冰岛';
			case 'countries.IN': return '印度';
			case 'countries.ID': return '印度尼西亚';
			case 'countries.IR': return '伊朗';
			case 'countries.IQ': return '伊拉克';
			case 'countries.IE': return '爱尔兰';
			case 'countries.IM': return '马恩岛';
			case 'countries.IL': return '以色列';
			case 'countries.IT': return '意大利';
			case 'countries.JM': return '牙买加';
			case 'countries.JP': return '日本';
			case 'countries.JE': return 'Jersey';
			case 'countries.JO': return '约旦';
			case 'countries.KZ': return '哈萨克斯坦';
			case 'countries.KE': return '肯尼亚';
			case 'countries.KI': return '基里巴斯';
			case 'countries.KP': return '朝鲜';
			case 'countries.KR': return '韩国';
			case 'countries.XK': return '科索沃';
			case 'countries.KW': return '科威特';
			case 'countries.KG': return '吉尔吉斯斯坦';
			case 'countries.LA': return '老挝';
			case 'countries.LV': return '拉脱维亚';
			case 'countries.LB': return '黎巴嫩';
			case 'countries.LS': return '莱索托';
			case 'countries.LR': return '利比里亚';
			case 'countries.LY': return '利比亚';
			case 'countries.LI': return '列支敦士登';
			case 'countries.LT': return '立陶宛';
			case 'countries.LU': return '卢森堡';
			case 'countries.MO': return '中国澳门';
			case 'countries.MK': return '马其顿';
			case 'countries.MG': return '马达加斯加';
			case 'countries.MW': return '马拉维';
			case 'countries.MY': return '马来西亚';
			case 'countries.MV': return '马尔代夫';
			case 'countries.ML': return '马里';
			case 'countries.MT': return '马耳他';
			case 'countries.MH': return '马绍尔群岛';
			case 'countries.MQ': return '马提尼克岛';
			case 'countries.MR': return '毛里塔尼亚';
			case 'countries.MU': return '毛里求斯';
			case 'countries.YT': return '马约特岛';
			case 'countries.MX': return '墨西哥';
			case 'countries.FM': return '密克罗尼西亚联邦';
			case 'countries.MD': return '摩尔多瓦共和国';
			case 'countries.MC': return '摩纳哥';
			case 'countries.ME': return '黑山';
			case 'countries.MA': return '摩洛哥';
			case 'countries.MN': return '蒙古';
			case 'countries.MS': return '蒙特塞拉特';
			case 'countries.MZ': return '莫桑比克';
			case 'countries.MM': return '缅甸';
			case 'countries.NA': return '纳米比亚';
			case 'countries.NR': return '瑙鲁';
			case 'countries.NP': return '尼泊尔';
			case 'countries.NL': return '尼德兰';
			case 'countries.AN': return '荷属安的列斯';
			case 'countries.NC': return '新喀里多尼亚';
			case 'countries.NZ': return '新西兰';
			case 'countries.NI': return '尼加拉瓜';
			case 'countries.NE': return '尼日尔';
			case 'countries.NG': return '尼日利亚';
			case 'countries.NU': return '纽埃';
			case 'countries.NF': return '诺福克岛';
			case 'countries.GB-NIR': return '北爱尔兰';
			case 'countries.MP': return '北马里亚纳群岛';
			case 'countries.NO': return '挪威';
			case 'countries.OM': return '阿曼';
			case 'countries.PK': return '巴基斯坦';
			case 'countries.PW': return '帕劳';
			case 'countries.PS': return '巴勒斯坦';
			case 'countries.PA': return '巴拿马';
			case 'countries.PG': return '巴布亚新几内亚';
			case 'countries.PY': return '巴拉圭';
			case 'countries.PE': return '秘鲁';
			case 'countries.PH': return '菲律宾';
			case 'countries.PN': return '皮特凯恩';
			case 'countries.PL': return '波兰';
			case 'countries.PT': return '葡萄牙';
			case 'countries.PR': return '波多黎各';
			case 'countries.QA': return '卡塔尔';
			case 'countries.RE': return '留尼汪';
			case 'countries.RO': return '罗马尼亚';
			case 'countries.RU': return '俄罗斯联邦';
			case 'countries.RW': return '卢旺达';
			case 'countries.BL': return '圣巴泰勒米';
			case 'countries.SH': return '圣赫勒拿,阿森松和特里斯坦-达库尼亚';
			case 'countries.KN': return '圣基茨和尼维斯';
			case 'countries.LC': return '圣卢西亚';
			case 'countries.MF': return '圣马丁';
			case 'countries.PM': return '圣皮埃尔和密克隆群岛';
			case 'countries.VC': return '圣文森特和格林纳丁斯';
			case 'countries.WS': return '萨摩亚';
			case 'countries.SM': return '圣马力诺';
			case 'countries.ST': return '圣多美和普林西比';
			case 'countries.SA': return '沙特阿拉伯';
			case 'countries.GB-SCT': return '苏格兰';
			case 'countries.SN': return '塞内加尔';
			case 'countries.RS': return '塞尔维亚';
			case 'countries.SC': return '塞舌尔';
			case 'countries.SL': return '塞拉利昂';
			case 'countries.SG': return '新加坡';
			case 'countries.SX': return '荷属圣马丁';
			case 'countries.SK': return '斯洛伐克';
			case 'countries.SI': return '斯洛文尼亚';
			case 'countries.SB': return '所罗门群岛';
			case 'countries.SO': return '索马里';
			case 'countries.ZA': return '南非';
			case 'countries.GS': return '南乔治亚和南桑威奇群岛';
			case 'countries.SS': return '南苏丹';
			case 'countries.ES': return '西班牙';
			case 'countries.LK': return '斯里兰卡';
			case 'countries.SD': return '苏丹';
			case 'countries.SR': return '苏里南';
			case 'countries.SJ': return '斯瓦尔巴和扬马延群岛';
			case 'countries.SZ': return '斯威士兰';
			case 'countries.SE': return '瑞典';
			case 'countries.CH': return '瑞士';
			case 'countries.SY': return '叙利亚';
			case 'countries.TW': return '中国台湾';
			case 'countries.TJ': return '塔吉克斯坦';
			case 'countries.TZ': return '坦桑尼亚';
			case 'countries.TH': return '泰国';
			case 'countries.TL': return '东帝汶';
			case 'countries.TG': return '多哥';
			case 'countries.TK': return '托克劳';
			case 'countries.TO': return '汤加';
			case 'countries.TT': return '特立尼达和多巴哥';
			case 'countries.TN': return '突尼斯';
			case 'countries.TR': return '土耳其';
			case 'countries.TM': return '土库曼斯坦';
			case 'countries.TC': return '特克斯和凯科斯群岛';
			case 'countries.TV': return '图瓦卢';
			case 'countries.UG': return '乌干达';
			case 'countries.UA': return '乌克兰';
			case 'countries.AE': return '阿拉伯联合酋长国';
			case 'countries.GB': return '英国';
			case 'countries.US': return '美国';
			case 'countries.UY': return '乌拉圭';
			case 'countries.UM': return '美国小岛屿';
			case 'countries.UZ': return '乌兹别克斯坦';
			case 'countries.VU': return '瓦努阿图';
			case 'countries.VE': return '委内瑞拉玻利瓦尔共和国';
			case 'countries.VN': return '越南';
			case 'countries.VG': return '英属维尔京群岛';
			case 'countries.VI': return '美属维尔京群岛';
			case 'countries.GB-WLS': return '威尔士';
			case 'countries.WF': return '瓦利斯和富图纳群岛';
			case 'countries.EH': return '西撒哈拉';
			case 'countries.YE': return '也门';
			case 'countries.ZM': return '赞比亚';
			case 'countries.ZW': return '津巴布韦';
			case 'countries.XX': return '未知';
			case 'countries.XM': return '月球';
			default: return null;
		}
	}
}
