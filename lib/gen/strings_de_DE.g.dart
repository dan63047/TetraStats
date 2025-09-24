///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsDeDe implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDeDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.deDe,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de-DE>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsDeDe _root = this; // ignore: unused_field

	@override 
	TranslationsDeDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDeDe(meta: meta ?? this.$meta);

	// Translations
	@override Map<String, String> get locales => {
		'en': 'Englisch',
		'ru-RU': 'Russisch (Русский)',
		'ko-KR': 'Koreanisch (한국인)',
		'zh-CN': 'Vereinfachtes Chinesisch (简体中文)',
		'de-DE': 'German (Deutsch)',
		'pl-PL': 'Polieren (Polski)',
	};
	@override Map<String, String> get gamemodes => {
		'league': 'Tetra League',
		'zenith': 'Quick Play',
		'zenithex': 'Quick Play Expert',
		'40l': '40 Lines',
		'blitz': 'Blitz',
		'5mblast': '5,000,000 Blast',
		'zen': 'Zen',
	};
	@override late final _TranslationsDestinationsDeDe destinations = _TranslationsDestinationsDeDe._(_root);
	@override Map<String, String> get playerRole => {
		'user': 'Nutzer',
		'banned': 'Gebannt',
		'bot': 'Bot',
		'sysop': 'Systemoperator',
		'admin': 'Admin',
		'mod': 'Moderator',
		'halfmod': 'Community Moderator',
		'anon': 'Anonym',
	};
	@override String get goBackButton => 'Zurück';
	@override String get nanow => 'Aktuell nicht verfügbar...';
	@override String seasonEnds({required Object countdown}) => 'Saison endet in ${countdown}';
	@override String get seasonEnded => 'Saison ist vorbei';
	@override String overallPB({required Object pb}) => 'Gesamt PB: ${pb} m';
	@override String gamesUntilRanked({required Object left}) => '${left} spiele bis zum Rang';
	@override String numOfVictories({required Object wins}) => '~${wins} Siege';
	@override String get promotionOnNextWin => 'Aufstieg beim nächsten Sieg';
	@override String numOfdefeats({required Object losses}) => '~${losses} Niederlagen';
	@override String get demotionOnNextLoss => 'Abstieg bei nächster Niederlage';
	@override String get records => 'Rekorde';
	@override String get nerdStats => 'Statistiken für Nerds';
	@override String get playstyles => 'Spielstile';
	@override String get horoscopes => 'Horoskope';
	@override String get relatedAchievements => 'Zugehörige Errungenschaften';
	@override String get season => 'Saison';
	@override String get smooth => 'Glatt';
	@override String get dateAndTime => 'Datum & Zeit';
	@override String get TLfullLBnote => 'Intensiv, aber erlaubt dir Spieler nach deren Statistiken zu sortieren und nach Rängen zu filtern';
	@override String get rank => 'Rang';
	@override String verdictGeneral({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} als ${rank} Durchschnitt';
	@override String get verdictBetter => 'besser';
	@override String get verdictWorse => 'schlechter';
	@override String get localStanding => 'Lokal';
	@override late final _TranslationsXpDeDe xp = _TranslationsXpDeDe._(_root);
	@override late final _TranslationsGametimeDeDe gametime = _TranslationsGametimeDeDe._(_root);
	@override String get whichOne => 'Which one?';
	@override String get track => 'Erfassen';
	@override String get stopTracking => 'Erfassen stoppen';
	@override String supporter({required Object tier}) => 'Unterstützer Stufe ${tier}';
	@override String comparingWith({required Object newDate, required Object oldDate}) => 'Daten von ${newDate}, vergleiche mit ${oldDate}';
	@override String get compare => 'Vergleich';
	@override String get comparison => 'Vergleichen';
	@override String get enterUsername => 'Benutzernamen eingeben \$avgX (X ist Rang)';
	@override String get general => 'Allgemein';
	@override String get badges => 'Abzeichen';
	@override String obtainDate({required Object date}) => 'Erhalten am ${date}';
	@override String get assignedManualy => 'Dieses Abzeichen wurde per Hand von TETR.IO Admins vergeben';
	@override String get distinguishment => 'Unterscheidung';
	@override String get banned => 'Gebannt';
	@override String get bannedSubtext => 'Banns werden vergeben wenn die TETR.IO Regeln oder Nutzungsvereinbarung gebrochen werden';
	@override String get badStanding => 'Bad standing';
	@override String get badStandingSubtext => 'Ein oder mehrere kürzliche Banns erhalten';
	@override String get botAccount => 'Bot Account';
	@override String botAccountSubtext({required Object botMaintainers}) => 'Betrieben von ${botMaintainers}';
	@override String get copiedToClipboard => 'In die Zwischenablage gespeichert!';
	@override String get bio => 'Bio';
	@override String get news => 'Neuigkeiten';
	@override late final _TranslationsMatchResultDeDe matchResult = _TranslationsMatchResultDeDe._(_root);
	@override late final _TranslationsDistinguishmentsDeDe distinguishments = _TranslationsDistinguishmentsDeDe._(_root);
	@override late final _TranslationsNewsEntriesDeDe newsEntries = _TranslationsNewsEntriesDeDe._(_root);
	@override String rankupMiddle({required Object r}) => '${r} Rang';
	@override String get copyUserID => 'Klicke um Nutzer ID zu kopieren';
	@override String get searchHint => 'Nutzername oder ID';
	@override String get navMenu => 'Navigation';
	@override String get navMenuTooltip => 'Öffne Navigation';
	@override String get refresh => 'Daten aktualisieren';
	@override String get searchButton => 'Suche';
	@override String get trackedPlayers => 'Erfasste Benutzer';
	@override String get standing => 'Stand';
	@override String get previousSeasons => 'Vorhärige Saison';
	@override String get checkingCache => 'Prüfe cache...';
	@override String get fetchingRecords => 'Rekorde laden...';
	@override String get munching => 'Analysiere...';
	@override String get outOf => 'von';
	@override String get replaysDone => 'Replays fertig';
	@override String get analysis => 'Analyse';
	@override String get minomuncherMention => 'via MinoMuncher von Freyhoe';
	@override String get recent => 'Kürzlich';
	@override String get top => 'Top';
	@override String get noRecord => 'Kein Rekord';
	@override String sprintAndBlitsRelevance({required Object date}) => 'Relevanz: ${date}';
	@override late final _TranslationsSnackBarMessagesDeDe snackBarMessages = _TranslationsSnackBarMessagesDeDe._(_root);
	@override late final _TranslationsErrorsDeDe errors = _TranslationsErrorsDeDe._(_root);
	@override late final _TranslationsActionsDeDe actions = _TranslationsActionsDeDe._(_root);
	@override late final _TranslationsGraphsDestinationDeDe graphsDestination = _TranslationsGraphsDestinationDeDe._(_root);
	@override late final _TranslationsFilterModaleDeDe filterModale = _TranslationsFilterModaleDeDe._(_root);
	@override late final _TranslationsCutoffsDestinationDeDe cutoffsDestination = _TranslationsCutoffsDestinationDeDe._(_root);
	@override late final _TranslationsRankViewDeDe rankView = _TranslationsRankViewDeDe._(_root);
	@override late final _TranslationsStateViewDeDe stateView = _TranslationsStateViewDeDe._(_root);
	@override late final _TranslationsTlMatchViewDeDe tlMatchView = _TranslationsTlMatchViewDeDe._(_root);
	@override late final _TranslationsCalcDestinationDeDe calcDestination = _TranslationsCalcDestinationDeDe._(_root);
	@override late final _TranslationsInfoDestinationDeDe infoDestination = _TranslationsInfoDestinationDeDe._(_root);
	@override late final _TranslationsLeaderboardsDestinationDeDe leaderboardsDestination = _TranslationsLeaderboardsDestinationDeDe._(_root);
	@override late final _TranslationsSavedDataDestinationDeDe savedDataDestination = _TranslationsSavedDataDestinationDeDe._(_root);
	@override late final _TranslationsSettingsDestinationDeDe settingsDestination = _TranslationsSettingsDestinationDeDe._(_root);
	@override late final _TranslationsHomeNavigationDeDe homeNavigation = _TranslationsHomeNavigationDeDe._(_root);
	@override late final _TranslationsGraphsNavigationDeDe graphsNavigation = _TranslationsGraphsNavigationDeDe._(_root);
	@override late final _TranslationsCalcNavigationDeDe calcNavigation = _TranslationsCalcNavigationDeDe._(_root);
	@override late final _TranslationsFirstTimeViewDeDe firstTimeView = _TranslationsFirstTimeViewDeDe._(_root);
	@override late final _TranslationsAboutViewDeDe aboutView = _TranslationsAboutViewDeDe._(_root);
	@override late final _TranslationsStatsDeDe stats = _TranslationsStatsDeDe._(_root);
	@override Map<String, String> get countries => {
		'': 'Weltweit',
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
		'XX': 'Unbekannt',
		'XM': 'Der Mond',
	};
}

// Path: destinations
class _TranslationsDestinationsDeDe implements TranslationsDestinationsEn {
	_TranslationsDestinationsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get home => 'Startseite';
	@override String get graphs => 'Graphen';
	@override String get leaderboards => 'Bestenlisten';
	@override String get cutoffs => 'Grenzwerte';
	@override String get calc => 'Rechner';
	@override String get info => 'Informationscenter';
	@override String get data => 'Gespeicherte Daten';
	@override String get settings => 'Einstellungen';
}

// Path: xp
class _TranslationsXpDeDe implements TranslationsXpEn {
	_TranslationsXpDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'XP Level';
	@override String progressToNextLevel({required Object percentage}) => 'Fortschritt zum nächsten Level: ${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => 'Fortschritt von 0 XP zum Level ${goal}: ${percentage} (${left} XP fehlen)';
}

// Path: gametime
class _TranslationsGametimeDeDe implements TranslationsGametimeEn {
	_TranslationsGametimeDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'genaue Spielzeit';
	@override String gametimeAday({required Object gametime}) => '${gametime} durchschnittliche Spielzeit am Tag';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'Das sind ${years} Jahre,\noder ${months} Monate,\noder ${days} Tage,\noder ${minutes} Minuten\noder ${seconds} Sekunden';
}

// Path: matchResult
class _TranslationsMatchResultDeDe implements TranslationsMatchResultEn {
	_TranslationsMatchResultDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get victory => 'Sieg';
	@override String get defeat => 'Niederlage';
	@override String get tie => 'Unentschieden';
	@override String get dqvictory => 'Gegner wurde DQ\'ed';
	@override String get dqdefeat => 'Disqualifiziert';
	@override String get nocontest => 'Kein Wettbewerb';
	@override String get nullified => 'Annulliert';
}

// Path: distinguishments
class _TranslationsDistinguishmentsDeDe implements TranslationsDistinguishmentsEn {
	_TranslationsDistinguishmentsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get noHeader => 'Header ist nicht Vorhanden';
	@override String get noFooter => 'Footer ist nicht Vorhanden';
	@override String get twc => 'TETR.IO Weltmeister';
	@override String twcYear({required Object year}) => '${year} TETR.IO Weltmeister';
}

// Path: newsEntries
class _TranslationsNewsEntriesDeDe implements TranslationsNewsEntriesEn {
	_TranslationsNewsEntriesDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override TextSpan leaderboard({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
		const TextSpan(text: 'Erreicht № '),
		rank,
		const TextSpan(text: ' in '),
		gametype,
	]);
	@override TextSpan personalbest({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
		const TextSpan(text: 'Erreicht einen neuen Rekord in '),
		gametype,
		const TextSpan(text: ' mit '),
		pb,
	]);
	@override TextSpan badge({required InlineSpan badge}) => TextSpan(children: [
		const TextSpan(text: 'Erhielt Abzeichen '),
		badge,
	]);
	@override TextSpan rankup({required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: 'Erreicht '),
		rank,
		const TextSpan(text: ' in Tetra League'),
	]);
	@override TextSpan supporter({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Wurde ein '),
		s('TETR.IO Unterstützer'),
	]);
	@override TextSpan supporter_gift({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Erhielt das Geschenk eines '),
		s('TETR.IO supporter'),
	]);
	@override TextSpan unknown({required InlineSpan type}) => TextSpan(children: [
		const TextSpan(text: 'Unbekannte Neuigkeiten vom Typ '),
		type,
	]);
}

// Path: snackBarMessages
class _TranslationsSnackBarMessagesDeDe implements TranslationsSnackBarMessagesEn {
	_TranslationsSnackBarMessagesDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => '${date} Status wurde von der Datenbank entfernt!';
	@override String matchRemoved({required Object date}) => '${date} Match wurde aus der Datenbank entfernt!';
	@override String get notForWeb => 'Funktion ist nicht verfügbar in der Webversion';
	@override String get importSuccess => 'Import erfolgreich';
	@override String get importCancelled => 'Import wurde abgebrochen';
}

// Path: errors
class _TranslationsErrorsDeDe implements TranslationsErrorsEn {
	_TranslationsErrorsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get noRecords => 'Keine Rekorde';
	@override String get notEnoughData => 'Nicht genug Daten';
	@override String get noHistorySaved => 'Keine Historie gespeichert';
	@override String connection({required Object code, required Object message}) => 'Netzwerkfehler: ${code} ${message}';
	@override String get noSuchUser => 'Dieser User existiert nicht';
	@override String get noSuchUserSub => 'Entweder hast du was falsch geschrieben, oder der Account existiert nicht mehr';
	@override String get discordNotAssigned => 'Keine Verknüpfungen gefunden';
	@override String get discordNotAssignedSub => 'Deine Anfrage sollte dem [API Guide](https://tetr.io/about/api/#userssearchquery) entsprechen';
	@override String get history => 'Historie des Nutzers fehlt';
	@override String get actionSuggestion => 'Womöglich, möchtest du';
	@override String get p1nkl0bst3rTLmatches => 'Keine Tetra League Matche gefunden';
	@override String get clientException => 'Keine Internetverbindung';
	@override String get forbidden => 'Deine IP-Adresse ist blockiert';
	@override String forbiddenSub({required Object nickname}) => 'Wenn du ein VPN oder Proxy verwendest, deaktiviere es. Wenn das nicht helfen sollte kontaktiere ${nickname}';
	@override String get tooManyRequests => 'Du hast das Anfragelimit erreicht.';
	@override String get tooManyRequestsSub => 'Warte einen Moment und versuche es erneut';
	@override String get internal => 'Irgendwas ist auf der tetr.io Seite passiert';
	@override String get internalSub => 'osk, weiß warscheinlich schon Bescheid';
	@override String get internalWebVersion => 'Irgendwas ist auf der tetr.io Seite passiert (oder auf oskware_bridge, ach was weiß ich)';
	@override String get internalWebVersionSub => 'Wenn auf osk Statusseite alles in Ordnung ist, dann lass es dan63047 wissen';
	@override String get oskwareBridge => 'Irgendwas ist mit oskware_bridge passiert';
	@override String get oskwareBridgeSub => 'Lass es dan63047 wissen';
	@override String get p1nkl0bst3rForbidden => 'Drittanbieter API ist von der IP-Adresse blockiert';
	@override String get p1nkl0bst3rTooManyRequests => 'Zu viele Anfragen an Drittanbiete API. Versuche es später erneut';
	@override String get p1nkl0bst3rinternal => 'Irgendwas ist auf der p1nkl0bst3r Seite passiert';
	@override String get p1nkl0bst3rinternalWebVersion => 'Irgendwas ist auf der p1nkl0bst3r Seite passiert (oder oskware_bridge, ach was weiß ich)';
	@override String get replayAlreadySaved => 'Wiederholung ist schon gespeichert';
	@override String get replayExpired => 'Wiederholung ist abgelaufen und ist nicht mehr Verfügbar';
	@override String get replayRejected => 'Drittanbieter API hat deine IP-Adresse blockiert';
}

// Path: actions
class _TranslationsActionsDeDe implements TranslationsActionsEn {
	_TranslationsActionsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get submit => 'Absenden';
	@override String get ok => 'OK';
	@override String get apply => 'Anwenden';
	@override String get refresh => 'Aktualisieren';
}

// Path: graphsDestination
class _TranslationsGraphsDestinationDeDe implements TranslationsGraphsDestinationEn {
	_TranslationsGraphsDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get fetchAndsaveTLHistory => 'Historie abrufen';
	@override String get fetchAndSaveOldTLmatches => 'Tetra League Matchhistorie abrufen';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '${number} Zustände was found';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} Matches gefunden';
	@override String gamesPlayed({required Object games}) => '${games} gespielt';
	@override String get dateAndTime => 'Datum & Zeit';
	@override String get filterModaleTitle => 'Filter Ränge oder Graphen';
	@override late final _TranslationsGraphsDestinationHistoryDeDe history = _TranslationsGraphsDestinationHistoryDeDe._(_root);
}

// Path: filterModale
class _TranslationsFilterModaleDeDe implements TranslationsFilterModaleEn {
	_TranslationsFilterModaleDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get all => 'Alle';
}

// Path: cutoffsDestination
class _TranslationsCutoffsDestinationDeDe implements TranslationsCutoffsDestinationEn {
	_TranslationsCutoffsDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tetra League Zustand';
	@override String relevance({required Object timestamp}) => 'stand vom ${timestamp}';
	@override String get actual => 'Aktuell';
	@override String get target => 'Ziel';
	@override String get cutoffTR => 'Grenzwert TR';
	@override String get targetTR => 'Ziel TR';
	@override String get state => 'Zustand';
	@override String get advanced => 'Erweitert';
	@override String players({required Object n}) => 'Spieler (${n})';
	@override String get moreInfo => 'Mehr Info';
	@override String NumberOne({required Object tr}) => '№ 1 ist ${tr} TR';
	@override String inflated({required Object tr}) => 'Überfüllt ab ${tr} TR';
	@override String get notInflated => 'Nicht überfüllt';
	@override String deflated({required Object tr}) => 'Unterfüllt ab ${tr} TR';
	@override String get notDeflated => 'Nicht unterfüllt';
	@override String get wellDotDotDot => 'Nun...';
	@override String fromPlace({required Object n}) => 'von № ${n}';
	@override String get viewButton => 'Ansicht';
}

// Path: rankView
class _TranslationsRankViewDeDe implements TranslationsRankViewEn {
	_TranslationsRankViewDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String rankTitle({required Object rank}) => '${rank} Rangdaten';
	@override String get everyoneTitle => 'Komplette Bestenliste';
	@override String get trRange => 'TR Reichweite';
	@override String get supposedToBe => 'Sollte sein';
	@override String gap({required Object value}) => '${value} Lücke';
	@override String trGap({required Object value}) => '${value} TR Lücke';
	@override String get deflationGap => 'Unterfüllt-Lücke';
	@override String get inflationGap => 'Überfüllt-Lücke';
	@override String get LBposRange => 'LB positions Reichweite';
	@override String overpopulated({required Object players}) => 'Überpopuliert von ${players} Spielern';
	@override String underpopulated({required Object players}) => 'Unterpopuliert von ${players} Spielern';
	@override String get PlayersEqualSupposedToBe => 'cute';
	@override String get avgStats => 'Durchschnitts-Statistik';
	@override String avgForRank({required Object rank}) => 'Durchschnitt für ${rank} Rang';
	@override String get avgNerdStats => 'Durchschnitts-Statistiken für Nerds';
	@override String get minimums => 'Minimume';
	@override String get maximums => 'Maximume';
}

// Path: stateView
class _TranslationsStateViewDeDe implements TranslationsStateViewEn {
	_TranslationsStateViewDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => 'Zustand vom ${date}';
}

// Path: tlMatchView
class _TranslationsTlMatchViewDeDe implements TranslationsTlMatchViewEn {
	_TranslationsTlMatchViewDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get match => 'Match';
	@override String get vs => 'vs';
	@override String get winner => 'Sieger';
	@override String roundNumber({required Object n}) => 'Runde ${n}';
	@override String get statsFor => 'Statistik für';
	@override String get numberOfRounds => 'Anzahl Runden';
	@override String get matchLength => 'Match Länge';
	@override String get roundLength => 'Runden Länge';
	@override String get matchStats => 'Match Statistik';
	@override String get downloadReplay => 'Download .ttrm Wiederholung';
	@override String get openReplay => 'Öffne Wiederholung in TETR.IO';
}

// Path: calcDestination
class _TranslationsCalcDestinationDeDe implements TranslationsCalcDestinationEn {
	_TranslationsCalcDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => 'Gebe ${stat} ein';
	@override String get tip => 'Gebe Wert ein und drücke "Berechnen", um Statistiken für Nerds zu sehen';
	@override String get invalidValues => 'Bitte, gebe ein validen Wert ein';
	@override String get statsCalcButton => 'Berechnen';
	@override String get damageCalcTip => 'Klicke auf die Aktionen zu deiner Linken, um diese hier hinzuzufügen';
	@override String get clearAll => 'Alles löschen';
	@override String get actions => 'Aktionen';
	@override String get results => 'Ergebnisse';
	@override String get rules => 'Regeln';
	@override String get noSpinClears => 'Keine Spin Clears';
	@override String get spins => 'Spins';
	@override String get miniSpins => 'Mini spins';
	@override String get noLineclear => 'Kein lineclear (Combo unterbrochen)';
	@override String get custom => 'Benutzerdefiniert';
	@override String get multiplier => 'Multiplikator';
	@override String get pcDamage => 'Perfect Clear Schaden';
	@override String get comboTable => 'Combo Tabelle';
	@override String get b2bChaining => 'Back-To-Back Chaining';
	@override String get surgeStartAtB2B => 'Startet bei B2B';
	@override String get surgeStartAmount => 'Start Wert';
	@override String get totalDamage => 'Totaler Schaden';
	@override String get lineclears => 'Lineclears';
	@override String get combo => 'Combo';
	@override String get surge => 'Surge';
	@override String get pcs => 'PCs';
}

// Path: infoDestination
class _TranslationsInfoDestinationDeDe implements TranslationsInfoDestinationEn {
	_TranslationsInfoDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Informationscenter';
	@override String get sprintAndBlitzAverages => '40 Lines & Blitz Durchschnitte';
	@override String get sprintAndBlitzAveragesDescription => 'Da 40 Lines & Blitz durchschnitte zu berechnen ein intensiver Prozess ist, aktualisieren sich die Daten nach einer Weile. Drücke auf den Titel von dieser Meldung, um den vollen 40 Lines & Blitz Durchschnittstabelle zu sehen';
	@override String get tetraStatsWiki => 'Tetra Stats Wiki';
	@override String get tetraStatsWikiDescription => 'Mehr Information zu Tetra Stats funktionen und Statistiken die es bereitstellt findest du hier';
	@override String get about => 'Über Tetra Stats';
	@override String get aboutDescription => 'Entwickelt von dan63\n';
}

// Path: leaderboardsDestination
class _TranslationsLeaderboardsDestinationDeDe implements TranslationsLeaderboardsDestinationEn {
	_TranslationsLeaderboardsDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bestenliste';
	@override String get tl => 'Tetra League (Aktuelle Saison)';
	@override String get fullTL => 'Tetra League (Aktuelle Saison, komplett)';
	@override String get ar => 'Errungenschaftspunkte';
}

// Path: savedDataDestination
class _TranslationsSavedDataDestinationDeDe implements TranslationsSavedDataDestinationEn {
	_TranslationsSavedDataDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Gespeicherte Daten';
	@override String get tip => 'Wähle Nutzername auf der linken aus um dessen Daten zu sehen';
	@override String seasonTLstates({required Object s}) => 'S${s} TL Statistiken';
	@override String get TLrecords => 'TL Rekorde';
}

// Path: settingsDestination
class _TranslationsSettingsDestinationDeDe implements TranslationsSettingsDestinationEn {
	_TranslationsSettingsDestinationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Einstellungen';
	@override String get general => 'Allgemein';
	@override String get customization => 'Personalisierung';
	@override String get database => 'Lokale Datenbank';
	@override String get checking => 'Überprüfen...';
	@override String get enterToSubmit => 'Drücke Enter zum absenden';
	@override String get account => 'Dein Account in TETR.IO';
	@override String get accountDescription => 'Statistiken dieses Spielers direkt beim ersten Start der App geladen. Standardmäßig läd es meine (dan63) Statistiken. Um das zu ändern, gebe bitte deinen Nutzernamen ein.';
	@override String get done => 'Fertig!';
	@override String get noSuchAccount => 'Diesen Account gibt es nicht';
	@override String get language => 'Sprache';
	@override String languageDescription({required Object languages}) => 'Tetra Stats wurde in ${languages} Sprachen übersetzt. Im Normalfall wird deine Systemsprache oder Englisch verwendet, falls deine Sprache nicht existiert.';
	@override String languages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		zero: 'Null Sprachen',
		one: '${n} Sprache',
		two: '${n} Sprachen',
		few: '${n} Sprachen',
		many: '${n} Sprachen',
		other: '${n} Sprachen',
	);
	@override String get updateInTheBackground => 'Aktualisieren der Daten im Hintergrund';
	@override String get updateInTheBackgroundDescription => 'Falls aktiviert, wird Tetra Stats versuchen die neue Daten zu laden wenn der Cache abgelaufen ist. Das passiert meistens alle 5 Minuten';
	@override String get munchLimit => 'Limit für Minomuncher Analyse';
	@override String get munchLimitDescription => 'Standardmäßig, analysiert minomuncher die ersten 10 Replays. Wenn du mehr möchtest kannst du das hier anpassen (max 25).';
	@override String get munchLimitTooMuch => 'Zu viel! Abgelehnt';
	@override String get compareStats => 'Vergleiche TL daten mit den Rangdurchschnitt';
	@override String get compareStatsDescription => 'Falls an, Tetra Stats wird weitere Parameter zur Verfügung stellen, welche es dir erlaubt dich mit den Durchschnittsspieler in deinem Rang zu vergleichen. Du wirs es so sehen: Statistiken werden mit einer Farbe markiert, fahre über diese drüber um mehr zu erfahren.';
	@override String get showPosition => 'Zeigt Position auf der Bestenliste nach Statistik';
	@override String get showPositionDescription => 'Dies kann einige Zeit und Daten in Anspruch nehmen, gibt dir aber die Möglichkeit deine Position in der Bestenliste zu sehen (nach Statistik sortiert)';
	@override String get accentColor => 'Akzentfarbe';
	@override String get accentColorDescription => 'Die Farbe die verwendet werden soll um UI Elemente hervorzuheben.';
	@override String get accentColorModale => 'Wähle eine Akzentfarbe aus';
	@override String get timestamps => 'Zeitformat';
	@override String timestampsDescriptionPart1({required Object d}) => 'Hier kannst du auswählen in welchen Format Zeitenpunkte dargestellt werden sollen. Standardmäßig werden diese in der GMT Zeitzone angezeigt und formatiert in folgendes format, Beispiel: ${d}.';
	@override String timestampsDescriptionPart2({required Object y, required Object r}) => 'Außerdem:\n• Lokale Zeitzone: ${y}\n• Relative Zeitzone: ${r}';
	@override String get timestampsAbsoluteGMT => 'Absolut (GMT)';
	@override String get timestampsAbsoluteLocalTime => 'Absolute (Deine Zeitzone)';
	@override String get timestampsRelative => 'Relative';
	@override String get sheetbotLikeGraphs => 'Sheetbot-like Verhalten von Radargraphen';
	@override String get sheetbotLikeGraphsDescription => 'Obwohl es von mir in Betracht gezogen wurde, dass die Funktionsweise von Diagrammen in SheetBot nicht sehr korrekt ist. Einige Leute waren verwirrt, als sie sahen, dass -0,5 Stride nicht so aussehen wie im SheetBot-Diagramm. Daher hier: Wenn dieser Schalter eingeschaltet ist, können Punkte in den Diagrammen auf der gegenüberliegenden Hälfte des Diagramms erscheinen, wenn der Wert negativ ist.';
	@override String get oskKagariGimmick => 'Osk-Kagari gimmick';
	@override String get oskKagariGimmickDescription => 'Falls an, anstelle von osk\'s Rang, :kagari: wird angezeigt.';
	@override String get bytesOfDataStored => 'an Daten gespeichert';
	@override String get TLrecordsSaved => 'Tetra League Rekorde gespeichert';
	@override String get TLplayerstatesSaved => 'Tetra League Nutzerzustände gespeichert';
	@override String get fixButton => 'Beheben';
	@override String get compressButton => 'Kompressieren';
	@override String get exportDB => 'Auf lokale Datenbank exportieren';
	@override String get desktopExportAlertTitle => 'Desktop Export';
	@override String get desktopExportText => 'Du verwendest anscheind die Desktop App.  Schau in deinen Dokumentenordner, dort findest du "TetraStats.db". Kopiere die irgendwo hin';
	@override String get androidExportAlertTitle => 'Android export';
	@override String androidExportText({required Object exportedDB}) => 'Exported.\n${exportedDB}';
	@override String get importDB => 'Importiere lokale Datenbank';
	@override String get importDBDescription => 'Stelle dein Backup wiederher. Bitte denke daran, dass deine bestehende Datenbank überschrieben wird';
	@override String get importWrongFileType => 'Falsches Dateiformat';
}

// Path: homeNavigation
class _TranslationsHomeNavigationDeDe implements TranslationsHomeNavigationEn {
	_TranslationsHomeNavigationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Übersicht';
	@override String get standing => 'Platzierung';
	@override String get seasons => 'Saisons';
	@override String get mathces => 'Matches';
	@override String get pb => 'PB';
	@override String get normal => 'Normal';
	@override String get expert => 'Expert';
	@override String get expertRecords => 'Ex Rekorde';
}

// Path: graphsNavigation
class _TranslationsGraphsNavigationDeDe implements TranslationsGraphsNavigationEn {
	_TranslationsGraphsNavigationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get history => 'Spielerhistorie';
	@override String get league => 'League Zustand';
	@override String get cutoffs => 'Grenzwerte Historie';
}

// Path: calcNavigation
class _TranslationsCalcNavigationDeDe implements TranslationsCalcNavigationEn {
	_TranslationsCalcNavigationDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get stats => 'Statistikenrechner';
	@override String get damage => 'Schadensrechner';
}

// Path: firstTimeView
class _TranslationsFirstTimeViewDeDe implements TranslationsFirstTimeViewEn {
	_TranslationsFirstTimeViewDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Willkommen auf Tetra Stats';
	@override String get description => 'Ein Dienst, der es dir erlaubt verschiedene Statistiken von TETR.IO aufzuzeichen';
	@override String get nicknameQuestion => 'Wie ist dein Nutzername?';
	@override String get inpuntHint => 'Gebe ihn hier ein... (3-16 Zeichen)';
	@override String get emptyInputError => 'Leereingaben funktionieren nicht';
	@override String niceToSeeYou({required Object n}) => 'Schön dich zu sehen, ${n}';
	@override String get letsTakeALook => 'Lass uns ein Blick auf deine Statistiken werfen...';
	@override String get skip => 'Überspringen';
}

// Path: aboutView
class _TranslationsAboutViewDeDe implements TranslationsAboutViewEn {
	_TranslationsAboutViewDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Über Tetra Stats';
	@override String get about => 'Tetra Stats ist ein Dienst, der mit der TETR.IO Tetra Channel API läuft, um Daten zur Verfügung zu stellen und weitere Statistiken basieren auf den Daten zu berechnen. Der Dienst erlaubt es dir Benutzer Fortschitte mit der "Aufzeichnen" Funktion zu verfolgen, welches Tetra League Änderungen in einer lokalen Datenbank speichert und verwaltet (nicht automatisch, besuche deine Seite ab und zu mal), damit man sie in Graphen darstellen kann.\n\nBeanserver blaster ist ein Teil von Tetra Stats, was als serverseitiges Skript fungiert. Es bietet komplette Tetra League Bestenlisten, sowie sortierung nach jeden möglichen Wert um Graphen darauf auzubauen, sowie Nutzern die möglichkeit zu geben Trends zu verfolgen. Eine Historie von Tetra League Rankgrenzwerten ist auch vorhanden, welche ebenfalls als Graph dargestellt werden können.\n\nGeplant sind Wiederholungsanalysen, sowie eine Turnierhistorie. Sei gespannt!\n\nDieser Dienst steht nicht in Verbindung mit TETR.IO oder osk in irgendeiner Weise.';
	@override String get appVersion => 'App Version';
	@override String build({required Object build}) => 'Build ${build}';
	@override String get GHrepo => 'GitHub Repository';
	@override String get submitAnIssue => 'Melde ein Problem';
	@override String get credits => 'Credits';
	@override String get authorAndDeveloper => 'Author & Entwickler';
	@override String get providedFormulas => 'Bereitgestellte Formeln';
	@override String get providedS1history => 'Bereitgestellte S1 Historie';
	@override String get inoue => 'Inoue (Wiederholungsschnapper)';
	@override String get zhCNlocale => 'Vereinfachtes Chinesisch Übersetzung';
	@override String get deDElocale => 'Deutsche Übersetzung';
	@override String get koKRlocale => 'Koreanisch Übersetzung';
	@override String get plPLlocale => 'Polieren Übersetzung';
	@override String withFixesBy({required Object username}) => 'Mit Korrekturen von ${username}';
	@override String get supportHim => 'Unterstütze Ihn!';
}

// Path: stats
class _TranslationsStatsDeDe implements TranslationsStatsEn {
	_TranslationsStatsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => 'Registrierungsdatum';
	@override String get gametime => 'Spielzeit';
	@override String get ogp => 'Onlinespiele gespielt';
	@override String get ogw => 'Onlinespiele gewonnen';
	@override String get followers => 'Followers';
	@override late final _TranslationsStatsXpDeDe xp = _TranslationsStatsXpDeDe._(_root);
	@override late final _TranslationsStatsTrDeDe tr = _TranslationsStatsTrDeDe._(_root);
	@override late final _TranslationsStatsGlickoDeDe glicko = _TranslationsStatsGlickoDeDe._(_root);
	@override late final _TranslationsStatsRdDeDe rd = _TranslationsStatsRdDeDe._(_root);
	@override late final _TranslationsStatsGlixareDeDe glixare = _TranslationsStatsGlixareDeDe._(_root);
	@override late final _TranslationsStatsS1trDeDe s1tr = _TranslationsStatsS1trDeDe._(_root);
	@override late final _TranslationsStatsGpDeDe gp = _TranslationsStatsGpDeDe._(_root);
	@override late final _TranslationsStatsGwDeDe gw = _TranslationsStatsGwDeDe._(_root);
	@override late final _TranslationsStatsWinrateDeDe winrate = _TranslationsStatsWinrateDeDe._(_root);
	@override late final _TranslationsStatsApmDeDe apm = _TranslationsStatsApmDeDe._(_root);
	@override late final _TranslationsStatsPpsDeDe pps = _TranslationsStatsPpsDeDe._(_root);
	@override late final _TranslationsStatsVsDeDe vs = _TranslationsStatsVsDeDe._(_root);
	@override late final _TranslationsStatsAppDeDe app = _TranslationsStatsAppDeDe._(_root);
	@override late final _TranslationsStatsVsapmDeDe vsapm = _TranslationsStatsVsapmDeDe._(_root);
	@override late final _TranslationsStatsDssDeDe dss = _TranslationsStatsDssDeDe._(_root);
	@override late final _TranslationsStatsDspDeDe dsp = _TranslationsStatsDspDeDe._(_root);
	@override late final _TranslationsStatsAppdspDeDe appdsp = _TranslationsStatsAppdspDeDe._(_root);
	@override late final _TranslationsStatsCheeseDeDe cheese = _TranslationsStatsCheeseDeDe._(_root);
	@override late final _TranslationsStatsGbeDeDe gbe = _TranslationsStatsGbeDeDe._(_root);
	@override late final _TranslationsStatsNyaappDeDe nyaapp = _TranslationsStatsNyaappDeDe._(_root);
	@override late final _TranslationsStatsAreaDeDe area = _TranslationsStatsAreaDeDe._(_root);
	@override late final _TranslationsStatsEtrDeDe etr = _TranslationsStatsEtrDeDe._(_root);
	@override late final _TranslationsStatsEtraccDeDe etracc = _TranslationsStatsEtraccDeDe._(_root);
	@override late final _TranslationsStatsOpenerDeDe opener = _TranslationsStatsOpenerDeDe._(_root);
	@override late final _TranslationsStatsPlonkDeDe plonk = _TranslationsStatsPlonkDeDe._(_root);
	@override late final _TranslationsStatsStrideDeDe stride = _TranslationsStatsStrideDeDe._(_root);
	@override late final _TranslationsStatsInfdsDeDe infds = _TranslationsStatsInfdsDeDe._(_root);
	@override late final _TranslationsStatsAltitudeDeDe altitude = _TranslationsStatsAltitudeDeDe._(_root);
	@override late final _TranslationsStatsClimbSpeedDeDe climbSpeed = _TranslationsStatsClimbSpeedDeDe._(_root);
	@override late final _TranslationsStatsPeakClimbSpeedDeDe peakClimbSpeed = _TranslationsStatsPeakClimbSpeedDeDe._(_root);
	@override late final _TranslationsStatsKosDeDe kos = _TranslationsStatsKosDeDe._(_root);
	@override late final _TranslationsStatsB2bDeDe b2b = _TranslationsStatsB2bDeDe._(_root);
	@override late final _TranslationsStatsFinesseDeDe finesse = _TranslationsStatsFinesseDeDe._(_root);
	@override late final _TranslationsStatsFinesseFaultsDeDe finesseFaults = _TranslationsStatsFinesseFaultsDeDe._(_root);
	@override late final _TranslationsStatsTotalTimeDeDe totalTime = _TranslationsStatsTotalTimeDeDe._(_root);
	@override late final _TranslationsStatsLevelDeDe level = _TranslationsStatsLevelDeDe._(_root);
	@override late final _TranslationsStatsPiecesDeDe pieces = _TranslationsStatsPiecesDeDe._(_root);
	@override late final _TranslationsStatsSppDeDe spp = _TranslationsStatsSppDeDe._(_root);
	@override late final _TranslationsStatsKpDeDe kp = _TranslationsStatsKpDeDe._(_root);
	@override late final _TranslationsStatsKppDeDe kpp = _TranslationsStatsKppDeDe._(_root);
	@override late final _TranslationsStatsKpsDeDe kps = _TranslationsStatsKpsDeDe._(_root);
	@override late final _TranslationsStatsAplDeDe apl = _TranslationsStatsAplDeDe._(_root);
	@override late final _TranslationsStatsQuadEfficiencyDeDe quadEfficiency = _TranslationsStatsQuadEfficiencyDeDe._(_root);
	@override late final _TranslationsStatsTspinEfficiencyDeDe tspinEfficiency = _TranslationsStatsTspinEfficiencyDeDe._(_root);
	@override late final _TranslationsStatsAllspinEfficiencyDeDe allspinEfficiency = _TranslationsStatsAllspinEfficiencyDeDe._(_root);
	@override String blitzScore({required Object p}) => '${p} Punkte';
	@override String levelUpRequirement({required Object p}) => 'Level up in ${p} Punkten';
	@override String get piecesTotal => 'Insgesamt platzierte Steine';
	@override String get piecesWithPerfectFinesse => 'davon mit perfekter Finesse';
	@override String get score => 'Punkte';
	@override String get lines => 'Linien';
	@override String get linesShort => 'L';
	@override String get pcs => 'Perfect Clears';
	@override String get holds => 'Gehalten';
	@override String get spike => 'Top Spike';
	@override String top({required Object percentage}) => 'Top ${percentage}';
	@override String topRank({required Object rank}) => 'Toprang: ${rank}';
	@override String get floor => 'Ebene';
	@override String get split => 'Split';
	@override String get total => 'Total';
	@override String get sent => 'Gesendet';
	@override String get received => 'Erhalten';
	@override String get placement => 'Platzierung';
	@override String get peak => 'Beste';
	@override String get overall => 'Overall';
	@override String get midgame => 'Midgame';
	@override String get efficiency => 'Effizienz';
	@override String get upstack => 'Upstack';
	@override String get downstack => 'Downstack';
	@override String get variance => 'Variance';
	@override String get burst => 'Burst';
	@override String get length => 'Length';
	@override String get rate => 'Rate';
	@override String get secsDS => 'Secs/DS';
	@override String get secsCheese => 'Secs/Cheese';
	@override String get attackCheesiness => 'Attacken Cheesiness';
	@override String get downstackingRatio => 'Downstacking Ratio';
	@override String get clearTypes => 'Clear Types';
	@override String get wellColumnDistribution => 'Well Column Distribution';
	@override String get allSpins => 'All Spins';
	@override String get sankeyTitle => 'Eingehende Attacke Sankey Chart';
	@override String get incomingAttack => 'Eingehende Attacke';
	@override String get clean => 'Clean';
	@override String get cancelled => 'Cancelled';
	@override String get cheeseTanked => 'Cheese Tanked';
	@override String get cleanTanked => 'Clean Tanked';
	@override String get kills => 'Kills';
	@override String get deaths => 'Tode';
	@override String get ppsDistribution => 'PPS distribution';
	@override String qpWithMods({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		one: 'Mit 1 Mod',
		two: 'Mit ${n} Mods',
		few: 'Mit ${n} Mods',
		many: 'Mit ${n} Mods',
		other: 'Mit ${n} Mods',
	);
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		zero: '${n} Tastenanschläge',
		one: '${n} Tastenanschlag',
		two: '${n} Tastenanschläge',
		few: '${n} Tastenanschläge',
		many: '${n} Tastenanschläge',
		other: '${n} Tastenanschläge',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		zero: '${n} T-Spins gesamt',
		one: '${n} T-Spin gesamt',
		two: '${n} T-Spins gesamt',
		few: '${n} T-Spins gesamt',
		many: '${n} T-Spins gesamt',
		other: '${n} T-Spins gesamt',
	);
	@override String linesCleared({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		zero: '${n} Linien geklärt',
		one: '${n} Linie geklärt',
		two: '${n} Linien geklärt',
		few: '${n} Linien geklärt',
		many: '${n} Linien geklärt',
		other: '${n} Linien geklärt',
	);
	@override late final _TranslationsStatsGraphsDeDe graphs = _TranslationsStatsGraphsDeDe._(_root);
	@override String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		zero: '${n} Spieler',
		one: '${n} Spieler',
		two: '${n} Spieler',
		few: '${n} Spieler',
		many: '${n} Spieler',
		other: '${n} Spieler',
	);
	@override String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
		zero: '${n} Spiele',
		one: '${n} Spiel',
		two: '${n} Spiele',
		few: '${n} Spiele',
		many: '${n} Spiele',
		other: '${n} Spiele',
	);
	@override late final _TranslationsStatsLineClearDeDe lineClear = _TranslationsStatsLineClearDeDe._(_root);
	@override late final _TranslationsStatsLineClearsDeDe lineClears = _TranslationsStatsLineClearsDeDe._(_root);
	@override String get mini => 'Mini';
	@override String get tSpin => 'T-Spin';
	@override String get tSpins => 'T-Spins';
	@override String get spin => 'Spin';
	@override String get spins => 'Spins';
}

// Path: graphsDestination.history
class _TranslationsGraphsDestinationHistoryDeDe implements TranslationsGraphsDestinationHistoryEn {
	_TranslationsGraphsDestinationHistoryDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get last7 => 'Last 7 Days';
	@override String get last30 => 'Last 30 Days';
	@override String get last90 => 'Last 90 Days';
	@override String get full => 'Full History';
}

// Path: stats.xp
class _TranslationsStatsXpDeDe implements TranslationsStatsXpEn {
	_TranslationsStatsXpDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'XP';
	@override String get full => 'Erfahrungspunkte';
}

// Path: stats.tr
class _TranslationsStatsTrDeDe implements TranslationsStatsTrEn {
	_TranslationsStatsTrDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => 'Tetra Rating';
}

// Path: stats.glicko
class _TranslationsStatsGlickoDeDe implements TranslationsStatsGlickoEn {
	_TranslationsStatsGlickoDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => 'Glicko';
}

// Path: stats.rd
class _TranslationsStatsRdDeDe implements TranslationsStatsRdEn {
	_TranslationsStatsRdDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'RA';
	@override String get full => 'Rating Abweichung';
}

// Path: stats.glixare
class _TranslationsStatsGlixareDeDe implements TranslationsStatsGlixareEn {
	_TranslationsStatsGlixareDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _TranslationsStatsS1trDeDe implements TranslationsStatsS1trEn {
	_TranslationsStatsS1trDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'S1 TR';
	@override String get full => 'Season 1 ähnliche TR';
}

// Path: stats.gp
class _TranslationsStatsGpDeDe implements TranslationsStatsGpEn {
	_TranslationsStatsGpDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'GP';
	@override String get full => 'Spiele gespielt';
}

// Path: stats.gw
class _TranslationsStatsGwDeDe implements TranslationsStatsGwEn {
	_TranslationsStatsGwDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'GW';
	@override String get full => 'Spiele gewonnen';
}

// Path: stats.winrate
class _TranslationsStatsWinrateDeDe implements TranslationsStatsWinrateEn {
	_TranslationsStatsWinrateDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'WR%';
	@override String get full => 'Siegrate';
}

// Path: stats.apm
class _TranslationsStatsApmDeDe implements TranslationsStatsApmEn {
	_TranslationsStatsApmDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => 'Attacken pro Minute';
}

// Path: stats.pps
class _TranslationsStatsPpsDeDe implements TranslationsStatsPpsEn {
	_TranslationsStatsPpsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => 'Steine pro Sekunde';
}

// Path: stats.vs
class _TranslationsStatsVsDeDe implements TranslationsStatsVsEn {
	_TranslationsStatsVsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => 'Versus Wertung';
}

// Path: stats.app
class _TranslationsStatsAppDeDe implements TranslationsStatsAppEn {
	_TranslationsStatsAppDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => 'Attack pro Stein';
}

// Path: stats.vsapm
class _TranslationsStatsVsapmDeDe implements TranslationsStatsVsapmEn {
	_TranslationsStatsVsapmDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _TranslationsStatsDssDeDe implements TranslationsStatsDssEn {
	_TranslationsStatsDssDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => 'Downstack pro Sekunde';
}

// Path: stats.dsp
class _TranslationsStatsDspDeDe implements TranslationsStatsDspEn {
	_TranslationsStatsDspDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => 'Downstack pro Stein';
}

// Path: stats.appdsp
class _TranslationsStatsAppdspDeDe implements TranslationsStatsAppdspEn {
	_TranslationsStatsAppdspDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _TranslationsStatsCheeseDeDe implements TranslationsStatsCheeseEn {
	_TranslationsStatsCheeseDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Cheese';
	@override String get full => 'Cheese Index';
}

// Path: stats.gbe
class _TranslationsStatsGbeDeDe implements TranslationsStatsGbeEn {
	_TranslationsStatsGbeDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => 'Garbage Effizienz';
}

// Path: stats.nyaapp
class _TranslationsStatsNyaappDeDe implements TranslationsStatsNyaappEn {
	_TranslationsStatsNyaappDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => 'Gewichtete APP';
}

// Path: stats.area
class _TranslationsStatsAreaDeDe implements TranslationsStatsAreaEn {
	_TranslationsStatsAreaDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Area';
	@override String get full => 'Areal';
}

// Path: stats.etr
class _TranslationsStatsEtrDeDe implements TranslationsStatsEtrEn {
	_TranslationsStatsEtrDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => 'Voraussichtlichen TR';
}

// Path: stats.etracc
class _TranslationsStatsEtraccDeDe implements TranslationsStatsEtraccEn {
	_TranslationsStatsEtraccDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => 'Genauigkeit der voraussichtlichen TR';
}

// Path: stats.opener
class _TranslationsStatsOpenerDeDe implements TranslationsStatsOpenerEn {
	_TranslationsStatsOpenerDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Opener';
	@override String get full => 'Opener';
}

// Path: stats.plonk
class _TranslationsStatsPlonkDeDe implements TranslationsStatsPlonkEn {
	_TranslationsStatsPlonkDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Plonk';
	@override String get full => 'Plonk';
}

// Path: stats.stride
class _TranslationsStatsStrideDeDe implements TranslationsStatsStrideEn {
	_TranslationsStatsStrideDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Stride';
	@override String get full => 'Stride';
}

// Path: stats.infds
class _TranslationsStatsInfdsDeDe implements TranslationsStatsInfdsEn {
	_TranslationsStatsInfdsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Inf. DS';
	@override String get full => 'Infinite Downstack';
}

// Path: stats.altitude
class _TranslationsStatsAltitudeDeDe implements TranslationsStatsAltitudeEn {
	_TranslationsStatsAltitudeDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'm';
	@override String get full => 'Höhe';
}

// Path: stats.climbSpeed
class _TranslationsStatsClimbSpeedDeDe implements TranslationsStatsClimbSpeedEn {
	_TranslationsStatsClimbSpeedDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'CSP';
	@override String get full => 'Klettergeschwindkeit';
	@override String get gaugetTitle => 'Kletter-\ngeschwindigkeit';
}

// Path: stats.peakClimbSpeed
class _TranslationsStatsPeakClimbSpeedDeDe implements TranslationsStatsPeakClimbSpeedEn {
	_TranslationsStatsPeakClimbSpeedDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Beste CSP';
	@override String get full => 'Beste Klettergeschwindigkeit';
	@override String get gaugetTitle => 'Beste';
}

// Path: stats.kos
class _TranslationsStatsKosDeDe implements TranslationsStatsKosEn {
	_TranslationsStatsKosDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'KO\'s';
	@override String get full => 'Eliminierungen';
}

// Path: stats.b2b
class _TranslationsStatsB2bDeDe implements TranslationsStatsB2bEn {
	_TranslationsStatsB2bDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => 'Back-To-Back';
}

// Path: stats.finesse
class _TranslationsStatsFinesseDeDe implements TranslationsStatsFinesseEn {
	_TranslationsStatsFinesseDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'F';
	@override String get full => 'Finesse';
	@override String get widgetTitle => 'inesse';
}

// Path: stats.finesseFaults
class _TranslationsStatsFinesseFaultsDeDe implements TranslationsStatsFinesseFaultsEn {
	_TranslationsStatsFinesseFaultsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'FF';
	@override String get full => 'Finesse Fehler';
}

// Path: stats.totalTime
class _TranslationsStatsTotalTimeDeDe implements TranslationsStatsTotalTimeEn {
	_TranslationsStatsTotalTimeDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Zeit';
	@override String get full => 'Gesamtzeit';
	@override String get widgetTitle => 'Gesamt Zeit';
}

// Path: stats.level
class _TranslationsStatsLevelDeDe implements TranslationsStatsLevelEn {
	_TranslationsStatsLevelDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Lvl';
	@override String get full => 'Level';
}

// Path: stats.pieces
class _TranslationsStatsPiecesDeDe implements TranslationsStatsPiecesEn {
	_TranslationsStatsPiecesDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => 'Steine';
}

// Path: stats.spp
class _TranslationsStatsSppDeDe implements TranslationsStatsSppEn {
	_TranslationsStatsSppDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => 'Punkte pro Stein';
}

// Path: stats.kp
class _TranslationsStatsKpDeDe implements TranslationsStatsKpEn {
	_TranslationsStatsKpDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => 'Tastenanschläge';
}

// Path: stats.kpp
class _TranslationsStatsKppDeDe implements TranslationsStatsKppEn {
	_TranslationsStatsKppDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => 'Tastenanschläge pro Stein';
}

// Path: stats.kps
class _TranslationsStatsKpsDeDe implements TranslationsStatsKpsEn {
	_TranslationsStatsKpsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => 'Tastenanschläge pro Sekunden';
}

// Path: stats.apl
class _TranslationsStatsAplDeDe implements TranslationsStatsAplEn {
	_TranslationsStatsAplDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'APL';
	@override String get full => 'Attack Per Line';
}

// Path: stats.quadEfficiency
class _TranslationsStatsQuadEfficiencyDeDe implements TranslationsStatsQuadEfficiencyEn {
	_TranslationsStatsQuadEfficiencyDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'Q Eff.';
	@override String get full => 'Quad efficiency';
}

// Path: stats.tspinEfficiency
class _TranslationsStatsTspinEfficiencyDeDe implements TranslationsStatsTspinEfficiencyEn {
	_TranslationsStatsTspinEfficiencyDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'T Eff.';
	@override String get full => 'T-spin efficiency';
}

// Path: stats.allspinEfficiency
class _TranslationsStatsAllspinEfficiencyDeDe implements TranslationsStatsAllspinEfficiencyEn {
	_TranslationsStatsAllspinEfficiencyDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get short => 'All Eff.';
	@override String get full => 'All-spin efficiency';
}

// Path: stats.graphs
class _TranslationsStatsGraphsDeDe implements TranslationsStatsGraphsEn {
	_TranslationsStatsGraphsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

	// Translations
	@override String get attack => 'Attacke';
	@override String get speed => 'Geschwindigkeit';
	@override String get defense => 'Verteidigung';
	@override String get cheese => 'Cheese';
}

// Path: stats.lineClear
class _TranslationsStatsLineClearDeDe implements TranslationsStatsLineClearEn {
	_TranslationsStatsLineClearDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

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
class _TranslationsStatsLineClearsDeDe implements TranslationsStatsLineClearsEn {
	_TranslationsStatsLineClearsDeDe._(this._root);

	final TranslationsDeDe _root; // ignore: unused_field

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
extension on TranslationsDeDe {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'Englisch';
			case 'locales.ru-RU': return 'Russisch (Русский)';
			case 'locales.ko-KR': return 'Koreanisch (한국인)';
			case 'locales.zh-CN': return 'Vereinfachtes Chinesisch (简体中文)';
			case 'locales.de-DE': return 'German (Deutsch)';
			case 'locales.pl-PL': return 'Polieren (Polski)';
			case 'gamemodes.league': return 'Tetra League';
			case 'gamemodes.zenith': return 'Quick Play';
			case 'gamemodes.zenithex': return 'Quick Play Expert';
			case 'gamemodes.40l': return '40 Lines';
			case 'gamemodes.blitz': return 'Blitz';
			case 'gamemodes.5mblast': return '5,000,000 Blast';
			case 'gamemodes.zen': return 'Zen';
			case 'destinations.home': return 'Startseite';
			case 'destinations.graphs': return 'Graphen';
			case 'destinations.leaderboards': return 'Bestenlisten';
			case 'destinations.cutoffs': return 'Grenzwerte';
			case 'destinations.calc': return 'Rechner';
			case 'destinations.info': return 'Informationscenter';
			case 'destinations.data': return 'Gespeicherte Daten';
			case 'destinations.settings': return 'Einstellungen';
			case 'playerRole.user': return 'Nutzer';
			case 'playerRole.banned': return 'Gebannt';
			case 'playerRole.bot': return 'Bot';
			case 'playerRole.sysop': return 'Systemoperator';
			case 'playerRole.admin': return 'Admin';
			case 'playerRole.mod': return 'Moderator';
			case 'playerRole.halfmod': return 'Community Moderator';
			case 'playerRole.anon': return 'Anonym';
			case 'goBackButton': return 'Zurück';
			case 'nanow': return 'Aktuell nicht verfügbar...';
			case 'seasonEnds': return ({required Object countdown}) => 'Saison endet in ${countdown}';
			case 'seasonEnded': return 'Saison ist vorbei';
			case 'overallPB': return ({required Object pb}) => 'Gesamt PB: ${pb} m';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} spiele bis zum Rang';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} Siege';
			case 'promotionOnNextWin': return 'Aufstieg beim nächsten Sieg';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} Niederlagen';
			case 'demotionOnNextLoss': return 'Abstieg bei nächster Niederlage';
			case 'records': return 'Rekorde';
			case 'nerdStats': return 'Statistiken für Nerds';
			case 'playstyles': return 'Spielstile';
			case 'horoscopes': return 'Horoskope';
			case 'relatedAchievements': return 'Zugehörige Errungenschaften';
			case 'season': return 'Saison';
			case 'smooth': return 'Glatt';
			case 'dateAndTime': return 'Datum & Zeit';
			case 'TLfullLBnote': return 'Intensiv, aber erlaubt dir Spieler nach deren Statistiken zu sortieren und nach Rängen zu filtern';
			case 'rank': return 'Rang';
			case 'verdictGeneral': return ({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} als ${rank} Durchschnitt';
			case 'verdictBetter': return 'besser';
			case 'verdictWorse': return 'schlechter';
			case 'localStanding': return 'Lokal';
			case 'xp.title': return 'XP Level';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => 'Fortschritt zum nächsten Level: ${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => 'Fortschritt von 0 XP zum Level ${goal}: ${percentage} (${left} XP fehlen)';
			case 'gametime.title': return 'genaue Spielzeit';
			case 'gametime.gametimeAday': return ({required Object gametime}) => '${gametime} durchschnittliche Spielzeit am Tag';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'Das sind ${years} Jahre,\noder ${months} Monate,\noder ${days} Tage,\noder ${minutes} Minuten\noder ${seconds} Sekunden';
			case 'whichOne': return 'Which one?';
			case 'track': return 'Erfassen';
			case 'stopTracking': return 'Erfassen stoppen';
			case 'supporter': return ({required Object tier}) => 'Unterstützer Stufe ${tier}';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => 'Daten von ${newDate}, vergleiche mit ${oldDate}';
			case 'compare': return 'Vergleich';
			case 'comparison': return 'Vergleichen';
			case 'enterUsername': return 'Benutzernamen eingeben \$avgX (X ist Rang)';
			case 'general': return 'Allgemein';
			case 'badges': return 'Abzeichen';
			case 'obtainDate': return ({required Object date}) => 'Erhalten am ${date}';
			case 'assignedManualy': return 'Dieses Abzeichen wurde per Hand von TETR.IO Admins vergeben';
			case 'distinguishment': return 'Unterscheidung';
			case 'banned': return 'Gebannt';
			case 'bannedSubtext': return 'Banns werden vergeben wenn die TETR.IO Regeln oder Nutzungsvereinbarung gebrochen werden';
			case 'badStanding': return 'Bad standing';
			case 'badStandingSubtext': return 'Ein oder mehrere kürzliche Banns erhalten';
			case 'botAccount': return 'Bot Account';
			case 'botAccountSubtext': return ({required Object botMaintainers}) => 'Betrieben von ${botMaintainers}';
			case 'copiedToClipboard': return 'In die Zwischenablage gespeichert!';
			case 'bio': return 'Bio';
			case 'news': return 'Neuigkeiten';
			case 'matchResult.victory': return 'Sieg';
			case 'matchResult.defeat': return 'Niederlage';
			case 'matchResult.tie': return 'Unentschieden';
			case 'matchResult.dqvictory': return 'Gegner wurde DQ\'ed';
			case 'matchResult.dqdefeat': return 'Disqualifiziert';
			case 'matchResult.nocontest': return 'Kein Wettbewerb';
			case 'matchResult.nullified': return 'Annulliert';
			case 'distinguishments.noHeader': return 'Header ist nicht Vorhanden';
			case 'distinguishments.noFooter': return 'Footer ist nicht Vorhanden';
			case 'distinguishments.twc': return 'TETR.IO Weltmeister';
			case 'distinguishments.twcYear': return ({required Object year}) => '${year} TETR.IO Weltmeister';
			case 'newsEntries.leaderboard': return ({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
				const TextSpan(text: 'Erreicht № '),
				rank,
				const TextSpan(text: ' in '),
				gametype,
			]);
			case 'newsEntries.personalbest': return ({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
				const TextSpan(text: 'Erreicht einen neuen Rekord in '),
				gametype,
				const TextSpan(text: ' mit '),
				pb,
			]);
			case 'newsEntries.badge': return ({required InlineSpan badge}) => TextSpan(children: [
				const TextSpan(text: 'Erhielt Abzeichen '),
				badge,
			]);
			case 'newsEntries.rankup': return ({required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: 'Erreicht '),
				rank,
				const TextSpan(text: ' in Tetra League'),
			]);
			case 'newsEntries.supporter': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Wurde ein '),
				s('TETR.IO Unterstützer'),
			]);
			case 'newsEntries.supporter_gift': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Erhielt das Geschenk eines '),
				s('TETR.IO supporter'),
			]);
			case 'newsEntries.unknown': return ({required InlineSpan type}) => TextSpan(children: [
				const TextSpan(text: 'Unbekannte Neuigkeiten vom Typ '),
				type,
			]);
			case 'rankupMiddle': return ({required Object r}) => '${r} Rang';
			case 'copyUserID': return 'Klicke um Nutzer ID zu kopieren';
			case 'searchHint': return 'Nutzername oder ID';
			case 'navMenu': return 'Navigation';
			case 'navMenuTooltip': return 'Öffne Navigation';
			case 'refresh': return 'Daten aktualisieren';
			case 'searchButton': return 'Suche';
			case 'trackedPlayers': return 'Erfasste Benutzer';
			case 'standing': return 'Stand';
			case 'previousSeasons': return 'Vorhärige Saison';
			case 'checkingCache': return 'Prüfe cache...';
			case 'fetchingRecords': return 'Rekorde laden...';
			case 'munching': return 'Analysiere...';
			case 'outOf': return 'von';
			case 'replaysDone': return 'Replays fertig';
			case 'analysis': return 'Analyse';
			case 'minomuncherMention': return 'via MinoMuncher von Freyhoe';
			case 'recent': return 'Kürzlich';
			case 'top': return 'Top';
			case 'noRecord': return 'Kein Rekord';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => 'Relevanz: ${date}';
			case 'snackBarMessages.stateRemoved': return ({required Object date}) => '${date} Status wurde von der Datenbank entfernt!';
			case 'snackBarMessages.matchRemoved': return ({required Object date}) => '${date} Match wurde aus der Datenbank entfernt!';
			case 'snackBarMessages.notForWeb': return 'Funktion ist nicht verfügbar in der Webversion';
			case 'snackBarMessages.importSuccess': return 'Import erfolgreich';
			case 'snackBarMessages.importCancelled': return 'Import wurde abgebrochen';
			case 'errors.noRecords': return 'Keine Rekorde';
			case 'errors.notEnoughData': return 'Nicht genug Daten';
			case 'errors.noHistorySaved': return 'Keine Historie gespeichert';
			case 'errors.connection': return ({required Object code, required Object message}) => 'Netzwerkfehler: ${code} ${message}';
			case 'errors.noSuchUser': return 'Dieser User existiert nicht';
			case 'errors.noSuchUserSub': return 'Entweder hast du was falsch geschrieben, oder der Account existiert nicht mehr';
			case 'errors.discordNotAssigned': return 'Keine Verknüpfungen gefunden';
			case 'errors.discordNotAssignedSub': return 'Deine Anfrage sollte dem [API Guide](https://tetr.io/about/api/#userssearchquery) entsprechen';
			case 'errors.history': return 'Historie des Nutzers fehlt';
			case 'errors.actionSuggestion': return 'Womöglich, möchtest du';
			case 'errors.p1nkl0bst3rTLmatches': return 'Keine Tetra League Matche gefunden';
			case 'errors.clientException': return 'Keine Internetverbindung';
			case 'errors.forbidden': return 'Deine IP-Adresse ist blockiert';
			case 'errors.forbiddenSub': return ({required Object nickname}) => 'Wenn du ein VPN oder Proxy verwendest, deaktiviere es. Wenn das nicht helfen sollte kontaktiere ${nickname}';
			case 'errors.tooManyRequests': return 'Du hast das Anfragelimit erreicht.';
			case 'errors.tooManyRequestsSub': return 'Warte einen Moment und versuche es erneut';
			case 'errors.internal': return 'Irgendwas ist auf der tetr.io Seite passiert';
			case 'errors.internalSub': return 'osk, weiß warscheinlich schon Bescheid';
			case 'errors.internalWebVersion': return 'Irgendwas ist auf der tetr.io Seite passiert (oder auf oskware_bridge, ach was weiß ich)';
			case 'errors.internalWebVersionSub': return 'Wenn auf osk Statusseite alles in Ordnung ist, dann lass es dan63047 wissen';
			case 'errors.oskwareBridge': return 'Irgendwas ist mit oskware_bridge passiert';
			case 'errors.oskwareBridgeSub': return 'Lass es dan63047 wissen';
			case 'errors.p1nkl0bst3rForbidden': return 'Drittanbieter API ist von der IP-Adresse blockiert';
			case 'errors.p1nkl0bst3rTooManyRequests': return 'Zu viele Anfragen an Drittanbiete API. Versuche es später erneut';
			case 'errors.p1nkl0bst3rinternal': return 'Irgendwas ist auf der p1nkl0bst3r Seite passiert';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'Irgendwas ist auf der p1nkl0bst3r Seite passiert (oder oskware_bridge, ach was weiß ich)';
			case 'errors.replayAlreadySaved': return 'Wiederholung ist schon gespeichert';
			case 'errors.replayExpired': return 'Wiederholung ist abgelaufen und ist nicht mehr Verfügbar';
			case 'errors.replayRejected': return 'Drittanbieter API hat deine IP-Adresse blockiert';
			case 'actions.cancel': return 'Abbrechen';
			case 'actions.submit': return 'Absenden';
			case 'actions.ok': return 'OK';
			case 'actions.apply': return 'Anwenden';
			case 'actions.refresh': return 'Aktualisieren';
			case 'graphsDestination.fetchAndsaveTLHistory': return 'Historie abrufen';
			case 'graphsDestination.fetchAndSaveOldTLmatches': return 'Tetra League Matchhistorie abrufen';
			case 'graphsDestination.fetchAndsaveTLHistoryResult': return ({required Object number}) => '${number} Zustände was found';
			case 'graphsDestination.fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '${number} Matches gefunden';
			case 'graphsDestination.gamesPlayed': return ({required Object games}) => '${games} gespielt';
			case 'graphsDestination.dateAndTime': return 'Datum & Zeit';
			case 'graphsDestination.filterModaleTitle': return 'Filter Ränge oder Graphen';
			case 'graphsDestination.history.last7': return 'Last 7 Days';
			case 'graphsDestination.history.last30': return 'Last 30 Days';
			case 'graphsDestination.history.last90': return 'Last 90 Days';
			case 'graphsDestination.history.full': return 'Full History';
			case 'filterModale.all': return 'Alle';
			case 'cutoffsDestination.title': return 'Tetra League Zustand';
			case 'cutoffsDestination.relevance': return ({required Object timestamp}) => 'stand vom ${timestamp}';
			case 'cutoffsDestination.actual': return 'Aktuell';
			case 'cutoffsDestination.target': return 'Ziel';
			case 'cutoffsDestination.cutoffTR': return 'Grenzwert TR';
			case 'cutoffsDestination.targetTR': return 'Ziel TR';
			case 'cutoffsDestination.state': return 'Zustand';
			case 'cutoffsDestination.advanced': return 'Erweitert';
			case 'cutoffsDestination.players': return ({required Object n}) => 'Spieler (${n})';
			case 'cutoffsDestination.moreInfo': return 'Mehr Info';
			case 'cutoffsDestination.NumberOne': return ({required Object tr}) => '№ 1 ist ${tr} TR';
			case 'cutoffsDestination.inflated': return ({required Object tr}) => 'Überfüllt ab ${tr} TR';
			case 'cutoffsDestination.notInflated': return 'Nicht überfüllt';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => 'Unterfüllt ab ${tr} TR';
			case 'cutoffsDestination.notDeflated': return 'Nicht unterfüllt';
			case 'cutoffsDestination.wellDotDotDot': return 'Nun...';
			case 'cutoffsDestination.fromPlace': return ({required Object n}) => 'von № ${n}';
			case 'cutoffsDestination.viewButton': return 'Ansicht';
			case 'rankView.rankTitle': return ({required Object rank}) => '${rank} Rangdaten';
			case 'rankView.everyoneTitle': return 'Komplette Bestenliste';
			case 'rankView.trRange': return 'TR Reichweite';
			case 'rankView.supposedToBe': return 'Sollte sein';
			case 'rankView.gap': return ({required Object value}) => '${value} Lücke';
			case 'rankView.trGap': return ({required Object value}) => '${value} TR Lücke';
			case 'rankView.deflationGap': return 'Unterfüllt-Lücke';
			case 'rankView.inflationGap': return 'Überfüllt-Lücke';
			case 'rankView.LBposRange': return 'LB positions Reichweite';
			case 'rankView.overpopulated': return ({required Object players}) => 'Überpopuliert von ${players} Spielern';
			case 'rankView.underpopulated': return ({required Object players}) => 'Unterpopuliert von ${players} Spielern';
			case 'rankView.PlayersEqualSupposedToBe': return 'cute';
			case 'rankView.avgStats': return 'Durchschnitts-Statistik';
			case 'rankView.avgForRank': return ({required Object rank}) => 'Durchschnitt für ${rank} Rang';
			case 'rankView.avgNerdStats': return 'Durchschnitts-Statistiken für Nerds';
			case 'rankView.minimums': return 'Minimume';
			case 'rankView.maximums': return 'Maximume';
			case 'stateView.title': return ({required Object date}) => 'Zustand vom ${date}';
			case 'tlMatchView.match': return 'Match';
			case 'tlMatchView.vs': return 'vs';
			case 'tlMatchView.winner': return 'Sieger';
			case 'tlMatchView.roundNumber': return ({required Object n}) => 'Runde ${n}';
			case 'tlMatchView.statsFor': return 'Statistik für';
			case 'tlMatchView.numberOfRounds': return 'Anzahl Runden';
			case 'tlMatchView.matchLength': return 'Match Länge';
			case 'tlMatchView.roundLength': return 'Runden Länge';
			case 'tlMatchView.matchStats': return 'Match Statistik';
			case 'tlMatchView.downloadReplay': return 'Download .ttrm Wiederholung';
			case 'tlMatchView.openReplay': return 'Öffne Wiederholung in TETR.IO';
			case 'calcDestination.placeholders': return ({required Object stat}) => 'Gebe ${stat} ein';
			case 'calcDestination.tip': return 'Gebe Wert ein und drücke "Berechnen", um Statistiken für Nerds zu sehen';
			case 'calcDestination.invalidValues': return 'Bitte, gebe ein validen Wert ein';
			case 'calcDestination.statsCalcButton': return 'Berechnen';
			case 'calcDestination.damageCalcTip': return 'Klicke auf die Aktionen zu deiner Linken, um diese hier hinzuzufügen';
			case 'calcDestination.clearAll': return 'Alles löschen';
			case 'calcDestination.actions': return 'Aktionen';
			case 'calcDestination.results': return 'Ergebnisse';
			case 'calcDestination.rules': return 'Regeln';
			case 'calcDestination.noSpinClears': return 'Keine Spin Clears';
			case 'calcDestination.spins': return 'Spins';
			case 'calcDestination.miniSpins': return 'Mini spins';
			case 'calcDestination.noLineclear': return 'Kein lineclear (Combo unterbrochen)';
			case 'calcDestination.custom': return 'Benutzerdefiniert';
			case 'calcDestination.multiplier': return 'Multiplikator';
			case 'calcDestination.pcDamage': return 'Perfect Clear Schaden';
			case 'calcDestination.comboTable': return 'Combo Tabelle';
			case 'calcDestination.b2bChaining': return 'Back-To-Back Chaining';
			case 'calcDestination.surgeStartAtB2B': return 'Startet bei B2B';
			case 'calcDestination.surgeStartAmount': return 'Start Wert';
			case 'calcDestination.totalDamage': return 'Totaler Schaden';
			case 'calcDestination.lineclears': return 'Lineclears';
			case 'calcDestination.combo': return 'Combo';
			case 'calcDestination.surge': return 'Surge';
			case 'calcDestination.pcs': return 'PCs';
			case 'infoDestination.title': return 'Informationscenter';
			case 'infoDestination.sprintAndBlitzAverages': return '40 Lines & Blitz Durchschnitte';
			case 'infoDestination.sprintAndBlitzAveragesDescription': return 'Da 40 Lines & Blitz durchschnitte zu berechnen ein intensiver Prozess ist, aktualisieren sich die Daten nach einer Weile. Drücke auf den Titel von dieser Meldung, um den vollen 40 Lines & Blitz Durchschnittstabelle zu sehen';
			case 'infoDestination.tetraStatsWiki': return 'Tetra Stats Wiki';
			case 'infoDestination.tetraStatsWikiDescription': return 'Mehr Information zu Tetra Stats funktionen und Statistiken die es bereitstellt findest du hier';
			case 'infoDestination.about': return 'Über Tetra Stats';
			case 'infoDestination.aboutDescription': return 'Entwickelt von dan63\n';
			case 'leaderboardsDestination.title': return 'Bestenliste';
			case 'leaderboardsDestination.tl': return 'Tetra League (Aktuelle Saison)';
			case 'leaderboardsDestination.fullTL': return 'Tetra League (Aktuelle Saison, komplett)';
			case 'leaderboardsDestination.ar': return 'Errungenschaftspunkte';
			case 'savedDataDestination.title': return 'Gespeicherte Daten';
			case 'savedDataDestination.tip': return 'Wähle Nutzername auf der linken aus um dessen Daten zu sehen';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => 'S${s} TL Statistiken';
			case 'savedDataDestination.TLrecords': return 'TL Rekorde';
			case 'settingsDestination.title': return 'Einstellungen';
			case 'settingsDestination.general': return 'Allgemein';
			case 'settingsDestination.customization': return 'Personalisierung';
			case 'settingsDestination.database': return 'Lokale Datenbank';
			case 'settingsDestination.checking': return 'Überprüfen...';
			case 'settingsDestination.enterToSubmit': return 'Drücke Enter zum absenden';
			case 'settingsDestination.account': return 'Dein Account in TETR.IO';
			case 'settingsDestination.accountDescription': return 'Statistiken dieses Spielers direkt beim ersten Start der App geladen. Standardmäßig läd es meine (dan63) Statistiken. Um das zu ändern, gebe bitte deinen Nutzernamen ein.';
			case 'settingsDestination.done': return 'Fertig!';
			case 'settingsDestination.noSuchAccount': return 'Diesen Account gibt es nicht';
			case 'settingsDestination.language': return 'Sprache';
			case 'settingsDestination.languageDescription': return ({required Object languages}) => 'Tetra Stats wurde in ${languages} Sprachen übersetzt. Im Normalfall wird deine Systemsprache oder Englisch verwendet, falls deine Sprache nicht existiert.';
			case 'settingsDestination.languages': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				zero: 'Null Sprachen',
				one: '${n} Sprache',
				two: '${n} Sprachen',
				few: '${n} Sprachen',
				many: '${n} Sprachen',
				other: '${n} Sprachen',
			);
			case 'settingsDestination.updateInTheBackground': return 'Aktualisieren der Daten im Hintergrund';
			case 'settingsDestination.updateInTheBackgroundDescription': return 'Falls aktiviert, wird Tetra Stats versuchen die neue Daten zu laden wenn der Cache abgelaufen ist. Das passiert meistens alle 5 Minuten';
			case 'settingsDestination.munchLimit': return 'Limit für Minomuncher Analyse';
			case 'settingsDestination.munchLimitDescription': return 'Standardmäßig, analysiert minomuncher die ersten 10 Replays. Wenn du mehr möchtest kannst du das hier anpassen (max 25).';
			case 'settingsDestination.munchLimitTooMuch': return 'Zu viel! Abgelehnt';
			case 'settingsDestination.compareStats': return 'Vergleiche TL daten mit den Rangdurchschnitt';
			case 'settingsDestination.compareStatsDescription': return 'Falls an, Tetra Stats wird weitere Parameter zur Verfügung stellen, welche es dir erlaubt dich mit den Durchschnittsspieler in deinem Rang zu vergleichen. Du wirs es so sehen: Statistiken werden mit einer Farbe markiert, fahre über diese drüber um mehr zu erfahren.';
			case 'settingsDestination.showPosition': return 'Zeigt Position auf der Bestenliste nach Statistik';
			case 'settingsDestination.showPositionDescription': return 'Dies kann einige Zeit und Daten in Anspruch nehmen, gibt dir aber die Möglichkeit deine Position in der Bestenliste zu sehen (nach Statistik sortiert)';
			case 'settingsDestination.accentColor': return 'Akzentfarbe';
			case 'settingsDestination.accentColorDescription': return 'Die Farbe die verwendet werden soll um UI Elemente hervorzuheben.';
			case 'settingsDestination.accentColorModale': return 'Wähle eine Akzentfarbe aus';
			case 'settingsDestination.timestamps': return 'Zeitformat';
			case 'settingsDestination.timestampsDescriptionPart1': return ({required Object d}) => 'Hier kannst du auswählen in welchen Format Zeitenpunkte dargestellt werden sollen. Standardmäßig werden diese in der GMT Zeitzone angezeigt und formatiert in folgendes format, Beispiel: ${d}.';
			case 'settingsDestination.timestampsDescriptionPart2': return ({required Object y, required Object r}) => 'Außerdem:\n• Lokale Zeitzone: ${y}\n• Relative Zeitzone: ${r}';
			case 'settingsDestination.timestampsAbsoluteGMT': return 'Absolut (GMT)';
			case 'settingsDestination.timestampsAbsoluteLocalTime': return 'Absolute (Deine Zeitzone)';
			case 'settingsDestination.timestampsRelative': return 'Relative';
			case 'settingsDestination.sheetbotLikeGraphs': return 'Sheetbot-like Verhalten von Radargraphen';
			case 'settingsDestination.sheetbotLikeGraphsDescription': return 'Obwohl es von mir in Betracht gezogen wurde, dass die Funktionsweise von Diagrammen in SheetBot nicht sehr korrekt ist. Einige Leute waren verwirrt, als sie sahen, dass -0,5 Stride nicht so aussehen wie im SheetBot-Diagramm. Daher hier: Wenn dieser Schalter eingeschaltet ist, können Punkte in den Diagrammen auf der gegenüberliegenden Hälfte des Diagramms erscheinen, wenn der Wert negativ ist.';
			case 'settingsDestination.oskKagariGimmick': return 'Osk-Kagari gimmick';
			case 'settingsDestination.oskKagariGimmickDescription': return 'Falls an, anstelle von osk\'s Rang, :kagari: wird angezeigt.';
			case 'settingsDestination.bytesOfDataStored': return 'an Daten gespeichert';
			case 'settingsDestination.TLrecordsSaved': return 'Tetra League Rekorde gespeichert';
			case 'settingsDestination.TLplayerstatesSaved': return 'Tetra League Nutzerzustände gespeichert';
			case 'settingsDestination.fixButton': return 'Beheben';
			case 'settingsDestination.compressButton': return 'Kompressieren';
			case 'settingsDestination.exportDB': return 'Auf lokale Datenbank exportieren';
			case 'settingsDestination.desktopExportAlertTitle': return 'Desktop Export';
			case 'settingsDestination.desktopExportText': return 'Du verwendest anscheind die Desktop App.  Schau in deinen Dokumentenordner, dort findest du "TetraStats.db". Kopiere die irgendwo hin';
			case 'settingsDestination.androidExportAlertTitle': return 'Android export';
			case 'settingsDestination.androidExportText': return ({required Object exportedDB}) => 'Exported.\n${exportedDB}';
			case 'settingsDestination.importDB': return 'Importiere lokale Datenbank';
			case 'settingsDestination.importDBDescription': return 'Stelle dein Backup wiederher. Bitte denke daran, dass deine bestehende Datenbank überschrieben wird';
			case 'settingsDestination.importWrongFileType': return 'Falsches Dateiformat';
			case 'homeNavigation.overview': return 'Übersicht';
			case 'homeNavigation.standing': return 'Platzierung';
			case 'homeNavigation.seasons': return 'Saisons';
			case 'homeNavigation.mathces': return 'Matches';
			case 'homeNavigation.pb': return 'PB';
			case 'homeNavigation.normal': return 'Normal';
			case 'homeNavigation.expert': return 'Expert';
			case 'homeNavigation.expertRecords': return 'Ex Rekorde';
			case 'graphsNavigation.history': return 'Spielerhistorie';
			case 'graphsNavigation.league': return 'League Zustand';
			case 'graphsNavigation.cutoffs': return 'Grenzwerte Historie';
			case 'calcNavigation.stats': return 'Statistikenrechner';
			case 'calcNavigation.damage': return 'Schadensrechner';
			case 'firstTimeView.welcome': return 'Willkommen auf Tetra Stats';
			case 'firstTimeView.description': return 'Ein Dienst, der es dir erlaubt verschiedene Statistiken von TETR.IO aufzuzeichen';
			case 'firstTimeView.nicknameQuestion': return 'Wie ist dein Nutzername?';
			case 'firstTimeView.inpuntHint': return 'Gebe ihn hier ein... (3-16 Zeichen)';
			case 'firstTimeView.emptyInputError': return 'Leereingaben funktionieren nicht';
			case 'firstTimeView.niceToSeeYou': return ({required Object n}) => 'Schön dich zu sehen, ${n}';
			case 'firstTimeView.letsTakeALook': return 'Lass uns ein Blick auf deine Statistiken werfen...';
			case 'firstTimeView.skip': return 'Überspringen';
			case 'aboutView.title': return 'Über Tetra Stats';
			case 'aboutView.about': return 'Tetra Stats ist ein Dienst, der mit der TETR.IO Tetra Channel API läuft, um Daten zur Verfügung zu stellen und weitere Statistiken basieren auf den Daten zu berechnen. Der Dienst erlaubt es dir Benutzer Fortschitte mit der "Aufzeichnen" Funktion zu verfolgen, welches Tetra League Änderungen in einer lokalen Datenbank speichert und verwaltet (nicht automatisch, besuche deine Seite ab und zu mal), damit man sie in Graphen darstellen kann.\n\nBeanserver blaster ist ein Teil von Tetra Stats, was als serverseitiges Skript fungiert. Es bietet komplette Tetra League Bestenlisten, sowie sortierung nach jeden möglichen Wert um Graphen darauf auzubauen, sowie Nutzern die möglichkeit zu geben Trends zu verfolgen. Eine Historie von Tetra League Rankgrenzwerten ist auch vorhanden, welche ebenfalls als Graph dargestellt werden können.\n\nGeplant sind Wiederholungsanalysen, sowie eine Turnierhistorie. Sei gespannt!\n\nDieser Dienst steht nicht in Verbindung mit TETR.IO oder osk in irgendeiner Weise.';
			case 'aboutView.appVersion': return 'App Version';
			case 'aboutView.build': return ({required Object build}) => 'Build ${build}';
			case 'aboutView.GHrepo': return 'GitHub Repository';
			case 'aboutView.submitAnIssue': return 'Melde ein Problem';
			case 'aboutView.credits': return 'Credits';
			case 'aboutView.authorAndDeveloper': return 'Author & Entwickler';
			case 'aboutView.providedFormulas': return 'Bereitgestellte Formeln';
			case 'aboutView.providedS1history': return 'Bereitgestellte S1 Historie';
			case 'aboutView.inoue': return 'Inoue (Wiederholungsschnapper)';
			case 'aboutView.zhCNlocale': return 'Vereinfachtes Chinesisch Übersetzung';
			case 'aboutView.deDElocale': return 'Deutsche Übersetzung';
			case 'aboutView.koKRlocale': return 'Koreanisch Übersetzung';
			case 'aboutView.plPLlocale': return 'Polieren Übersetzung';
			case 'aboutView.withFixesBy': return ({required Object username}) => 'Mit Korrekturen von ${username}';
			case 'aboutView.supportHim': return 'Unterstütze Ihn!';
			case 'stats.registrationDate': return 'Registrierungsdatum';
			case 'stats.gametime': return 'Spielzeit';
			case 'stats.ogp': return 'Onlinespiele gespielt';
			case 'stats.ogw': return 'Onlinespiele gewonnen';
			case 'stats.followers': return 'Followers';
			case 'stats.xp.short': return 'XP';
			case 'stats.xp.full': return 'Erfahrungspunkte';
			case 'stats.tr.short': return 'TR';
			case 'stats.tr.full': return 'Tetra Rating';
			case 'stats.glicko.short': return 'Glicko';
			case 'stats.glicko.full': return 'Glicko';
			case 'stats.rd.short': return 'RA';
			case 'stats.rd.full': return 'Rating Abweichung';
			case 'stats.glixare.short': return 'GXE';
			case 'stats.glixare.full': return 'GLIXARE';
			case 'stats.s1tr.short': return 'S1 TR';
			case 'stats.s1tr.full': return 'Season 1 ähnliche TR';
			case 'stats.gp.short': return 'GP';
			case 'stats.gp.full': return 'Spiele gespielt';
			case 'stats.gw.short': return 'GW';
			case 'stats.gw.full': return 'Spiele gewonnen';
			case 'stats.winrate.short': return 'WR%';
			case 'stats.winrate.full': return 'Siegrate';
			case 'stats.apm.short': return 'APM';
			case 'stats.apm.full': return 'Attacken pro Minute';
			case 'stats.pps.short': return 'PPS';
			case 'stats.pps.full': return 'Steine pro Sekunde';
			case 'stats.vs.short': return 'VS';
			case 'stats.vs.full': return 'Versus Wertung';
			case 'stats.app.short': return 'APP';
			case 'stats.app.full': return 'Attack pro Stein';
			case 'stats.vsapm.short': return 'VS/APM';
			case 'stats.vsapm.full': return 'VS / APM';
			case 'stats.dss.short': return 'DS/S';
			case 'stats.dss.full': return 'Downstack pro Sekunde';
			case 'stats.dsp.short': return 'DS/P';
			case 'stats.dsp.full': return 'Downstack pro Stein';
			case 'stats.appdsp.short': return 'APP+DSP';
			case 'stats.appdsp.full': return 'APP + DSP';
			case 'stats.cheese.short': return 'Cheese';
			case 'stats.cheese.full': return 'Cheese Index';
			case 'stats.gbe.short': return 'GbE';
			case 'stats.gbe.full': return 'Garbage Effizienz';
			case 'stats.nyaapp.short': return 'wAPP';
			case 'stats.nyaapp.full': return 'Gewichtete APP';
			case 'stats.area.short': return 'Area';
			case 'stats.area.full': return 'Areal';
			case 'stats.etr.short': return 'eTR';
			case 'stats.etr.full': return 'Voraussichtlichen TR';
			case 'stats.etracc.short': return '±eTR';
			case 'stats.etracc.full': return 'Genauigkeit der voraussichtlichen TR';
			case 'stats.opener.short': return 'Opener';
			case 'stats.opener.full': return 'Opener';
			case 'stats.plonk.short': return 'Plonk';
			case 'stats.plonk.full': return 'Plonk';
			case 'stats.stride.short': return 'Stride';
			case 'stats.stride.full': return 'Stride';
			case 'stats.infds.short': return 'Inf. DS';
			case 'stats.infds.full': return 'Infinite Downstack';
			case 'stats.altitude.short': return 'm';
			case 'stats.altitude.full': return 'Höhe';
			case 'stats.climbSpeed.short': return 'CSP';
			case 'stats.climbSpeed.full': return 'Klettergeschwindkeit';
			case 'stats.climbSpeed.gaugetTitle': return 'Kletter-\ngeschwindigkeit';
			case 'stats.peakClimbSpeed.short': return 'Beste CSP';
			case 'stats.peakClimbSpeed.full': return 'Beste Klettergeschwindigkeit';
			case 'stats.peakClimbSpeed.gaugetTitle': return 'Beste';
			case 'stats.kos.short': return 'KO\'s';
			case 'stats.kos.full': return 'Eliminierungen';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return 'Back-To-Back';
			case 'stats.finesse.short': return 'F';
			case 'stats.finesse.full': return 'Finesse';
			case 'stats.finesse.widgetTitle': return 'inesse';
			case 'stats.finesseFaults.short': return 'FF';
			case 'stats.finesseFaults.full': return 'Finesse Fehler';
			case 'stats.totalTime.short': return 'Zeit';
			case 'stats.totalTime.full': return 'Gesamtzeit';
			case 'stats.totalTime.widgetTitle': return 'Gesamt Zeit';
			case 'stats.level.short': return 'Lvl';
			case 'stats.level.full': return 'Level';
			case 'stats.pieces.short': return 'P';
			case 'stats.pieces.full': return 'Steine';
			case 'stats.spp.short': return 'SPP';
			case 'stats.spp.full': return 'Punkte pro Stein';
			case 'stats.kp.short': return 'KP';
			case 'stats.kp.full': return 'Tastenanschläge';
			case 'stats.kpp.short': return 'KPP';
			case 'stats.kpp.full': return 'Tastenanschläge pro Stein';
			case 'stats.kps.short': return 'KPS';
			case 'stats.kps.full': return 'Tastenanschläge pro Sekunden';
			case 'stats.apl.short': return 'APL';
			case 'stats.apl.full': return 'Attack Per Line';
			case 'stats.quadEfficiency.short': return 'Q Eff.';
			case 'stats.quadEfficiency.full': return 'Quad efficiency';
			case 'stats.tspinEfficiency.short': return 'T Eff.';
			case 'stats.tspinEfficiency.full': return 'T-spin efficiency';
			case 'stats.allspinEfficiency.short': return 'All Eff.';
			case 'stats.allspinEfficiency.full': return 'All-spin efficiency';
			case 'stats.blitzScore': return ({required Object p}) => '${p} Punkte';
			case 'stats.levelUpRequirement': return ({required Object p}) => 'Level up in ${p} Punkten';
			case 'stats.piecesTotal': return 'Insgesamt platzierte Steine';
			case 'stats.piecesWithPerfectFinesse': return 'davon mit perfekter Finesse';
			case 'stats.score': return 'Punkte';
			case 'stats.lines': return 'Linien';
			case 'stats.linesShort': return 'L';
			case 'stats.pcs': return 'Perfect Clears';
			case 'stats.holds': return 'Gehalten';
			case 'stats.spike': return 'Top Spike';
			case 'stats.top': return ({required Object percentage}) => 'Top ${percentage}';
			case 'stats.topRank': return ({required Object rank}) => 'Toprang: ${rank}';
			case 'stats.floor': return 'Ebene';
			case 'stats.split': return 'Split';
			case 'stats.total': return 'Total';
			case 'stats.sent': return 'Gesendet';
			case 'stats.received': return 'Erhalten';
			case 'stats.placement': return 'Platzierung';
			case 'stats.peak': return 'Beste';
			case 'stats.overall': return 'Overall';
			case 'stats.midgame': return 'Midgame';
			case 'stats.efficiency': return 'Effizienz';
			case 'stats.upstack': return 'Upstack';
			case 'stats.downstack': return 'Downstack';
			case 'stats.variance': return 'Variance';
			case 'stats.burst': return 'Burst';
			case 'stats.length': return 'Length';
			case 'stats.rate': return 'Rate';
			case 'stats.secsDS': return 'Secs/DS';
			case 'stats.secsCheese': return 'Secs/Cheese';
			case 'stats.attackCheesiness': return 'Attacken Cheesiness';
			case 'stats.downstackingRatio': return 'Downstacking Ratio';
			case 'stats.clearTypes': return 'Clear Types';
			case 'stats.wellColumnDistribution': return 'Well Column Distribution';
			case 'stats.allSpins': return 'All Spins';
			case 'stats.sankeyTitle': return 'Eingehende Attacke Sankey Chart';
			case 'stats.incomingAttack': return 'Eingehende Attacke';
			case 'stats.clean': return 'Clean';
			case 'stats.cancelled': return 'Cancelled';
			case 'stats.cheeseTanked': return 'Cheese Tanked';
			case 'stats.cleanTanked': return 'Clean Tanked';
			case 'stats.kills': return 'Kills';
			case 'stats.deaths': return 'Tode';
			case 'stats.ppsDistribution': return 'PPS distribution';
			case 'stats.qpWithMods': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				one: 'Mit 1 Mod',
				two: 'Mit ${n} Mods',
				few: 'Mit ${n} Mods',
				many: 'Mit ${n} Mods',
				other: 'Mit ${n} Mods',
			);
			case 'stats.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				zero: '${n} Tastenanschläge',
				one: '${n} Tastenanschlag',
				two: '${n} Tastenanschläge',
				few: '${n} Tastenanschläge',
				many: '${n} Tastenanschläge',
				other: '${n} Tastenanschläge',
			);
			case 'stats.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				zero: '${n} T-Spins gesamt',
				one: '${n} T-Spin gesamt',
				two: '${n} T-Spins gesamt',
				few: '${n} T-Spins gesamt',
				many: '${n} T-Spins gesamt',
				other: '${n} T-Spins gesamt',
			);
			case 'stats.linesCleared': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				zero: '${n} Linien geklärt',
				one: '${n} Linie geklärt',
				two: '${n} Linien geklärt',
				few: '${n} Linien geklärt',
				many: '${n} Linien geklärt',
				other: '${n} Linien geklärt',
			);
			case 'stats.graphs.attack': return 'Attacke';
			case 'stats.graphs.speed': return 'Geschwindigkeit';
			case 'stats.graphs.defense': return 'Verteidigung';
			case 'stats.graphs.cheese': return 'Cheese';
			case 'stats.players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				zero: '${n} Spieler',
				one: '${n} Spieler',
				two: '${n} Spieler',
				few: '${n} Spieler',
				many: '${n} Spieler',
				other: '${n} Spieler',
			);
			case 'stats.games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(n,
				zero: '${n} Spiele',
				one: '${n} Spiel',
				two: '${n} Spiele',
				few: '${n} Spiele',
				many: '${n} Spiele',
				other: '${n} Spiele',
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
			case 'stats.tSpin': return 'T-Spin';
			case 'stats.tSpins': return 'T-Spins';
			case 'stats.spin': return 'Spin';
			case 'stats.spins': return 'Spins';
			case 'countries.': return 'Weltweit';
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
			case 'countries.XX': return 'Unbekannt';
			case 'countries.XM': return 'Der Mond';
			default: return null;
		}
	}
}

