/// Generated file. Do not edit.
///
/// Original: res/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 2295 (765 per locale)
///
/// Built on 2024-12-31 at 17:29 UTC

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
	ruRu(languageCode: 'ru', countryCode: 'RU', build: _StringsRuRu.build),
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
		'ru-RU': 'Russian (Русский)',
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
	String get goBackButton => 'Go Back';
	String get nanow => 'Not avaliable for now...';
	String seasonEnds({required Object countdown}) => 'Season ends in ${countdown}';
	String get seasonEnded => 'Season has ended';
	String overallPB({required Object pb}) => 'Overall PB: ${pb} m';
	String gamesUntilRanked({required Object left}) => '${left} games until being ranked';
	String numOfVictories({required Object wins}) => '~${wins} victories';
	String get promotionOnNextWin => 'Promotion on next win';
	String numOfdefeats({required Object losses}) => '~${losses} defeats';
	String get demotionOnNextLoss => 'Demotion on next loss';
	String get records => 'Records';
	String get nerdStats => 'Nerd Stats';
	String get playstyles => 'Playstyles';
	String get horoscopes => 'Horoscopes';
	String get relatedAchievements => 'Related Achievements';
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
	String get enterUsername => 'Enter username or \$avgX (where X is rank)';
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
	String avgForRank({required Object rank}) => 'Average for ${rank} rank';
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
	String placeholders({required Object stat}) => 'Enter your ${stat}';
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
	String get customization => 'Customization';
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
	String get emptyInputError => 'Can\'t submit an empty string';
	String niceToSeeYou({required Object n}) => 'Nice to see you, ${n}';
	String get letsTakeALook => 'Let\'s take a look at your stats...';
	String get skip => 'Skip';
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
	String get zhCNlocale => 'Simplfied Chinese locale';
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
	String get full => 'Weighted APP';
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

// Path: <root>
class _StringsRuRu implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsRuRu.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ruRu,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru-RU>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsRuRu _root = this; // ignore: unused_field

	// Translations
	@override Map<String, String> get locales => {
		'en': 'Английский (English)',
		'ru-RU': 'Русский',
		'zh-CN': 'Упрощенный Китайский (简体中文)',
	};
	@override Map<String, String> get gamemodes => {
		'league': 'Тетра Лига',
		'zenith': 'Quick Play',
		'zenithex': 'Quick Play Expert',
		'40l': '40 линий',
		'blitz': 'Блиц',
		'5mblast': '5 000 000 бласт',
		'zen': 'Дзен',
	};
	@override late final _StringsDestinationsRuRu destinations = _StringsDestinationsRuRu._(_root);
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
	@override String get goBackButton => 'Назад';
	@override String get nanow => 'Сейчас недоступно...';
	@override String seasonEnds({required Object countdown}) => 'Сезон закончится через ${countdown}';
	@override String get seasonEnded => 'Сезон завершён';
	@override String overallPB({required Object pb}) => 'Абсолютный рекорд: ${pb} м';
	@override String gamesUntilRanked({required Object left}) => '${left} матчей до получения рейтинга';
	@override String numOfVictories({required Object wins}) => '~${wins} побед';
	@override String get promotionOnNextWin => 'Повышение после следующей победы';
	@override String numOfdefeats({required Object losses}) => '~${losses} поражений';
	@override String get demotionOnNextLoss => 'Понижение после следующего поражения';
	@override String get records => 'Записи';
	@override String get nerdStats => 'Для Задротов';
	@override String get playstyles => 'Стили игры';
	@override String get horoscopes => 'Гороскопы';
	@override String get relatedAchievements => 'Достижения режима';
	@override String get season => 'Сезон';
	@override String get smooth => 'Сглаживание';
	@override String get dateAndTime => 'Дата и время';
	@override String get TLfullLBnote => 'Большая, но позволяет сортировать игроков по их статам и фильтровать их по рангам';
	@override String get rank => 'Ранг';
	@override String verdictGeneral({required Object n, required Object verdict, required Object rank}) => 'На ${n} ${verdict} среднего ${rank}';
	@override String get verdictBetter => 'впереди';
	@override String get verdictWorse => 'позади';
	@override String get localStanding => 'по стране';
	@override late final _StringsXpRuRu xp = _StringsXpRuRu._(_root);
	@override late final _StringsGametimeRuRu gametime = _StringsGametimeRuRu._(_root);
	@override String get track => 'Отслеживать';
	@override String get stopTracking => 'Не отслеживать';
	@override String supporter({required Object tier}) => 'Спонсор ${tier}-го уровня';
	@override String comparingWith({required Object newDate, required Object oldDate}) => 'Данные от ${newDate} в сравнении с данными от ${oldDate}';
	@override String get compare => 'Сравнить';
	@override String get comparison => 'Сравнение';
	@override String get enterUsername => 'Введите ник или \$avgX (где X это ранг)';
	@override String get general => 'Основное';
	@override String get badges => 'Значки';
	@override String obtainDate({required Object date}) => 'Получен ${date}';
	@override String get assignedManualy => 'Этот значок был присвоен вручную администрацией TETR.IO';
	@override String get distinguishment => 'Заслуга';
	@override String get banned => 'Забанен';
	@override String get bannedSubtext => 'Баны выдаются в случаях нарушений правил TETR.IO';
	@override String get badStanding => 'Плохая репутация';
	@override String get badStandingSubtext => 'Один или более банов на счету';
	@override String get botAccount => 'Бот аккаунт';
	@override String botAccountSubtext({required Object botMaintainers}) => 'Операторы: ${botMaintainers}';
	@override String get copiedToClipboard => 'Скопировано в буфер обмена!';
	@override String get bio => 'Биография';
	@override String get news => 'Новости';
	@override late final _StringsMatchResultRuRu matchResult = _StringsMatchResultRuRu._(_root);
	@override late final _StringsDistinguishmentsRuRu distinguishments = _StringsDistinguishmentsRuRu._(_root);
	@override late final _StringsNewsEntriesRuRu newsEntries = _StringsNewsEntriesRuRu._(_root);
	@override String rankupMiddle({required Object r}) => '${r} ранг';
	@override String get copyUserID => 'Нажмите, чтобы скопировать ID';
	@override String get searchHint => 'Никнейм или ID';
	@override String get navMenu => 'Меню навигации';
	@override String get navMenuTooltip => 'Открыть меню навигации';
	@override String get refresh => 'Обновить данные';
	@override String get searchButton => 'Искать';
	@override String get trackedPlayers => 'Отслеживаемые игроки';
	@override String get standing => 'Положение';
	@override String get previousSeasons => 'Предыдущие сезоны';
	@override String get recent => 'Недавние';
	@override String get top => 'Топ';
	@override String get noRecord => 'Нет записи';
	@override String sprintAndBlitsRelevance({required Object date}) => 'Актуальность: ${date}';
	@override late final _StringsSnackBarMessagesRuRu snackBarMessages = _StringsSnackBarMessagesRuRu._(_root);
	@override late final _StringsErrorsRuRu errors = _StringsErrorsRuRu._(_root);
	@override late final _StringsActionsRuRu actions = _StringsActionsRuRu._(_root);
	@override late final _StringsGraphsDestinationRuRu graphsDestination = _StringsGraphsDestinationRuRu._(_root);
	@override late final _StringsFilterModaleRuRu filterModale = _StringsFilterModaleRuRu._(_root);
	@override late final _StringsCutoffsDestinationRuRu cutoffsDestination = _StringsCutoffsDestinationRuRu._(_root);
	@override late final _StringsRankViewRuRu rankView = _StringsRankViewRuRu._(_root);
	@override late final _StringsStateViewRuRu stateView = _StringsStateViewRuRu._(_root);
	@override late final _StringsTlMatchViewRuRu tlMatchView = _StringsTlMatchViewRuRu._(_root);
	@override late final _StringsCalcDestinationRuRu calcDestination = _StringsCalcDestinationRuRu._(_root);
	@override late final _StringsInfoDestinationRuRu infoDestination = _StringsInfoDestinationRuRu._(_root);
	@override late final _StringsLeaderboardsDestinationRuRu leaderboardsDestination = _StringsLeaderboardsDestinationRuRu._(_root);
	@override late final _StringsSavedDataDestinationRuRu savedDataDestination = _StringsSavedDataDestinationRuRu._(_root);
	@override late final _StringsSettingsDestinationRuRu settingsDestination = _StringsSettingsDestinationRuRu._(_root);
	@override late final _StringsHomeNavigationRuRu homeNavigation = _StringsHomeNavigationRuRu._(_root);
	@override late final _StringsGraphsNavigationRuRu graphsNavigation = _StringsGraphsNavigationRuRu._(_root);
	@override late final _StringsCalcNavigationRuRu calcNavigation = _StringsCalcNavigationRuRu._(_root);
	@override late final _StringsFirstTimeViewRuRu firstTimeView = _StringsFirstTimeViewRuRu._(_root);
	@override late final _StringsAboutViewRuRu aboutView = _StringsAboutViewRuRu._(_root);
	@override late final _StringsStatsRuRu stats = _StringsStatsRuRu._(_root);
	@override Map<String, String> get countries => {
		'': 'Во всем мире',
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
		'TO': 'Тонга',
		'TT': 'Тринидад и Тобаго',
		'TN': 'Тунис',
		'TR': 'Турция',
		'TM': 'Туркменистан',
		'TC': 'Острова Теркс и Кайкос',
		'TV': 'Тувалу',
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

// Path: destinations
class _StringsDestinationsRuRu implements _StringsDestinationsEn {
	_StringsDestinationsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get home => 'Дом';
	@override String get graphs => 'Графики';
	@override String get leaderboards => 'Таблицы лидеров';
	@override String get cutoffs => 'Требования рангов';
	@override String get calc => 'Калькулятор';
	@override String get info => 'Инфо-центр';
	@override String get data => 'Сохранённые данные';
	@override String get settings => 'Настройки';
}

// Path: xp
class _StringsXpRuRu implements _StringsXpEn {
	_StringsXpRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уровень Опыта';
	@override String progressToNextLevel({required Object percentage}) => 'Прогресс до следующего уровня: ${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => 'Прогресс с 0 XP до уровня ${goal}: ${percentage} (${left} XP осталось)';
}

// Path: gametime
class _StringsGametimeRuRu implements _StringsGametimeEn {
	_StringsGametimeRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Времени проведено в игре';
	@override String gametimeAday({required Object gametime}) => '${gametime} в день в среднем';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'Это ${years} лет,\nили ${months} месяцев,\nили ${days} дней,\nили ${minutes} минут\nили ${seconds} секунд';
}

// Path: matchResult
class _StringsMatchResultRuRu implements _StringsMatchResultEn {
	_StringsMatchResultRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get victory => 'Победа';
	@override String get defeat => 'Поражение';
	@override String get tie => 'Ничья';
	@override String get dqvictory => 'Оппонент дисквалифицирован';
	@override String get dqdefeat => 'Дисквалифицирован';
	@override String get nocontest => 'Без согласия';
	@override String get nullified => 'Отменен';
}

// Path: distinguishments
class _StringsDistinguishmentsRuRu implements _StringsDistinguishmentsEn {
	_StringsDistinguishmentsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get noHeader => 'Заголовок отсутствует';
	@override String get noFooter => 'Подзаголовок отсуствует';
	@override String get twc => 'Чемпион мира TETR.IO';
	@override String twcYear({required Object year}) => 'Чемпионат мира по TETR.IO ${year} года';
}

// Path: newsEntries
class _StringsNewsEntriesRuRu implements _StringsNewsEntriesEn {
	_StringsNewsEntriesRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override TextSpan leaderboard({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
		const TextSpan(text: 'Заработал №'),
		rank,
		const TextSpan(text: ' в режиме '),
		gametype,
	]);
	@override TextSpan personalbest({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
		const TextSpan(text: 'Новый ЛР в '),
		gametype,
		const TextSpan(text: ': '),
		pb,
	]);
	@override TextSpan badge({required InlineSpan badge}) => TextSpan(children: [
		const TextSpan(text: 'Заработал значок '),
		badge,
	]);
	@override TextSpan rankup({required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: 'Заработал '),
		rank,
		const TextSpan(text: ' в Тетра Лиге'),
	]);
	@override TextSpan supporter({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Стал '),
		s('спонсором TETR.IO'),
	]);
	@override TextSpan supporter_gift({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Получил '),
		s('спонсорку TETR.IO'),
		const TextSpan(text: ' в качестве подарка'),
	]);
	@override TextSpan unknown({required InlineSpan type}) => TextSpan(children: [
		const TextSpan(text: 'Неизвестная новость типа '),
		type,
	]);
}

// Path: snackBarMessages
class _StringsSnackBarMessagesRuRu implements _StringsSnackBarMessagesEn {
	_StringsSnackBarMessagesRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => 'Состояние от ${date} удалено из базы данных!';
	@override String matchRemoved({required Object date}) => 'Матч от ${date} удален из базы данных!';
	@override String get notForWeb => 'Функция недоступна для веб-версии';
	@override String get importSuccess => 'Импорт выполнен успешно';
	@override String get importCancelled => 'Импорт был отменен';
}

// Path: errors
class _StringsErrorsRuRu implements _StringsErrorsEn {
	_StringsErrorsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get noRecords => 'Нет записей';
	@override String get notEnoughData => 'Недостаточно данных';
	@override String get noHistorySaved => 'Нет сохраненной истории';
	@override String connection({required Object code, required Object message}) => 'Проблема с подключением: ${code} ${message}';
	@override String get noSuchUser => 'Нет такого пользователя';
	@override String get noSuchUserSub => 'Либо вы опечатались, либо аккаунт больше не существует';
	@override String get discordNotAssigned => 'К данному Discord ID не привязан аккаунт';
	@override String get discordNotAssignedSub => 'Убедитесь, что указан правильный ID';
	@override String get history => 'История этого игрока отсутствует';
	@override String get actionSuggestion => 'Возможно, вы хотите';
	@override String get p1nkl0bst3rTLmatches => 'Матчей Тетра Лиги не найдено';
	@override String get clientException => 'Нет подключения к Интернету';
	@override String get forbidden => 'Ваш IP-адрес заблокирован';
	@override String forbiddenSub({required Object nickname}) => 'Если вы используете VPN или Proxy, выключите его. Если это не помогает, свяжитесь с ${nickname}';
	@override String get tooManyRequests => 'Слишком много запросов';
	@override String get tooManyRequestsSub => 'Повторите попытку позже';
	@override String get internal => 'Что-то случилось на стороне tetr.io';
	@override String get internalSub => 'Скорее всего, osk уже в курсе';
	@override String get internalWebVersion => 'Что-то случилось на стороне TETR.IO (или у oskware_bridge, я хз)';
	@override String get internalWebVersionSub => 'Если на osk status page нет сообщений о проблемах, дайте знать dan63047';
	@override String get oskwareBridge => 'Что-то случилось с oskware_bridge';
	@override String get oskwareBridgeSub => 'Дайте знать dan63047';
	@override String get p1nkl0bst3rForbidden => 'Сторонний API заблокировал ваш IP-адрес';
	@override String get p1nkl0bst3rTooManyRequests => 'Слишком много запросов к стороннему API. Попробуйте позже';
	@override String get p1nkl0bst3rinternal => 'Что-то случилось на стороне p1nkl0bst3r';
	@override String get p1nkl0bst3rinternalWebVersion => 'Что-то случилось на стороне p1nkl0bst3r (или на oskware_bridge, я хз)';
	@override String get replayAlreadySaved => 'Повтор уже был сохранен';
	@override String get replayExpired => 'Повтор истек и больше не доступен';
	@override String get replayRejected => 'Сторонний API заблокировал ваш IP-адрес';
}

// Path: actions
class _StringsActionsRuRu implements _StringsActionsEn {
	_StringsActionsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отменить';
	@override String get submit => 'Подтвердить';
	@override String get ok => 'ОК';
	@override String get apply => 'Применить';
	@override String get refresh => 'Обновить';
}

// Path: graphsDestination
class _StringsGraphsDestinationRuRu implements _StringsGraphsDestinationEn {
	_StringsGraphsDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get fetchAndsaveTLHistory => 'Получить историю игрока';
	@override String get fetchAndSaveOldTLmatches => 'Получить историю матчей Тетра Лиги';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '${number} состояний было найдено';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} матчей было найдено';
	@override String gamesPlayed({required Object games}) => '${games} сыграно';
	@override String get dateAndTime => 'Дата и время';
	@override String get filterModaleTitle => 'Фильтровать график по рангам';
}

// Path: filterModale
class _StringsFilterModaleRuRu implements _StringsFilterModaleEn {
	_StringsFilterModaleRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get all => 'Все';
}

// Path: cutoffsDestination
class _StringsCutoffsDestinationRuRu implements _StringsCutoffsDestinationEn {
	_StringsCutoffsDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Состояние Тетра Лиги';
	@override String relevance({required Object timestamp}) => 'на момент ${timestamp}';
	@override String get actual => 'Требование';
	@override String get target => 'Цель';
	@override String get cutoffTR => 'Треб. TR';
	@override String get targetTR => 'Целевой TR';
	@override String get state => 'Состояние';
	@override String get advanced => 'Продвинутая';
	@override String players({required Object n}) => 'Игроков (${n})';
	@override String get moreInfo => 'Подробнее';
	@override String NumberOne({required Object tr}) => '№ 1 - ${tr} TR';
	@override String inflated({required Object tr}) => 'Инфляция - ${tr} TR';
	@override String get notInflated => 'Нет инфляции';
	@override String deflated({required Object tr}) => 'Дефляция - ${tr} TR';
	@override String get notDeflated => 'Нет дефляции';
	@override String get wellDotDotDot => 'Ну-у...';
	@override String fromPlace({required Object n}) => 'от № ${n}';
	@override String get viewButton => 'Посмотреть';
}

// Path: rankView
class _StringsRankViewRuRu implements _StringsRankViewEn {
	_StringsRankViewRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String rankTitle({required Object rank}) => 'Данные ${rank} ранга';
	@override String get everyoneTitle => 'Вся таблица';
	@override String get trRange => 'Диапазон TR';
	@override String get supposedToBe => 'Должен быть';
	@override String gap({required Object value}) => 'промежуток в ${value}';
	@override String trGap({required Object value}) => 'промежуток в ${value} TR';
	@override String get deflationGap => 'Зона дефляции';
	@override String get inflationGap => 'Зона инфляции';
	@override String get LBposRange => 'Диапазон по позициям';
	@override String overpopulated({required Object players}) => 'Переполнен ${players}';
	@override String underpopulated({required Object players}) => 'Не хватает ${players}';
	@override String get PlayersEqualSupposedToBe => 'лол';
	@override String get avgStats => 'Средние значения';
	@override String avgForRank({required Object rank}) => 'Среднее для ${rank} ранга';
	@override String get avgNerdStats => 'Средние задротские значения';
	@override String get minimums => 'Минимумы';
	@override String get maximums => 'Максимумы';
}

// Path: stateView
class _StringsStateViewRuRu implements _StringsStateViewEn {
	_StringsStateViewRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => 'Состояние от ${date}';
}

// Path: tlMatchView
class _StringsTlMatchViewRuRu implements _StringsTlMatchViewEn {
	_StringsTlMatchViewRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get match => 'Матч';
	@override String get vs => 'против';
	@override String get winner => 'Победитель';
	@override String roundNumber({required Object n}) => 'Раунд ${n}';
	@override String get statsFor => 'Статистика для';
	@override String get numberOfRounds => 'Количество раундов';
	@override String get matchLength => 'Продолжительность матча';
	@override String get roundLength => 'Продолжительность раунда';
	@override String get matchStats => 'Статистика матча';
	@override String get downloadReplay => 'Скачать .ttrm повтор';
	@override String get openReplay => 'Открыть повтор в TETR.IO';
}

// Path: calcDestination
class _StringsCalcDestinationRuRu implements _StringsCalcDestinationEn {
	_StringsCalcDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => 'Введите ваш ${stat}';
	@override String get tip => 'Введите значения и нажмите "Считать", чтобы увидеть статистику для задротов';
	@override String get statsCalcButton => 'Считать';
	@override String get damageCalcTip => 'Нажмите на действия слева, чтобы добавить их сюда';
	@override String get actions => 'Действия';
	@override String get results => 'Результаты';
	@override String get rules => 'Правила';
	@override String get noSpinClears => 'Без спинов';
	@override String get spins => 'Спины';
	@override String get miniSpins => 'Мини спины';
	@override String get noLineclear => '0 линий (сброс комбо)';
	@override String get custom => 'Custom';
	@override String get multiplier => 'Множитель';
	@override String get pcDamage => 'PC урон';
	@override String get comboTable => 'Таблица комбо';
	@override String get b2bChaining => 'Таблица комбо';
	@override String get surgeStartAtB2B => 'Начинается с B2B';
	@override String get surgeStartAmount => 'Начинается с';
	@override String get totalDamage => 'Всего урона';
	@override String get lineclears => 'Lineclears';
	@override String get combo => 'Комбо';
	@override String get surge => 'Surge';
	@override String get pcs => 'PCs';
}

// Path: infoDestination
class _StringsInfoDestinationRuRu implements _StringsInfoDestinationEn {
	_StringsInfoDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Информационный Центр';
	@override String get sprintAndBlitzAverages => 'Средние значения для 40 линий и блиц';
	@override String get sprintAndBlitzAveragesDescription => 'Поскольку считать средние значения 40 линий и Блиц неудобно, они обновляется довольно редко. Кликните по названию этой карточки, чтобы увидеть таблицу средних значений 40 линий и Блиц';
	@override String get tetraStatsWiki => 'Tetra Stats Вики';
	@override String get tetraStatsWikiDescription => 'Узнайте больше о функциях Tetra Stats и статистике, что он предоставляет';
	@override String get about => 'О Tetra Stats';
	@override String get aboutDescription => 'Разработано dan63\n';
}

// Path: leaderboardsDestination
class _StringsLeaderboardsDestinationRuRu implements _StringsLeaderboardsDestinationEn {
	_StringsLeaderboardsDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Таблицы лидеров';
	@override String get tl => 'Тетра Лига (Текущий сезон)';
	@override String get fullTL => 'Тетра Лига (Текущий сезон, вся за раз)';
	@override String get ar => 'Очки достижений';
}

// Path: savedDataDestination
class _StringsSavedDataDestinationRuRu implements _StringsSavedDataDestinationEn {
	_StringsSavedDataDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Сохранённые данные';
	@override String get tip => 'Выберите никнейм слева, чтобы увидеть данные ассоциированные с ним';
	@override String seasonTLstates({required Object s}) => 'TL ${s} сезона';
	@override String get TLrecords => 'Записи TL';
}

// Path: settingsDestination
class _StringsSettingsDestinationRuRu implements _StringsSettingsDestinationEn {
	_StringsSettingsDestinationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override String get general => 'Общие';
	@override String get customization => 'Кастомизация';
	@override String get database => 'Локальная база данных';
	@override String get checking => 'Проверяем...';
	@override String get enterToSubmit => 'Enter, чтобы подтвердить';
	@override String get account => 'Ваш аккаунт в TETR.IO';
	@override String get accountDescription => 'Статистика этого игрока будет загружена сразу после запуска приложения. По умолчанию программа загружает мою (dan63) статистику. Чтобы изменить это, введите свой ник.';
	@override String get done => 'Готово!';
	@override String get noSuchAccount => 'Нет такого аккаунта';
	@override String get language => 'Язык';
	@override String languageDescription({required Object languages}) => 'Tetra Stats был переведен на ${languages}. По умолчанию приложение выберет язык системы или Английский, если перевода на язык системы нету.';
	@override String languages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: 'ноль языков',
		one: '${n} язык',
		two: '${n} языка',
		few: '${n} языка',
		many: '${n} языков',
		other: '${n} языков',
	);
	@override String get updateInTheBackground => 'Обновлять данные в фоновом режиме';
	@override String get updateInTheBackgroundDescription => 'Пока Tetra Stats работает, он может обновлять статистику самостоятельно когда кэш истекает. Обычно это происходит каждые 5 минут';
	@override String get compareStats => 'Сравнивать статистику со средними значениями ранга';
	@override String get compareStatsDescription => 'Если включено, Tetra Stats загрузит средние значения и будет сравнивать вас со средними значениями вашего ранга. В результате этого почти каждый пункт статистики обретёт цвет, наводите курсор, что-бы узнать больше.';
	@override String get showPosition => 'Показывать позиции по статам';
	@override String get showPositionDescription => 'На загрузку потребуется немного времени (и трафика), но зато вы сможете видеть своё положение в таблице Тетра Лиги, отсортированной по статам';
	@override String get accentColor => 'Цветовой акцент';
	@override String get accentColorDescription => 'Этот цвет подчёркивает интерактивные элементы интерфейса.';
	@override String get accentColorModale => 'Выберите цвет акцента';
	@override String get timestamps => 'Формат отметок времени';
	@override String timestampsDescriptionPart1({required Object d}) => 'Вы можете выбрать вид отметок времени. По умолчанию показывается дата и время по Гринвичу, форматированная в соответствии с выбранной локалью. Пример: ${d}.';
	@override String timestampsDescriptionPart2({required Object y, required Object r}) => 'Также можно выбрать:\n• Дата и время в вашем часовом поясе: ${y}\n• Относительные отметки времени: ${r}';
	@override String get timestampsAbsoluteGMT => 'Абсолютные (по Гринвичу)';
	@override String get timestampsAbsoluteLocalTime => 'Абсолютные (ваша временная зона)';
	@override String get timestampsRelative => 'Относительные';
	@override String get sheetbotLikeGraphs => 'Графики-радары как у sheetBot';
	@override String get sheetbotLikeGraphsDescription => 'Хоть и несмотря на то, что я считаю поведение графиков sheetBot-а не совсем корректным, некоторые пользователи были в замешательстве от того, что -0,5 страйд не выглядит так, как на графике sheetBot-а. Поэтому вот моё решение: если тумблер включен, точки графика могут появляться на противоположенной стороне графика если значение со знаком минус.';
	@override String get oskKagariGimmick => '"Оск Кагари" прикол';
	@override String get oskKagariGimmickDescription => 'Если включено, вместо настоящего ранга оска будет рендерится :kagari:.';
	@override String get bytesOfDataStored => 'данных сохранено';
	@override String get TLrecordsSaved => 'записей о матчах Тетра Лиги сохранено';
	@override String get TLplayerstatesSaved => 'состояний Тетра Лиги сохранено';
	@override String get fixButton => 'Исправить';
	@override String get compressButton => 'Сжать';
	@override String get exportDB => 'Экспортировать локальную базу данных';
	@override String get desktopExportAlertTitle => 'Экспорт на десктопе';
	@override String get desktopExportText => 'Похоже, вы используете десктопную версию. Проверьте папку "Документы", там вы должны найти файл "TetraStats.db". Скопируйте его куда-нибудь';
	@override String get androidExportAlertTitle => 'Экспорт на Android';
	@override String androidExportText({required Object exportedDB}) => 'Экспортировано.\n${exportedDB}';
	@override String get importDB => 'Импортировать локальную базу данных';
	@override String get importDBDescription => 'Восстановите свою резеврную копию. Обратите внимание, что текущая база данных будет перезаписана.';
	@override String get importWrongFileType => 'Неверный тип файла';
}

// Path: homeNavigation
class _StringsHomeNavigationRuRu implements _StringsHomeNavigationEn {
	_StringsHomeNavigationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Обзор';
	@override String get standing => 'Положение';
	@override String get seasons => 'Сезоны';
	@override String get mathces => 'Матчи';
	@override String get pb => 'Рекорд';
	@override String get normal => 'Обычный';
	@override String get expert => 'Эксперт';
	@override String get expertRecords => 'Записи EX';
}

// Path: graphsNavigation
class _StringsGraphsNavigationRuRu implements _StringsGraphsNavigationEn {
	_StringsGraphsNavigationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get history => 'История игрока';
	@override String get league => 'Состояние Лиги';
	@override String get cutoffs => 'История рангов';
}

// Path: calcNavigation
class _StringsCalcNavigationRuRu implements _StringsCalcNavigationEn {
	_StringsCalcNavigationRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get stats => 'Калькулятор статистики';
	@override String get damage => 'Калькулятор урона';
}

// Path: firstTimeView
class _StringsFirstTimeViewRuRu implements _StringsFirstTimeViewEn {
	_StringsFirstTimeViewRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Добро пожаловать в Tetra Stats';
	@override String get description => 'Сервис, который позволяет просматривать статистику в TETR.IO';
	@override String get nicknameQuestion => 'Введите свой ник';
	@override String get inpuntHint => '(3-16 символов)';
	@override String get emptyInputError => 'Строка пуста';
	@override String niceToSeeYou({required Object n}) => 'Приятно познакомиться, ${n}';
	@override String get letsTakeALook => 'Давайте же посмотрим на ваши статы...';
	@override String get skip => 'Пропустить';
}

// Path: aboutView
class _StringsAboutViewRuRu implements _StringsAboutViewEn {
	_StringsAboutViewRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'О Tetra Stats';
	@override String get about => 'Tetra Stats — это сервис, который работает с TETR.IO Tetra Channel API, показывает данные оттуда и считает дополнительную статистику, основанную на этих данных. Сервис позволяет отслеживать прогресс в Тетра Лиге с помощью функции "Отслеживать", которая записывает каждое изменение в Лиге в локальную базу данных (не автоматически, вы должны вручную посещать свой профиль), что позволяет потом просматривать изменения с помощью графиков.\n\nBeanserver blaster — серверная часть Tetra Stats. Она собирает полную таблицу игроков Тетра Лиги, благодаря чему сортировать эту таблицу по любой метрике и строить точечную диаграмму, что позволяет анализировать тренды Лиги. Также она предоставляет историю требований рангов, которую тоже можно посмотреть на графике.\n\nВ будущем планируется добавить анализ повторов и историю турниров, так что оставайтесь на связи.\n\nСервис ни коим образом не ассоциируется с TETR.IO или osk.';
	@override String get appVersion => 'Версия приложения';
	@override String build({required Object build}) => 'Сборка ${build}';
	@override String get GHrepo => 'Репозиторий на GitHub';
	@override String get submitAnIssue => 'Сообщить об ошибке';
	@override String get credits => 'Благодарности';
	@override String get authorAndDeveloper => 'Автор и разработчик';
	@override String get providedFormulas => 'Предоставил формулы';
	@override String get providedS1history => 'Предоставляет историю первого сезона лиги';
	@override String get inoue => 'Inoue (достаёт повторы)';
	@override String get zhCNlocale => 'Перевёл на упрощённый китайский';
	@override String get supportHim => 'Поддержите его!';
}

// Path: stats
class _StringsStatsRuRu implements _StringsStatsEn {
	_StringsStatsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => 'Дата регистрации';
	@override String get gametime => 'Время в игре';
	@override String get ogp => 'Онлайн игр';
	@override String get ogw => 'Онлайн побед';
	@override String get followers => 'Подписчиков';
	@override late final _StringsStatsXpRuRu xp = _StringsStatsXpRuRu._(_root);
	@override late final _StringsStatsTrRuRu tr = _StringsStatsTrRuRu._(_root);
	@override late final _StringsStatsGlickoRuRu glicko = _StringsStatsGlickoRuRu._(_root);
	@override late final _StringsStatsRdRuRu rd = _StringsStatsRdRuRu._(_root);
	@override late final _StringsStatsGlixareRuRu glixare = _StringsStatsGlixareRuRu._(_root);
	@override late final _StringsStatsS1trRuRu s1tr = _StringsStatsS1trRuRu._(_root);
	@override late final _StringsStatsGpRuRu gp = _StringsStatsGpRuRu._(_root);
	@override late final _StringsStatsGwRuRu gw = _StringsStatsGwRuRu._(_root);
	@override late final _StringsStatsWinrateRuRu winrate = _StringsStatsWinrateRuRu._(_root);
	@override late final _StringsStatsApmRuRu apm = _StringsStatsApmRuRu._(_root);
	@override late final _StringsStatsPpsRuRu pps = _StringsStatsPpsRuRu._(_root);
	@override late final _StringsStatsVsRuRu vs = _StringsStatsVsRuRu._(_root);
	@override late final _StringsStatsAppRuRu app = _StringsStatsAppRuRu._(_root);
	@override late final _StringsStatsVsapmRuRu vsapm = _StringsStatsVsapmRuRu._(_root);
	@override late final _StringsStatsDssRuRu dss = _StringsStatsDssRuRu._(_root);
	@override late final _StringsStatsDspRuRu dsp = _StringsStatsDspRuRu._(_root);
	@override late final _StringsStatsAppdspRuRu appdsp = _StringsStatsAppdspRuRu._(_root);
	@override late final _StringsStatsCheeseRuRu cheese = _StringsStatsCheeseRuRu._(_root);
	@override late final _StringsStatsGbeRuRu gbe = _StringsStatsGbeRuRu._(_root);
	@override late final _StringsStatsNyaappRuRu nyaapp = _StringsStatsNyaappRuRu._(_root);
	@override late final _StringsStatsAreaRuRu area = _StringsStatsAreaRuRu._(_root);
	@override late final _StringsStatsEtrRuRu etr = _StringsStatsEtrRuRu._(_root);
	@override late final _StringsStatsEtraccRuRu etracc = _StringsStatsEtraccRuRu._(_root);
	@override late final _StringsStatsOpenerRuRu opener = _StringsStatsOpenerRuRu._(_root);
	@override late final _StringsStatsPlonkRuRu plonk = _StringsStatsPlonkRuRu._(_root);
	@override late final _StringsStatsStrideRuRu stride = _StringsStatsStrideRuRu._(_root);
	@override late final _StringsStatsInfdsRuRu infds = _StringsStatsInfdsRuRu._(_root);
	@override late final _StringsStatsAltitudeRuRu altitude = _StringsStatsAltitudeRuRu._(_root);
	@override late final _StringsStatsClimbSpeedRuRu climbSpeed = _StringsStatsClimbSpeedRuRu._(_root);
	@override late final _StringsStatsPeakClimbSpeedRuRu peakClimbSpeed = _StringsStatsPeakClimbSpeedRuRu._(_root);
	@override late final _StringsStatsKosRuRu kos = _StringsStatsKosRuRu._(_root);
	@override late final _StringsStatsB2bRuRu b2b = _StringsStatsB2bRuRu._(_root);
	@override late final _StringsStatsFinesseRuRu finesse = _StringsStatsFinesseRuRu._(_root);
	@override late final _StringsStatsFinesseFaultsRuRu finesseFaults = _StringsStatsFinesseFaultsRuRu._(_root);
	@override late final _StringsStatsTotalTimeRuRu totalTime = _StringsStatsTotalTimeRuRu._(_root);
	@override late final _StringsStatsLevelRuRu level = _StringsStatsLevelRuRu._(_root);
	@override late final _StringsStatsPiecesRuRu pieces = _StringsStatsPiecesRuRu._(_root);
	@override late final _StringsStatsSppRuRu spp = _StringsStatsSppRuRu._(_root);
	@override late final _StringsStatsKpRuRu kp = _StringsStatsKpRuRu._(_root);
	@override late final _StringsStatsKppRuRu kpp = _StringsStatsKppRuRu._(_root);
	@override late final _StringsStatsKpsRuRu kps = _StringsStatsKpsRuRu._(_root);
	@override String blitzScore({required Object p}) => '${p} очков';
	@override String levelUpRequirement({required Object p}) => 'Очков для повышения уровня: ${p}';
	@override String get piecesTotal => 'Всего фигур установлено';
	@override String get piecesWithPerfectFinesse => 'Установлено с идеальной техникой';
	@override String get score => 'Счёт';
	@override String get lines => 'Линий';
	@override String get linesShort => 'L';
	@override String get pcs => 'Perfect Clears';
	@override String get holds => 'Holds';
	@override String get spike => 'Top Spike';
	@override String top({required Object percentage}) => 'Топ ${percentage}';
	@override String topRank({required Object rank}) => 'Топ ранг: ${rank}';
	@override String get floor => 'Этаж';
	@override String get split => 'Сектор';
	@override String get total => 'Всего';
	@override String get sent => 'Отправлено';
	@override String get received => 'Получено';
	@override String get placement => 'Положение';
	@override String get peak => 'Пик';
	@override String qpWithMods({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'С 1 модом',
		two: 'С ${n} модами',
		few: 'С ${n} модами',
		many: 'С ${n} модами',
		other: 'С ${n} модами',
	);
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} нажатий клавиш',
		one: '${n} нажатие клавиш',
		two: '${n} нажатия клавиш',
		few: '${n} нажатия клавиш',
		many: '${n} нажатий клавиш',
		other: '${n} нажатий клавиш',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} T-спинов всего',
		one: 'Всего ${n} T-спин',
		two: '${n} T-спина всего',
		few: '${n} T-спина всего',
		many: '${n} T-спинов всего',
		other: '${n} T-спинов всего',
	);
	@override String linesCleared({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '${n} линий очищено',
		one: '${n} линия очищена',
		two: '${n} линии очищено',
		few: '${n} линии очищено',
		many: '${n} линий очищено',
		other: '${n} линий очищено',
	);
	@override late final _StringsStatsGraphsRuRu graphs = _StringsStatsGraphsRuRu._(_root);
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
	@override late final _StringsStatsLineClearRuRu lineClear = _StringsStatsLineClearRuRu._(_root);
	@override late final _StringsStatsLineClearsRuRu lineClears = _StringsStatsLineClearsRuRu._(_root);
	@override String get mini => 'Mini';
	@override String get tSpin => 'T-spin';
	@override String get tSpins => 'T-spins';
	@override String get spin => 'Spin';
	@override String get spins => 'Spins';
}

// Path: stats.xp
class _StringsStatsXpRuRu implements _StringsStatsXpEn {
	_StringsStatsXpRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Опыт';
	@override String get full => 'Очки опыта';
}

// Path: stats.tr
class _StringsStatsTrRuRu implements _StringsStatsTrEn {
	_StringsStatsTrRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => 'Тетра Рейтинг';
}

// Path: stats.glicko
class _StringsStatsGlickoRuRu implements _StringsStatsGlickoEn {
	_StringsStatsGlickoRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => 'Glicko';
}

// Path: stats.rd
class _StringsStatsRdRuRu implements _StringsStatsRdEn {
	_StringsStatsRdRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'RD';
	@override String get full => 'Отклонение Рейтинга';
}

// Path: stats.glixare
class _StringsStatsGlixareRuRu implements _StringsStatsGlixareEn {
	_StringsStatsGlixareRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _StringsStatsS1trRuRu implements _StringsStatsS1trEn {
	_StringsStatsS1trRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'S1 TR';
	@override String get full => 'TR как в первом сезоне';
}

// Path: stats.gp
class _StringsStatsGpRuRu implements _StringsStatsGpEn {
	_StringsStatsGpRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GP';
	@override String get full => 'Матчей';
}

// Path: stats.gw
class _StringsStatsGwRuRu implements _StringsStatsGwEn {
	_StringsStatsGwRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GW';
	@override String get full => 'Побед';
}

// Path: stats.winrate
class _StringsStatsWinrateRuRu implements _StringsStatsWinrateEn {
	_StringsStatsWinrateRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'WR%';
	@override String get full => 'Процент побед';
}

// Path: stats.apm
class _StringsStatsApmRuRu implements _StringsStatsApmEn {
	_StringsStatsApmRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => 'Атаки в Минуту';
}

// Path: stats.pps
class _StringsStatsPpsRuRu implements _StringsStatsPpsEn {
	_StringsStatsPpsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => 'Фигур в Секунду';
}

// Path: stats.vs
class _StringsStatsVsRuRu implements _StringsStatsVsEn {
	_StringsStatsVsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => 'Показатель Versus';
}

// Path: stats.app
class _StringsStatsAppRuRu implements _StringsStatsAppEn {
	_StringsStatsAppRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => 'Атаки на Фигуру';
}

// Path: stats.vsapm
class _StringsStatsVsapmRuRu implements _StringsStatsVsapmEn {
	_StringsStatsVsapmRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _StringsStatsDssRuRu implements _StringsStatsDssEn {
	_StringsStatsDssRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => 'Спуск в секунду';
}

// Path: stats.dsp
class _StringsStatsDspRuRu implements _StringsStatsDspEn {
	_StringsStatsDspRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => 'Спуск на фигуру';
}

// Path: stats.appdsp
class _StringsStatsAppdspRuRu implements _StringsStatsAppdspEn {
	_StringsStatsAppdspRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _StringsStatsCheeseRuRu implements _StringsStatsCheeseEn {
	_StringsStatsCheeseRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Cheese';
	@override String get full => 'Индекс Сыра';
}

// Path: stats.gbe
class _StringsStatsGbeRuRu implements _StringsStatsGbeEn {
	_StringsStatsGbeRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => 'Эффективность Мусора';
}

// Path: stats.nyaapp
class _StringsStatsNyaappRuRu implements _StringsStatsNyaappEn {
	_StringsStatsNyaappRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => 'Weighted APP';
}

// Path: stats.area
class _StringsStatsAreaRuRu implements _StringsStatsAreaEn {
	_StringsStatsAreaRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Area';
	@override String get full => 'Area';
}

// Path: stats.etr
class _StringsStatsEtrRuRu implements _StringsStatsEtrEn {
	_StringsStatsEtrRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => 'Расчётный TR';
}

// Path: stats.etracc
class _StringsStatsEtraccRuRu implements _StringsStatsEtraccEn {
	_StringsStatsEtraccRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => 'Точность расчёта';
}

// Path: stats.opener
class _StringsStatsOpenerRuRu implements _StringsStatsOpenerEn {
	_StringsStatsOpenerRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Opener';
	@override String get full => 'Опенер';
}

// Path: stats.plonk
class _StringsStatsPlonkRuRu implements _StringsStatsPlonkEn {
	_StringsStatsPlonkRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Plonk';
	@override String get full => 'Плонк';
}

// Path: stats.stride
class _StringsStatsStrideRuRu implements _StringsStatsStrideEn {
	_StringsStatsStrideRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Stride';
	@override String get full => 'Страйд';
}

// Path: stats.infds
class _StringsStatsInfdsRuRu implements _StringsStatsInfdsEn {
	_StringsStatsInfdsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Inf. DS';
	@override String get full => 'Бесконечный спуск';
}

// Path: stats.altitude
class _StringsStatsAltitudeRuRu implements _StringsStatsAltitudeEn {
	_StringsStatsAltitudeRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'м';
	@override String get full => 'Высота';
}

// Path: stats.climbSpeed
class _StringsStatsClimbSpeedRuRu implements _StringsStatsClimbSpeedEn {
	_StringsStatsClimbSpeedRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'CSP';
	@override String get full => 'Скорость подъёма';
	@override String get gaugetTitle => 'Скорость\nПодъёма';
}

// Path: stats.peakClimbSpeed
class _StringsStatsPeakClimbSpeedRuRu implements _StringsStatsPeakClimbSpeedEn {
	_StringsStatsPeakClimbSpeedRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Пик CSP';
	@override String get full => 'Пиковая скорость подъёма';
	@override String get gaugetTitle => 'Пик';
}

// Path: stats.kos
class _StringsStatsKosRuRu implements _StringsStatsKosEn {
	_StringsStatsKosRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KO\'s';
	@override String get full => 'Выбил';
}

// Path: stats.b2b
class _StringsStatsB2bRuRu implements _StringsStatsB2bEn {
	_StringsStatsB2bRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => 'Back-To-Back';
}

// Path: stats.finesse
class _StringsStatsFinesseRuRu implements _StringsStatsFinesseEn {
	_StringsStatsFinesseRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'F';
	@override String get full => 'Техника';
	@override String get widgetTitle => 'Техника';
}

// Path: stats.finesseFaults
class _StringsStatsFinesseFaultsRuRu implements _StringsStatsFinesseFaultsEn {
	_StringsStatsFinesseFaultsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'FF';
	@override String get full => 'Ошибок техники';
}

// Path: stats.totalTime
class _StringsStatsTotalTimeRuRu implements _StringsStatsTotalTimeEn {
	_StringsStatsTotalTimeRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Время';
	@override String get full => 'Общее время';
	@override String get widgetTitle => 'Общее время';
}

// Path: stats.level
class _StringsStatsLevelRuRu implements _StringsStatsLevelEn {
	_StringsStatsLevelRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Лвл';
	@override String get full => 'Уровень';
}

// Path: stats.pieces
class _StringsStatsPiecesRuRu implements _StringsStatsPiecesEn {
	_StringsStatsPiecesRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => 'Фигур';
}

// Path: stats.spp
class _StringsStatsSppRuRu implements _StringsStatsSppEn {
	_StringsStatsSppRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => 'Очков на Фигуру';
}

// Path: stats.kp
class _StringsStatsKpRuRu implements _StringsStatsKpEn {
	_StringsStatsKpRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => 'Нажатий клавиш';
}

// Path: stats.kpp
class _StringsStatsKppRuRu implements _StringsStatsKppEn {
	_StringsStatsKppRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => 'Нажатий клавиш на Фигуру';
}

// Path: stats.kps
class _StringsStatsKpsRuRu implements _StringsStatsKpsEn {
	_StringsStatsKpsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => 'Нажатий клавиш в Секунду';
}

// Path: stats.graphs
class _StringsStatsGraphsRuRu implements _StringsStatsGraphsEn {
	_StringsStatsGraphsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get attack => 'Атака';
	@override String get speed => 'Скорость';
	@override String get defense => 'Оборона';
	@override String get cheese => 'Сыр';
}

// Path: stats.lineClear
class _StringsStatsLineClearRuRu implements _StringsStatsLineClearEn {
	_StringsStatsLineClearRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get single => 'Single';
	@override String get double => 'Double';
	@override String get triple => 'Triple';
	@override String get quad => 'Quad';
	@override String get penta => 'Penta';
	@override String get hexa => 'Hexa';
	@override String get hepta => 'Hepta';
	@override String get octa => 'Octa';
	@override String get ennea => 'Ennea';
	@override String get deca => 'Deca';
	@override String get hendeca => 'Hendeca';
	@override String get dodeca => 'Dodeca';
	@override String get triadeca => 'Triadeca';
	@override String get tessaradeca => 'Tessaradeca';
	@override String get pentedeca => 'Pentedeca';
	@override String get hexadeca => 'Hexadeca';
	@override String get heptadeca => 'Heptadeca';
	@override String get octadeca => 'Octadeca';
	@override String get enneadeca => 'Enneadeca';
	@override String get eicosa => 'Eicosa';
	@override String get kagaris => 'Kagaris';
}

// Path: stats.lineClears
class _StringsStatsLineClearsRuRu implements _StringsStatsLineClearsEn {
	_StringsStatsLineClearsRuRu._(this._root);

	@override final _StringsRuRu _root; // ignore: unused_field

	// Translations
	@override String get zero => 'Zeros';
	@override String get single => 'Singles';
	@override String get double => 'Doubles';
	@override String get triple => 'Triples';
	@override String get quad => 'Quads';
	@override String get penta => 'Pentas';
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
		'ru-RU': '俄语 (Русский)',
		'zh-CN': '简体中文',
	};
	@override Map<String, String> get gamemodes => {
		'league': 'Tetra 联赛',
		'zenith': '快速游戏',
		'zenithex': '快速游戏 · 专家模式',
		'40l': '40行竞速',
		'blitz': '闪电战',
		'5mblast': '5,000,000 Blast',
		'zen': '禅意模式',
	};
	@override late final _StringsDestinationsZhCn destinations = _StringsDestinationsZhCn._(_root);
	@override Map<String, String> get playerRole => {
		'user': '用户',
		'banned': '已封禁',
		'bot': '机器人',
		'sysop': '系统操作员',
		'admin': '管理员',
		'mod': '管理员',
		'halfmod': '社区管理员',
		'anon': '匿名用户',
	};
	@override String get goBackButton => '返回';
	@override String get nanow => '目前不可用...';
	@override String seasonEnds({required Object countdown}) => '当前赛季还有${countdown}结束';
	@override String get seasonEnded => '赛季已结束';
	@override String overallPB({required Object pb}) => '生涯最佳：${pb} m';
	@override String gamesUntilRanked({required Object left}) => '还有${left}局才可获得段位';
	@override String numOfVictories({required Object wins}) => '~${wins}次胜局';
	@override String get promotionOnNextWin => '下一场胜局即可升段';
	@override String numOfdefeats({required Object losses}) => '~${losses}次负局';
	@override String get demotionOnNextLoss => '下一场负局即可掉段';
	@override String get records => '记录';
	@override String get nerdStats => '详细信息';
	@override String get playstyles => '游戏方式';
	@override String get horoscopes => '散点图';
	@override String get relatedAchievements => '相关成就';
	@override String get season => '赛季';
	@override String get smooth => '平滑';
	@override String get dateAndTime => '日期和时间：';
	@override String get TLfullLBnote => '很大，但允许你通过玩家的数据对玩家进行排序，还可以按段位筛选玩家';
	@override String get rank => '段位';
	@override String verdictGeneral({required Object rank, required Object n, required Object verdict}) => '比 ${rank} 段平均数据${n} ${verdict}';
	@override String get verdictBetter => '好';
	@override String get verdictWorse => '差';
	@override String get localStanding => '本地';
	@override late final _StringsXpZhCn xp = _StringsXpZhCn._(_root);
	@override late final _StringsGametimeZhCn gametime = _StringsGametimeZhCn._(_root);
	@override String get track => '跟踪';
	@override String get stopTracking => '停止跟踪';
	@override String supporter({required Object tier}) => '${tier}级会员';
	@override String comparingWith({required Object newDate, required Object oldDate}) => '${newDate}的数据与${oldDate}相比';
	@override String get compare => '比较';
	@override String get comparison => '比较';
	@override String get enterUsername => '输入用户名或者\$avgX (X是一个段位)';
	@override String get general => '常规';
	@override String get badges => '勋章';
	@override String obtainDate({required Object date}) => '于${date}获得';
	@override String get assignedManualy => '此徽章由TETR.IO管理员手动颁发';
	@override String get distinguishment => '区别';
	@override String get banned => '已封禁';
	@override String get bannedSubtext => '由于 TETR.IO 规则或服务条款被违反 而被封禁';
	@override String get badStanding => '信誉不佳';
	@override String get badStandingSubtext => '近期有一次或多次违禁行为';
	@override String get botAccount => '机器人账号';
	@override String botAccountSubtext({required Object botMaintainers}) => '由${botMaintainers}管理';
	@override String get copiedToClipboard => '已复制到剪贴板！';
	@override String get bio => '个性签名';
	@override String get news => '新闻';
	@override late final _StringsMatchResultZhCn matchResult = _StringsMatchResultZhCn._(_root);
	@override late final _StringsDistinguishmentsZhCn distinguishments = _StringsDistinguishmentsZhCn._(_root);
	@override late final _StringsNewsEntriesZhCn newsEntries = _StringsNewsEntriesZhCn._(_root);
	@override String rankupMiddle({required Object r}) => '${r} 段';
	@override String get copyUserID => '点击以复制用户 ID';
	@override String get searchHint => '用户名或 ID';
	@override String get navMenu => '导航菜单';
	@override String get navMenuTooltip => '打开导航菜单';
	@override String get refresh => '刷新数据';
	@override String get searchButton => '搜索';
	@override String get trackedPlayers => '跟踪的玩家';
	@override String get standing => '名次';
	@override String get previousSeasons => '上赛季';
	@override String get recent => '最近';
	@override String get top => '前';
	@override String get noRecord => '暂无记录';
	@override String sprintAndBlitsRelevance({required Object date}) => '${date}';
	@override late final _StringsSnackBarMessagesZhCn snackBarMessages = _StringsSnackBarMessagesZhCn._(_root);
	@override late final _StringsErrorsZhCn errors = _StringsErrorsZhCn._(_root);
	@override late final _StringsActionsZhCn actions = _StringsActionsZhCn._(_root);
	@override late final _StringsGraphsDestinationZhCn graphsDestination = _StringsGraphsDestinationZhCn._(_root);
	@override late final _StringsFilterModaleZhCn filterModale = _StringsFilterModaleZhCn._(_root);
	@override late final _StringsCutoffsDestinationZhCn cutoffsDestination = _StringsCutoffsDestinationZhCn._(_root);
	@override late final _StringsRankViewZhCn rankView = _StringsRankViewZhCn._(_root);
	@override late final _StringsStateViewZhCn stateView = _StringsStateViewZhCn._(_root);
	@override late final _StringsTlMatchViewZhCn tlMatchView = _StringsTlMatchViewZhCn._(_root);
	@override late final _StringsCalcDestinationZhCn calcDestination = _StringsCalcDestinationZhCn._(_root);
	@override late final _StringsInfoDestinationZhCn infoDestination = _StringsInfoDestinationZhCn._(_root);
	@override late final _StringsLeaderboardsDestinationZhCn leaderboardsDestination = _StringsLeaderboardsDestinationZhCn._(_root);
	@override late final _StringsSavedDataDestinationZhCn savedDataDestination = _StringsSavedDataDestinationZhCn._(_root);
	@override late final _StringsSettingsDestinationZhCn settingsDestination = _StringsSettingsDestinationZhCn._(_root);
	@override late final _StringsHomeNavigationZhCn homeNavigation = _StringsHomeNavigationZhCn._(_root);
	@override late final _StringsGraphsNavigationZhCn graphsNavigation = _StringsGraphsNavigationZhCn._(_root);
	@override late final _StringsCalcNavigationZhCn calcNavigation = _StringsCalcNavigationZhCn._(_root);
	@override late final _StringsFirstTimeViewZhCn firstTimeView = _StringsFirstTimeViewZhCn._(_root);
	@override late final _StringsAboutViewZhCn aboutView = _StringsAboutViewZhCn._(_root);
	@override late final _StringsStatsZhCn stats = _StringsStatsZhCn._(_root);
	@override Map<String, String> get countries => {
		'': '全球',
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
		'BO': '玻利维亚',
		'BA': '波黑',
		'BW': '博茨瓦纳',
		'BV': '布韦岛',
		'BR': '巴西',
		'IO': '英属印度洋领地',
		'BN': '文莱',
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
		'CC': '科科斯群岛',
		'CO': '哥伦比亚',
		'KM': '科摩罗',
		'CG': '刚果（布）',
		'CD': '刚果（金）',
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
		'DM': '多米尼克',
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
		'FK': '福克兰群岛 (马尔维纳斯)',
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
		'GL': '格陵兰',
		'GD': '格林纳达',
		'GP': '瓜德罗普',
		'GU': '关岛',
		'GT': '危地马拉',
		'GG': '根西',
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
		'ID': '印尼',
		'IR': '伊朗',
		'IQ': '伊拉克',
		'IE': '爱尔兰',
		'IM': '马恩岛',
		'IL': '以色列',
		'IT': '意大利',
		'JM': '牙买加',
		'JP': '日本',
		'JE': '泽西',
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
		'LV': '拉托维亚',
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
		'MQ': '马提尼克',
		'MR': '毛里塔尼亚',
		'MU': '毛里求斯',
		'YT': '马约特岛',
		'MX': '墨西哥',
		'FM': '密克罗尼西亚',
		'MD': '摩尔多瓦',
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
		'NL': '荷兰',
		'AN': '荷属安地列斯',
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
		'PR': '波多黎哥',
		'QA': '卡塔尔',
		'RE': '留尼汪',
		'RO': '罗马尼亚',
		'RU': '俄罗斯',
		'RW': '卢旺达',
		'BL': '圣巴泰勒米',
		'SH': '圣赫勒拿-阿森松-特里斯坦达库尼亚',
		'KN': '圣基茨和尼维斯',
		'LC': '圣卢西亚',
		'MF': '圣马丁',
		'PM': '圣皮埃尔和密克隆',
		'VC': '圣文森特和格林纳丁斯',
		'WS': '萨摩亚',
		'SM': '圣马利诺',
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
		'SB': '所罗门',
		'SO': '索马里',
		'ZA': '南非',
		'GS': '南乔治亚和南桑威奇',
		'SS': '南苏丹',
		'ES': '西班牙',
		'LK': '斯里兰卡',
		'SD': '苏丹',
		'SR': '苏里南',
		'SJ': '斯瓦尔巴和扬马延',
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
		'TC': '特克斯河凯科斯群岛',
		'TV': '图瓦卢',
		'UG': '乌干达',
		'UA': '乌克兰',
		'AE': '阿联酋',
		'GB': '英国',
		'US': '美国',
		'UY': '乌拉圭',
		'UM': '美国本土外小岛屿',
		'UZ': '乌兹别克斯坦',
		'VU': '瓦努阿图',
		'VE': '委内瑞拉',
		'VN': '越南',
		'VG': '英属维京群岛',
		'VI': '美属维京群岛',
		'GB-WLS': '威尔士',
		'WF': '瓦利斯群岛和富图纳群岛',
		'EH': '西撒哈拉',
		'YE': '也门',
		'ZM': '赞比亚',
		'ZW': '津巴布韦',
		'XX': '未知',
		'XM': '月球',
	};
}

// Path: destinations
class _StringsDestinationsZhCn implements _StringsDestinationsEn {
	_StringsDestinationsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get home => '主页';
	@override String get graphs => '图表';
	@override String get leaderboards => '排行榜';
	@override String get cutoffs => '段位分界线';
	@override String get calc => '计算器';
	@override String get info => '信息中心';
	@override String get data => '已保存的数据';
	@override String get settings => '设置';
}

// Path: xp
class _StringsXpZhCn implements _StringsXpEn {
	_StringsXpZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '经验等级';
	@override String progressToNextLevel({required Object percentage}) => '到下一等级的进度：${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => '从0级到${goal}级的进度：${percentage} (还差 ${left} 点经验值)';
}

// Path: gametime
class _StringsGametimeZhCn implements _StringsGametimeEn {
	_StringsGametimeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '精确游戏时长';
	@override String gametimeAday({required Object gametime}) => '平均每天${gametime}';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => '相当于 ${years} 年，\n${months} 月，\n${days} 天，\n${minutes} 分钟，\n${seconds} 秒';
}

// Path: matchResult
class _StringsMatchResultZhCn implements _StringsMatchResultEn {
	_StringsMatchResultZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get victory => '胜利';
	@override String get defeat => '失败';
	@override String get tie => '平局';
	@override String get dqvictory => '对手被取消资格';
	@override String get dqdefeat => '被取消资格';
	@override String get nocontest => '无竞赛记录';
	@override String get nullified => '竞赛记录已取消';
}

// Path: distinguishments
class _StringsDistinguishmentsZhCn implements _StringsDistinguishmentsEn {
	_StringsDistinguishmentsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noHeader => '缺少标题';
	@override String get noFooter => '缺少标题';
	@override String get twc => 'TETR.IO 世界冠军';
	@override String twcYear({required Object year}) => '${year} TETR.IO 世界杯';
}

// Path: newsEntries
class _StringsNewsEntriesZhCn implements _StringsNewsEntriesEn {
	_StringsNewsEntriesZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override TextSpan leaderboard({required InlineSpan gametype, required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: '在'),
		gametype,
		const TextSpan(text: '中荣获第'),
		rank,
		const TextSpan(text: '名'),
	]);
	@override TextSpan personalbest({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
		const TextSpan(text: '在'),
		gametype,
		const TextSpan(text: '中取得新纪录：'),
		pb,
	]);
	@override TextSpan badge({required InlineSpan badge}) => TextSpan(children: [
		const TextSpan(text: '获得勋章 '),
		badge,
	]);
	@override TextSpan rankup({required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: '升 '),
		rank,
	]);
	@override TextSpan supporter({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: '成为'),
		s('TETR.IO supporter'),
	]);
	@override TextSpan supporter_gift({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: '被赠送'),
		s('TETR.IO supporter'),
	]);
	@override TextSpan unknown({required InlineSpan type}) => TextSpan(children: [
		const TextSpan(text: '未知新闻类型 '),
		type,
	]);
}

// Path: snackBarMessages
class _StringsSnackBarMessagesZhCn implements _StringsSnackBarMessagesEn {
	_StringsSnackBarMessagesZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => '成功移除${date}时的状态！';
	@override String matchRemoved({required Object date}) => '成功移除${date}时的一局！';
	@override String get notForWeb => '此功能在网络版本中不可用';
	@override String get importSuccess => '导入成功';
	@override String get importCancelled => '导入已取消';
}

// Path: errors
class _StringsErrorsZhCn implements _StringsErrorsEn {
	_StringsErrorsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noRecords => '暂无记录';
	@override String get notEnoughData => '数据不足';
	@override String get noHistorySaved => '没有保存历史记录';
	@override String connection({required Object code, required Object message}) => '连接错误：${code} ${message}';
	@override String get noSuchUser => '用户不存在';
	@override String get noSuchUserSub => '您输入的内容有误，或者用户不存在';
	@override String get discordNotAssigned => '没有指定Discord ID的用户';
	@override String get discordNotAssignedSub => '请确保您提供了有效的 ID';
	@override String get history => '缺少该玩家的历史';
	@override String get actionSuggestion => '也许，您想要';
	@override String get p1nkl0bst3rTLmatches => '没有找到Tetra联赛比赛';
	@override String get clientException => '你尚未连接';
	@override String get forbidden => '您的 IP 地址已被封禁';
	@override String forbiddenSub({required Object nickname}) => '如果你在使用VPN，请关闭。如果仍然不可以，请联系${nickname}';
	@override String get tooManyRequests => '您的评分已经被限制';
	@override String get tooManyRequestsSub => '请稍后重试';
	@override String get internal => 'TETR.IO 出现了问题！';
	@override String get internalSub => 'osk，或许，已经知道了';
	@override String get internalWebVersion => 'TETR.IO （也许是oskware_bridge，我不知道到底是哪儿） 出现了问题！';
	@override String get internalWebVersionSub => '如果 osk status 页面显示一切都很正常，请联系dan63047';
	@override String get oskwareBridge => 'oskware_bridge 出现了问题！';
	@override String get oskwareBridgeSub => '请联系dan63047';
	@override String get p1nkl0bst3rForbidden => '第三方API屏蔽了您的 IP 地址';
	@override String get p1nkl0bst3rTooManyRequests => '第三方API请求过多，请稍后再试';
	@override String get p1nkl0bst3rinternal => 'p1nkl0bst3r 那边出现了问题！';
	@override String get p1nkl0bst3rinternalWebVersion => 'p1nkl0bst3r 那边（也许是oskware_bridge，我不知道到底是哪儿）出现了问题！';
	@override String get replayAlreadySaved => '回放已保存';
	@override String get replayExpired => '回放已过期或不再可用';
	@override String get replayRejected => '第三方API屏蔽了您的 IP 地址';
}

// Path: actions
class _StringsActionsZhCn implements _StringsActionsEn {
	_StringsActionsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get submit => '确定';
	@override String get ok => '确定';
	@override String get apply => '应用';
	@override String get refresh => '刷新';
}

// Path: graphsDestination
class _StringsGraphsDestinationZhCn implements _StringsGraphsDestinationEn {
	_StringsGraphsDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get fetchAndsaveTLHistory => '获取玩家历史';
	@override String get fetchAndSaveOldTLmatches => '获取 Tetra 联赛历史记录';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '找到 ${number} 个状态';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '找到 ${number} 场比赛';
	@override String gamesPlayed({required Object games}) => '游玩次数：${games}';
	@override String get dateAndTime => '日期和时间';
	@override String get filterModaleTitle => '在图表上筛选等级';
}

// Path: filterModale
class _StringsFilterModaleZhCn implements _StringsFilterModaleEn {
	_StringsFilterModaleZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get all => '全部';
}

// Path: cutoffsDestination
class _StringsCutoffsDestinationZhCn implements _StringsCutoffsDestinationEn {
	_StringsCutoffsDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tetra 联赛 状态';
	@override String relevance({required Object timestamp}) => '${timestamp}';
	@override String get actual => '实际';
	@override String get target => '目标';
	@override String get cutoffTR => '分段 TR';
	@override String get targetTR => '目标 TR';
	@override String get state => '状态';
	@override String get advanced => '高级选项';
	@override String players({required Object n}) => '玩家（${n}）';
	@override String get moreInfo => '更多信息';
	@override String NumberOne({required Object tr}) => '№ 1 is ${tr} TR';
	@override String inflated({required Object tr}) => '高于目标 ${tr}';
	@override String get notInflated => '不偏高';
	@override String deflated({required Object tr}) => '低于目标 ${tr}';
	@override String get notDeflated => '不偏低';
	@override String get wellDotDotDot => '嗯…';
	@override String fromPlace({required Object n}) => '自 № ${n}';
	@override String get viewButton => '查看';
}

// Path: rankView
class _StringsRankViewZhCn implements _StringsRankViewEn {
	_StringsRankViewZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String rankTitle({required Object rank}) => '${rank} 段数据';
	@override String get everyoneTitle => '全部排行榜';
	@override String get trRange => 'TR 范围';
	@override String get supposedToBe => '应为';
	@override String gap({required Object value}) => '相差 ${value}';
	@override String trGap({required Object value}) => '相差 ${value} TR';
	@override String get deflationGap => '偏低量';
	@override String get inflationGap => '偏高量';
	@override String get LBposRange => '排行榜位置范围';
	@override String overpopulated({required Object players}) => '比期望的多 ${players}';
	@override String underpopulated({required Object players}) => '比期望的少 ${players}';
	@override String get PlayersEqualSupposedToBe => '符合';
	@override String get avgStats => '平均数据';
	@override String avgForRank({required Object rank}) => '${rank} 段平均数据';
	@override String get avgNerdStats => '平均详细信息';
	@override String get minimums => '最小值';
	@override String get maximums => '最大值';
}

// Path: stateView
class _StringsStateViewZhCn implements _StringsStateViewEn {
	_StringsStateViewZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => '${date}的状态';
}

// Path: tlMatchView
class _StringsTlMatchViewZhCn implements _StringsTlMatchViewEn {
	_StringsTlMatchViewZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get match => '匹配';
	@override String get vs => 'vs';
	@override String get winner => '获胜者';
	@override String roundNumber({required Object n}) => '第${n}回合';
	@override String get statsFor => '状态';
	@override String get numberOfRounds => '回合数';
	@override String get matchLength => '比赛时长';
	@override String get roundLength => '回合时长';
	@override String get matchStats => '比赛数据';
	@override String get downloadReplay => '下载 .ttrm 回放';
	@override String get openReplay => '在 TETR.IO 中打开回放';
}

// Path: calcDestination
class _StringsCalcDestinationZhCn implements _StringsCalcDestinationEn {
	_StringsCalcDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => '输入你的${stat}';
	@override String get tip => '输入值并按 "计算" 来查看TA的详细信息';
	@override String get statsCalcButton => '计算';
	@override String get damageCalcTip => '点击左侧的操作在此添加';
	@override String get actions => '操作';
	@override String get results => '结果';
	@override String get rules => '规则';
	@override String get noSpinClears => '非 Spin 清除';
	@override String get spins => 'Spin';
	@override String get miniSpins => 'Mini spin';
	@override String get noLineclear => '无清除（连消结束）';
	@override String get custom => '自定义';
	@override String get multiplier => '倍增';
	@override String get pcDamage => '全消伤害';
	@override String get comboTable => '连击';
	@override String get b2bChaining => 'B2B增伤';
	@override String get surgeStartAtB2B => '开始于B2B';
	@override String get surgeStartAmount => '初始值';
	@override String get totalDamage => '累计伤害';
	@override String get lineclears => '清除行数';
	@override String get combo => '连击';
	@override String get surge => 'B2B充能';
	@override String get pcs => '全消';
}

// Path: infoDestination
class _StringsInfoDestinationZhCn implements _StringsInfoDestinationEn {
	_StringsInfoDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '信息中心';
	@override String get sprintAndBlitzAverages => '40 行 & 闪电战平均数据';
	@override String get sprintAndBlitzAveragesDescription => '计算40 行 & 闪电战平均数据是个很繁琐的过程，所以很久才会更新一次。 点击标题查看完整的 40 行 & 闪电战平均数据表';
	@override String get tetraStatsWiki => 'Tetra Stats Wiki';
	@override String get tetraStatsWikiDescription => '查看更多关于Tetra Stats提供的功能和数据';
	@override String get about => '关于 Tetra Stats';
	@override String get aboutDescription => '由 dan63 开发';
}

// Path: leaderboardsDestination
class _StringsLeaderboardsDestinationZhCn implements _StringsLeaderboardsDestinationEn {
	_StringsLeaderboardsDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '排行榜';
	@override String get tl => 'Tetra 联赛（当前赛季）';
	@override String get fullTL => 'Tetra 联赛（当前赛季，完整）';
	@override String get ar => '成就点';
}

// Path: savedDataDestination
class _StringsSavedDataDestinationZhCn implements _StringsSavedDataDestinationEn {
	_StringsSavedDataDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '已保存的数据';
	@override String get tip => '选择左边的昵称以查看与之相关的数据';
	@override String seasonTLstates({required Object s}) => '第${s}赛季状态';
	@override String get TLrecords => '联赛记录';
}

// Path: settingsDestination
class _StringsSettingsDestinationZhCn implements _StringsSettingsDestinationEn {
	_StringsSettingsDestinationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '设置';
	@override String get general => '常规';
	@override String get customization => '自定义设置';
	@override String get database => '本地数据库';
	@override String get checking => '正在检查...';
	@override String get enterToSubmit => '按回车键提交';
	@override String get account => '您的 TETR.IO 账号';
	@override String get accountDescription => '该玩家的状态将在启动此应用后立即加载。 默认情况下，它会加载我的数据。如要更改，请在此输入您的昵称。';
	@override String get done => '完成！';
	@override String get noSuchAccount => '账号不存在';
	@override String get language => '语言';
	@override String languageDescription({required Object languages}) => 'Tetra Stats 有${languages}。默认情况下，应用程序将选择您的系统语言，如果您的系统区域设置不可用，则选择英语。';
	@override String languages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '0种语言',
		one: '${n}种语言',
		two: '${n}种语言',
		few: '${n}种语言',
		many: '${n}种语言',
		other: '${n}种语言',
	);
	@override String get updateInTheBackground => '后台更新数据';
	@override String get updateInTheBackgroundDescription => '如果开启，Tetra Stats将尝试在缓存过期后查询新信息。通常一次/5分钟。';
	@override String get compareStats => '将TL数据与段位平均水平作比较';
	@override String get compareStatsDescription => '如果开启，Tetra Stats将提供额外的量度，使您能够将自己与普通玩家的等级相比较。 你看到它的方式——统计信息将以相应的颜色高亮，用光标悬停在它们上面以获取更多信息。';
	@override String get showPosition => '显示排行榜中的位置';
	@override String get showPositionDescription => '这可能需要一些时间(和流量)，但您可以看到您在排行榜上的位置，按数据排序';
	@override String get accentColor => '主题色';
	@override String get accentColorDescription => '这种颜色会在这个应用上可见，而且通常会高亮显示交互界面元素。';
	@override String get accentColorModale => '选取主题色';
	@override String get timestamps => '时间戳格式';
	@override String timestampsDescriptionPart1({required Object d}) => '您可以选择时间戳显示时间的方式。默认情况下，它们以 GMT 时区显示时间，并根据所选区域设置进行格式设置，例如：${d}。';
	@override String timestampsDescriptionPart2({required Object y, required Object r}) => '这里还有：\n• 以您的时区设置的区域设置：${y}\n• 相对时间戳：${r}';
	@override String get timestampsAbsoluteGMT => 'GMT';
	@override String get timestampsAbsoluteLocalTime => '您的时区';
	@override String get timestampsRelative => '相对';
	@override String get sheetbotLikeGraphs => 'Sheetbot 型雷达图';
	@override String get sheetbotLikeGraphsDescription => '尽管我认为，图表在 SheetBot 中的工作方式不是很正确，有些人感到困惑，那 -0.5 Stride 看起来不像它在 SheetBot 图表上那样。因此，我们这里有：如果开启，则如果数值为负，则图形上的点可以出现在图形的另一半。';
	@override String get oskKagariGimmick => 'Osk-Kagari';
	@override String get oskKagariGimmickDescription => '如果开启，osk的段位会显示为:kagari:';
	@override String get bytesOfDataStored => '存储数据';
	@override String get TLrecordsSaved => '已保存 Tetra 联赛记录';
	@override String get TLplayerstatesSaved => '已保存 Tetra 联赛玩家状态';
	@override String get fixButton => '修复';
	@override String get compressButton => '压缩';
	@override String get exportDB => '导出本地数据库';
	@override String get desktopExportAlertTitle => '桌面导出';
	@override String get desktopExportText => '看起来您在桌面上使用了这个应用程序。请检查您的文档文件夹，您应该找到"TetraStats.db"。请将其复制到某处';
	@override String get androidExportAlertTitle => 'Android 导出';
	@override String androidExportText({required Object exportedDB}) => '已导出。\n${exportedDB}';
	@override String get importDB => '导入本地数据库';
	@override String get importDBDescription => '还原您的备份。请注意已存储的数据库将被覆盖。';
	@override String get importWrongFileType => '文件类型错误！';
}

// Path: homeNavigation
class _StringsHomeNavigationZhCn implements _StringsHomeNavigationEn {
	_StringsHomeNavigationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get overview => '概览';
	@override String get standing => '名次';
	@override String get seasons => '赛季';
	@override String get mathces => '比赛场次';
	@override String get pb => '个人最佳';
	@override String get normal => '普通模式';
	@override String get expert => '专家模式';
	@override String get expertRecords => '专家模式记录';
}

// Path: graphsNavigation
class _StringsGraphsNavigationZhCn implements _StringsGraphsNavigationEn {
	_StringsGraphsNavigationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get history => '玩家历史记录';
	@override String get league => '联赛状态';
	@override String get cutoffs => '分段线历史';
}

// Path: calcNavigation
class _StringsCalcNavigationZhCn implements _StringsCalcNavigationEn {
	_StringsCalcNavigationZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get stats => '数据计算器';
	@override String get damage => '伤害计算器';
}

// Path: firstTimeView
class _StringsFirstTimeViewZhCn implements _StringsFirstTimeViewEn {
	_StringsFirstTimeViewZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get welcome => '欢迎使用 Tetra Stats';
	@override String get description => '服务，允许您跟踪TETR.IO的各种数据';
	@override String get nicknameQuestion => '您的昵称是？';
	@override String get inpuntHint => '在此处输入... (3-16个符号)';
	@override String get emptyInputError => '不能提交空字符串';
	@override String niceToSeeYou({required Object n}) => '很高兴见到你，${n}';
	@override String get letsTakeALook => '让我们看看您的统计资料...';
	@override String get skip => '跳过';
}

// Path: aboutView
class _StringsAboutViewZhCn implements _StringsAboutViewEn {
	_StringsAboutViewZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '关于 Tetra Stats';
	@override String get about => 'Tetra Stats是一种服务，与TETR.IO Tetra Channel API共用，提供数据并根据这种数据计算一些附加度量。 服务允许用户用"Track"功能跟踪他们在Tetra League中的进度，这个功能记录每个Tetra Leage更改到本地数据库(非自动) 您必须不时地访问服务。这样，这些更改可以通过图表来查看。\n\nBeanserver blaster 是Tetra Stats的一部分，它被拆解成服务器侧脚本。 它提供完整的Tetra League排行榜，允许Tetra Stats通过任何公式对排行榜进行排序并生成散点图，这允许用户分析Tetra联赛趋势。 它还提供了Tetra League 的评分历史，用户也可以通过图表看到。\n\n我们有一个添加回放分析和锦标赛历史记录的计划，所以随时关注！\n\n服务没有与TETR.IO与osk以任何身份关联。';
	@override String get appVersion => '版本';
	@override String build({required Object build}) => '${build}';
	@override String get GHrepo => 'GitHub Repository';
	@override String get submitAnIssue => '提交问题';
	@override String get credits => '鸣谢';
	@override String get authorAndDeveloper => '作者 & 开发者';
	@override String get providedFormulas => '提供的公式';
	@override String get providedS1history => '提供的 S1 历史';
	@override String get inoue => 'Inoue (回放抓取器)';
	@override String get zhCNlocale => '简中翻译员';
	@override String get supportHim => '为他提供支持！';
}

// Path: stats
class _StringsStatsZhCn implements _StringsStatsEn {
	_StringsStatsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => '注册时间';
	@override String get gametime => '游玩时长';
	@override String get ogp => '在线游戏次数';
	@override String get ogw => '在线游戏胜利次数';
	@override String get followers => '粉丝';
	@override late final _StringsStatsXpZhCn xp = _StringsStatsXpZhCn._(_root);
	@override late final _StringsStatsTrZhCn tr = _StringsStatsTrZhCn._(_root);
	@override late final _StringsStatsGlickoZhCn glicko = _StringsStatsGlickoZhCn._(_root);
	@override late final _StringsStatsRdZhCn rd = _StringsStatsRdZhCn._(_root);
	@override late final _StringsStatsGlixareZhCn glixare = _StringsStatsGlixareZhCn._(_root);
	@override late final _StringsStatsS1trZhCn s1tr = _StringsStatsS1trZhCn._(_root);
	@override late final _StringsStatsGpZhCn gp = _StringsStatsGpZhCn._(_root);
	@override late final _StringsStatsGwZhCn gw = _StringsStatsGwZhCn._(_root);
	@override late final _StringsStatsWinrateZhCn winrate = _StringsStatsWinrateZhCn._(_root);
	@override late final _StringsStatsApmZhCn apm = _StringsStatsApmZhCn._(_root);
	@override late final _StringsStatsPpsZhCn pps = _StringsStatsPpsZhCn._(_root);
	@override late final _StringsStatsVsZhCn vs = _StringsStatsVsZhCn._(_root);
	@override late final _StringsStatsAppZhCn app = _StringsStatsAppZhCn._(_root);
	@override late final _StringsStatsVsapmZhCn vsapm = _StringsStatsVsapmZhCn._(_root);
	@override late final _StringsStatsDssZhCn dss = _StringsStatsDssZhCn._(_root);
	@override late final _StringsStatsDspZhCn dsp = _StringsStatsDspZhCn._(_root);
	@override late final _StringsStatsAppdspZhCn appdsp = _StringsStatsAppdspZhCn._(_root);
	@override late final _StringsStatsCheeseZhCn cheese = _StringsStatsCheeseZhCn._(_root);
	@override late final _StringsStatsGbeZhCn gbe = _StringsStatsGbeZhCn._(_root);
	@override late final _StringsStatsNyaappZhCn nyaapp = _StringsStatsNyaappZhCn._(_root);
	@override late final _StringsStatsAreaZhCn area = _StringsStatsAreaZhCn._(_root);
	@override late final _StringsStatsEtrZhCn etr = _StringsStatsEtrZhCn._(_root);
	@override late final _StringsStatsEtraccZhCn etracc = _StringsStatsEtraccZhCn._(_root);
	@override late final _StringsStatsOpenerZhCn opener = _StringsStatsOpenerZhCn._(_root);
	@override late final _StringsStatsPlonkZhCn plonk = _StringsStatsPlonkZhCn._(_root);
	@override late final _StringsStatsStrideZhCn stride = _StringsStatsStrideZhCn._(_root);
	@override late final _StringsStatsInfdsZhCn infds = _StringsStatsInfdsZhCn._(_root);
	@override late final _StringsStatsAltitudeZhCn altitude = _StringsStatsAltitudeZhCn._(_root);
	@override late final _StringsStatsClimbSpeedZhCn climbSpeed = _StringsStatsClimbSpeedZhCn._(_root);
	@override late final _StringsStatsPeakClimbSpeedZhCn peakClimbSpeed = _StringsStatsPeakClimbSpeedZhCn._(_root);
	@override late final _StringsStatsKosZhCn kos = _StringsStatsKosZhCn._(_root);
	@override late final _StringsStatsB2bZhCn b2b = _StringsStatsB2bZhCn._(_root);
	@override late final _StringsStatsFinesseZhCn finesse = _StringsStatsFinesseZhCn._(_root);
	@override late final _StringsStatsFinesseFaultsZhCn finesseFaults = _StringsStatsFinesseFaultsZhCn._(_root);
	@override late final _StringsStatsTotalTimeZhCn totalTime = _StringsStatsTotalTimeZhCn._(_root);
	@override late final _StringsStatsLevelZhCn level = _StringsStatsLevelZhCn._(_root);
	@override late final _StringsStatsPiecesZhCn pieces = _StringsStatsPiecesZhCn._(_root);
	@override late final _StringsStatsSppZhCn spp = _StringsStatsSppZhCn._(_root);
	@override late final _StringsStatsKpZhCn kp = _StringsStatsKpZhCn._(_root);
	@override late final _StringsStatsKppZhCn kpp = _StringsStatsKppZhCn._(_root);
	@override late final _StringsStatsKpsZhCn kps = _StringsStatsKpsZhCn._(_root);
	@override String blitzScore({required Object p}) => '${p} 分';
	@override String levelUpRequirement({required Object p}) => '还需 ${p} 升到下一级';
	@override String get piecesTotal => '放块总数';
	@override String get piecesWithPerfectFinesse => '极简块数';
	@override String get score => '分数';
	@override String get lines => '行数';
	@override String get linesShort => '行';
	@override String get pcs => '全消数';
	@override String get holds => '暂存数';
	@override String get spike => '最高暴击';
	@override String top({required Object percentage}) => '前 ${percentage}';
	@override String topRank({required Object rank}) => '最高段位：${rank}';
	@override String get floor => '层';
	@override String get split => '拆分';
	@override String get total => '总计';
	@override String get sent => '已发送';
	@override String get received => '已接收';
	@override String get placement => '排名';
	@override String get peak => '最高';
	@override String qpWithMods({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		one: '使用 1 个模组',
		two: '使用 ${n} 个模组',
		few: '使用 ${n} 个模组',
		many: '使用 ${n} 个模组',
		other: '使用 ${n} 个模组',
	);
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '${n} 按键',
		one: '${n} 按键',
		two: '${n} 按键',
		few: '${n} 按键',
		many: '${n} 按键',
		other: '${n} 按键',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '总共 ${n} 次T旋',
		one: '总共 ${n} 次T旋',
		two: '总共 ${n} 次T旋',
		few: '总共 ${n} 次T旋',
		many: '总共 ${n} 次T旋',
		other: '总共 ${n} 次T旋',
	);
	@override String linesCleared({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '总共消除 ${n} 行',
		one: '总共消除 ${n} 行',
		two: '总共消除 ${n} 行',
		few: '总共消除 ${n} 行',
		many: '总共消除 ${n} 行',
		other: '总共消除 ${n} 行',
	);
	@override late final _StringsStatsGraphsZhCn graphs = _StringsStatsGraphsZhCn._(_root);
	@override String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '${n} 名玩家',
		one: '${n} 名玩家',
		two: '${n} 名玩家',
		few: '${n} 名玩家',
		many: '${n} 名玩家',
		other: '${n} 名玩家',
	);
	@override String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		zero: '${n} 次游戏',
		one: '${n} 次游戏',
		two: '${n} 次游戏',
		few: '${n} 次游戏',
		many: '${n} 次游戏',
		other: '${n} 次游戏',
	);
	@override late final _StringsStatsLineClearZhCn lineClear = _StringsStatsLineClearZhCn._(_root);
	@override late final _StringsStatsLineClearsZhCn lineClears = _StringsStatsLineClearsZhCn._(_root);
	@override String get mini => 'Mini';
	@override String get tSpin => 'T-spin';
	@override String get tSpins => 'T-spins';
	@override String get spin => 'Spin';
	@override String get spins => 'Spins';
}

// Path: stats.xp
class _StringsStatsXpZhCn implements _StringsStatsXpEn {
	_StringsStatsXpZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '经验值';
	@override String get full => '经验点';
}

// Path: stats.tr
class _StringsStatsTrZhCn implements _StringsStatsTrEn {
	_StringsStatsTrZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => 'Tetra 评分';
}

// Path: stats.glicko
class _StringsStatsGlickoZhCn implements _StringsStatsGlickoEn {
	_StringsStatsGlickoZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => 'Glicko';
}

// Path: stats.rd
class _StringsStatsRdZhCn implements _StringsStatsRdEn {
	_StringsStatsRdZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'RD';
	@override String get full => '评分偏差';
}

// Path: stats.glixare
class _StringsStatsGlixareZhCn implements _StringsStatsGlixareEn {
	_StringsStatsGlixareZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _StringsStatsS1trZhCn implements _StringsStatsS1trEn {
	_StringsStatsS1trZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'S1 TR';
	@override String get full => '第 1 赛季式 TR';
}

// Path: stats.gp
class _StringsStatsGpZhCn implements _StringsStatsGpEn {
	_StringsStatsGpZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GP';
	@override String get full => '总场数';
}

// Path: stats.gw
class _StringsStatsGwZhCn implements _StringsStatsGwEn {
	_StringsStatsGwZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GW';
	@override String get full => '胜场数';
}

// Path: stats.winrate
class _StringsStatsWinrateZhCn implements _StringsStatsWinrateEn {
	_StringsStatsWinrateZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'WR%';
	@override String get full => '胜率';
}

// Path: stats.apm
class _StringsStatsApmZhCn implements _StringsStatsApmEn {
	_StringsStatsApmZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => '每分钟攻击数';
}

// Path: stats.pps
class _StringsStatsPpsZhCn implements _StringsStatsPpsEn {
	_StringsStatsPpsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => '每秒块数';
}

// Path: stats.vs
class _StringsStatsVsZhCn implements _StringsStatsVsEn {
	_StringsStatsVsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => 'VS 分数';
}

// Path: stats.app
class _StringsStatsAppZhCn implements _StringsStatsAppEn {
	_StringsStatsAppZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => '每块攻击数';
}

// Path: stats.vsapm
class _StringsStatsVsapmZhCn implements _StringsStatsVsapmEn {
	_StringsStatsVsapmZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _StringsStatsDssZhCn implements _StringsStatsDssEn {
	_StringsStatsDssZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => '每秒挖掘数';
}

// Path: stats.dsp
class _StringsStatsDspZhCn implements _StringsStatsDspEn {
	_StringsStatsDspZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => '每块挖掘数';
}

// Path: stats.appdsp
class _StringsStatsAppdspZhCn implements _StringsStatsAppdspEn {
	_StringsStatsAppdspZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _StringsStatsCheeseZhCn implements _StringsStatsCheeseEn {
	_StringsStatsCheeseZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'CI';
	@override String get full => '垃圾行混乱指数';
}

// Path: stats.gbe
class _StringsStatsGbeZhCn implements _StringsStatsGbeEn {
	_StringsStatsGbeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => '垃圾行效率';
}

// Path: stats.nyaapp
class _StringsStatsNyaappZhCn implements _StringsStatsNyaappEn {
	_StringsStatsNyaappZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => '加权APP';
}

// Path: stats.area
class _StringsStatsAreaZhCn implements _StringsStatsAreaEn {
	_StringsStatsAreaZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '面积';
	@override String get full => '面积';
}

// Path: stats.etr
class _StringsStatsEtrZhCn implements _StringsStatsEtrEn {
	_StringsStatsEtrZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => '预测 TR';
}

// Path: stats.etracc
class _StringsStatsEtraccZhCn implements _StringsStatsEtraccEn {
	_StringsStatsEtraccZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => '预测实际差量';
}

// Path: stats.opener
class _StringsStatsOpenerZhCn implements _StringsStatsOpenerEn {
	_StringsStatsOpenerZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '定式';
	@override String get full => '定式';
}

// Path: stats.plonk
class _StringsStatsPlonkZhCn implements _StringsStatsPlonkEn {
	_StringsStatsPlonkZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '太极';
	@override String get full => '太极';
}

// Path: stats.stride
class _StringsStatsStrideZhCn implements _StringsStatsStrideEn {
	_StringsStatsStrideZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '速度';
	@override String get full => '速度';
}

// Path: stats.infds
class _StringsStatsInfdsZhCn implements _StringsStatsInfdsEn {
	_StringsStatsInfdsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '挖掘';
	@override String get full => '挖掘';
}

// Path: stats.altitude
class _StringsStatsAltitudeZhCn implements _StringsStatsAltitudeEn {
	_StringsStatsAltitudeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'm';
	@override String get full => '高度';
}

// Path: stats.climbSpeed
class _StringsStatsClimbSpeedZhCn implements _StringsStatsClimbSpeedEn {
	_StringsStatsClimbSpeedZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'CSP';
	@override String get full => '爬行速度';
	@override String get gaugetTitle => '爬行速度';
}

// Path: stats.peakClimbSpeed
class _StringsStatsPeakClimbSpeedZhCn implements _StringsStatsPeakClimbSpeedEn {
	_StringsStatsPeakClimbSpeedZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '最高CSP';
	@override String get full => '最高爬行速度';
	@override String get gaugetTitle => '最高';
}

// Path: stats.kos
class _StringsStatsKosZhCn implements _StringsStatsKosEn {
	_StringsStatsKosZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KO\'s';
	@override String get full => '击杀';
}

// Path: stats.b2b
class _StringsStatsB2bZhCn implements _StringsStatsB2bEn {
	_StringsStatsB2bZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => '背靠背/满贯';
}

// Path: stats.finesse
class _StringsStatsFinesseZhCn implements _StringsStatsFinesseEn {
	_StringsStatsFinesseZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '极';
	@override String get full => '极简率';
	@override String get widgetTitle => '简率';
}

// Path: stats.finesseFaults
class _StringsStatsFinesseFaultsZhCn implements _StringsStatsFinesseFaultsEn {
	_StringsStatsFinesseFaultsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '非极简';
	@override String get full => '非极简操作数';
}

// Path: stats.totalTime
class _StringsStatsTotalTimeZhCn implements _StringsStatsTotalTimeEn {
	_StringsStatsTotalTimeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '时长';
	@override String get full => '总时长';
	@override String get widgetTitle => '总时长';
}

// Path: stats.level
class _StringsStatsLevelZhCn implements _StringsStatsLevelEn {
	_StringsStatsLevelZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'Lvl';
	@override String get full => '等级';
}

// Path: stats.pieces
class _StringsStatsPiecesZhCn implements _StringsStatsPiecesEn {
	_StringsStatsPiecesZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => '块';
}

// Path: stats.spp
class _StringsStatsSppZhCn implements _StringsStatsSppEn {
	_StringsStatsSppZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => '每块得分';
}

// Path: stats.kp
class _StringsStatsKpZhCn implements _StringsStatsKpEn {
	_StringsStatsKpZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => '按键';
}

// Path: stats.kpp
class _StringsStatsKppZhCn implements _StringsStatsKppEn {
	_StringsStatsKppZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => '每块按键数';
}

// Path: stats.kps
class _StringsStatsKpsZhCn implements _StringsStatsKpsEn {
	_StringsStatsKpsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => '每秒按键数';
}

// Path: stats.graphs
class _StringsStatsGraphsZhCn implements _StringsStatsGraphsEn {
	_StringsStatsGraphsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get attack => '攻击';
	@override String get speed => '速度';
	@override String get defense => '防御';
	@override String get cheese => '奶酪层';
}

// Path: stats.lineClear
class _StringsStatsLineClearZhCn implements _StringsStatsLineClearEn {
	_StringsStatsLineClearZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get single => 'Single';
	@override String get double => 'Double';
	@override String get triple => 'Triple';
	@override String get quad => 'Quad';
	@override String get penta => 'Penta';
	@override String get hexa => 'Hexa';
	@override String get hepta => 'Hepta';
	@override String get octa => 'Octa';
	@override String get ennea => 'Ennea';
	@override String get deca => 'Deca';
	@override String get hendeca => 'Hendeca';
	@override String get dodeca => 'Dodeca';
	@override String get triadeca => 'Triadeca';
	@override String get tessaradeca => 'Tessaradeca';
	@override String get pentedeca => 'Pentedeca';
	@override String get hexadeca => 'Hexadeca';
	@override String get heptadeca => 'Heptadeca';
	@override String get octadeca => 'Octadeca';
	@override String get enneadeca => 'Enneadeca';
	@override String get eicosa => 'Eicosa';
	@override String get kagaris => 'Kagaris';
}

// Path: stats.lineClears
class _StringsStatsLineClearsZhCn implements _StringsStatsLineClearsEn {
	_StringsStatsLineClearsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get zero => 'Zeros';
	@override String get single => 'Singles';
	@override String get double => 'Doubles';
	@override String get triple => 'Triples';
	@override String get quad => 'Quads';
	@override String get penta => 'Pentas';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'English';
			case 'locales.ru-RU': return 'Russian (Русский)';
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
			case 'playerRole.user': return 'User';
			case 'playerRole.banned': return 'Banned';
			case 'playerRole.bot': return 'Bot';
			case 'playerRole.sysop': return 'System operator';
			case 'playerRole.admin': return 'Admin';
			case 'playerRole.mod': return 'Moderator';
			case 'playerRole.halfmod': return 'Community moderator';
			case 'playerRole.anon': return 'Anonymous';
			case 'goBackButton': return 'Go Back';
			case 'nanow': return 'Not avaliable for now...';
			case 'seasonEnds': return ({required Object countdown}) => 'Season ends in ${countdown}';
			case 'seasonEnded': return 'Season has ended';
			case 'overallPB': return ({required Object pb}) => 'Overall PB: ${pb} m';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} games until being ranked';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} victories';
			case 'promotionOnNextWin': return 'Promotion on next win';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} defeats';
			case 'demotionOnNextLoss': return 'Demotion on next loss';
			case 'records': return 'Records';
			case 'nerdStats': return 'Nerd Stats';
			case 'playstyles': return 'Playstyles';
			case 'horoscopes': return 'Horoscopes';
			case 'relatedAchievements': return 'Related Achievements';
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
			case 'enterUsername': return 'Enter username or \$avgX (where X is rank)';
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
			case 'rankView.avgForRank': return ({required Object rank}) => 'Average for ${rank} rank';
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
			case 'calcDestination.placeholders': return ({required Object stat}) => 'Enter your ${stat}';
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
			case 'savedDataDestination.title': return 'Saved Data';
			case 'savedDataDestination.tip': return 'Select nickname on the left to see data assosiated with it';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => 'S${s} TL States';
			case 'savedDataDestination.TLrecords': return 'TL Records';
			case 'settingsDestination.title': return 'Settings';
			case 'settingsDestination.general': return 'General';
			case 'settingsDestination.customization': return 'Customization';
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
			case 'firstTimeView.emptyInputError': return 'Can\'t submit an empty string';
			case 'firstTimeView.niceToSeeYou': return ({required Object n}) => 'Nice to see you, ${n}';
			case 'firstTimeView.letsTakeALook': return 'Let\'s take a look at your stats...';
			case 'firstTimeView.skip': return 'Skip';
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
			case 'aboutView.zhCNlocale': return 'Simplfied Chinese locale';
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
			case 'stats.nyaapp.full': return 'Weighted APP';
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

extension on _StringsRuRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'Английский (English)';
			case 'locales.ru-RU': return 'Русский';
			case 'locales.zh-CN': return 'Упрощенный Китайский (简体中文)';
			case 'gamemodes.league': return 'Тетра Лига';
			case 'gamemodes.zenith': return 'Quick Play';
			case 'gamemodes.zenithex': return 'Quick Play Expert';
			case 'gamemodes.40l': return '40 линий';
			case 'gamemodes.blitz': return 'Блиц';
			case 'gamemodes.5mblast': return '5 000 000 бласт';
			case 'gamemodes.zen': return 'Дзен';
			case 'destinations.home': return 'Дом';
			case 'destinations.graphs': return 'Графики';
			case 'destinations.leaderboards': return 'Таблицы лидеров';
			case 'destinations.cutoffs': return 'Требования рангов';
			case 'destinations.calc': return 'Калькулятор';
			case 'destinations.info': return 'Инфо-центр';
			case 'destinations.data': return 'Сохранённые данные';
			case 'destinations.settings': return 'Настройки';
			case 'playerRole.user': return 'Пользователь';
			case 'playerRole.banned': return 'Заблокированный пользователь';
			case 'playerRole.bot': return 'Бот';
			case 'playerRole.sysop': return 'Системный оператор';
			case 'playerRole.admin': return 'Администратор';
			case 'playerRole.mod': return 'Модератор';
			case 'playerRole.halfmod': return 'Модератор сообщества';
			case 'playerRole.anon': return 'Аноним';
			case 'goBackButton': return 'Назад';
			case 'nanow': return 'Сейчас недоступно...';
			case 'seasonEnds': return ({required Object countdown}) => 'Сезон закончится через ${countdown}';
			case 'seasonEnded': return 'Сезон завершён';
			case 'overallPB': return ({required Object pb}) => 'Абсолютный рекорд: ${pb} м';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} матчей до получения рейтинга';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} побед';
			case 'promotionOnNextWin': return 'Повышение после следующей победы';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} поражений';
			case 'demotionOnNextLoss': return 'Понижение после следующего поражения';
			case 'records': return 'Записи';
			case 'nerdStats': return 'Для Задротов';
			case 'playstyles': return 'Стили игры';
			case 'horoscopes': return 'Гороскопы';
			case 'relatedAchievements': return 'Достижения режима';
			case 'season': return 'Сезон';
			case 'smooth': return 'Сглаживание';
			case 'dateAndTime': return 'Дата и время';
			case 'TLfullLBnote': return 'Большая, но позволяет сортировать игроков по их статам и фильтровать их по рангам';
			case 'rank': return 'Ранг';
			case 'verdictGeneral': return ({required Object n, required Object verdict, required Object rank}) => 'На ${n} ${verdict} среднего ${rank}';
			case 'verdictBetter': return 'впереди';
			case 'verdictWorse': return 'позади';
			case 'localStanding': return 'по стране';
			case 'xp.title': return 'Уровень Опыта';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => 'Прогресс до следующего уровня: ${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => 'Прогресс с 0 XP до уровня ${goal}: ${percentage} (${left} XP осталось)';
			case 'gametime.title': return 'Времени проведено в игре';
			case 'gametime.gametimeAday': return ({required Object gametime}) => '${gametime} в день в среднем';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'Это ${years} лет,\nили ${months} месяцев,\nили ${days} дней,\nили ${minutes} минут\nили ${seconds} секунд';
			case 'track': return 'Отслеживать';
			case 'stopTracking': return 'Не отслеживать';
			case 'supporter': return ({required Object tier}) => 'Спонсор ${tier}-го уровня';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => 'Данные от ${newDate} в сравнении с данными от ${oldDate}';
			case 'compare': return 'Сравнить';
			case 'comparison': return 'Сравнение';
			case 'enterUsername': return 'Введите ник или \$avgX (где X это ранг)';
			case 'general': return 'Основное';
			case 'badges': return 'Значки';
			case 'obtainDate': return ({required Object date}) => 'Получен ${date}';
			case 'assignedManualy': return 'Этот значок был присвоен вручную администрацией TETR.IO';
			case 'distinguishment': return 'Заслуга';
			case 'banned': return 'Забанен';
			case 'bannedSubtext': return 'Баны выдаются в случаях нарушений правил TETR.IO';
			case 'badStanding': return 'Плохая репутация';
			case 'badStandingSubtext': return 'Один или более банов на счету';
			case 'botAccount': return 'Бот аккаунт';
			case 'botAccountSubtext': return ({required Object botMaintainers}) => 'Операторы: ${botMaintainers}';
			case 'copiedToClipboard': return 'Скопировано в буфер обмена!';
			case 'bio': return 'Биография';
			case 'news': return 'Новости';
			case 'matchResult.victory': return 'Победа';
			case 'matchResult.defeat': return 'Поражение';
			case 'matchResult.tie': return 'Ничья';
			case 'matchResult.dqvictory': return 'Оппонент дисквалифицирован';
			case 'matchResult.dqdefeat': return 'Дисквалифицирован';
			case 'matchResult.nocontest': return 'Без согласия';
			case 'matchResult.nullified': return 'Отменен';
			case 'distinguishments.noHeader': return 'Заголовок отсутствует';
			case 'distinguishments.noFooter': return 'Подзаголовок отсуствует';
			case 'distinguishments.twc': return 'Чемпион мира TETR.IO';
			case 'distinguishments.twcYear': return ({required Object year}) => 'Чемпионат мира по TETR.IO ${year} года';
			case 'newsEntries.leaderboard': return ({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
				const TextSpan(text: 'Заработал №'),
				rank,
				const TextSpan(text: ' в режиме '),
				gametype,
			]);
			case 'newsEntries.personalbest': return ({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
				const TextSpan(text: 'Новый ЛР в '),
				gametype,
				const TextSpan(text: ': '),
				pb,
			]);
			case 'newsEntries.badge': return ({required InlineSpan badge}) => TextSpan(children: [
				const TextSpan(text: 'Заработал значок '),
				badge,
			]);
			case 'newsEntries.rankup': return ({required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: 'Заработал '),
				rank,
				const TextSpan(text: ' в Тетра Лиге'),
			]);
			case 'newsEntries.supporter': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Стал '),
				s('спонсором TETR.IO'),
			]);
			case 'newsEntries.supporter_gift': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Получил '),
				s('спонсорку TETR.IO'),
				const TextSpan(text: ' в качестве подарка'),
			]);
			case 'newsEntries.unknown': return ({required InlineSpan type}) => TextSpan(children: [
				const TextSpan(text: 'Неизвестная новость типа '),
				type,
			]);
			case 'rankupMiddle': return ({required Object r}) => '${r} ранг';
			case 'copyUserID': return 'Нажмите, чтобы скопировать ID';
			case 'searchHint': return 'Никнейм или ID';
			case 'navMenu': return 'Меню навигации';
			case 'navMenuTooltip': return 'Открыть меню навигации';
			case 'refresh': return 'Обновить данные';
			case 'searchButton': return 'Искать';
			case 'trackedPlayers': return 'Отслеживаемые игроки';
			case 'standing': return 'Положение';
			case 'previousSeasons': return 'Предыдущие сезоны';
			case 'recent': return 'Недавние';
			case 'top': return 'Топ';
			case 'noRecord': return 'Нет записи';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => 'Актуальность: ${date}';
			case 'snackBarMessages.stateRemoved': return ({required Object date}) => 'Состояние от ${date} удалено из базы данных!';
			case 'snackBarMessages.matchRemoved': return ({required Object date}) => 'Матч от ${date} удален из базы данных!';
			case 'snackBarMessages.notForWeb': return 'Функция недоступна для веб-версии';
			case 'snackBarMessages.importSuccess': return 'Импорт выполнен успешно';
			case 'snackBarMessages.importCancelled': return 'Импорт был отменен';
			case 'errors.noRecords': return 'Нет записей';
			case 'errors.notEnoughData': return 'Недостаточно данных';
			case 'errors.noHistorySaved': return 'Нет сохраненной истории';
			case 'errors.connection': return ({required Object code, required Object message}) => 'Проблема с подключением: ${code} ${message}';
			case 'errors.noSuchUser': return 'Нет такого пользователя';
			case 'errors.noSuchUserSub': return 'Либо вы опечатались, либо аккаунт больше не существует';
			case 'errors.discordNotAssigned': return 'К данному Discord ID не привязан аккаунт';
			case 'errors.discordNotAssignedSub': return 'Убедитесь, что указан правильный ID';
			case 'errors.history': return 'История этого игрока отсутствует';
			case 'errors.actionSuggestion': return 'Возможно, вы хотите';
			case 'errors.p1nkl0bst3rTLmatches': return 'Матчей Тетра Лиги не найдено';
			case 'errors.clientException': return 'Нет подключения к Интернету';
			case 'errors.forbidden': return 'Ваш IP-адрес заблокирован';
			case 'errors.forbiddenSub': return ({required Object nickname}) => 'Если вы используете VPN или Proxy, выключите его. Если это не помогает, свяжитесь с ${nickname}';
			case 'errors.tooManyRequests': return 'Слишком много запросов';
			case 'errors.tooManyRequestsSub': return 'Повторите попытку позже';
			case 'errors.internal': return 'Что-то случилось на стороне tetr.io';
			case 'errors.internalSub': return 'Скорее всего, osk уже в курсе';
			case 'errors.internalWebVersion': return 'Что-то случилось на стороне TETR.IO (или у oskware_bridge, я хз)';
			case 'errors.internalWebVersionSub': return 'Если на osk status page нет сообщений о проблемах, дайте знать dan63047';
			case 'errors.oskwareBridge': return 'Что-то случилось с oskware_bridge';
			case 'errors.oskwareBridgeSub': return 'Дайте знать dan63047';
			case 'errors.p1nkl0bst3rForbidden': return 'Сторонний API заблокировал ваш IP-адрес';
			case 'errors.p1nkl0bst3rTooManyRequests': return 'Слишком много запросов к стороннему API. Попробуйте позже';
			case 'errors.p1nkl0bst3rinternal': return 'Что-то случилось на стороне p1nkl0bst3r';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'Что-то случилось на стороне p1nkl0bst3r (или на oskware_bridge, я хз)';
			case 'errors.replayAlreadySaved': return 'Повтор уже был сохранен';
			case 'errors.replayExpired': return 'Повтор истек и больше не доступен';
			case 'errors.replayRejected': return 'Сторонний API заблокировал ваш IP-адрес';
			case 'actions.cancel': return 'Отменить';
			case 'actions.submit': return 'Подтвердить';
			case 'actions.ok': return 'ОК';
			case 'actions.apply': return 'Применить';
			case 'actions.refresh': return 'Обновить';
			case 'graphsDestination.fetchAndsaveTLHistory': return 'Получить историю игрока';
			case 'graphsDestination.fetchAndSaveOldTLmatches': return 'Получить историю матчей Тетра Лиги';
			case 'graphsDestination.fetchAndsaveTLHistoryResult': return ({required Object number}) => '${number} состояний было найдено';
			case 'graphsDestination.fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '${number} матчей было найдено';
			case 'graphsDestination.gamesPlayed': return ({required Object games}) => '${games} сыграно';
			case 'graphsDestination.dateAndTime': return 'Дата и время';
			case 'graphsDestination.filterModaleTitle': return 'Фильтровать график по рангам';
			case 'filterModale.all': return 'Все';
			case 'cutoffsDestination.title': return 'Состояние Тетра Лиги';
			case 'cutoffsDestination.relevance': return ({required Object timestamp}) => 'на момент ${timestamp}';
			case 'cutoffsDestination.actual': return 'Требование';
			case 'cutoffsDestination.target': return 'Цель';
			case 'cutoffsDestination.cutoffTR': return 'Треб. TR';
			case 'cutoffsDestination.targetTR': return 'Целевой TR';
			case 'cutoffsDestination.state': return 'Состояние';
			case 'cutoffsDestination.advanced': return 'Продвинутая';
			case 'cutoffsDestination.players': return ({required Object n}) => 'Игроков (${n})';
			case 'cutoffsDestination.moreInfo': return 'Подробнее';
			case 'cutoffsDestination.NumberOne': return ({required Object tr}) => '№ 1 - ${tr} TR';
			case 'cutoffsDestination.inflated': return ({required Object tr}) => 'Инфляция - ${tr} TR';
			case 'cutoffsDestination.notInflated': return 'Нет инфляции';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => 'Дефляция - ${tr} TR';
			case 'cutoffsDestination.notDeflated': return 'Нет дефляции';
			case 'cutoffsDestination.wellDotDotDot': return 'Ну-у...';
			case 'cutoffsDestination.fromPlace': return ({required Object n}) => 'от № ${n}';
			case 'cutoffsDestination.viewButton': return 'Посмотреть';
			case 'rankView.rankTitle': return ({required Object rank}) => 'Данные ${rank} ранга';
			case 'rankView.everyoneTitle': return 'Вся таблица';
			case 'rankView.trRange': return 'Диапазон TR';
			case 'rankView.supposedToBe': return 'Должен быть';
			case 'rankView.gap': return ({required Object value}) => 'промежуток в ${value}';
			case 'rankView.trGap': return ({required Object value}) => 'промежуток в ${value} TR';
			case 'rankView.deflationGap': return 'Зона дефляции';
			case 'rankView.inflationGap': return 'Зона инфляции';
			case 'rankView.LBposRange': return 'Диапазон по позициям';
			case 'rankView.overpopulated': return ({required Object players}) => 'Переполнен ${players}';
			case 'rankView.underpopulated': return ({required Object players}) => 'Не хватает ${players}';
			case 'rankView.PlayersEqualSupposedToBe': return 'лол';
			case 'rankView.avgStats': return 'Средние значения';
			case 'rankView.avgForRank': return ({required Object rank}) => 'Среднее для ${rank} ранга';
			case 'rankView.avgNerdStats': return 'Средние задротские значения';
			case 'rankView.minimums': return 'Минимумы';
			case 'rankView.maximums': return 'Максимумы';
			case 'stateView.title': return ({required Object date}) => 'Состояние от ${date}';
			case 'tlMatchView.match': return 'Матч';
			case 'tlMatchView.vs': return 'против';
			case 'tlMatchView.winner': return 'Победитель';
			case 'tlMatchView.roundNumber': return ({required Object n}) => 'Раунд ${n}';
			case 'tlMatchView.statsFor': return 'Статистика для';
			case 'tlMatchView.numberOfRounds': return 'Количество раундов';
			case 'tlMatchView.matchLength': return 'Продолжительность матча';
			case 'tlMatchView.roundLength': return 'Продолжительность раунда';
			case 'tlMatchView.matchStats': return 'Статистика матча';
			case 'tlMatchView.downloadReplay': return 'Скачать .ttrm повтор';
			case 'tlMatchView.openReplay': return 'Открыть повтор в TETR.IO';
			case 'calcDestination.placeholders': return ({required Object stat}) => 'Введите ваш ${stat}';
			case 'calcDestination.tip': return 'Введите значения и нажмите "Считать", чтобы увидеть статистику для задротов';
			case 'calcDestination.statsCalcButton': return 'Считать';
			case 'calcDestination.damageCalcTip': return 'Нажмите на действия слева, чтобы добавить их сюда';
			case 'calcDestination.actions': return 'Действия';
			case 'calcDestination.results': return 'Результаты';
			case 'calcDestination.rules': return 'Правила';
			case 'calcDestination.noSpinClears': return 'Без спинов';
			case 'calcDestination.spins': return 'Спины';
			case 'calcDestination.miniSpins': return 'Мини спины';
			case 'calcDestination.noLineclear': return '0 линий (сброс комбо)';
			case 'calcDestination.custom': return 'Custom';
			case 'calcDestination.multiplier': return 'Множитель';
			case 'calcDestination.pcDamage': return 'PC урон';
			case 'calcDestination.comboTable': return 'Таблица комбо';
			case 'calcDestination.b2bChaining': return 'Таблица комбо';
			case 'calcDestination.surgeStartAtB2B': return 'Начинается с B2B';
			case 'calcDestination.surgeStartAmount': return 'Начинается с';
			case 'calcDestination.totalDamage': return 'Всего урона';
			case 'calcDestination.lineclears': return 'Lineclears';
			case 'calcDestination.combo': return 'Комбо';
			case 'calcDestination.surge': return 'Surge';
			case 'calcDestination.pcs': return 'PCs';
			case 'infoDestination.title': return 'Информационный Центр';
			case 'infoDestination.sprintAndBlitzAverages': return 'Средние значения для 40 линий и блиц';
			case 'infoDestination.sprintAndBlitzAveragesDescription': return 'Поскольку считать средние значения 40 линий и Блиц неудобно, они обновляется довольно редко. Кликните по названию этой карточки, чтобы увидеть таблицу средних значений 40 линий и Блиц';
			case 'infoDestination.tetraStatsWiki': return 'Tetra Stats Вики';
			case 'infoDestination.tetraStatsWikiDescription': return 'Узнайте больше о функциях Tetra Stats и статистике, что он предоставляет';
			case 'infoDestination.about': return 'О Tetra Stats';
			case 'infoDestination.aboutDescription': return 'Разработано dan63\n';
			case 'leaderboardsDestination.title': return 'Таблицы лидеров';
			case 'leaderboardsDestination.tl': return 'Тетра Лига (Текущий сезон)';
			case 'leaderboardsDestination.fullTL': return 'Тетра Лига (Текущий сезон, вся за раз)';
			case 'leaderboardsDestination.ar': return 'Очки достижений';
			case 'savedDataDestination.title': return 'Сохранённые данные';
			case 'savedDataDestination.tip': return 'Выберите никнейм слева, чтобы увидеть данные ассоциированные с ним';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => 'TL ${s} сезона';
			case 'savedDataDestination.TLrecords': return 'Записи TL';
			case 'settingsDestination.title': return 'Настройки';
			case 'settingsDestination.general': return 'Общие';
			case 'settingsDestination.customization': return 'Кастомизация';
			case 'settingsDestination.database': return 'Локальная база данных';
			case 'settingsDestination.checking': return 'Проверяем...';
			case 'settingsDestination.enterToSubmit': return 'Enter, чтобы подтвердить';
			case 'settingsDestination.account': return 'Ваш аккаунт в TETR.IO';
			case 'settingsDestination.accountDescription': return 'Статистика этого игрока будет загружена сразу после запуска приложения. По умолчанию программа загружает мою (dan63) статистику. Чтобы изменить это, введите свой ник.';
			case 'settingsDestination.done': return 'Готово!';
			case 'settingsDestination.noSuchAccount': return 'Нет такого аккаунта';
			case 'settingsDestination.language': return 'Язык';
			case 'settingsDestination.languageDescription': return ({required Object languages}) => 'Tetra Stats был переведен на ${languages}. По умолчанию приложение выберет язык системы или Английский, если перевода на язык системы нету.';
			case 'settingsDestination.languages': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: 'ноль языков',
				one: '${n} язык',
				two: '${n} языка',
				few: '${n} языка',
				many: '${n} языков',
				other: '${n} языков',
			);
			case 'settingsDestination.updateInTheBackground': return 'Обновлять данные в фоновом режиме';
			case 'settingsDestination.updateInTheBackgroundDescription': return 'Пока Tetra Stats работает, он может обновлять статистику самостоятельно когда кэш истекает. Обычно это происходит каждые 5 минут';
			case 'settingsDestination.compareStats': return 'Сравнивать статистику со средними значениями ранга';
			case 'settingsDestination.compareStatsDescription': return 'Если включено, Tetra Stats загрузит средние значения и будет сравнивать вас со средними значениями вашего ранга. В результате этого почти каждый пункт статистики обретёт цвет, наводите курсор, что-бы узнать больше.';
			case 'settingsDestination.showPosition': return 'Показывать позиции по статам';
			case 'settingsDestination.showPositionDescription': return 'На загрузку потребуется немного времени (и трафика), но зато вы сможете видеть своё положение в таблице Тетра Лиги, отсортированной по статам';
			case 'settingsDestination.accentColor': return 'Цветовой акцент';
			case 'settingsDestination.accentColorDescription': return 'Этот цвет подчёркивает интерактивные элементы интерфейса.';
			case 'settingsDestination.accentColorModale': return 'Выберите цвет акцента';
			case 'settingsDestination.timestamps': return 'Формат отметок времени';
			case 'settingsDestination.timestampsDescriptionPart1': return ({required Object d}) => 'Вы можете выбрать вид отметок времени. По умолчанию показывается дата и время по Гринвичу, форматированная в соответствии с выбранной локалью. Пример: ${d}.';
			case 'settingsDestination.timestampsDescriptionPart2': return ({required Object y, required Object r}) => 'Также можно выбрать:\n• Дата и время в вашем часовом поясе: ${y}\n• Относительные отметки времени: ${r}';
			case 'settingsDestination.timestampsAbsoluteGMT': return 'Абсолютные (по Гринвичу)';
			case 'settingsDestination.timestampsAbsoluteLocalTime': return 'Абсолютные (ваша временная зона)';
			case 'settingsDestination.timestampsRelative': return 'Относительные';
			case 'settingsDestination.sheetbotLikeGraphs': return 'Графики-радары как у sheetBot';
			case 'settingsDestination.sheetbotLikeGraphsDescription': return 'Хоть и несмотря на то, что я считаю поведение графиков sheetBot-а не совсем корректным, некоторые пользователи были в замешательстве от того, что -0,5 страйд не выглядит так, как на графике sheetBot-а. Поэтому вот моё решение: если тумблер включен, точки графика могут появляться на противоположенной стороне графика если значение со знаком минус.';
			case 'settingsDestination.oskKagariGimmick': return '"Оск Кагари" прикол';
			case 'settingsDestination.oskKagariGimmickDescription': return 'Если включено, вместо настоящего ранга оска будет рендерится :kagari:.';
			case 'settingsDestination.bytesOfDataStored': return 'данных сохранено';
			case 'settingsDestination.TLrecordsSaved': return 'записей о матчах Тетра Лиги сохранено';
			case 'settingsDestination.TLplayerstatesSaved': return 'состояний Тетра Лиги сохранено';
			case 'settingsDestination.fixButton': return 'Исправить';
			case 'settingsDestination.compressButton': return 'Сжать';
			case 'settingsDestination.exportDB': return 'Экспортировать локальную базу данных';
			case 'settingsDestination.desktopExportAlertTitle': return 'Экспорт на десктопе';
			case 'settingsDestination.desktopExportText': return 'Похоже, вы используете десктопную версию. Проверьте папку "Документы", там вы должны найти файл "TetraStats.db". Скопируйте его куда-нибудь';
			case 'settingsDestination.androidExportAlertTitle': return 'Экспорт на Android';
			case 'settingsDestination.androidExportText': return ({required Object exportedDB}) => 'Экспортировано.\n${exportedDB}';
			case 'settingsDestination.importDB': return 'Импортировать локальную базу данных';
			case 'settingsDestination.importDBDescription': return 'Восстановите свою резеврную копию. Обратите внимание, что текущая база данных будет перезаписана.';
			case 'settingsDestination.importWrongFileType': return 'Неверный тип файла';
			case 'homeNavigation.overview': return 'Обзор';
			case 'homeNavigation.standing': return 'Положение';
			case 'homeNavigation.seasons': return 'Сезоны';
			case 'homeNavigation.mathces': return 'Матчи';
			case 'homeNavigation.pb': return 'Рекорд';
			case 'homeNavigation.normal': return 'Обычный';
			case 'homeNavigation.expert': return 'Эксперт';
			case 'homeNavigation.expertRecords': return 'Записи EX';
			case 'graphsNavigation.history': return 'История игрока';
			case 'graphsNavigation.league': return 'Состояние Лиги';
			case 'graphsNavigation.cutoffs': return 'История рангов';
			case 'calcNavigation.stats': return 'Калькулятор статистики';
			case 'calcNavigation.damage': return 'Калькулятор урона';
			case 'firstTimeView.welcome': return 'Добро пожаловать в Tetra Stats';
			case 'firstTimeView.description': return 'Сервис, который позволяет просматривать статистику в TETR.IO';
			case 'firstTimeView.nicknameQuestion': return 'Введите свой ник';
			case 'firstTimeView.inpuntHint': return '(3-16 символов)';
			case 'firstTimeView.emptyInputError': return 'Строка пуста';
			case 'firstTimeView.niceToSeeYou': return ({required Object n}) => 'Приятно познакомиться, ${n}';
			case 'firstTimeView.letsTakeALook': return 'Давайте же посмотрим на ваши статы...';
			case 'firstTimeView.skip': return 'Пропустить';
			case 'aboutView.title': return 'О Tetra Stats';
			case 'aboutView.about': return 'Tetra Stats — это сервис, который работает с TETR.IO Tetra Channel API, показывает данные оттуда и считает дополнительную статистику, основанную на этих данных. Сервис позволяет отслеживать прогресс в Тетра Лиге с помощью функции "Отслеживать", которая записывает каждое изменение в Лиге в локальную базу данных (не автоматически, вы должны вручную посещать свой профиль), что позволяет потом просматривать изменения с помощью графиков.\n\nBeanserver blaster — серверная часть Tetra Stats. Она собирает полную таблицу игроков Тетра Лиги, благодаря чему сортировать эту таблицу по любой метрике и строить точечную диаграмму, что позволяет анализировать тренды Лиги. Также она предоставляет историю требований рангов, которую тоже можно посмотреть на графике.\n\nВ будущем планируется добавить анализ повторов и историю турниров, так что оставайтесь на связи.\n\nСервис ни коим образом не ассоциируется с TETR.IO или osk.';
			case 'aboutView.appVersion': return 'Версия приложения';
			case 'aboutView.build': return ({required Object build}) => 'Сборка ${build}';
			case 'aboutView.GHrepo': return 'Репозиторий на GitHub';
			case 'aboutView.submitAnIssue': return 'Сообщить об ошибке';
			case 'aboutView.credits': return 'Благодарности';
			case 'aboutView.authorAndDeveloper': return 'Автор и разработчик';
			case 'aboutView.providedFormulas': return 'Предоставил формулы';
			case 'aboutView.providedS1history': return 'Предоставляет историю первого сезона лиги';
			case 'aboutView.inoue': return 'Inoue (достаёт повторы)';
			case 'aboutView.zhCNlocale': return 'Перевёл на упрощённый китайский';
			case 'aboutView.supportHim': return 'Поддержите его!';
			case 'stats.registrationDate': return 'Дата регистрации';
			case 'stats.gametime': return 'Время в игре';
			case 'stats.ogp': return 'Онлайн игр';
			case 'stats.ogw': return 'Онлайн побед';
			case 'stats.followers': return 'Подписчиков';
			case 'stats.xp.short': return 'Опыт';
			case 'stats.xp.full': return 'Очки опыта';
			case 'stats.tr.short': return 'TR';
			case 'stats.tr.full': return 'Тетра Рейтинг';
			case 'stats.glicko.short': return 'Glicko';
			case 'stats.glicko.full': return 'Glicko';
			case 'stats.rd.short': return 'RD';
			case 'stats.rd.full': return 'Отклонение Рейтинга';
			case 'stats.glixare.short': return 'GXE';
			case 'stats.glixare.full': return 'GLIXARE';
			case 'stats.s1tr.short': return 'S1 TR';
			case 'stats.s1tr.full': return 'TR как в первом сезоне';
			case 'stats.gp.short': return 'GP';
			case 'stats.gp.full': return 'Матчей';
			case 'stats.gw.short': return 'GW';
			case 'stats.gw.full': return 'Побед';
			case 'stats.winrate.short': return 'WR%';
			case 'stats.winrate.full': return 'Процент побед';
			case 'stats.apm.short': return 'APM';
			case 'stats.apm.full': return 'Атаки в Минуту';
			case 'stats.pps.short': return 'PPS';
			case 'stats.pps.full': return 'Фигур в Секунду';
			case 'stats.vs.short': return 'VS';
			case 'stats.vs.full': return 'Показатель Versus';
			case 'stats.app.short': return 'APP';
			case 'stats.app.full': return 'Атаки на Фигуру';
			case 'stats.vsapm.short': return 'VS/APM';
			case 'stats.vsapm.full': return 'VS / APM';
			case 'stats.dss.short': return 'DS/S';
			case 'stats.dss.full': return 'Спуск в секунду';
			case 'stats.dsp.short': return 'DS/P';
			case 'stats.dsp.full': return 'Спуск на фигуру';
			case 'stats.appdsp.short': return 'APP+DSP';
			case 'stats.appdsp.full': return 'APP + DSP';
			case 'stats.cheese.short': return 'Cheese';
			case 'stats.cheese.full': return 'Индекс Сыра';
			case 'stats.gbe.short': return 'GbE';
			case 'stats.gbe.full': return 'Эффективность Мусора';
			case 'stats.nyaapp.short': return 'wAPP';
			case 'stats.nyaapp.full': return 'Weighted APP';
			case 'stats.area.short': return 'Area';
			case 'stats.area.full': return 'Area';
			case 'stats.etr.short': return 'eTR';
			case 'stats.etr.full': return 'Расчётный TR';
			case 'stats.etracc.short': return '±eTR';
			case 'stats.etracc.full': return 'Точность расчёта';
			case 'stats.opener.short': return 'Opener';
			case 'stats.opener.full': return 'Опенер';
			case 'stats.plonk.short': return 'Plonk';
			case 'stats.plonk.full': return 'Плонк';
			case 'stats.stride.short': return 'Stride';
			case 'stats.stride.full': return 'Страйд';
			case 'stats.infds.short': return 'Inf. DS';
			case 'stats.infds.full': return 'Бесконечный спуск';
			case 'stats.altitude.short': return 'м';
			case 'stats.altitude.full': return 'Высота';
			case 'stats.climbSpeed.short': return 'CSP';
			case 'stats.climbSpeed.full': return 'Скорость подъёма';
			case 'stats.climbSpeed.gaugetTitle': return 'Скорость\nПодъёма';
			case 'stats.peakClimbSpeed.short': return 'Пик CSP';
			case 'stats.peakClimbSpeed.full': return 'Пиковая скорость подъёма';
			case 'stats.peakClimbSpeed.gaugetTitle': return 'Пик';
			case 'stats.kos.short': return 'KO\'s';
			case 'stats.kos.full': return 'Выбил';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return 'Back-To-Back';
			case 'stats.finesse.short': return 'F';
			case 'stats.finesse.full': return 'Техника';
			case 'stats.finesse.widgetTitle': return 'Техника';
			case 'stats.finesseFaults.short': return 'FF';
			case 'stats.finesseFaults.full': return 'Ошибок техники';
			case 'stats.totalTime.short': return 'Время';
			case 'stats.totalTime.full': return 'Общее время';
			case 'stats.totalTime.widgetTitle': return 'Общее время';
			case 'stats.level.short': return 'Лвл';
			case 'stats.level.full': return 'Уровень';
			case 'stats.pieces.short': return 'P';
			case 'stats.pieces.full': return 'Фигур';
			case 'stats.spp.short': return 'SPP';
			case 'stats.spp.full': return 'Очков на Фигуру';
			case 'stats.kp.short': return 'KP';
			case 'stats.kp.full': return 'Нажатий клавиш';
			case 'stats.kpp.short': return 'KPP';
			case 'stats.kpp.full': return 'Нажатий клавиш на Фигуру';
			case 'stats.kps.short': return 'KPS';
			case 'stats.kps.full': return 'Нажатий клавиш в Секунду';
			case 'stats.blitzScore': return ({required Object p}) => '${p} очков';
			case 'stats.levelUpRequirement': return ({required Object p}) => 'Очков для повышения уровня: ${p}';
			case 'stats.piecesTotal': return 'Всего фигур установлено';
			case 'stats.piecesWithPerfectFinesse': return 'Установлено с идеальной техникой';
			case 'stats.score': return 'Счёт';
			case 'stats.lines': return 'Линий';
			case 'stats.linesShort': return 'L';
			case 'stats.pcs': return 'Perfect Clears';
			case 'stats.holds': return 'Holds';
			case 'stats.spike': return 'Top Spike';
			case 'stats.top': return ({required Object percentage}) => 'Топ ${percentage}';
			case 'stats.topRank': return ({required Object rank}) => 'Топ ранг: ${rank}';
			case 'stats.floor': return 'Этаж';
			case 'stats.split': return 'Сектор';
			case 'stats.total': return 'Всего';
			case 'stats.sent': return 'Отправлено';
			case 'stats.received': return 'Получено';
			case 'stats.placement': return 'Положение';
			case 'stats.peak': return 'Пик';
			case 'stats.qpWithMods': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				one: 'С 1 модом',
				two: 'С ${n} модами',
				few: 'С ${n} модами',
				many: 'С ${n} модами',
				other: 'С ${n} модами',
			);
			case 'stats.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} нажатий клавиш',
				one: '${n} нажатие клавиш',
				two: '${n} нажатия клавиш',
				few: '${n} нажатия клавиш',
				many: '${n} нажатий клавиш',
				other: '${n} нажатий клавиш',
			);
			case 'stats.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} T-спинов всего',
				one: 'Всего ${n} T-спин',
				two: '${n} T-спина всего',
				few: '${n} T-спина всего',
				many: '${n} T-спинов всего',
				other: '${n} T-спинов всего',
			);
			case 'stats.linesCleared': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} линий очищено',
				one: '${n} линия очищена',
				two: '${n} линии очищено',
				few: '${n} линии очищено',
				many: '${n} линий очищено',
				other: '${n} линий очищено',
			);
			case 'stats.graphs.attack': return 'Атака';
			case 'stats.graphs.speed': return 'Скорость';
			case 'stats.graphs.defense': return 'Оборона';
			case 'stats.graphs.cheese': return 'Сыр';
			case 'stats.players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} игроков',
				one: '${n} игрок',
				two: '${n} игрока',
				few: '${n} игрока',
				many: '${n} игроков',
				other: '${n} игроков',
			);
			case 'stats.games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				zero: '${n} игр',
				one: '${n} игра',
				two: '${n} игры',
				few: '${n} игры',
				many: '${n} игр',
				other: '${n} игр',
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
			case 'countries.': return 'Во всем мире';
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
			case 'countries.TO': return 'Тонга';
			case 'countries.TT': return 'Тринидад и Тобаго';
			case 'countries.TN': return 'Тунис';
			case 'countries.TR': return 'Турция';
			case 'countries.TM': return 'Туркменистан';
			case 'countries.TC': return 'Острова Теркс и Кайкос';
			case 'countries.TV': return 'Тувалу';
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
			case 'locales.ru-RU': return '俄语 (Русский)';
			case 'locales.zh-CN': return '简体中文';
			case 'gamemodes.league': return 'Tetra 联赛';
			case 'gamemodes.zenith': return '快速游戏';
			case 'gamemodes.zenithex': return '快速游戏 · 专家模式';
			case 'gamemodes.40l': return '40行竞速';
			case 'gamemodes.blitz': return '闪电战';
			case 'gamemodes.5mblast': return '5,000,000 Blast';
			case 'gamemodes.zen': return '禅意模式';
			case 'destinations.home': return '主页';
			case 'destinations.graphs': return '图表';
			case 'destinations.leaderboards': return '排行榜';
			case 'destinations.cutoffs': return '段位分界线';
			case 'destinations.calc': return '计算器';
			case 'destinations.info': return '信息中心';
			case 'destinations.data': return '已保存的数据';
			case 'destinations.settings': return '设置';
			case 'playerRole.user': return '用户';
			case 'playerRole.banned': return '已封禁';
			case 'playerRole.bot': return '机器人';
			case 'playerRole.sysop': return '系统操作员';
			case 'playerRole.admin': return '管理员';
			case 'playerRole.mod': return '管理员';
			case 'playerRole.halfmod': return '社区管理员';
			case 'playerRole.anon': return '匿名用户';
			case 'goBackButton': return '返回';
			case 'nanow': return '目前不可用...';
			case 'seasonEnds': return ({required Object countdown}) => '当前赛季还有${countdown}结束';
			case 'seasonEnded': return '赛季已结束';
			case 'overallPB': return ({required Object pb}) => '生涯最佳：${pb} m';
			case 'gamesUntilRanked': return ({required Object left}) => '还有${left}局才可获得段位';
			case 'numOfVictories': return ({required Object wins}) => '~${wins}次胜局';
			case 'promotionOnNextWin': return '下一场胜局即可升段';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses}次负局';
			case 'demotionOnNextLoss': return '下一场负局即可掉段';
			case 'records': return '记录';
			case 'nerdStats': return '详细信息';
			case 'playstyles': return '游戏方式';
			case 'horoscopes': return '散点图';
			case 'relatedAchievements': return '相关成就';
			case 'season': return '赛季';
			case 'smooth': return '平滑';
			case 'dateAndTime': return '日期和时间：';
			case 'TLfullLBnote': return '很大，但允许你通过玩家的数据对玩家进行排序，还可以按段位筛选玩家';
			case 'rank': return '段位';
			case 'verdictGeneral': return ({required Object rank, required Object n, required Object verdict}) => '比 ${rank} 段平均数据${n} ${verdict}';
			case 'verdictBetter': return '好';
			case 'verdictWorse': return '差';
			case 'localStanding': return '本地';
			case 'xp.title': return '经验等级';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => '到下一等级的进度：${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => '从0级到${goal}级的进度：${percentage} (还差 ${left} 点经验值)';
			case 'gametime.title': return '精确游戏时长';
			case 'gametime.gametimeAday': return ({required Object gametime}) => '平均每天${gametime}';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => '相当于 ${years} 年，\n${months} 月，\n${days} 天，\n${minutes} 分钟，\n${seconds} 秒';
			case 'track': return '跟踪';
			case 'stopTracking': return '停止跟踪';
			case 'supporter': return ({required Object tier}) => '${tier}级会员';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => '${newDate}的数据与${oldDate}相比';
			case 'compare': return '比较';
			case 'comparison': return '比较';
			case 'enterUsername': return '输入用户名或者\$avgX (X是一个段位)';
			case 'general': return '常规';
			case 'badges': return '勋章';
			case 'obtainDate': return ({required Object date}) => '于${date}获得';
			case 'assignedManualy': return '此徽章由TETR.IO管理员手动颁发';
			case 'distinguishment': return '区别';
			case 'banned': return '已封禁';
			case 'bannedSubtext': return '由于 TETR.IO 规则或服务条款被违反 而被封禁';
			case 'badStanding': return '信誉不佳';
			case 'badStandingSubtext': return '近期有一次或多次违禁行为';
			case 'botAccount': return '机器人账号';
			case 'botAccountSubtext': return ({required Object botMaintainers}) => '由${botMaintainers}管理';
			case 'copiedToClipboard': return '已复制到剪贴板！';
			case 'bio': return '个性签名';
			case 'news': return '新闻';
			case 'matchResult.victory': return '胜利';
			case 'matchResult.defeat': return '失败';
			case 'matchResult.tie': return '平局';
			case 'matchResult.dqvictory': return '对手被取消资格';
			case 'matchResult.dqdefeat': return '被取消资格';
			case 'matchResult.nocontest': return '无竞赛记录';
			case 'matchResult.nullified': return '竞赛记录已取消';
			case 'distinguishments.noHeader': return '缺少标题';
			case 'distinguishments.noFooter': return '缺少标题';
			case 'distinguishments.twc': return 'TETR.IO 世界冠军';
			case 'distinguishments.twcYear': return ({required Object year}) => '${year} TETR.IO 世界杯';
			case 'newsEntries.leaderboard': return ({required InlineSpan gametype, required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: '在'),
				gametype,
				const TextSpan(text: '中荣获第'),
				rank,
				const TextSpan(text: '名'),
			]);
			case 'newsEntries.personalbest': return ({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
				const TextSpan(text: '在'),
				gametype,
				const TextSpan(text: '中取得新纪录：'),
				pb,
			]);
			case 'newsEntries.badge': return ({required InlineSpan badge}) => TextSpan(children: [
				const TextSpan(text: '获得勋章 '),
				badge,
			]);
			case 'newsEntries.rankup': return ({required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: '升 '),
				rank,
			]);
			case 'newsEntries.supporter': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: '成为'),
				s('TETR.IO supporter'),
			]);
			case 'newsEntries.supporter_gift': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: '被赠送'),
				s('TETR.IO supporter'),
			]);
			case 'newsEntries.unknown': return ({required InlineSpan type}) => TextSpan(children: [
				const TextSpan(text: '未知新闻类型 '),
				type,
			]);
			case 'rankupMiddle': return ({required Object r}) => '${r} 段';
			case 'copyUserID': return '点击以复制用户 ID';
			case 'searchHint': return '用户名或 ID';
			case 'navMenu': return '导航菜单';
			case 'navMenuTooltip': return '打开导航菜单';
			case 'refresh': return '刷新数据';
			case 'searchButton': return '搜索';
			case 'trackedPlayers': return '跟踪的玩家';
			case 'standing': return '名次';
			case 'previousSeasons': return '上赛季';
			case 'recent': return '最近';
			case 'top': return '前';
			case 'noRecord': return '暂无记录';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => '${date}';
			case 'snackBarMessages.stateRemoved': return ({required Object date}) => '成功移除${date}时的状态！';
			case 'snackBarMessages.matchRemoved': return ({required Object date}) => '成功移除${date}时的一局！';
			case 'snackBarMessages.notForWeb': return '此功能在网络版本中不可用';
			case 'snackBarMessages.importSuccess': return '导入成功';
			case 'snackBarMessages.importCancelled': return '导入已取消';
			case 'errors.noRecords': return '暂无记录';
			case 'errors.notEnoughData': return '数据不足';
			case 'errors.noHistorySaved': return '没有保存历史记录';
			case 'errors.connection': return ({required Object code, required Object message}) => '连接错误：${code} ${message}';
			case 'errors.noSuchUser': return '用户不存在';
			case 'errors.noSuchUserSub': return '您输入的内容有误，或者用户不存在';
			case 'errors.discordNotAssigned': return '没有指定Discord ID的用户';
			case 'errors.discordNotAssignedSub': return '请确保您提供了有效的 ID';
			case 'errors.history': return '缺少该玩家的历史';
			case 'errors.actionSuggestion': return '也许，您想要';
			case 'errors.p1nkl0bst3rTLmatches': return '没有找到Tetra联赛比赛';
			case 'errors.clientException': return '你尚未连接';
			case 'errors.forbidden': return '您的 IP 地址已被封禁';
			case 'errors.forbiddenSub': return ({required Object nickname}) => '如果你在使用VPN，请关闭。如果仍然不可以，请联系${nickname}';
			case 'errors.tooManyRequests': return '您的评分已经被限制';
			case 'errors.tooManyRequestsSub': return '请稍后重试';
			case 'errors.internal': return 'TETR.IO 出现了问题！';
			case 'errors.internalSub': return 'osk，或许，已经知道了';
			case 'errors.internalWebVersion': return 'TETR.IO （也许是oskware_bridge，我不知道到底是哪儿） 出现了问题！';
			case 'errors.internalWebVersionSub': return '如果 osk status 页面显示一切都很正常，请联系dan63047';
			case 'errors.oskwareBridge': return 'oskware_bridge 出现了问题！';
			case 'errors.oskwareBridgeSub': return '请联系dan63047';
			case 'errors.p1nkl0bst3rForbidden': return '第三方API屏蔽了您的 IP 地址';
			case 'errors.p1nkl0bst3rTooManyRequests': return '第三方API请求过多，请稍后再试';
			case 'errors.p1nkl0bst3rinternal': return 'p1nkl0bst3r 那边出现了问题！';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'p1nkl0bst3r 那边（也许是oskware_bridge，我不知道到底是哪儿）出现了问题！';
			case 'errors.replayAlreadySaved': return '回放已保存';
			case 'errors.replayExpired': return '回放已过期或不再可用';
			case 'errors.replayRejected': return '第三方API屏蔽了您的 IP 地址';
			case 'actions.cancel': return '取消';
			case 'actions.submit': return '确定';
			case 'actions.ok': return '确定';
			case 'actions.apply': return '应用';
			case 'actions.refresh': return '刷新';
			case 'graphsDestination.fetchAndsaveTLHistory': return '获取玩家历史';
			case 'graphsDestination.fetchAndSaveOldTLmatches': return '获取 Tetra 联赛历史记录';
			case 'graphsDestination.fetchAndsaveTLHistoryResult': return ({required Object number}) => '找到 ${number} 个状态';
			case 'graphsDestination.fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '找到 ${number} 场比赛';
			case 'graphsDestination.gamesPlayed': return ({required Object games}) => '游玩次数：${games}';
			case 'graphsDestination.dateAndTime': return '日期和时间';
			case 'graphsDestination.filterModaleTitle': return '在图表上筛选等级';
			case 'filterModale.all': return '全部';
			case 'cutoffsDestination.title': return 'Tetra 联赛 状态';
			case 'cutoffsDestination.relevance': return ({required Object timestamp}) => '${timestamp}';
			case 'cutoffsDestination.actual': return '实际';
			case 'cutoffsDestination.target': return '目标';
			case 'cutoffsDestination.cutoffTR': return '分段 TR';
			case 'cutoffsDestination.targetTR': return '目标 TR';
			case 'cutoffsDestination.state': return '状态';
			case 'cutoffsDestination.advanced': return '高级选项';
			case 'cutoffsDestination.players': return ({required Object n}) => '玩家（${n}）';
			case 'cutoffsDestination.moreInfo': return '更多信息';
			case 'cutoffsDestination.NumberOne': return ({required Object tr}) => '№ 1 is ${tr} TR';
			case 'cutoffsDestination.inflated': return ({required Object tr}) => '高于目标 ${tr}';
			case 'cutoffsDestination.notInflated': return '不偏高';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => '低于目标 ${tr}';
			case 'cutoffsDestination.notDeflated': return '不偏低';
			case 'cutoffsDestination.wellDotDotDot': return '嗯…';
			case 'cutoffsDestination.fromPlace': return ({required Object n}) => '自 № ${n}';
			case 'cutoffsDestination.viewButton': return '查看';
			case 'rankView.rankTitle': return ({required Object rank}) => '${rank} 段数据';
			case 'rankView.everyoneTitle': return '全部排行榜';
			case 'rankView.trRange': return 'TR 范围';
			case 'rankView.supposedToBe': return '应为';
			case 'rankView.gap': return ({required Object value}) => '相差 ${value}';
			case 'rankView.trGap': return ({required Object value}) => '相差 ${value} TR';
			case 'rankView.deflationGap': return '偏低量';
			case 'rankView.inflationGap': return '偏高量';
			case 'rankView.LBposRange': return '排行榜位置范围';
			case 'rankView.overpopulated': return ({required Object players}) => '比期望的多 ${players}';
			case 'rankView.underpopulated': return ({required Object players}) => '比期望的少 ${players}';
			case 'rankView.PlayersEqualSupposedToBe': return '符合';
			case 'rankView.avgStats': return '平均数据';
			case 'rankView.avgForRank': return ({required Object rank}) => '${rank} 段平均数据';
			case 'rankView.avgNerdStats': return '平均详细信息';
			case 'rankView.minimums': return '最小值';
			case 'rankView.maximums': return '最大值';
			case 'stateView.title': return ({required Object date}) => '${date}的状态';
			case 'tlMatchView.match': return '匹配';
			case 'tlMatchView.vs': return 'vs';
			case 'tlMatchView.winner': return '获胜者';
			case 'tlMatchView.roundNumber': return ({required Object n}) => '第${n}回合';
			case 'tlMatchView.statsFor': return '状态';
			case 'tlMatchView.numberOfRounds': return '回合数';
			case 'tlMatchView.matchLength': return '比赛时长';
			case 'tlMatchView.roundLength': return '回合时长';
			case 'tlMatchView.matchStats': return '比赛数据';
			case 'tlMatchView.downloadReplay': return '下载 .ttrm 回放';
			case 'tlMatchView.openReplay': return '在 TETR.IO 中打开回放';
			case 'calcDestination.placeholders': return ({required Object stat}) => '输入你的${stat}';
			case 'calcDestination.tip': return '输入值并按 "计算" 来查看TA的详细信息';
			case 'calcDestination.statsCalcButton': return '计算';
			case 'calcDestination.damageCalcTip': return '点击左侧的操作在此添加';
			case 'calcDestination.actions': return '操作';
			case 'calcDestination.results': return '结果';
			case 'calcDestination.rules': return '规则';
			case 'calcDestination.noSpinClears': return '非 Spin 清除';
			case 'calcDestination.spins': return 'Spin';
			case 'calcDestination.miniSpins': return 'Mini spin';
			case 'calcDestination.noLineclear': return '无清除（连消结束）';
			case 'calcDestination.custom': return '自定义';
			case 'calcDestination.multiplier': return '倍增';
			case 'calcDestination.pcDamage': return '全消伤害';
			case 'calcDestination.comboTable': return '连击';
			case 'calcDestination.b2bChaining': return 'B2B增伤';
			case 'calcDestination.surgeStartAtB2B': return '开始于B2B';
			case 'calcDestination.surgeStartAmount': return '初始值';
			case 'calcDestination.totalDamage': return '累计伤害';
			case 'calcDestination.lineclears': return '清除行数';
			case 'calcDestination.combo': return '连击';
			case 'calcDestination.surge': return 'B2B充能';
			case 'calcDestination.pcs': return '全消';
			case 'infoDestination.title': return '信息中心';
			case 'infoDestination.sprintAndBlitzAverages': return '40 行 & 闪电战平均数据';
			case 'infoDestination.sprintAndBlitzAveragesDescription': return '计算40 行 & 闪电战平均数据是个很繁琐的过程，所以很久才会更新一次。 点击标题查看完整的 40 行 & 闪电战平均数据表';
			case 'infoDestination.tetraStatsWiki': return 'Tetra Stats Wiki';
			case 'infoDestination.tetraStatsWikiDescription': return '查看更多关于Tetra Stats提供的功能和数据';
			case 'infoDestination.about': return '关于 Tetra Stats';
			case 'infoDestination.aboutDescription': return '由 dan63 开发';
			case 'leaderboardsDestination.title': return '排行榜';
			case 'leaderboardsDestination.tl': return 'Tetra 联赛（当前赛季）';
			case 'leaderboardsDestination.fullTL': return 'Tetra 联赛（当前赛季，完整）';
			case 'leaderboardsDestination.ar': return '成就点';
			case 'savedDataDestination.title': return '已保存的数据';
			case 'savedDataDestination.tip': return '选择左边的昵称以查看与之相关的数据';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => '第${s}赛季状态';
			case 'savedDataDestination.TLrecords': return '联赛记录';
			case 'settingsDestination.title': return '设置';
			case 'settingsDestination.general': return '常规';
			case 'settingsDestination.customization': return '自定义设置';
			case 'settingsDestination.database': return '本地数据库';
			case 'settingsDestination.checking': return '正在检查...';
			case 'settingsDestination.enterToSubmit': return '按回车键提交';
			case 'settingsDestination.account': return '您的 TETR.IO 账号';
			case 'settingsDestination.accountDescription': return '该玩家的状态将在启动此应用后立即加载。 默认情况下，它会加载我的数据。如要更改，请在此输入您的昵称。';
			case 'settingsDestination.done': return '完成！';
			case 'settingsDestination.noSuchAccount': return '账号不存在';
			case 'settingsDestination.language': return '语言';
			case 'settingsDestination.languageDescription': return ({required Object languages}) => 'Tetra Stats 有${languages}。默认情况下，应用程序将选择您的系统语言，如果您的系统区域设置不可用，则选择英语。';
			case 'settingsDestination.languages': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '0种语言',
				one: '${n}种语言',
				two: '${n}种语言',
				few: '${n}种语言',
				many: '${n}种语言',
				other: '${n}种语言',
			);
			case 'settingsDestination.updateInTheBackground': return '后台更新数据';
			case 'settingsDestination.updateInTheBackgroundDescription': return '如果开启，Tetra Stats将尝试在缓存过期后查询新信息。通常一次/5分钟。';
			case 'settingsDestination.compareStats': return '将TL数据与段位平均水平作比较';
			case 'settingsDestination.compareStatsDescription': return '如果开启，Tetra Stats将提供额外的量度，使您能够将自己与普通玩家的等级相比较。 你看到它的方式——统计信息将以相应的颜色高亮，用光标悬停在它们上面以获取更多信息。';
			case 'settingsDestination.showPosition': return '显示排行榜中的位置';
			case 'settingsDestination.showPositionDescription': return '这可能需要一些时间(和流量)，但您可以看到您在排行榜上的位置，按数据排序';
			case 'settingsDestination.accentColor': return '主题色';
			case 'settingsDestination.accentColorDescription': return '这种颜色会在这个应用上可见，而且通常会高亮显示交互界面元素。';
			case 'settingsDestination.accentColorModale': return '选取主题色';
			case 'settingsDestination.timestamps': return '时间戳格式';
			case 'settingsDestination.timestampsDescriptionPart1': return ({required Object d}) => '您可以选择时间戳显示时间的方式。默认情况下，它们以 GMT 时区显示时间，并根据所选区域设置进行格式设置，例如：${d}。';
			case 'settingsDestination.timestampsDescriptionPart2': return ({required Object y, required Object r}) => '这里还有：\n• 以您的时区设置的区域设置：${y}\n• 相对时间戳：${r}';
			case 'settingsDestination.timestampsAbsoluteGMT': return 'GMT';
			case 'settingsDestination.timestampsAbsoluteLocalTime': return '您的时区';
			case 'settingsDestination.timestampsRelative': return '相对';
			case 'settingsDestination.sheetbotLikeGraphs': return 'Sheetbot 型雷达图';
			case 'settingsDestination.sheetbotLikeGraphsDescription': return '尽管我认为，图表在 SheetBot 中的工作方式不是很正确，有些人感到困惑，那 -0.5 Stride 看起来不像它在 SheetBot 图表上那样。因此，我们这里有：如果开启，则如果数值为负，则图形上的点可以出现在图形的另一半。';
			case 'settingsDestination.oskKagariGimmick': return 'Osk-Kagari';
			case 'settingsDestination.oskKagariGimmickDescription': return '如果开启，osk的段位会显示为:kagari:';
			case 'settingsDestination.bytesOfDataStored': return '存储数据';
			case 'settingsDestination.TLrecordsSaved': return '已保存 Tetra 联赛记录';
			case 'settingsDestination.TLplayerstatesSaved': return '已保存 Tetra 联赛玩家状态';
			case 'settingsDestination.fixButton': return '修复';
			case 'settingsDestination.compressButton': return '压缩';
			case 'settingsDestination.exportDB': return '导出本地数据库';
			case 'settingsDestination.desktopExportAlertTitle': return '桌面导出';
			case 'settingsDestination.desktopExportText': return '看起来您在桌面上使用了这个应用程序。请检查您的文档文件夹，您应该找到"TetraStats.db"。请将其复制到某处';
			case 'settingsDestination.androidExportAlertTitle': return 'Android 导出';
			case 'settingsDestination.androidExportText': return ({required Object exportedDB}) => '已导出。\n${exportedDB}';
			case 'settingsDestination.importDB': return '导入本地数据库';
			case 'settingsDestination.importDBDescription': return '还原您的备份。请注意已存储的数据库将被覆盖。';
			case 'settingsDestination.importWrongFileType': return '文件类型错误！';
			case 'homeNavigation.overview': return '概览';
			case 'homeNavigation.standing': return '名次';
			case 'homeNavigation.seasons': return '赛季';
			case 'homeNavigation.mathces': return '比赛场次';
			case 'homeNavigation.pb': return '个人最佳';
			case 'homeNavigation.normal': return '普通模式';
			case 'homeNavigation.expert': return '专家模式';
			case 'homeNavigation.expertRecords': return '专家模式记录';
			case 'graphsNavigation.history': return '玩家历史记录';
			case 'graphsNavigation.league': return '联赛状态';
			case 'graphsNavigation.cutoffs': return '分段线历史';
			case 'calcNavigation.stats': return '数据计算器';
			case 'calcNavigation.damage': return '伤害计算器';
			case 'firstTimeView.welcome': return '欢迎使用 Tetra Stats';
			case 'firstTimeView.description': return '服务，允许您跟踪TETR.IO的各种数据';
			case 'firstTimeView.nicknameQuestion': return '您的昵称是？';
			case 'firstTimeView.inpuntHint': return '在此处输入... (3-16个符号)';
			case 'firstTimeView.emptyInputError': return '不能提交空字符串';
			case 'firstTimeView.niceToSeeYou': return ({required Object n}) => '很高兴见到你，${n}';
			case 'firstTimeView.letsTakeALook': return '让我们看看您的统计资料...';
			case 'firstTimeView.skip': return '跳过';
			case 'aboutView.title': return '关于 Tetra Stats';
			case 'aboutView.about': return 'Tetra Stats是一种服务，与TETR.IO Tetra Channel API共用，提供数据并根据这种数据计算一些附加度量。 服务允许用户用"Track"功能跟踪他们在Tetra League中的进度，这个功能记录每个Tetra Leage更改到本地数据库(非自动) 您必须不时地访问服务。这样，这些更改可以通过图表来查看。\n\nBeanserver blaster 是Tetra Stats的一部分，它被拆解成服务器侧脚本。 它提供完整的Tetra League排行榜，允许Tetra Stats通过任何公式对排行榜进行排序并生成散点图，这允许用户分析Tetra联赛趋势。 它还提供了Tetra League 的评分历史，用户也可以通过图表看到。\n\n我们有一个添加回放分析和锦标赛历史记录的计划，所以随时关注！\n\n服务没有与TETR.IO与osk以任何身份关联。';
			case 'aboutView.appVersion': return '版本';
			case 'aboutView.build': return ({required Object build}) => '${build}';
			case 'aboutView.GHrepo': return 'GitHub Repository';
			case 'aboutView.submitAnIssue': return '提交问题';
			case 'aboutView.credits': return '鸣谢';
			case 'aboutView.authorAndDeveloper': return '作者 & 开发者';
			case 'aboutView.providedFormulas': return '提供的公式';
			case 'aboutView.providedS1history': return '提供的 S1 历史';
			case 'aboutView.inoue': return 'Inoue (回放抓取器)';
			case 'aboutView.zhCNlocale': return '简中翻译员';
			case 'aboutView.supportHim': return '为他提供支持！';
			case 'stats.registrationDate': return '注册时间';
			case 'stats.gametime': return '游玩时长';
			case 'stats.ogp': return '在线游戏次数';
			case 'stats.ogw': return '在线游戏胜利次数';
			case 'stats.followers': return '粉丝';
			case 'stats.xp.short': return '经验值';
			case 'stats.xp.full': return '经验点';
			case 'stats.tr.short': return 'TR';
			case 'stats.tr.full': return 'Tetra 评分';
			case 'stats.glicko.short': return 'Glicko';
			case 'stats.glicko.full': return 'Glicko';
			case 'stats.rd.short': return 'RD';
			case 'stats.rd.full': return '评分偏差';
			case 'stats.glixare.short': return 'GXE';
			case 'stats.glixare.full': return 'GLIXARE';
			case 'stats.s1tr.short': return 'S1 TR';
			case 'stats.s1tr.full': return '第 1 赛季式 TR';
			case 'stats.gp.short': return 'GP';
			case 'stats.gp.full': return '总场数';
			case 'stats.gw.short': return 'GW';
			case 'stats.gw.full': return '胜场数';
			case 'stats.winrate.short': return 'WR%';
			case 'stats.winrate.full': return '胜率';
			case 'stats.apm.short': return 'APM';
			case 'stats.apm.full': return '每分钟攻击数';
			case 'stats.pps.short': return 'PPS';
			case 'stats.pps.full': return '每秒块数';
			case 'stats.vs.short': return 'VS';
			case 'stats.vs.full': return 'VS 分数';
			case 'stats.app.short': return 'APP';
			case 'stats.app.full': return '每块攻击数';
			case 'stats.vsapm.short': return 'VS/APM';
			case 'stats.vsapm.full': return 'VS / APM';
			case 'stats.dss.short': return 'DS/S';
			case 'stats.dss.full': return '每秒挖掘数';
			case 'stats.dsp.short': return 'DS/P';
			case 'stats.dsp.full': return '每块挖掘数';
			case 'stats.appdsp.short': return 'APP+DSP';
			case 'stats.appdsp.full': return 'APP + DSP';
			case 'stats.cheese.short': return 'CI';
			case 'stats.cheese.full': return '垃圾行混乱指数';
			case 'stats.gbe.short': return 'GbE';
			case 'stats.gbe.full': return '垃圾行效率';
			case 'stats.nyaapp.short': return 'wAPP';
			case 'stats.nyaapp.full': return '加权APP';
			case 'stats.area.short': return '面积';
			case 'stats.area.full': return '面积';
			case 'stats.etr.short': return 'eTR';
			case 'stats.etr.full': return '预测 TR';
			case 'stats.etracc.short': return '±eTR';
			case 'stats.etracc.full': return '预测实际差量';
			case 'stats.opener.short': return '定式';
			case 'stats.opener.full': return '定式';
			case 'stats.plonk.short': return '太极';
			case 'stats.plonk.full': return '太极';
			case 'stats.stride.short': return '速度';
			case 'stats.stride.full': return '速度';
			case 'stats.infds.short': return '挖掘';
			case 'stats.infds.full': return '挖掘';
			case 'stats.altitude.short': return 'm';
			case 'stats.altitude.full': return '高度';
			case 'stats.climbSpeed.short': return 'CSP';
			case 'stats.climbSpeed.full': return '爬行速度';
			case 'stats.climbSpeed.gaugetTitle': return '爬行速度';
			case 'stats.peakClimbSpeed.short': return '最高CSP';
			case 'stats.peakClimbSpeed.full': return '最高爬行速度';
			case 'stats.peakClimbSpeed.gaugetTitle': return '最高';
			case 'stats.kos.short': return 'KO\'s';
			case 'stats.kos.full': return '击杀';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return '背靠背/满贯';
			case 'stats.finesse.short': return '极';
			case 'stats.finesse.full': return '极简率';
			case 'stats.finesse.widgetTitle': return '简率';
			case 'stats.finesseFaults.short': return '非极简';
			case 'stats.finesseFaults.full': return '非极简操作数';
			case 'stats.totalTime.short': return '时长';
			case 'stats.totalTime.full': return '总时长';
			case 'stats.totalTime.widgetTitle': return '总时长';
			case 'stats.level.short': return 'Lvl';
			case 'stats.level.full': return '等级';
			case 'stats.pieces.short': return 'P';
			case 'stats.pieces.full': return '块';
			case 'stats.spp.short': return 'SPP';
			case 'stats.spp.full': return '每块得分';
			case 'stats.kp.short': return 'KP';
			case 'stats.kp.full': return '按键';
			case 'stats.kpp.short': return 'KPP';
			case 'stats.kpp.full': return '每块按键数';
			case 'stats.kps.short': return 'KPS';
			case 'stats.kps.full': return '每秒按键数';
			case 'stats.blitzScore': return ({required Object p}) => '${p} 分';
			case 'stats.levelUpRequirement': return ({required Object p}) => '还需 ${p} 升到下一级';
			case 'stats.piecesTotal': return '放块总数';
			case 'stats.piecesWithPerfectFinesse': return '极简块数';
			case 'stats.score': return '分数';
			case 'stats.lines': return '行数';
			case 'stats.linesShort': return '行';
			case 'stats.pcs': return '全消数';
			case 'stats.holds': return '暂存数';
			case 'stats.spike': return '最高暴击';
			case 'stats.top': return ({required Object percentage}) => '前 ${percentage}';
			case 'stats.topRank': return ({required Object rank}) => '最高段位：${rank}';
			case 'stats.floor': return '层';
			case 'stats.split': return '拆分';
			case 'stats.total': return '总计';
			case 'stats.sent': return '已发送';
			case 'stats.received': return '已接收';
			case 'stats.placement': return '排名';
			case 'stats.peak': return '最高';
			case 'stats.qpWithMods': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				one: '使用 1 个模组',
				two: '使用 ${n} 个模组',
				few: '使用 ${n} 个模组',
				many: '使用 ${n} 个模组',
				other: '使用 ${n} 个模组',
			);
			case 'stats.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '${n} 按键',
				one: '${n} 按键',
				two: '${n} 按键',
				few: '${n} 按键',
				many: '${n} 按键',
				other: '${n} 按键',
			);
			case 'stats.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '总共 ${n} 次T旋',
				one: '总共 ${n} 次T旋',
				two: '总共 ${n} 次T旋',
				few: '总共 ${n} 次T旋',
				many: '总共 ${n} 次T旋',
				other: '总共 ${n} 次T旋',
			);
			case 'stats.linesCleared': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '总共消除 ${n} 行',
				one: '总共消除 ${n} 行',
				two: '总共消除 ${n} 行',
				few: '总共消除 ${n} 行',
				many: '总共消除 ${n} 行',
				other: '总共消除 ${n} 行',
			);
			case 'stats.graphs.attack': return '攻击';
			case 'stats.graphs.speed': return '速度';
			case 'stats.graphs.defense': return '防御';
			case 'stats.graphs.cheese': return '奶酪层';
			case 'stats.players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '${n} 名玩家',
				one: '${n} 名玩家',
				two: '${n} 名玩家',
				few: '${n} 名玩家',
				many: '${n} 名玩家',
				other: '${n} 名玩家',
			);
			case 'stats.games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
				zero: '${n} 次游戏',
				one: '${n} 次游戏',
				two: '${n} 次游戏',
				few: '${n} 次游戏',
				many: '${n} 次游戏',
				other: '${n} 次游戏',
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
			case 'countries.': return '全球';
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
			case 'countries.BO': return '玻利维亚';
			case 'countries.BA': return '波黑';
			case 'countries.BW': return '博茨瓦纳';
			case 'countries.BV': return '布韦岛';
			case 'countries.BR': return '巴西';
			case 'countries.IO': return '英属印度洋领地';
			case 'countries.BN': return '文莱';
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
			case 'countries.CC': return '科科斯群岛';
			case 'countries.CO': return '哥伦比亚';
			case 'countries.KM': return '科摩罗';
			case 'countries.CG': return '刚果（布）';
			case 'countries.CD': return '刚果（金）';
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
			case 'countries.DM': return '多米尼克';
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
			case 'countries.FK': return '福克兰群岛 (马尔维纳斯)';
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
			case 'countries.GL': return '格陵兰';
			case 'countries.GD': return '格林纳达';
			case 'countries.GP': return '瓜德罗普';
			case 'countries.GU': return '关岛';
			case 'countries.GT': return '危地马拉';
			case 'countries.GG': return '根西';
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
			case 'countries.ID': return '印尼';
			case 'countries.IR': return '伊朗';
			case 'countries.IQ': return '伊拉克';
			case 'countries.IE': return '爱尔兰';
			case 'countries.IM': return '马恩岛';
			case 'countries.IL': return '以色列';
			case 'countries.IT': return '意大利';
			case 'countries.JM': return '牙买加';
			case 'countries.JP': return '日本';
			case 'countries.JE': return '泽西';
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
			case 'countries.LV': return '拉托维亚';
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
			case 'countries.MQ': return '马提尼克';
			case 'countries.MR': return '毛里塔尼亚';
			case 'countries.MU': return '毛里求斯';
			case 'countries.YT': return '马约特岛';
			case 'countries.MX': return '墨西哥';
			case 'countries.FM': return '密克罗尼西亚';
			case 'countries.MD': return '摩尔多瓦';
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
			case 'countries.NL': return '荷兰';
			case 'countries.AN': return '荷属安地列斯';
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
			case 'countries.PR': return '波多黎哥';
			case 'countries.QA': return '卡塔尔';
			case 'countries.RE': return '留尼汪';
			case 'countries.RO': return '罗马尼亚';
			case 'countries.RU': return '俄罗斯';
			case 'countries.RW': return '卢旺达';
			case 'countries.BL': return '圣巴泰勒米';
			case 'countries.SH': return '圣赫勒拿-阿森松-特里斯坦达库尼亚';
			case 'countries.KN': return '圣基茨和尼维斯';
			case 'countries.LC': return '圣卢西亚';
			case 'countries.MF': return '圣马丁';
			case 'countries.PM': return '圣皮埃尔和密克隆';
			case 'countries.VC': return '圣文森特和格林纳丁斯';
			case 'countries.WS': return '萨摩亚';
			case 'countries.SM': return '圣马利诺';
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
			case 'countries.SB': return '所罗门';
			case 'countries.SO': return '索马里';
			case 'countries.ZA': return '南非';
			case 'countries.GS': return '南乔治亚和南桑威奇';
			case 'countries.SS': return '南苏丹';
			case 'countries.ES': return '西班牙';
			case 'countries.LK': return '斯里兰卡';
			case 'countries.SD': return '苏丹';
			case 'countries.SR': return '苏里南';
			case 'countries.SJ': return '斯瓦尔巴和扬马延';
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
			case 'countries.TC': return '特克斯河凯科斯群岛';
			case 'countries.TV': return '图瓦卢';
			case 'countries.UG': return '乌干达';
			case 'countries.UA': return '乌克兰';
			case 'countries.AE': return '阿联酋';
			case 'countries.GB': return '英国';
			case 'countries.US': return '美国';
			case 'countries.UY': return '乌拉圭';
			case 'countries.UM': return '美国本土外小岛屿';
			case 'countries.UZ': return '乌兹别克斯坦';
			case 'countries.VU': return '瓦努阿图';
			case 'countries.VE': return '委内瑞拉';
			case 'countries.VN': return '越南';
			case 'countries.VG': return '英属维京群岛';
			case 'countries.VI': return '美属维京群岛';
			case 'countries.GB-WLS': return '威尔士';
			case 'countries.WF': return '瓦利斯群岛和富图纳群岛';
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
