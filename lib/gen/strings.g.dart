/// Generated file. Do not edit.
///
/// Original: res/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 1
/// Strings: 750
///
/// Built on 2024-12-04 at 18:43 UTC

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
	en(languageCode: 'en', build: Translations.build);

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
	Map<String, String> get gamemodes => {
		'league': 'Tetra League',
		'zenith': 'Quick Play',
		'zenithex': 'Quick Play Expert',
		'40l': '40 Lines',
		'blitz': 'Blitz',
		'5mblast': '5,000,000 Blast',
		'zen': 'Zen',
	};
	late final _StringsDestinationsEn destinations = _StringsDestinationsEn._(_root);
	String get goBackButton => 'Go Back';
	String get nanow => 'Not avaliable for now...';
	String seasonEnds({required Object countdown}) => 'Season ends in ${countdown}';
	String get seasonEnded => 'Season has ended';
	String overallPB({required Object pb}) => 'Overall PB: ${pb}';
	String gamesUntilRanked({required Object left}) => '${left} games until being ranked';
	String numOfVictories({required Object wins}) => '~${wins} victories';
	String get promotionOnNextWin => 'Promotion on next win';
	String numOfdefeats({required Object losses}) => '~${losses} defeats';
	String get demotionOnNextLoss => 'Demotion on next loss';
	String get records => 'Records';
	String get nerdStats => 'Nerd Stats';
	String get playstyles => 'Playstyles';
	String get horoscopes => 'Horoscopes';
	String get season => 'Season';
	String get smooth => 'Smooth';
	String get dateAndTime => 'Date & Time';
	String get TLfullLBnote => 'Heavy, but allows you to sort players by their stats and filter them by ranks';
	String get rank => 'Rank';
	String verdictGeneral({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} of ${rank} rank avg';
	String get verdictBetter => 'ahead';
	String get verdictWorse => 'behind';
	String get localStanding => 'local';
	late final _StringsXpEn xp = _StringsXpEn._(_root);
	late final _StringsGametimeEn gametime = _StringsGametimeEn._(_root);
	String get track => 'Track';
	String get stopTracking => 'Stop tracking';
	String supporter({required Object tier}) => 'Supporter tier ${tier}';
	String comparingWith({required Object newDate, required Object oldDate}) => 'Data from ${newDate} comparing with ${oldDate}';
	String get compare => 'Compare';
	String get comparison => 'Comparison';
	String get general => 'General';
	String get badges => 'Badges';
	String obtainDate({required Object date}) => 'Obtained ${date}';
	String get assignedManualy => 'That badge was assigned manualy by TETR.IO admins';
	String get distinguishment => 'Distinguishment';
	String get banned => 'Banned';
	String get bannedSubtext => 'Bans are placed when TETR.IO rules or terms of service are broken';
	String get badStanding => 'Bad standing';
	String get badStandingSubtext => 'One or more recent bans on record';
	String get botAccount => 'Bot account';
	String botAccountSubtext({required Object botMaintainers}) => 'Operated by ${botMaintainers}';
	String get copiedToClipboard => 'Copied to clipboard!';
	String get bio => 'Bio';
	String get news => 'News';
	late final _StringsMatchResultEn matchResult = _StringsMatchResultEn._(_root);
	late final _StringsDistinguishmentsEn distinguishments = _StringsDistinguishmentsEn._(_root);
	late final _StringsNewsEntriesEn newsEntries = _StringsNewsEntriesEn._(_root);
	String rankupMiddle({required Object r}) => '${r} rank';
	String get copyUserID => 'Click to copy user ID';
	String get searchHint => 'Username or ID';
	String get navMenu => 'Navigation menu';
	String get navMenuTooltip => 'Open navigation menu';
	String get refresh => 'Refresh data';
	String get searchButton => 'Search';
	String get trackedPlayers => 'Tracked Players';
	String get standing => 'Standing';
	String get previousSeasons => 'Previous Seasons';
	String get recent => 'Recent';
	String get top => 'Top';
	String get noRecord => 'No record';
	String sprintAndBlitsRelevance({required Object date}) => 'Relevance: ${date}';
	late final _StringsSnackBarMessagesEn snackBarMessages = _StringsSnackBarMessagesEn._(_root);
	late final _StringsErrorsEn errors = _StringsErrorsEn._(_root);
	late final _StringsActionsEn actions = _StringsActionsEn._(_root);
	late final _StringsGraphsDestinationEn graphsDestination = _StringsGraphsDestinationEn._(_root);
	late final _StringsFilterModaleEn filterModale = _StringsFilterModaleEn._(_root);
	late final _StringsCutoffsDestinationEn cutoffsDestination = _StringsCutoffsDestinationEn._(_root);
	late final _StringsRankViewEn rankView = _StringsRankViewEn._(_root);
	late final _StringsStateViewEn stateView = _StringsStateViewEn._(_root);
	late final _StringsTlMatchViewEn tlMatchView = _StringsTlMatchViewEn._(_root);
	late final _StringsCalcDestinationEn calcDestination = _StringsCalcDestinationEn._(_root);
	late final _StringsInfoDestinationEn infoDestination = _StringsInfoDestinationEn._(_root);
	late final _StringsLeaderboardsDestinationEn leaderboardsDestination = _StringsLeaderboardsDestinationEn._(_root);
	late final _StringsSavedDataDestinationEn savedDataDestination = _StringsSavedDataDestinationEn._(_root);
	late final _StringsSettingsDestinationEn settingsDestination = _StringsSettingsDestinationEn._(_root);
	late final _StringsHomeNavigationEn homeNavigation = _StringsHomeNavigationEn._(_root);
	late final _StringsGraphsNavigationEn graphsNavigation = _StringsGraphsNavigationEn._(_root);
	late final _StringsCalcNavigationEn calcNavigation = _StringsCalcNavigationEn._(_root);
	late final _StringsFirstTimeViewEn firstTimeView = _StringsFirstTimeViewEn._(_root);
	late final _StringsAboutViewEn aboutView = _StringsAboutViewEn._(_root);
	late final _StringsStatsEn stats = _StringsStatsEn._(_root);
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

// Path: destinations
class _StringsDestinationsEn {
	_StringsDestinationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'Home';
	String get graphs => 'Graphs';
	String get leaderboards => 'Leaderboards';
	String get cutoffs => 'Cutoffs';
	String get calc => 'Calculator';
	String get info => 'Info Center';
	String get data => 'Saved Data';
	String get settings => 'Settings';
}

// Path: xp
class _StringsXpEn {
	_StringsXpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'XP Level';
	String progressToNextLevel({required Object percentage}) => 'Progress to next level: ${percentage}';
	String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => 'Progress from 0 XP to level ${goal}: ${percentage} (${left} XP left)';
}

// Path: gametime
class _StringsGametimeEn {
	_StringsGametimeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Exact gametime';
	String gametimeAday({required Object gametime}) => '${gametime} a day in average';
	String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'It\'s ${years} years,\nor ${months} months,\nor ${days} days,\nor ${minutes} minutes\nor ${seconds} seconds';
}

// Path: matchResult
class _StringsMatchResultEn {
	_StringsMatchResultEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get victory => 'Victory';
	String get defeat => 'Defeat';
	String get tie => 'Tie';
	String get dqvictory => 'Opponent was DQ\'ed';
	String get dqdefeat => 'Disqualified';
	String get nocontest => 'No Contest';
	String get nullified => 'Nullified';
}

// Path: distinguishments
class _StringsDistinguishmentsEn {
	_StringsDistinguishmentsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get noHeader => 'Header is missing';
	String get noFooter => 'Footer is missing';
	String get twc => 'TETR.IO World Champion';
	String twcYear({required Object year}) => '${year} TETR.IO World Championship';
}

// Path: newsEntries
class _StringsNewsEntriesEn {
	_StringsNewsEntriesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	TextSpan leaderboard({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
		const TextSpan(text: 'Got № '),
		rank,
		const TextSpan(text: ' in '),
		gametype,
	]);
	TextSpan personalbest({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
		const TextSpan(text: 'Got a new PB in '),
		gametype,
		const TextSpan(text: ' of '),
		pb,
	]);
	TextSpan badge({required InlineSpan badge}) => TextSpan(children: [
		const TextSpan(text: 'Obtained a '),
		badge,
		const TextSpan(text: ' badge'),
	]);
	TextSpan rankup({required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: 'Obtained '),
		rank,
		const TextSpan(text: ' in Tetra League'),
	]);
	TextSpan supporter({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Became a '),
		s('TETR.IO supporter'),
	]);
	TextSpan supporter_gift({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Received the gift of '),
		s('TETR.IO supporter'),
	]);
	TextSpan unknown({required InlineSpan type}) => TextSpan(children: [
		const TextSpan(text: 'Unknown news of type '),
		type,
	]);
}

// Path: snackBarMessages
class _StringsSnackBarMessagesEn {
	_StringsSnackBarMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String stateRemoved({required Object date}) => '${date} state was removed from database!';
	String matchRemoved({required Object date}) => '${date} match was removed from database!';
	String get notForWeb => 'Function is not available for web version';
	String get importSuccess => 'Import successful';
	String get importCancelled => 'Import was cancelled';
}

// Path: errors
class _StringsErrorsEn {
	_StringsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get noRecords => 'No records';
	String get notEnoughData => 'Not enough data';
	String get noHistorySaved => 'No history saved';
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

// Path: actions
class _StringsActionsEn {
	_StringsActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancel => 'Cancel';
	String get submit => 'Submit';
	String get ok => 'OK';
	String get apply => 'Apply';
	String get refresh => 'Refresh';
}

// Path: graphsDestination
class _StringsGraphsDestinationEn {
	_StringsGraphsDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get fetchAndsaveTLHistory => 'Get player history';
	String get fetchAndSaveOldTLmatches => 'Get Tetra League matches history';
	String fetchAndsaveTLHistoryResult({required Object number}) => '${number} states was found';
	String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} matches was found';
	String gamesPlayed({required Object games}) => '${games} played';
	String get dateAndTime => 'Date & Time';
	String get filterModaleTitle => 'Filter ranks on graph';
}

// Path: filterModale
class _StringsFilterModaleEn {
	_StringsFilterModaleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get all => 'All';
}

// Path: cutoffsDestination
class _StringsCutoffsDestinationEn {
	_StringsCutoffsDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Tetra League State';
	String relevance({required Object timestamp}) => 'as of ${timestamp}';
	String get actual => 'Actual';
	String get target => 'Target';
	String get cutoffTR => 'Cutoff TR';
	String get targetTR => 'Target TR';
	String get state => 'State';
	String get advanced => 'Advanced';
	String players({required Object n}) => 'Players (${n})';
	String get moreInfo => 'More Info';
	String NumberOne({required Object tr}) => '№ 1 is ${tr} TR';
	String inflated({required Object tr}) => 'Inflated on ${tr} TR';
	String get notInflated => 'Not inflated';
	String deflated({required Object tr}) => 'Deflated on ${tr} TR';
	String get notDeflated => 'Not deflated';
	String get wellDotDotDot => 'Well...';
	String fromPlace({required Object n}) => 'from № ${n}';
	String get viewButton => 'View';
}

// Path: rankView
class _StringsRankViewEn {
	_StringsRankViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String rankTitle({required Object rank}) => '${rank} rank data';
	String get everyoneTitle => 'Entire leaderboard';
	String get trRange => 'TR Range';
	String get supposedToBe => 'Supposed to be';
	String gap({required Object value}) => '${value} gap';
	String trGap({required Object value}) => '${value} TR gap';
	String get deflationGap => 'Deflation gap';
	String get inflationGap => 'Inflation gap';
	String get LBposRange => 'LB pos range';
	String overpopulated({required Object players}) => 'Overpopulated by a ${players}';
	String underpopulated({required Object players}) => 'Underpopulated by a ${players}';
	String get PlayersEqualSupposedToBe => 'cute';
	String get avgStats => 'Average Stats';
	String get avgNerdStats => 'Average Nerd Stats';
	String get minimums => 'Minimums';
	String get maximums => 'Maximums';
}

// Path: stateView
class _StringsStateViewEn {
	_StringsStateViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String title({required Object date}) => 'State from ${date}';
}

// Path: tlMatchView
class _StringsTlMatchViewEn {
	_StringsTlMatchViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get match => 'Match';
	String get vs => 'vs';
	String get winner => 'Winner';
	String roundNumber({required Object n}) => 'Round ${n}';
	String get statsFor => 'Stats for';
	String get numberOfRounds => 'Number of rounds';
	String get matchLength => 'Match Length';
	String get roundLength => 'Round Length';
	String get matchStats => 'Match stats';
	String get downloadReplay => 'Download .ttrm replay';
	String get openReplay => 'Open replay in TETR.IO';
}

// Path: calcDestination
class _StringsCalcDestinationEn {
	_StringsCalcDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tip => 'Enter values and press "Calc" to see Nerd Stats for them';
	String get statsCalcButton => 'Calc';
	String get damageCalcTip => 'Click on the actions on the left to add them here';
	String get actions => 'Actions';
	String get results => 'Results';
	String get rules => 'Rules';
	String get noSpinClears => 'No Spin Clears';
	String get spins => 'Spins';
	String get miniSpins => 'Mini spins';
	String get noLineclear => 'No lineclear (Break Combo)';
	String get custom => 'Custom';
	String get multiplier => 'Multiplier';
	String get pcDamage => 'Perfect Clear Damage';
	String get comboTable => 'Combo Table';
	String get b2bChaining => 'Back-To-Back Chaining';
	String get surgeStartAtB2B => 'Starts at B2B';
	String get surgeStartAmount => 'Start amount';
	String get totalDamage => 'Total damage';
	String get lineclears => 'Lineclears';
	String get combo => 'Combo';
	String get surge => 'Surge';
	String get pcs => 'PCs';
}

// Path: infoDestination
class _StringsInfoDestinationEn {
	_StringsInfoDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Information Center';
	String get sprintAndBlitzAverages => '40 Lines & Blitz Averages';
	String get sprintAndBlitzAveragesDescription => 'Since calculating 40 Lines & Blitz averages is tedious process, it gets updated only once in a while. Click on the title of this card to see the full 40 Lines & Blitz averages table';
	String get tetraStatsWiki => 'Tetra Stats Wiki';
	String get tetraStatsWikiDescription => 'Find more information about Tetra Stats functions and statictic, that it provides';
	String get about => 'About Tetra Stats';
	String get aboutDescription => 'Developed by dan63\n';
}

// Path: leaderboardsDestination
class _StringsLeaderboardsDestinationEn {
	_StringsLeaderboardsDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Leaderboards';
	String get tl => 'Tetra League (Current Season)';
	String get fullTL => 'Tetra League (Current Season, full one)';
	String get ar => 'Acievement Points';
	String get fullTLnote => 'Heavy, but allows you to sort players by their stats and filter them by ranks';
}

// Path: savedDataDestination
class _StringsSavedDataDestinationEn {
	_StringsSavedDataDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Saved Data';
	String get tip => 'Select nickname on the left to see data assosiated with it';
	String seasonTLstates({required Object s}) => 'S${s} TL States';
	String get TLrecords => 'TL Records';
}

// Path: settingsDestination
class _StringsSettingsDestinationEn {
	_StringsSettingsDestinationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get general => 'General';
	String get customization => 'Custonization';
	String get database => 'Local database';
	String get checking => 'Checking...';
	String get enterToSubmit => 'Press Enter to submit';
	String get account => 'Your account in TETR.IO';
	String get accountDescription => 'Stats of that player will be loaded initially right after launching this app. By default it loads my (dan63) stats. To change that, enter your nickname here.';
	String get done => 'Done!';
	String get noSuchAccount => 'No such account';
	String get language => 'Language';
	String languageDescription({required Object languages}) => 'Tetra Stats was translated on ${languages}. By default, app will pick your system one or English, if locale of your system isn\'t avaliable.';
	String languages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'zero languages',
		one: '${n} language',
		two: '${n} languages',
		few: '${n} languages',
		many: '${n} languages',
		other: '${n} languages',
	);
	String get updateInTheBackground => 'Update data in the background';
	String get updateInTheBackgroundDescription => 'If on, Tetra Stats will attempt to retrieve new info once cache expires. Usually that happen every 5 minutes';
	String get compareStats => 'Compare TL stats with rank averages';
	String get compareStatsDescription => 'If on, Tetra Stats will provide additional metrics, which allow you to compare yourself with average player on your rank. The way you\'ll see it — stats will be highlited with corresponding color, hover over them with cursor for more info.';
	String get showPosition => 'Show position on leaderboard by stats';
	String get showPositionDescription => 'This can take some time (and traffic) to load, but will allow you to see your position on the leaderboard, sorted by a stat';
	String get accentColor => 'Accent color';
	String get accentColorDescription => 'That color is seen across this app and usually highlites interactive UI elements.';
	String get accentColorModale => 'Pick an accent color';
	String get timestamps => 'Timestamps format';
	String timestampsDescriptionPart1({required Object d}) => 'You can choose, in which way timestamps shows time. By default, they show time in GMT timezone, formatted according to chosen locale, example: ${d}.';
	String timestampsDescriptionPart2({required Object y, required Object r}) => 'There is also:\n• Locale formatted in your timezone: ${y}\n• Relative timestamp: ${r}';
	String get timestampsAbsoluteGMT => 'Absolute (GMT)';
	String get timestampsAbsoluteLocalTime => 'Absolute (Your timezone)';
	String get timestampsRelative => 'Relative';
	String get sheetbotLikeGraphs => 'Sheetbot-like behavior for radar graphs';
	String get sheetbotLikeGraphsDescription => 'Altough it was considered by me, that the way graphs work in SheetBot is not very correct, some people were confused to see, that -0.5 stride dosen\'t look the way it looks on SheetBot graph. Hence, he we are: if this toggle is on, points on the graphs can appear on the opposite half of the graph if value is negative.';
	String get oskKagariGimmick => 'Osk-Kagari gimmick';
	String get oskKagariGimmickDescription => 'If on, instead of osk\'s rank, :kagari: will be rendered.';
	String get bytesOfDataStored => 'of data stored';
	String get TLrecordsSaved => 'Tetra League records saved';
	String get TLplayerstatesSaved => 'Tetra League playerstates saved';
	String get fixButton => 'Fix';
	String get compressButton => 'Compress';
	String get exportDB => 'Export local database';
	String get desktopExportAlertTitle => 'Desktop export';
	String get desktopExportText => 'It seems like you using this app on desktop. Check your documents folder, you should find "TetraStats.db". Copy it somewhere';
	String get androidExportAlertTitle => 'Android export';
	String androidExportText({required Object exportedDB}) => 'Exported.\n${exportedDB}';
	String get importDB => 'Import local database';
	String get importDBDescription => 'Restore your backup. Notice that already stored database will be overwritten.';
	String get importWrongFileType => 'Wrong file type';
}

// Path: homeNavigation
class _StringsHomeNavigationEn {
	_StringsHomeNavigationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get overview => 'Overview';
	String get standing => 'Standing';
	String get seasons => 'Seasons';
	String get mathces => 'Matches';
	String get pb => 'PB';
	String get normal => 'Normal';
	String get expert => 'Expert';
	String get expertRecords => 'Ex Records';
}

// Path: graphsNavigation
class _StringsGraphsNavigationEn {
	_StringsGraphsNavigationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get history => 'Player History';
	String get league => 'League State';
	String get cutoffs => 'Cutoffs History';
}

// Path: calcNavigation
class _StringsCalcNavigationEn {
	_StringsCalcNavigationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get stats => 'Stats Calculator';
	String get damage => 'Damage Calculator';
}

// Path: firstTimeView
class _StringsFirstTimeViewEn {
	_StringsFirstTimeViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get welcome => 'Welcome to Tetra Stats';
	String get description => 'Service, that allows you to keep track of various statistics for TETR.IO';
	String get nicknameQuestion => 'What\'s your nickname?';
	String get inpuntHint => 'Type it here... (3-16 symbols)';
}

// Path: aboutView
class _StringsAboutViewEn {
	_StringsAboutViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'About Tetra Stats';
	String get about => 'Tetra Stats is a service, that works with TETR.IO Tetra Channel API, providing data from it and calculating some addtitional metrics, based on this data. Service allows user to track their progress in Tetra League with "Track" function, which records every Tetra League change into local database (not automatically, you have to visit service from time to time), so these changes could be looked through graphs.\n\nBeanserver blaster is a part of a Tetra Stats, that decoupled into a serverside script. It provides full Tetra League leaderboard, allowing Tetra Stats to sort leaderboard by any metric and build scatter chart, that allows user to analyse Tetra League trends. It also provides history of Tetra League ranks cutoffs, which can be viewed by user via graph as well.\n\nThere is a plans to add replay analysis and tournaments history, so stay tuned!\n\nService is not associated with TETR.IO or osk in any capacity.';
	String get appVersion => 'App Version';
	String build({required Object build}) => 'Build ${build}';
	String get GHrepo => 'GitHub Repository';
	String get submitAnIssue => 'Submit an issue';
	String get credits => 'Credits';
	String get authorAndDeveloper => 'Autor & developer';
	String get providedFormulas => 'Provided formulas';
	String get providedS1history => 'Provided S1 history';
	String get inoue => 'Inoue (replay grabber)';
	String get zhCNlocale => 'Simplfied Chinise locale';
	String get supportHim => 'Support him!';
}

// Path: stats
class _StringsStatsEn {
	_StringsStatsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get registrationDate => 'Registration Date';
	String get gametime => 'Time Played';
	String get ogp => 'Online Games Played';
	String get ogw => 'Online Games Won';
	String get followers => 'Followers';
	late final _StringsStatsXpEn xp = _StringsStatsXpEn._(_root);
	late final _StringsStatsTrEn tr = _StringsStatsTrEn._(_root);
	late final _StringsStatsGlickoEn glicko = _StringsStatsGlickoEn._(_root);
	late final _StringsStatsRdEn rd = _StringsStatsRdEn._(_root);
	late final _StringsStatsGlixareEn glixare = _StringsStatsGlixareEn._(_root);
	late final _StringsStatsS1trEn s1tr = _StringsStatsS1trEn._(_root);
	late final _StringsStatsGpEn gp = _StringsStatsGpEn._(_root);
	late final _StringsStatsGwEn gw = _StringsStatsGwEn._(_root);
	late final _StringsStatsWinrateEn winrate = _StringsStatsWinrateEn._(_root);
	late final _StringsStatsApmEn apm = _StringsStatsApmEn._(_root);
	late final _StringsStatsPpsEn pps = _StringsStatsPpsEn._(_root);
	late final _StringsStatsVsEn vs = _StringsStatsVsEn._(_root);
	late final _StringsStatsAppEn app = _StringsStatsAppEn._(_root);
	late final _StringsStatsVsapmEn vsapm = _StringsStatsVsapmEn._(_root);
	late final _StringsStatsDssEn dss = _StringsStatsDssEn._(_root);
	late final _StringsStatsDspEn dsp = _StringsStatsDspEn._(_root);
	late final _StringsStatsAppdspEn appdsp = _StringsStatsAppdspEn._(_root);
	late final _StringsStatsCheeseEn cheese = _StringsStatsCheeseEn._(_root);
	late final _StringsStatsGbeEn gbe = _StringsStatsGbeEn._(_root);
	late final _StringsStatsNyaappEn nyaapp = _StringsStatsNyaappEn._(_root);
	late final _StringsStatsAreaEn area = _StringsStatsAreaEn._(_root);
	late final _StringsStatsEtrEn etr = _StringsStatsEtrEn._(_root);
	late final _StringsStatsEtraccEn etracc = _StringsStatsEtraccEn._(_root);
	late final _StringsStatsOpenerEn opener = _StringsStatsOpenerEn._(_root);
	late final _StringsStatsPlonkEn plonk = _StringsStatsPlonkEn._(_root);
	late final _StringsStatsStrideEn stride = _StringsStatsStrideEn._(_root);
	late final _StringsStatsInfdsEn infds = _StringsStatsInfdsEn._(_root);
	late final _StringsStatsAltitudeEn altitude = _StringsStatsAltitudeEn._(_root);
	late final _StringsStatsClimbSpeedEn climbSpeed = _StringsStatsClimbSpeedEn._(_root);
	late final _StringsStatsPeakClimbSpeedEn peakClimbSpeed = _StringsStatsPeakClimbSpeedEn._(_root);
	late final _StringsStatsKosEn kos = _StringsStatsKosEn._(_root);
	late final _StringsStatsB2bEn b2b = _StringsStatsB2bEn._(_root);
	late final _StringsStatsFinesseEn finesse = _StringsStatsFinesseEn._(_root);
	late final _StringsStatsFinesseFaultsEn finesseFaults = _StringsStatsFinesseFaultsEn._(_root);
	late final _StringsStatsTotalTimeEn totalTime = _StringsStatsTotalTimeEn._(_root);
	late final _StringsStatsLevelEn level = _StringsStatsLevelEn._(_root);
	late final _StringsStatsPiecesEn pieces = _StringsStatsPiecesEn._(_root);
	late final _StringsStatsSppEn spp = _StringsStatsSppEn._(_root);
	late final _StringsStatsKpEn kp = _StringsStatsKpEn._(_root);
	late final _StringsStatsKppEn kpp = _StringsStatsKppEn._(_root);
	late final _StringsStatsKpsEn kps = _StringsStatsKpsEn._(_root);
	String blitzScore({required Object p}) => '${p} points';
	String levelUpRequirement({required Object p}) => 'Level up requirement: ${p}';
	String get piecesTotal => 'Total pieces placed';
	String get piecesWithPerfectFinesse => 'Placed with perfect finesse';
	String get score => 'Score';
	String get lines => 'Lines';
	String get linesShort => 'L';
	String get pcs => 'Perfect Clears';
	String get holds => 'Holds';
	String get spike => 'Top Spike';
	String top({required Object percentage}) => 'Top ${percentage}';
	String topRank({required Object rank}) => 'Top rank: ${rank}';
	String get floor => 'Floor';
	String get split => 'Split';
	String get total => 'Total';
	String get sent => 'Sent';
	String get received => 'Received';
	String get placement => 'Placement';
	String get peak => 'Peak';
	String qpWithMods({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'With 1 mod',
		two: 'With ${n} mods',
		few: 'With ${n} mods',
		many: 'With ${n} mods',
		other: 'With ${n} mods',
	);
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
	String linesCleared({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '${n} lines cleared',
		one: '${n} line cleared',
		two: '${n} lines cleared',
		few: '${n} lines cleared',
		many: '${n} lines cleared',
		other: '${n} lines cleared',
	);
	late final _StringsStatsGraphsEn graphs = _StringsStatsGraphsEn._(_root);
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
	late final _StringsStatsLineClearEn lineClear = _StringsStatsLineClearEn._(_root);
	late final _StringsStatsLineClearsEn lineClears = _StringsStatsLineClearsEn._(_root);
	String get mini => 'Mini';
	String get tSpin => 'T-spin';
	String get tSpins => 'T-spins';
	String get spin => 'Spin';
	String get spins => 'Spins';
}

// Path: stats.xp
class _StringsStatsXpEn {
	_StringsStatsXpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'XP';
	String get full => 'Experience Points';
}

// Path: stats.tr
class _StringsStatsTrEn {
	_StringsStatsTrEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'TR';
	String get full => 'Tetra Rating';
}

// Path: stats.glicko
class _StringsStatsGlickoEn {
	_StringsStatsGlickoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Glicko';
	String get full => 'Glicko';
}

// Path: stats.rd
class _StringsStatsRdEn {
	_StringsStatsRdEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'RD';
	String get full => 'Rating Deviation';
}

// Path: stats.glixare
class _StringsStatsGlixareEn {
	_StringsStatsGlixareEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'GXE';
	String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _StringsStatsS1trEn {
	_StringsStatsS1trEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'S1 TR';
	String get full => 'Season 1 like TR';
}

// Path: stats.gp
class _StringsStatsGpEn {
	_StringsStatsGpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'GP';
	String get full => 'Games Played';
}

// Path: stats.gw
class _StringsStatsGwEn {
	_StringsStatsGwEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'GW';
	String get full => 'Games Won';
}

// Path: stats.winrate
class _StringsStatsWinrateEn {
	_StringsStatsWinrateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'WR%';
	String get full => 'Win Rate';
}

// Path: stats.apm
class _StringsStatsApmEn {
	_StringsStatsApmEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'APM';
	String get full => 'Attack Per Minute';
}

// Path: stats.pps
class _StringsStatsPpsEn {
	_StringsStatsPpsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'PPS';
	String get full => 'Pieces Per Second';
}

// Path: stats.vs
class _StringsStatsVsEn {
	_StringsStatsVsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'VS';
	String get full => 'Versus Score';
}

// Path: stats.app
class _StringsStatsAppEn {
	_StringsStatsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'APP';
	String get full => 'Attack Per Piece';
}

// Path: stats.vsapm
class _StringsStatsVsapmEn {
	_StringsStatsVsapmEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'VS/APM';
	String get full => 'VS / APM';
}

// Path: stats.dss
class _StringsStatsDssEn {
	_StringsStatsDssEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'DS/S';
	String get full => 'Downstack Per Second';
}

// Path: stats.dsp
class _StringsStatsDspEn {
	_StringsStatsDspEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'DS/P';
	String get full => 'Downstack Per Piece';
}

// Path: stats.appdsp
class _StringsStatsAppdspEn {
	_StringsStatsAppdspEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'APP+DSP';
	String get full => 'APP + DSP';
}

// Path: stats.cheese
class _StringsStatsCheeseEn {
	_StringsStatsCheeseEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Cheese';
	String get full => 'Cheese Index';
}

// Path: stats.gbe
class _StringsStatsGbeEn {
	_StringsStatsGbeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'GbE';
	String get full => 'Garbage Efficiency';
}

// Path: stats.nyaapp
class _StringsStatsNyaappEn {
	_StringsStatsNyaappEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'wAPP';
	String get full => 'Weigente APP';
}

// Path: stats.area
class _StringsStatsAreaEn {
	_StringsStatsAreaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Area';
	String get full => 'Area';
}

// Path: stats.etr
class _StringsStatsEtrEn {
	_StringsStatsEtrEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'eTR';
	String get full => 'Estimated TR';
}

// Path: stats.etracc
class _StringsStatsEtraccEn {
	_StringsStatsEtraccEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => '±eTR';
	String get full => 'Accuracy of Estimated TR';
}

// Path: stats.opener
class _StringsStatsOpenerEn {
	_StringsStatsOpenerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Opener';
	String get full => 'Opener';
}

// Path: stats.plonk
class _StringsStatsPlonkEn {
	_StringsStatsPlonkEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Plonk';
	String get full => 'Plonk';
}

// Path: stats.stride
class _StringsStatsStrideEn {
	_StringsStatsStrideEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Stride';
	String get full => 'Stride';
}

// Path: stats.infds
class _StringsStatsInfdsEn {
	_StringsStatsInfdsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Inf. DS';
	String get full => 'Infinite Downstack';
}

// Path: stats.altitude
class _StringsStatsAltitudeEn {
	_StringsStatsAltitudeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'm';
	String get full => 'Altitude';
}

// Path: stats.climbSpeed
class _StringsStatsClimbSpeedEn {
	_StringsStatsClimbSpeedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'CSP';
	String get full => 'Climb Speed';
	String get gaugetTitle => 'Climb\nSpeed';
}

// Path: stats.peakClimbSpeed
class _StringsStatsPeakClimbSpeedEn {
	_StringsStatsPeakClimbSpeedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Peak CSP';
	String get full => 'Peak Climb Speed';
	String get gaugetTitle => 'Peak';
}

// Path: stats.kos
class _StringsStatsKosEn {
	_StringsStatsKosEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'KO\'s';
	String get full => 'Knockouts';
}

// Path: stats.b2b
class _StringsStatsB2bEn {
	_StringsStatsB2bEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'B2B';
	String get full => 'Back-To-Back';
}

// Path: stats.finesse
class _StringsStatsFinesseEn {
	_StringsStatsFinesseEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'F';
	String get full => 'Finesse';
	String get widgetTitle => 'inesse';
}

// Path: stats.finesseFaults
class _StringsStatsFinesseFaultsEn {
	_StringsStatsFinesseFaultsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'FF';
	String get full => 'Finesse Faults';
}

// Path: stats.totalTime
class _StringsStatsTotalTimeEn {
	_StringsStatsTotalTimeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Time';
	String get full => 'Total Time';
	String get widgetTitle => 'otal Time';
}

// Path: stats.level
class _StringsStatsLevelEn {
	_StringsStatsLevelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'Lvl';
	String get full => 'Level';
}

// Path: stats.pieces
class _StringsStatsPiecesEn {
	_StringsStatsPiecesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'P';
	String get full => 'Pieces';
}

// Path: stats.spp
class _StringsStatsSppEn {
	_StringsStatsSppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'SPP';
	String get full => 'Score Per Piece';
}

// Path: stats.kp
class _StringsStatsKpEn {
	_StringsStatsKpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'KP';
	String get full => 'Key presses';
}

// Path: stats.kpp
class _StringsStatsKppEn {
	_StringsStatsKppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'KPP';
	String get full => 'Key presses Per Piece';
}

// Path: stats.kps
class _StringsStatsKpsEn {
	_StringsStatsKpsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get short => 'KPS';
	String get full => 'Key presses Per Second';
}

// Path: stats.graphs
class _StringsStatsGraphsEn {
	_StringsStatsGraphsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get attack => 'Attack';
	String get speed => 'Speed';
	String get defense => 'Defense';
	String get cheese => 'Cheese';
}

// Path: stats.lineClear
class _StringsStatsLineClearEn {
	_StringsStatsLineClearEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get single => 'Single';
	String get double => 'Double';
	String get triple => 'Triple';
	String get quad => 'Quad';
	String get penta => 'Penta';
	String get hexa => 'Hexa';
	String get hepta => 'Hepta';
	String get octa => 'Octa';
	String get ennea => 'Ennea';
	String get deca => 'Deca';
	String get hendeca => 'Hendeca';
	String get dodeca => 'Dodeca';
	String get triadeca => 'Triadeca';
	String get tessaradeca => 'Tessaradeca';
	String get pentedeca => 'Pentedeca';
	String get hexadeca => 'Hexadeca';
	String get heptadeca => 'Heptadeca';
	String get octadeca => 'Octadeca';
	String get enneadeca => 'Enneadeca';
	String get eicosa => 'Eicosa';
	String get kagaris => 'Kagaris';
}

// Path: stats.lineClears
class _StringsStatsLineClearsEn {
	_StringsStatsLineClearsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get zero => 'Zeros';
	String get single => 'Singles';
	String get double => 'Doubles';
	String get triple => 'Triples';
	String get quad => 'Quads';
	String get penta => 'Pentas';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'English';
			case 'locales.ru': return 'Russian (Русский)';
			case 'locales.zh-CN': return 'Simplified Chinese (简体中文)';
			case 'gamemodes.league': return 'Tetra League';
			case 'gamemodes.zenith': return 'Quick Play';
			case 'gamemodes.zenithex': return 'Quick Play Expert';
			case 'gamemodes.40l': return '40 Lines';
			case 'gamemodes.blitz': return 'Blitz';
			case 'gamemodes.5mblast': return '5,000,000 Blast';
			case 'gamemodes.zen': return 'Zen';
			case 'destinations.home': return 'Home';
			case 'destinations.graphs': return 'Graphs';
			case 'destinations.leaderboards': return 'Leaderboards';
			case 'destinations.cutoffs': return 'Cutoffs';
			case 'destinations.calc': return 'Calculator';
			case 'destinations.info': return 'Info Center';
			case 'destinations.data': return 'Saved Data';
			case 'destinations.settings': return 'Settings';
			case 'goBackButton': return 'Go Back';
			case 'nanow': return 'Not avaliable for now...';
			case 'seasonEnds': return ({required Object countdown}) => 'Season ends in ${countdown}';
			case 'seasonEnded': return 'Season has ended';
			case 'overallPB': return ({required Object pb}) => 'Overall PB: ${pb}';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} games until being ranked';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} victories';
			case 'promotionOnNextWin': return 'Promotion on next win';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} defeats';
			case 'demotionOnNextLoss': return 'Demotion on next loss';
			case 'records': return 'Records';
			case 'nerdStats': return 'Nerd Stats';
			case 'playstyles': return 'Playstyles';
			case 'horoscopes': return 'Horoscopes';
			case 'season': return 'Season';
			case 'smooth': return 'Smooth';
			case 'dateAndTime': return 'Date & Time';
			case 'TLfullLBnote': return 'Heavy, but allows you to sort players by their stats and filter them by ranks';
			case 'rank': return 'Rank';
			case 'verdictGeneral': return ({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} of ${rank} rank avg';
			case 'verdictBetter': return 'ahead';
			case 'verdictWorse': return 'behind';
			case 'localStanding': return 'local';
			case 'xp.title': return 'XP Level';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => 'Progress to next level: ${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => 'Progress from 0 XP to level ${goal}: ${percentage} (${left} XP left)';
			case 'gametime.title': return 'Exact gametime';
			case 'gametime.gametimeAday': return ({required Object gametime}) => '${gametime} a day in average';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'It\'s ${years} years,\nor ${months} months,\nor ${days} days,\nor ${minutes} minutes\nor ${seconds} seconds';
			case 'track': return 'Track';
			case 'stopTracking': return 'Stop tracking';
			case 'supporter': return ({required Object tier}) => 'Supporter tier ${tier}';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => 'Data from ${newDate} comparing with ${oldDate}';
			case 'compare': return 'Compare';
			case 'comparison': return 'Comparison';
			case 'general': return 'General';
			case 'badges': return 'Badges';
			case 'obtainDate': return ({required Object date}) => 'Obtained ${date}';
			case 'assignedManualy': return 'That badge was assigned manualy by TETR.IO admins';
			case 'distinguishment': return 'Distinguishment';
			case 'banned': return 'Banned';
			case 'bannedSubtext': return 'Bans are placed when TETR.IO rules or terms of service are broken';
			case 'badStanding': return 'Bad standing';
			case 'badStandingSubtext': return 'One or more recent bans on record';
			case 'botAccount': return 'Bot account';
			case 'botAccountSubtext': return ({required Object botMaintainers}) => 'Operated by ${botMaintainers}';
			case 'copiedToClipboard': return 'Copied to clipboard!';
			case 'bio': return 'Bio';
			case 'news': return 'News';
			case 'matchResult.victory': return 'Victory';
			case 'matchResult.defeat': return 'Defeat';
			case 'matchResult.tie': return 'Tie';
			case 'matchResult.dqvictory': return 'Opponent was DQ\'ed';
			case 'matchResult.dqdefeat': return 'Disqualified';
			case 'matchResult.nocontest': return 'No Contest';
			case 'matchResult.nullified': return 'Nullified';
			case 'distinguishments.noHeader': return 'Header is missing';
			case 'distinguishments.noFooter': return 'Footer is missing';
			case 'distinguishments.twc': return 'TETR.IO World Champion';
			case 'distinguishments.twcYear': return ({required Object year}) => '${year} TETR.IO World Championship';
			case 'newsEntries.leaderboard': return ({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
				const TextSpan(text: 'Got № '),
				rank,
				const TextSpan(text: ' in '),
				gametype,
			]);
			case 'newsEntries.personalbest': return ({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
				const TextSpan(text: 'Got a new PB in '),
				gametype,
				const TextSpan(text: ' of '),
				pb,
			]);
			case 'newsEntries.badge': return ({required InlineSpan badge}) => TextSpan(children: [
				const TextSpan(text: 'Obtained a '),
				badge,
				const TextSpan(text: ' badge'),
			]);
			case 'newsEntries.rankup': return ({required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: 'Obtained '),
				rank,
				const TextSpan(text: ' in Tetra League'),
			]);
			case 'newsEntries.supporter': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Became a '),
				s('TETR.IO supporter'),
			]);
			case 'newsEntries.supporter_gift': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Received the gift of '),
				s('TETR.IO supporter'),
			]);
			case 'newsEntries.unknown': return ({required InlineSpan type}) => TextSpan(children: [
				const TextSpan(text: 'Unknown news of type '),
				type,
			]);
			case 'rankupMiddle': return ({required Object r}) => '${r} rank';
			case 'copyUserID': return 'Click to copy user ID';
			case 'searchHint': return 'Username or ID';
			case 'navMenu': return 'Navigation menu';
			case 'navMenuTooltip': return 'Open navigation menu';
			case 'refresh': return 'Refresh data';
			case 'searchButton': return 'Search';
			case 'trackedPlayers': return 'Tracked Players';
			case 'standing': return 'Standing';
			case 'previousSeasons': return 'Previous Seasons';
			case 'recent': return 'Recent';
			case 'top': return 'Top';
			case 'noRecord': return 'No record';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => 'Relevance: ${date}';
			case 'snackBarMessages.stateRemoved': return ({required Object date}) => '${date} state was removed from database!';
			case 'snackBarMessages.matchRemoved': return ({required Object date}) => '${date} match was removed from database!';
			case 'snackBarMessages.notForWeb': return 'Function is not available for web version';
			case 'snackBarMessages.importSuccess': return 'Import successful';
			case 'snackBarMessages.importCancelled': return 'Import was cancelled';
			case 'errors.noRecords': return 'No records';
			case 'errors.notEnoughData': return 'Not enough data';
			case 'errors.noHistorySaved': return 'No history saved';
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
			case 'actions.cancel': return 'Cancel';
			case 'actions.submit': return 'Submit';
			case 'actions.ok': return 'OK';
			case 'actions.apply': return 'Apply';
			case 'actions.refresh': return 'Refresh';
			case 'graphsDestination.fetchAndsaveTLHistory': return 'Get player history';
			case 'graphsDestination.fetchAndSaveOldTLmatches': return 'Get Tetra League matches history';
			case 'graphsDestination.fetchAndsaveTLHistoryResult': return ({required Object number}) => '${number} states was found';
			case 'graphsDestination.fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '${number} matches was found';
			case 'graphsDestination.gamesPlayed': return ({required Object games}) => '${games} played';
			case 'graphsDestination.dateAndTime': return 'Date & Time';
			case 'graphsDestination.filterModaleTitle': return 'Filter ranks on graph';
			case 'filterModale.all': return 'All';
			case 'cutoffsDestination.title': return 'Tetra League State';
			case 'cutoffsDestination.relevance': return ({required Object timestamp}) => 'as of ${timestamp}';
			case 'cutoffsDestination.actual': return 'Actual';
			case 'cutoffsDestination.target': return 'Target';
			case 'cutoffsDestination.cutoffTR': return 'Cutoff TR';
			case 'cutoffsDestination.targetTR': return 'Target TR';
			case 'cutoffsDestination.state': return 'State';
			case 'cutoffsDestination.advanced': return 'Advanced';
			case 'cutoffsDestination.players': return ({required Object n}) => 'Players (${n})';
			case 'cutoffsDestination.moreInfo': return 'More Info';
			case 'cutoffsDestination.NumberOne': return ({required Object tr}) => '№ 1 is ${tr} TR';
			case 'cutoffsDestination.inflated': return ({required Object tr}) => 'Inflated on ${tr} TR';
			case 'cutoffsDestination.notInflated': return 'Not inflated';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => 'Deflated on ${tr} TR';
			case 'cutoffsDestination.notDeflated': return 'Not deflated';
			case 'cutoffsDestination.wellDotDotDot': return 'Well...';
			case 'cutoffsDestination.fromPlace': return ({required Object n}) => 'from № ${n}';
			case 'cutoffsDestination.viewButton': return 'View';
			case 'rankView.rankTitle': return ({required Object rank}) => '${rank} rank data';
			case 'rankView.everyoneTitle': return 'Entire leaderboard';
			case 'rankView.trRange': return 'TR Range';
			case 'rankView.supposedToBe': return 'Supposed to be';
			case 'rankView.gap': return ({required Object value}) => '${value} gap';
			case 'rankView.trGap': return ({required Object value}) => '${value} TR gap';
			case 'rankView.deflationGap': return 'Deflation gap';
			case 'rankView.inflationGap': return 'Inflation gap';
			case 'rankView.LBposRange': return 'LB pos range';
			case 'rankView.overpopulated': return ({required Object players}) => 'Overpopulated by a ${players}';
			case 'rankView.underpopulated': return ({required Object players}) => 'Underpopulated by a ${players}';
			case 'rankView.PlayersEqualSupposedToBe': return 'cute';
			case 'rankView.avgStats': return 'Average Stats';
			case 'rankView.avgNerdStats': return 'Average Nerd Stats';
			case 'rankView.minimums': return 'Minimums';
			case 'rankView.maximums': return 'Maximums';
			case 'stateView.title': return ({required Object date}) => 'State from ${date}';
			case 'tlMatchView.match': return 'Match';
			case 'tlMatchView.vs': return 'vs';
			case 'tlMatchView.winner': return 'Winner';
			case 'tlMatchView.roundNumber': return ({required Object n}) => 'Round ${n}';
			case 'tlMatchView.statsFor': return 'Stats for';
			case 'tlMatchView.numberOfRounds': return 'Number of rounds';
			case 'tlMatchView.matchLength': return 'Match Length';
			case 'tlMatchView.roundLength': return 'Round Length';
			case 'tlMatchView.matchStats': return 'Match stats';
			case 'tlMatchView.downloadReplay': return 'Download .ttrm replay';
			case 'tlMatchView.openReplay': return 'Open replay in TETR.IO';
			case 'calcDestination.tip': return 'Enter values and press "Calc" to see Nerd Stats for them';
			case 'calcDestination.statsCalcButton': return 'Calc';
			case 'calcDestination.damageCalcTip': return 'Click on the actions on the left to add them here';
			case 'calcDestination.actions': return 'Actions';
			case 'calcDestination.results': return 'Results';
			case 'calcDestination.rules': return 'Rules';
			case 'calcDestination.noSpinClears': return 'No Spin Clears';
			case 'calcDestination.spins': return 'Spins';
			case 'calcDestination.miniSpins': return 'Mini spins';
			case 'calcDestination.noLineclear': return 'No lineclear (Break Combo)';
			case 'calcDestination.custom': return 'Custom';
			case 'calcDestination.multiplier': return 'Multiplier';
			case 'calcDestination.pcDamage': return 'Perfect Clear Damage';
			case 'calcDestination.comboTable': return 'Combo Table';
			case 'calcDestination.b2bChaining': return 'Back-To-Back Chaining';
			case 'calcDestination.surgeStartAtB2B': return 'Starts at B2B';
			case 'calcDestination.surgeStartAmount': return 'Start amount';
			case 'calcDestination.totalDamage': return 'Total damage';
			case 'calcDestination.lineclears': return 'Lineclears';
			case 'calcDestination.combo': return 'Combo';
			case 'calcDestination.surge': return 'Surge';
			case 'calcDestination.pcs': return 'PCs';
			case 'infoDestination.title': return 'Information Center';
			case 'infoDestination.sprintAndBlitzAverages': return '40 Lines & Blitz Averages';
			case 'infoDestination.sprintAndBlitzAveragesDescription': return 'Since calculating 40 Lines & Blitz averages is tedious process, it gets updated only once in a while. Click on the title of this card to see the full 40 Lines & Blitz averages table';
			case 'infoDestination.tetraStatsWiki': return 'Tetra Stats Wiki';
			case 'infoDestination.tetraStatsWikiDescription': return 'Find more information about Tetra Stats functions and statictic, that it provides';
			case 'infoDestination.about': return 'About Tetra Stats';
			case 'infoDestination.aboutDescription': return 'Developed by dan63\n';
			case 'leaderboardsDestination.title': return 'Leaderboards';
			case 'leaderboardsDestination.tl': return 'Tetra League (Current Season)';
			case 'leaderboardsDestination.fullTL': return 'Tetra League (Current Season, full one)';
			case 'leaderboardsDestination.ar': return 'Acievement Points';
			case 'leaderboardsDestination.fullTLnote': return 'Heavy, but allows you to sort players by their stats and filter them by ranks';
			case 'savedDataDestination.title': return 'Saved Data';
			case 'savedDataDestination.tip': return 'Select nickname on the left to see data assosiated with it';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => 'S${s} TL States';
			case 'savedDataDestination.TLrecords': return 'TL Records';
			case 'settingsDestination.title': return 'Settings';
			case 'settingsDestination.general': return 'General';
			case 'settingsDestination.customization': return 'Custonization';
			case 'settingsDestination.database': return 'Local database';
			case 'settingsDestination.checking': return 'Checking...';
			case 'settingsDestination.enterToSubmit': return 'Press Enter to submit';
			case 'settingsDestination.account': return 'Your account in TETR.IO';
			case 'settingsDestination.accountDescription': return 'Stats of that player will be loaded initially right after launching this app. By default it loads my (dan63) stats. To change that, enter your nickname here.';
			case 'settingsDestination.done': return 'Done!';
			case 'settingsDestination.noSuchAccount': return 'No such account';
			case 'settingsDestination.language': return 'Language';
			case 'settingsDestination.languageDescription': return ({required Object languages}) => 'Tetra Stats was translated on ${languages}. By default, app will pick your system one or English, if locale of your system isn\'t avaliable.';
			case 'settingsDestination.languages': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: 'zero languages',
				one: '${n} language',
				two: '${n} languages',
				few: '${n} languages',
				many: '${n} languages',
				other: '${n} languages',
			);
			case 'settingsDestination.updateInTheBackground': return 'Update data in the background';
			case 'settingsDestination.updateInTheBackgroundDescription': return 'If on, Tetra Stats will attempt to retrieve new info once cache expires. Usually that happen every 5 minutes';
			case 'settingsDestination.compareStats': return 'Compare TL stats with rank averages';
			case 'settingsDestination.compareStatsDescription': return 'If on, Tetra Stats will provide additional metrics, which allow you to compare yourself with average player on your rank. The way you\'ll see it — stats will be highlited with corresponding color, hover over them with cursor for more info.';
			case 'settingsDestination.showPosition': return 'Show position on leaderboard by stats';
			case 'settingsDestination.showPositionDescription': return 'This can take some time (and traffic) to load, but will allow you to see your position on the leaderboard, sorted by a stat';
			case 'settingsDestination.accentColor': return 'Accent color';
			case 'settingsDestination.accentColorDescription': return 'That color is seen across this app and usually highlites interactive UI elements.';
			case 'settingsDestination.accentColorModale': return 'Pick an accent color';
			case 'settingsDestination.timestamps': return 'Timestamps format';
			case 'settingsDestination.timestampsDescriptionPart1': return ({required Object d}) => 'You can choose, in which way timestamps shows time. By default, they show time in GMT timezone, formatted according to chosen locale, example: ${d}.';
			case 'settingsDestination.timestampsDescriptionPart2': return ({required Object y, required Object r}) => 'There is also:\n• Locale formatted in your timezone: ${y}\n• Relative timestamp: ${r}';
			case 'settingsDestination.timestampsAbsoluteGMT': return 'Absolute (GMT)';
			case 'settingsDestination.timestampsAbsoluteLocalTime': return 'Absolute (Your timezone)';
			case 'settingsDestination.timestampsRelative': return 'Relative';
			case 'settingsDestination.sheetbotLikeGraphs': return 'Sheetbot-like behavior for radar graphs';
			case 'settingsDestination.sheetbotLikeGraphsDescription': return 'Altough it was considered by me, that the way graphs work in SheetBot is not very correct, some people were confused to see, that -0.5 stride dosen\'t look the way it looks on SheetBot graph. Hence, he we are: if this toggle is on, points on the graphs can appear on the opposite half of the graph if value is negative.';
			case 'settingsDestination.oskKagariGimmick': return 'Osk-Kagari gimmick';
			case 'settingsDestination.oskKagariGimmickDescription': return 'If on, instead of osk\'s rank, :kagari: will be rendered.';
			case 'settingsDestination.bytesOfDataStored': return 'of data stored';
			case 'settingsDestination.TLrecordsSaved': return 'Tetra League records saved';
			case 'settingsDestination.TLplayerstatesSaved': return 'Tetra League playerstates saved';
			case 'settingsDestination.fixButton': return 'Fix';
			case 'settingsDestination.compressButton': return 'Compress';
			case 'settingsDestination.exportDB': return 'Export local database';
			case 'settingsDestination.desktopExportAlertTitle': return 'Desktop export';
			case 'settingsDestination.desktopExportText': return 'It seems like you using this app on desktop. Check your documents folder, you should find "TetraStats.db". Copy it somewhere';
			case 'settingsDestination.androidExportAlertTitle': return 'Android export';
			case 'settingsDestination.androidExportText': return ({required Object exportedDB}) => 'Exported.\n${exportedDB}';
			case 'settingsDestination.importDB': return 'Import local database';
			case 'settingsDestination.importDBDescription': return 'Restore your backup. Notice that already stored database will be overwritten.';
			case 'settingsDestination.importWrongFileType': return 'Wrong file type';
			case 'homeNavigation.overview': return 'Overview';
			case 'homeNavigation.standing': return 'Standing';
			case 'homeNavigation.seasons': return 'Seasons';
			case 'homeNavigation.mathces': return 'Matches';
			case 'homeNavigation.pb': return 'PB';
			case 'homeNavigation.normal': return 'Normal';
			case 'homeNavigation.expert': return 'Expert';
			case 'homeNavigation.expertRecords': return 'Ex Records';
			case 'graphsNavigation.history': return 'Player History';
			case 'graphsNavigation.league': return 'League State';
			case 'graphsNavigation.cutoffs': return 'Cutoffs History';
			case 'calcNavigation.stats': return 'Stats Calculator';
			case 'calcNavigation.damage': return 'Damage Calculator';
			case 'firstTimeView.welcome': return 'Welcome to Tetra Stats';
			case 'firstTimeView.description': return 'Service, that allows you to keep track of various statistics for TETR.IO';
			case 'firstTimeView.nicknameQuestion': return 'What\'s your nickname?';
			case 'firstTimeView.inpuntHint': return 'Type it here... (3-16 symbols)';
			case 'aboutView.title': return 'About Tetra Stats';
			case 'aboutView.about': return 'Tetra Stats is a service, that works with TETR.IO Tetra Channel API, providing data from it and calculating some addtitional metrics, based on this data. Service allows user to track their progress in Tetra League with "Track" function, which records every Tetra League change into local database (not automatically, you have to visit service from time to time), so these changes could be looked through graphs.\n\nBeanserver blaster is a part of a Tetra Stats, that decoupled into a serverside script. It provides full Tetra League leaderboard, allowing Tetra Stats to sort leaderboard by any metric and build scatter chart, that allows user to analyse Tetra League trends. It also provides history of Tetra League ranks cutoffs, which can be viewed by user via graph as well.\n\nThere is a plans to add replay analysis and tournaments history, so stay tuned!\n\nService is not associated with TETR.IO or osk in any capacity.';
			case 'aboutView.appVersion': return 'App Version';
			case 'aboutView.build': return ({required Object build}) => 'Build ${build}';
			case 'aboutView.GHrepo': return 'GitHub Repository';
			case 'aboutView.submitAnIssue': return 'Submit an issue';
			case 'aboutView.credits': return 'Credits';
			case 'aboutView.authorAndDeveloper': return 'Autor & developer';
			case 'aboutView.providedFormulas': return 'Provided formulas';
			case 'aboutView.providedS1history': return 'Provided S1 history';
			case 'aboutView.inoue': return 'Inoue (replay grabber)';
			case 'aboutView.zhCNlocale': return 'Simplfied Chinise locale';
			case 'aboutView.supportHim': return 'Support him!';
			case 'stats.registrationDate': return 'Registration Date';
			case 'stats.gametime': return 'Time Played';
			case 'stats.ogp': return 'Online Games Played';
			case 'stats.ogw': return 'Online Games Won';
			case 'stats.followers': return 'Followers';
			case 'stats.xp.short': return 'XP';
			case 'stats.xp.full': return 'Experience Points';
			case 'stats.tr.short': return 'TR';
			case 'stats.tr.full': return 'Tetra Rating';
			case 'stats.glicko.short': return 'Glicko';
			case 'stats.glicko.full': return 'Glicko';
			case 'stats.rd.short': return 'RD';
			case 'stats.rd.full': return 'Rating Deviation';
			case 'stats.glixare.short': return 'GXE';
			case 'stats.glixare.full': return 'GLIXARE';
			case 'stats.s1tr.short': return 'S1 TR';
			case 'stats.s1tr.full': return 'Season 1 like TR';
			case 'stats.gp.short': return 'GP';
			case 'stats.gp.full': return 'Games Played';
			case 'stats.gw.short': return 'GW';
			case 'stats.gw.full': return 'Games Won';
			case 'stats.winrate.short': return 'WR%';
			case 'stats.winrate.full': return 'Win Rate';
			case 'stats.apm.short': return 'APM';
			case 'stats.apm.full': return 'Attack Per Minute';
			case 'stats.pps.short': return 'PPS';
			case 'stats.pps.full': return 'Pieces Per Second';
			case 'stats.vs.short': return 'VS';
			case 'stats.vs.full': return 'Versus Score';
			case 'stats.app.short': return 'APP';
			case 'stats.app.full': return 'Attack Per Piece';
			case 'stats.vsapm.short': return 'VS/APM';
			case 'stats.vsapm.full': return 'VS / APM';
			case 'stats.dss.short': return 'DS/S';
			case 'stats.dss.full': return 'Downstack Per Second';
			case 'stats.dsp.short': return 'DS/P';
			case 'stats.dsp.full': return 'Downstack Per Piece';
			case 'stats.appdsp.short': return 'APP+DSP';
			case 'stats.appdsp.full': return 'APP + DSP';
			case 'stats.cheese.short': return 'Cheese';
			case 'stats.cheese.full': return 'Cheese Index';
			case 'stats.gbe.short': return 'GbE';
			case 'stats.gbe.full': return 'Garbage Efficiency';
			case 'stats.nyaapp.short': return 'wAPP';
			case 'stats.nyaapp.full': return 'Weigente APP';
			case 'stats.area.short': return 'Area';
			case 'stats.area.full': return 'Area';
			case 'stats.etr.short': return 'eTR';
			case 'stats.etr.full': return 'Estimated TR';
			case 'stats.etracc.short': return '±eTR';
			case 'stats.etracc.full': return 'Accuracy of Estimated TR';
			case 'stats.opener.short': return 'Opener';
			case 'stats.opener.full': return 'Opener';
			case 'stats.plonk.short': return 'Plonk';
			case 'stats.plonk.full': return 'Plonk';
			case 'stats.stride.short': return 'Stride';
			case 'stats.stride.full': return 'Stride';
			case 'stats.infds.short': return 'Inf. DS';
			case 'stats.infds.full': return 'Infinite Downstack';
			case 'stats.altitude.short': return 'm';
			case 'stats.altitude.full': return 'Altitude';
			case 'stats.climbSpeed.short': return 'CSP';
			case 'stats.climbSpeed.full': return 'Climb Speed';
			case 'stats.climbSpeed.gaugetTitle': return 'Climb\nSpeed';
			case 'stats.peakClimbSpeed.short': return 'Peak CSP';
			case 'stats.peakClimbSpeed.full': return 'Peak Climb Speed';
			case 'stats.peakClimbSpeed.gaugetTitle': return 'Peak';
			case 'stats.kos.short': return 'KO\'s';
			case 'stats.kos.full': return 'Knockouts';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return 'Back-To-Back';
			case 'stats.finesse.short': return 'F';
			case 'stats.finesse.full': return 'Finesse';
			case 'stats.finesse.widgetTitle': return 'inesse';
			case 'stats.finesseFaults.short': return 'FF';
			case 'stats.finesseFaults.full': return 'Finesse Faults';
			case 'stats.totalTime.short': return 'Time';
			case 'stats.totalTime.full': return 'Total Time';
			case 'stats.totalTime.widgetTitle': return 'otal Time';
			case 'stats.level.short': return 'Lvl';
			case 'stats.level.full': return 'Level';
			case 'stats.pieces.short': return 'P';
			case 'stats.pieces.full': return 'Pieces';
			case 'stats.spp.short': return 'SPP';
			case 'stats.spp.full': return 'Score Per Piece';
			case 'stats.kp.short': return 'KP';
			case 'stats.kp.full': return 'Key presses';
			case 'stats.kpp.short': return 'KPP';
			case 'stats.kpp.full': return 'Key presses Per Piece';
			case 'stats.kps.short': return 'KPS';
			case 'stats.kps.full': return 'Key presses Per Second';
			case 'stats.blitzScore': return ({required Object p}) => '${p} points';
			case 'stats.levelUpRequirement': return ({required Object p}) => 'Level up requirement: ${p}';
			case 'stats.piecesTotal': return 'Total pieces placed';
			case 'stats.piecesWithPerfectFinesse': return 'Placed with perfect finesse';
			case 'stats.score': return 'Score';
			case 'stats.lines': return 'Lines';
			case 'stats.linesShort': return 'L';
			case 'stats.pcs': return 'Perfect Clears';
			case 'stats.holds': return 'Holds';
			case 'stats.spike': return 'Top Spike';
			case 'stats.top': return ({required Object percentage}) => 'Top ${percentage}';
			case 'stats.topRank': return ({required Object rank}) => 'Top rank: ${rank}';
			case 'stats.floor': return 'Floor';
			case 'stats.split': return 'Split';
			case 'stats.total': return 'Total';
			case 'stats.sent': return 'Sent';
			case 'stats.received': return 'Received';
			case 'stats.placement': return 'Placement';
			case 'stats.peak': return 'Peak';
			case 'stats.qpWithMods': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				one: 'With 1 mod',
				two: 'With ${n} mods',
				few: 'With ${n} mods',
				many: 'With ${n} mods',
				other: 'With ${n} mods',
			);
			case 'stats.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} key presses',
				one: '${n} key press',
				two: '${n} key presses',
				few: '${n} key presses',
				many: '${n} key presses',
				other: '${n} key presses',
			);
			case 'stats.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} T-spins total',
				one: '${n} T-spin total',
				two: '${n} T-spins total',
				few: '${n} T-spins total',
				many: '${n} T-spins total',
				other: '${n} T-spins total',
			);
			case 'stats.linesCleared': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} lines cleared',
				one: '${n} line cleared',
				two: '${n} lines cleared',
				few: '${n} lines cleared',
				many: '${n} lines cleared',
				other: '${n} lines cleared',
			);
			case 'stats.graphs.attack': return 'Attack';
			case 'stats.graphs.speed': return 'Speed';
			case 'stats.graphs.defense': return 'Defense';
			case 'stats.graphs.cheese': return 'Cheese';
			case 'stats.players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} players',
				one: '${n} player',
				two: '${n} players',
				few: '${n} players',
				many: '${n} players',
				other: '${n} players',
			);
			case 'stats.games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: '${n} games',
				one: '${n} game',
				two: '${n} games',
				few: '${n} games',
				many: '${n} games',
				other: '${n} games',
			);
			case 'stats.lineClear.single': return 'Single';
			case 'stats.lineClear.double': return 'Double';
			case 'stats.lineClear.triple': return 'Triple';
			case 'stats.lineClear.quad': return 'Quad';
			case 'stats.lineClear.penta': return 'Penta';
			case 'stats.lineClear.hexa': return 'Hexa';
			case 'stats.lineClear.hepta': return 'Hepta';
			case 'stats.lineClear.octa': return 'Octa';
			case 'stats.lineClear.ennea': return 'Ennea';
			case 'stats.lineClear.deca': return 'Deca';
			case 'stats.lineClear.hendeca': return 'Hendeca';
			case 'stats.lineClear.dodeca': return 'Dodeca';
			case 'stats.lineClear.triadeca': return 'Triadeca';
			case 'stats.lineClear.tessaradeca': return 'Tessaradeca';
			case 'stats.lineClear.pentedeca': return 'Pentedeca';
			case 'stats.lineClear.hexadeca': return 'Hexadeca';
			case 'stats.lineClear.heptadeca': return 'Heptadeca';
			case 'stats.lineClear.octadeca': return 'Octadeca';
			case 'stats.lineClear.enneadeca': return 'Enneadeca';
			case 'stats.lineClear.eicosa': return 'Eicosa';
			case 'stats.lineClear.kagaris': return 'Kagaris';
			case 'stats.lineClears.zero': return 'Zeros';
			case 'stats.lineClears.single': return 'Singles';
			case 'stats.lineClears.double': return 'Doubles';
			case 'stats.lineClears.triple': return 'Triples';
			case 'stats.lineClears.quad': return 'Quads';
			case 'stats.lineClears.penta': return 'Pentas';
			case 'stats.mini': return 'Mini';
			case 'stats.tSpin': return 'T-spin';
			case 'stats.tSpins': return 'T-spins';
			case 'stats.spin': return 'Spin';
			case 'stats.spins': return 'Spins';
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
