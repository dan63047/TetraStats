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
class TranslationsPlPl implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPlPl({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.plPl,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pl-PL>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsPlPl _root = this; // ignore: unused_field

	@override 
	TranslationsPlPl $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPlPl(meta: meta ?? this.$meta);

	// Translations
	@override Map<String, String> get locales => {
		'en': 'Angielski (English)',
		'ru-RU': 'Rosyjski (Русский)',
		'ko-KR': 'Koreański (한국인)',
		'zh-CN': 'Chiński uproszczony (简体中文)',
		'de-DE': 'Niemiecki (Deutsch)',
		'pl-PL': 'Polski',
	};
	@override Map<String, String> get gamemodes => {
		'league': 'Tetra League',
		'zenith': 'Quick Play',
		'zenithex': 'Quick Play Ekspert',
		'40l': '40 Line',
		'blitz': 'Blitz',
		'5mblast': '5,000,000 Blast',
		'zen': 'Zen',
	};
	@override late final _TranslationsDestinationsPlPl destinations = _TranslationsDestinationsPlPl._(_root);
	@override Map<String, String> get playerRole => {
		'user': 'Użytkownik',
		'banned': 'Zbanowany',
		'bot': 'Bot',
		'sysop': 'Operator systemowy',
		'admin': 'Administrator',
		'mod': 'Moderator',
		'halfmod': 'Moderator Społeczności',
		'anon': 'Anonim',
	};
	@override String get goBackButton => 'Powrót';
	@override String get nanow => 'Obecnie niedostępne...';
	@override String seasonEnds({required Object countdown}) => 'Sezon kończy się za ${countdown}';
	@override String get seasonEnded => 'Sezon zakończył się';
	@override String overallPB({required Object pb}) => 'Ogólne PB: ${pb} m';
	@override String gamesUntilRanked({required Object left}) => '${left} gier do osiągnięcia rangi';
	@override String numOfVictories({required Object wins}) => '~${wins} zwycięstw';
	@override String get promotionOnNextWin => 'Awans przy następnej wygranej';
	@override String numOfdefeats({required Object losses}) => '~${losses} przegranych';
	@override String get demotionOnNextLoss => 'Spadek przy następnej przegranej';
	@override String get records => 'Rekordy';
	@override String get nerdStats => 'Statystyki Dla Nerdów';
	@override String get playstyles => 'Style Gry';
	@override String get horoscopes => 'Horoskopy';
	@override String get relatedAchievements => 'Powiązane Osiągnięcia';
	@override String get season => 'Sezon';
	@override String get smooth => 'Wygładź';
	@override String get dateAndTime => 'Data i Czas';
	@override String get TLfullLBnote => 'Wymagające, ale pozwala ci sortować graczy za pomocą ich statystyk i rang';
	@override String get rank => 'Ranga';
	@override String verdictGeneral({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} ${rank}';
	@override String get verdictBetter => 'powyżej średniej';
	@override String get verdictWorse => 'za średnią';
	@override String get localStanding => 'lokalnie';
	@override late final _TranslationsXpPlPl xp = _TranslationsXpPlPl._(_root);
	@override late final _TranslationsGametimePlPl gametime = _TranslationsGametimePlPl._(_root);
	@override String get whichOne => 'Które?';
	@override String get track => 'Śledź';
	@override String get stopTracking => 'Przestań śledzić';
	@override String supporter({required Object tier}) => 'Supporter poziomu ${tier}';
	@override String comparingWith({required Object newDate, required Object oldDate}) => 'Dane z ${newDate} w porównaniu z ${oldDate}';
	@override String get compare => 'Porównaj';
	@override String get comparison => 'Porównanie';
	@override String get enterUsername => 'Podaj nazwę użytkownika lub \$avgX (Gdzie X to ranga)';
	@override String get general => 'Ogólne';
	@override String get badges => 'Odznaki';
	@override String obtainDate({required Object date}) => 'Otrzymano ${date}';
	@override String get assignedManualy => 'Ta odznaka została manualnie przydzielona przez administratorów TETR.IO';
	@override String get distinguishment => 'Wyróżnienie';
	@override String get banned => 'Zbanowany';
	@override String get bannedSubtext => 'Bany są nakładane kiedy zasady TETR.IO są złamane';
	@override String get badStanding => 'Złe zachowanie';
	@override String get badStandingSubtext => 'Jeden lub więcej nałożonych banów';
	@override String get botAccount => 'Konto Bota';
	@override String botAccountSubtext({required Object botMaintainers}) => 'Operowany przez ${botMaintainers}';
	@override String get copiedToClipboard => 'Skopiowano do schowka!';
	@override String get bio => 'Bio';
	@override String get news => 'Aktualności';
	@override late final _TranslationsMatchResultPlPl matchResult = _TranslationsMatchResultPlPl._(_root);
	@override late final _TranslationsDistinguishmentsPlPl distinguishments = _TranslationsDistinguishmentsPlPl._(_root);
	@override late final _TranslationsNewsEntriesPlPl newsEntries = _TranslationsNewsEntriesPlPl._(_root);
	@override String rankupMiddle({required Object r}) => 'ranga ${r}';
	@override String get copyUserID => 'Kliknij aby skopiować ID użytkownika';
	@override String get searchHint => 'Nazwa użytkownika lub ID';
	@override String get navMenu => 'Menu nawigacji';
	@override String get navMenuTooltip => 'Otwórz menu nawigacji';
	@override String get refresh => 'Odśwież dane';
	@override String get searchButton => 'Szukaj';
	@override String get trackedPlayers => 'Śledzeni gracze';
	@override String get standing => 'Miejsce';
	@override String get previousSeasons => 'Poprzednie sezony';
	@override String get checkingCache => 'Sprawdzanie pamięci podręcznej...';
	@override String get fetchingRecords => 'Pobieranie rekordów...';
	@override String get munching => 'Munching...';
	@override String get outOf => 'z';
	@override String get replaysDone => 'Wwykonane powtórki';
	@override String get analysis => 'Analiza';
	@override String get minomuncherMention => 'za pomocą MinoMuncher przez Freyhoe';
	@override String get recent => 'Ostatnie';
	@override String get top => 'Najlepszy';
	@override String get noRecord => 'Brak rekordu';
	@override String sprintAndBlitsRelevance({required Object date}) => 'Istotność: ${date}';
	@override late final _TranslationsSnackBarMessagesPlPl snackBarMessages = _TranslationsSnackBarMessagesPlPl._(_root);
	@override late final _TranslationsErrorsPlPl errors = _TranslationsErrorsPlPl._(_root);
	@override late final _TranslationsActionsPlPl actions = _TranslationsActionsPlPl._(_root);
	@override late final _TranslationsGraphsDestinationPlPl graphsDestination = _TranslationsGraphsDestinationPlPl._(_root);
	@override late final _TranslationsFilterModalePlPl filterModale = _TranslationsFilterModalePlPl._(_root);
	@override late final _TranslationsCutoffsDestinationPlPl cutoffsDestination = _TranslationsCutoffsDestinationPlPl._(_root);
	@override late final _TranslationsRankViewPlPl rankView = _TranslationsRankViewPlPl._(_root);
	@override late final _TranslationsStateViewPlPl stateView = _TranslationsStateViewPlPl._(_root);
	@override late final _TranslationsTlMatchViewPlPl tlMatchView = _TranslationsTlMatchViewPlPl._(_root);
	@override late final _TranslationsCalcDestinationPlPl calcDestination = _TranslationsCalcDestinationPlPl._(_root);
	@override late final _TranslationsInfoDestinationPlPl infoDestination = _TranslationsInfoDestinationPlPl._(_root);
	@override late final _TranslationsLeaderboardsDestinationPlPl leaderboardsDestination = _TranslationsLeaderboardsDestinationPlPl._(_root);
	@override late final _TranslationsSavedDataDestinationPlPl savedDataDestination = _TranslationsSavedDataDestinationPlPl._(_root);
	@override late final _TranslationsSettingsDestinationPlPl settingsDestination = _TranslationsSettingsDestinationPlPl._(_root);
	@override late final _TranslationsHomeNavigationPlPl homeNavigation = _TranslationsHomeNavigationPlPl._(_root);
	@override late final _TranslationsGraphsNavigationPlPl graphsNavigation = _TranslationsGraphsNavigationPlPl._(_root);
	@override late final _TranslationsCalcNavigationPlPl calcNavigation = _TranslationsCalcNavigationPlPl._(_root);
	@override late final _TranslationsFirstTimeViewPlPl firstTimeView = _TranslationsFirstTimeViewPlPl._(_root);
	@override late final _TranslationsAboutViewPlPl aboutView = _TranslationsAboutViewPlPl._(_root);
	@override late final _TranslationsStatsPlPl stats = _TranslationsStatsPlPl._(_root);
	@override Map<String, String> get countries => {
		'': 'Światowy',
		'AF': 'Afganistan',
		'AX': 'Wyspy Alandzkie',
		'AL': 'Albania',
		'DZ': 'Algieria',
		'AS': 'Samoa Amerykańska',
		'AD': 'Andora',
		'AO': 'Angola',
		'AI': 'Anguilla',
		'AQ': 'Antarktyka',
		'AG': 'Antigua i Barbuda',
		'AR': 'Argentyna',
		'AM': 'Armenia',
		'AW': 'Aruba',
		'AU': 'Australia',
		'AT': 'Austria',
		'AZ': 'Azerbejdżan',
		'BS': 'Bahamy',
		'BH': 'Bahrajn',
		'BD': 'Bangladesz',
		'BB': 'Barbados',
		'BY': 'Białoruś',
		'BE': 'Belgia',
		'BZ': 'Belize',
		'BJ': 'Benin',
		'BM': 'Bermudy',
		'BT': 'Bhutan',
		'BO': 'Wielonarodowe Państwo Boliwii',
		'BA': 'Bośnia i Hercegowina',
		'BW': 'Botswana',
		'BV': 'Wyspa Bouveta',
		'BR': 'Brazylia',
		'IO': 'Brytyjskie Terytorium Oceanu Indyjskiego',
		'BN': 'Brunei Darussalam',
		'BG': 'Bułgaria',
		'BF': 'Burkina Faso',
		'BI': 'Burundi',
		'KH': 'Kambodża',
		'CM': 'Kamerun',
		'CA': 'Kanada',
		'CV': 'Wyspy Zielonego Przylądka',
		'BQ': 'Niderlandy Karaibskie',
		'KY': 'Kajmany',
		'CF': 'Republika Środkowoafrykańska',
		'TD': 'Czad',
		'CL': 'Czile',
		'CN': 'Chiny',
		'CX': 'Wyspa Wielkanocna',
		'CC': 'Wyspy Kokosowe (Keeling)',
		'CO': 'Kolumbia',
		'KM': 'Związek Komorów',
		'CG': 'Kongo',
		'CD': 'Demokratyczna Republika Konga',
		'CK': 'Wyspy Cooka',
		'CR': 'Kostaryka',
		'CI': 'Wybrzeże Kości Słoniowej',
		'HR': 'Chorwacja',
		'CU': 'Kuba',
		'CW': 'Curacao',
		'CY': 'Cypr',
		'CZ': 'Republika Czeska',
		'DK': 'Dania',
		'DJ': 'Dżibuti',
		'DM': 'Dominikana',
		'DO': 'Republika Dominikany',
		'EC': 'Ekwador',
		'EG': 'Egipt',
		'SV': 'El Salvador',
		'GB-ENG': 'Anglia',
		'GQ': 'Gwinea Równikowa',
		'ER': 'Erytrea',
		'EE': 'Estonia',
		'ET': 'Etiopia',
		'EU': 'Europa',
		'FK': 'Falklandy (Malwiny)',
		'FO': 'Wyspy Owcze',
		'FJ': 'Fidżi',
		'FI': 'Finlandia',
		'FR': 'Francja',
		'GF': 'Gujana Francuska',
		'PF': 'Polinezja Francuska',
		'TF': 'Francuskie Terytoria Południowe i Antarktyczne',
		'GA': 'Gabon',
		'GM': 'Gambia',
		'GE': 'Gruzja',
		'DE': 'Niemcy',
		'GH': 'Ghana',
		'GI': 'Gibraltar',
		'GR': 'Grecja',
		'GL': 'Grenlandia',
		'GD': 'Grenada',
		'GP': 'Gwadelupa',
		'GU': 'Guam',
		'GT': 'Gwatemala',
		'GG': 'Wyspa Guernsey',
		'GN': 'Gwinea',
		'GW': 'Gwinea Bissau',
		'GY': 'Gujana',
		'HT': 'Haiti',
		'HM': 'Wyspy Heard i McDonalda',
		'VA': 'Stolica Apostolska (Watykan)',
		'HN': 'Honduras',
		'HK': 'Hongkong',
		'HU': 'Węgry',
		'IS': 'Islandia',
		'IN': 'Indie',
		'ID': 'Indonezja',
		'IR': 'Iran',
		'IQ': 'Irak',
		'IE': 'Irlandia',
		'IM': 'Wyspa Man',
		'IL': 'Izrael',
		'IT': 'Włochy',
		'JM': 'Jamajka',
		'JP': 'Japonia',
		'JE': 'Jersey',
		'JO': 'Jordania',
		'KZ': 'Kazachstan',
		'KE': 'Kenia',
		'KI': 'Kiribati',
		'KP': 'Koreańska Republika Ludowo-Demokratyczna',
		'KR': 'Korea Południowa',
		'XK': 'Kosowo',
		'KW': 'Kuwejt',
		'KG': 'Kirgistan',
		'LA': 'Laotańska Republika Ludowo-Demokratyczna',
		'LV': 'Łotwa',
		'LB': 'Lebanon',
		'LS': 'Lesotho',
		'LR': 'Republika Liberii',
		'LY': 'Libia',
		'LI': 'Liechtenstein',
		'LT': 'Litwa',
		'LU': 'Luksemburg',
		'MO': 'Makau',
		'MK': 'Republika Macedonii Północnej',
		'MG': 'Madagaskar',
		'MW': 'Malawi',
		'MY': 'Malezja',
		'MV': 'Malediwy',
		'ML': 'Mali',
		'MT': 'Malta',
		'MH': 'Wyspy Marshalla',
		'MQ': 'Martynika',
		'MR': 'Mauretania',
		'MU': 'Mauritius',
		'YT': 'Majotta',
		'MX': 'Meksyk',
		'FM': 'Mikronezja',
		'MD': 'Republika Mołdowy',
		'MC': 'Monako',
		'ME': 'Czarnogóra',
		'MA': 'Maroko',
		'MN': 'Mongolia',
		'MS': 'Montserrat',
		'MZ': 'Mozambik',
		'MM': 'Mjanma',
		'NA': 'Namibia',
		'NR': 'Nauru',
		'NP': 'Nepal',
		'NL': 'Holandia (Królestwo Niderlandów)',
		'AN': 'Antyle Holenderskie',
		'NC': 'Nowa Kaledonia',
		'NZ': 'Nowa Zelandia',
		'NI': 'Nikaragua',
		'NE': 'Niger',
		'NG': 'Nigeria',
		'NU': 'Niue',
		'NF': 'Wyspa Norfolk',
		'GB-NIR': 'Irlandia Północna',
		'MP': 'Mariany Północne',
		'NO': 'Norwegia',
		'OM': 'Oman',
		'PK': 'Pakistan',
		'PW': 'Palau',
		'PS': 'Palestyna',
		'PA': 'Panama',
		'PG': 'Papua-Nowa Gwinea',
		'PY': 'Paragwaj',
		'PE': 'Peru',
		'PH': 'Filipiny',
		'PN': 'Pitcairn',
		'PL': 'Polska',
		'PT': 'Portugalia',
		'PR': 'Portoryko',
		'QA': 'Katar',
		'RE': 'Reunion',
		'RO': 'Rumunia',
		'RU': 'Federacja Rosyjska',
		'RW': 'Rwanda',
		'BL': 'Saint-Barthélemy',
		'SH': 'Wyspa Świętej Heleny',
		'KN': 'Saint Kitts i Nevis',
		'LC': 'Saint Lucia',
		'MF': 'Saint Martin',
		'PM': 'Saint-Pierre i Miquelon',
		'VC': 'Saint Vincent i Grenadyny',
		'WS': 'Samoa',
		'SM': 'San Marino',
		'ST': 'Wyspy Świętego Tomasza i Książęca',
		'SA': 'Arabia Saudyjska',
		'GB-SCT': 'Szkocja',
		'SN': 'Senegal',
		'RS': 'Serbia',
		'SC': 'Seszele',
		'SL': 'Sierra Leone',
		'SG': 'Singapur',
		'SX': 'Sint Maarten (część duńska)',
		'SK': 'Słowacja',
		'SI': 'Słowenia',
		'SB': 'Wyspy Salomona',
		'SO': 'Somalia',
		'ZA': 'Afryka Południowa',
		'GS': 'Georgia Południowa i Sandwich Południowy',
		'SS': 'Sudan Południowy',
		'ES': 'Hiszpania',
		'LK': 'Sri Lanka',
		'SD': 'Sudan',
		'SR': 'Surinam',
		'SJ': 'Wyspy Svalbard i Jan Mayen',
		'SZ': 'Suazi',
		'SE': 'Szwecja',
		'CH': 'Szwajcaria',
		'SY': 'Syryjska Republika Arabska',
		'TW': 'Tajwan',
		'TJ': 'Tadżykistan',
		'TZ': 'Zjednoczona Republika Tanzanii',
		'TH': 'Tajlandia',
		'TL': 'Timor Wschodni',
		'TG': 'Togo',
		'TK': 'Tokelau',
		'TO': 'Tonga',
		'TT': 'Trynidad i Tobago',
		'TN': 'Tunezja',
		'TR': 'Turcja',
		'TM': 'Turkmenistan',
		'TC': 'Wyspy Turks i Caicos',
		'TV': 'Tuvalu',
		'UG': 'Uganda',
		'UA': 'Ukraina',
		'AE': 'Zjednoczone Emiraty Arabskie',
		'GB': 'Wielka Brytania',
		'US': 'Stany Zjednoczone',
		'UY': 'Urugwaj',
		'UM': 'Małe Wyspy Północne USA',
		'UZ': 'Uzbekistan',
		'VU': 'Vanuatu',
		'VE': 'Boliwariańska Republika Wenezueli',
		'VN': 'Wietnam',
		'VG': 'Brytyjskie Wyspy Dziewicze',
		'VI': 'Wyspy Dziewicze Stanów Zjednoczonych',
		'GB-WLS': 'Walia',
		'WF': 'Wallis i Futuna',
		'EH': 'Sahara Zachodnia',
		'YE': 'Jemen',
		'ZM': 'Zambia',
		'ZW': 'Zimbabwe',
		'XX': 'Nieznane',
		'XM': 'Księżyc',
	};
}

// Path: destinations
class _TranslationsDestinationsPlPl implements TranslationsDestinationsEn {
	_TranslationsDestinationsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get home => 'Strona Główna';
	@override String get graphs => 'Wykresy';
	@override String get leaderboards => 'Rankingi';
	@override String get cutoffs => 'Cutoffy';
	@override String get calc => 'Kalkulator';
	@override String get info => 'Centrum informacji';
	@override String get data => 'Zapisane Dane';
	@override String get settings => 'Ustawienia';
}

// Path: xp
class _TranslationsXpPlPl implements TranslationsXpEn {
	_TranslationsXpPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Poziom XP';
	@override String progressToNextLevel({required Object percentage}) => 'Postęp do następnego poziomu: ${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => 'Postęp od 0XP do poziomu ${goal}: ${percentage} (pozostało ${left} XP)';
}

// Path: gametime
class _TranslationsGametimePlPl implements TranslationsGametimeEn {
	_TranslationsGametimePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dokładny czas gry';
	@override String gametimeAday({required Object gametime}) => 'Średnio ${gametime} dziennie';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'To ${years} lat,\nlub ${months} miesięcy,\nlub ${days} dni,\nlub ${minutes} minut\nlub ${seconds} sekund';
}

// Path: matchResult
class _TranslationsMatchResultPlPl implements TranslationsMatchResultEn {
	_TranslationsMatchResultPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get victory => 'Zwycięstwo';
	@override String get defeat => 'Porażka';
	@override String get tie => 'Remis';
	@override String get dqvictory => 'Przeciwnik został zdyskwalifikowany';
	@override String get dqdefeat => 'Zdyskwalifikowany';
	@override String get nocontest => 'Brak kontestu';
	@override String get nullified => 'Unieważniony';
}

// Path: distinguishments
class _TranslationsDistinguishmentsPlPl implements TranslationsDistinguishmentsEn {
	_TranslationsDistinguishmentsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get noHeader => 'Brak nagłówka';
	@override String get noFooter => 'Brak stopki';
	@override String get twc => 'Światowy Czempion TETR.IO';
	@override String twcYear({required Object year}) => 'Mistrzostwa Świata w TETR.IO ${year}';
}

// Path: newsEntries
class _TranslationsNewsEntriesPlPl implements TranslationsNewsEntriesEn {
	_TranslationsNewsEntriesPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override TextSpan leaderboard({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
		const TextSpan(text: 'Zdobył(a) № '),
		rank,
		const TextSpan(text: ' w '),
		gametype,
	]);
	@override TextSpan personalbest({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
		const TextSpan(text: 'Osiągnął/Osiągnęła nowe PB w '),
		gametype,
		const TextSpan(text: ' wynoszące '),
		pb,
	]);
	@override TextSpan badge({required InlineSpan badge}) => TextSpan(children: [
		const TextSpan(text: 'Zdobył(a) odznakę '),
		badge,
	]);
	@override TextSpan rankup({required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: 'Zdobył(a) rangę '),
		rank,
		const TextSpan(text: ' w Tetra League'),
	]);
	@override TextSpan supporter({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Został(a) '),
		s('TETR.IO supporter'),
		const TextSpan(text: 'em'),
	]);
	@override TextSpan supporter_gift({required InlineSpanBuilder s}) => TextSpan(children: [
		const TextSpan(text: 'Otrzymał(a) prezent '),
		s('TETR.IO supporter'),
	]);
	@override TextSpan unknown({required InlineSpan type}) => TextSpan(children: [
		const TextSpan(text: 'Nieznane wieści typu '),
		type,
	]);
}

// Path: snackBarMessages
class _TranslationsSnackBarMessagesPlPl implements TranslationsSnackBarMessagesEn {
	_TranslationsSnackBarMessagesPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => 'Stan ${date} został usunięty z bazy danych!';
	@override String matchRemoved({required Object date}) => 'Mecz z ${date} został usunięty z bazy danych!';
	@override String get notForWeb => 'Funkcja nie jest dostępna w wersji internetowej';
	@override String get importSuccess => 'Zaimportowano pomyślnie';
	@override String get importCancelled => 'Anulowano importowanie';
}

// Path: errors
class _TranslationsErrorsPlPl implements TranslationsErrorsEn {
	_TranslationsErrorsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get noRecords => 'Brak wpisów';
	@override String get notEnoughData => 'Za mało danych';
	@override String get noHistorySaved => 'Brak zapisanej historii';
	@override String connection({required Object code, required Object message}) => 'Problem z połączeniem: ${code} ${message}';
	@override String get noSuchUser => 'Użytkownik nie istnieje';
	@override String get noSuchUserSub => 'Albo niepoprawnie wpisałeś nazwę użytkownika, albo konto nie istnieje';
	@override String get discordNotAssigned => 'Nie znaleziono połączeń';
	@override String get discordNotAssignedSub => 'Twoje zapytanie powinno wyglądać jak opisane w [API](https://tetr.io/about/api/#userssearchquery)';
	@override String get history => 'Brak historii dla tego gracza';
	@override String get actionSuggestion => 'Być może chcesz';
	@override String get p1nkl0bst3rTLmatches => 'Nie znaleziono meczów Tetra League';
	@override String get clientException => 'Brak połączenia z Internetem';
	@override String get forbidden => 'Twój adres IP jest zablokowany';
	@override String forbiddenSub({required Object nickname}) => 'Jeśli korzystasz z VPN lub Proxy, wyłącz go. Jeśli to nie pomoże, skontaktuj się z ${nickname}';
	@override String get tooManyRequests => 'Zostałeś ograniczony.';
	@override String get tooManyRequestsSub => 'Zaczekaj chwilę i spróbuj ponownie.';
	@override String get internal => 'Coś się stało po stronie tetr.io';
	@override String get internalSub => 'osk, prawdopodobnie, już o tym wie';
	@override String get internalWebVersion => 'Coś się stało po stronie tetr.io (lub na oskware_bridge, nwm wsm)';
	@override String get internalWebVersionSub => 'Jeśli strona statusu osk mówi, że wszystko jest w porządku, poinformuj dan63047 o tym problemie';
	@override String get oskwareBridge => 'Coś się stało z oskware_bridge';
	@override String get oskwareBridgeSub => 'Daj znać dan63047';
	@override String get p1nkl0bst3rForbidden => 'API firm trzecich zablokowało Twój adres IP';
	@override String get p1nkl0bst3rTooManyRequests => 'Zbyt wiele zapytań do API osób trzecich. Spróbuj ponownie później';
	@override String get p1nkl0bst3rinternal => 'Coś się stało po stronie p1nkl0bst3r';
	@override String get p1nkl0bst3rinternalWebVersion => 'Coś się wydarzyło po stronie p1nkl0bst3r (lub na oskware_bridge, idk)';
	@override String get replayAlreadySaved => 'Powtórka już zapisana';
	@override String get replayExpired => 'Powtórka wygasła i nie jest już dostępna';
	@override String get replayRejected => 'API firm trzecich zablokowało Twój adres IP';
}

// Path: actions
class _TranslationsActionsPlPl implements TranslationsActionsEn {
	_TranslationsActionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Anuluj';
	@override String get submit => 'Zatwierdź';
	@override String get ok => 'Ok';
	@override String get apply => 'Zastosuj';
	@override String get refresh => 'Odśwież';
}

// Path: graphsDestination
class _TranslationsGraphsDestinationPlPl implements TranslationsGraphsDestinationEn {
	_TranslationsGraphsDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get fetchAndsaveTLHistory => 'Pobierz historię';
	@override String get fetchAndSaveOldTLmatches => 'Pobierz historię meczy Tetra League';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => 'Znaleziono ${number} stanów';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => 'Znaleziono ${number} meczy';
	@override String gamesPlayed({required Object games}) => 'Zagrano ${games} gier';
	@override String get dateAndTime => 'Data i czas';
	@override String get filterModaleTitle => 'Filtruj rangi na wykresie';
}

// Path: filterModale
class _TranslationsFilterModalePlPl implements TranslationsFilterModaleEn {
	_TranslationsFilterModalePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get all => 'Wszystkie';
}

// Path: cutoffsDestination
class _TranslationsCutoffsDestinationPlPl implements TranslationsCutoffsDestinationEn {
	_TranslationsCutoffsDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Stan Tetra League';
	@override String relevance({required Object timestamp}) => 'z ${timestamp}';
	@override String get actual => 'Prawdziwy';
	@override String get target => 'Docelowy';
	@override String get cutoffTR => 'Odcięcie TR';
	@override String get targetTR => 'Docelowy TR';
	@override String get state => 'Stan';
	@override String get advanced => 'Zaawansowane';
	@override String players({required Object n}) => 'Gracze (${n})';
	@override String get moreInfo => 'Więcej informacji';
	@override String NumberOne({required Object tr}) => '№ 1 posiada ${tr} TR';
	@override String inflated({required Object tr}) => 'Podwyższone o ${tr} TR';
	@override String get notInflated => 'Nie jest podwyższone';
	@override String deflated({required Object tr}) => 'Obniżone o ${tr} TR';
	@override String get notDeflated => 'Nie jest obniżone';
	@override String get wellDotDotDot => 'Cóż...';
	@override String fromPlace({required Object n}) => 'z № ${n}';
	@override String get viewButton => 'Pokaż';
}

// Path: rankView
class _TranslationsRankViewPlPl implements TranslationsRankViewEn {
	_TranslationsRankViewPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String rankTitle({required Object rank}) => 'Dane rangi ${rank}';
	@override String get everyoneTitle => 'Cały ranking';
	@override String get trRange => 'Zakres TR';
	@override String get supposedToBe => 'Powinno być';
	@override String gap({required Object value}) => '${value} różnicy';
	@override String trGap({required Object value}) => '${value} TR różnicy';
	@override String get deflationGap => 'Różnica deflacji';
	@override String get inflationGap => 'Różnica inflacji';
	@override String get LBposRange => 'Zakres pozycji w rankingu';
	@override String overpopulated({required Object players}) => 'Przepełniony o ${players}';
	@override String underpopulated({required Object players}) => 'Deficyt o ${players}';
	@override String get PlayersEqualSupposedToBe => 'cute';
	@override String get avgStats => 'Średnie statystyki';
	@override String avgForRank({required Object rank}) => 'Średnia dla rangi ${rank}';
	@override String get avgNerdStats => 'Średnie statystyki dla nerdów';
	@override String get minimums => 'Minima';
	@override String get maximums => 'Maksyma';
}

// Path: stateView
class _TranslationsStateViewPlPl implements TranslationsStateViewEn {
	_TranslationsStateViewPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => 'Stan z ${date}';
}

// Path: tlMatchView
class _TranslationsTlMatchViewPlPl implements TranslationsTlMatchViewEn {
	_TranslationsTlMatchViewPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get match => 'Mecz';
	@override String get vs => 'vs';
	@override String get winner => 'Zwycięzca';
	@override String roundNumber({required Object n}) => 'Runda ${n}';
	@override String get statsFor => 'Statystyki dla';
	@override String get numberOfRounds => 'Ilość rund';
	@override String get matchLength => 'Długość meczu';
	@override String get roundLength => 'Długość rundy';
	@override String get matchStats => 'Statystyki meczu';
	@override String get downloadReplay => 'Pobierz powtórkę .ttrm';
	@override String get openReplay => 'Otwórz powtórkę w TETR.IO';
}

// Path: calcDestination
class _TranslationsCalcDestinationPlPl implements TranslationsCalcDestinationEn {
	_TranslationsCalcDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => 'Wprowadź ${stat}';
	@override String get tip => 'Wprowadź wartości i naciśnij "Kalkuluj", aby zobaczyć wykalkulowane statystyki dla Nerdów';
	@override String get invalidValues => 'Podaj prawidłową wartość';
	@override String get statsCalcButton => 'Kalkuluj';
	@override String get damageCalcTip => 'Kliknij na akcje po lewej stronie, aby dodać je tutaj';
	@override String get clearAll => 'Wyczyść wszystko';
	@override String get actions => 'Działania';
	@override String get results => 'Wyniki';
	@override String get rules => 'Zasady';
	@override String get noSpinClears => 'Bez Clearów Spinami';
	@override String get spins => 'Spiny';
	@override String get miniSpins => 'Mini Spiny';
	@override String get noLineclear => 'Brak lineclearów (Break Combo)';
	@override String get custom => 'Własne';
	@override String get multiplier => 'Mnożnik';
	@override String get pcDamage => 'Obrażenia Perfect Cleara';
	@override String get comboTable => 'Tabela Combo';
	@override String get b2bChaining => 'Chainowanie Back-To-Back';
	@override String get surgeStartAtB2B => 'Początkowy B2B';
	@override String get surgeStartAmount => 'Wartość początkowa';
	@override String get totalDamage => 'Łączne obrażenia';
	@override String get lineclears => 'Wyczyszczone Linie';
	@override String get combo => 'Kombo';
	@override String get surge => 'Wyładowanie';
	@override String get pcs => 'PC';
}

// Path: infoDestination
class _TranslationsInfoDestinationPlPl implements TranslationsInfoDestinationEn {
	_TranslationsInfoDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Centrum informacji';
	@override String get sprintAndBlitzAverages => 'Średnie 40 Lines i Blitz';
	@override String get sprintAndBlitzAveragesDescription => 'Ponieważ kalkulacja 40 linii i średnich Blitz jest żmudnym procesem, jest on aktualizowany tylko raz na jakiś czas. Kliknij tytuł tej karty, aby zobaczyć pełną tabelę 40 linii i średnich wartości Blitz';
	@override String get tetraStatsWiki => 'Tetra Stats Wiki';
	@override String get tetraStatsWikiDescription => 'Dowiedz się więcej o funkcjach i statystykach Tetra Stats';
	@override String get about => 'O Tetra Stats';
	@override String get aboutDescription => 'Stworzone przez dan63\n';
}

// Path: leaderboardsDestination
class _TranslationsLeaderboardsDestinationPlPl implements TranslationsLeaderboardsDestinationEn {
	_TranslationsLeaderboardsDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Rankingi';
	@override String get tl => 'Tetra League (Obecny Sezon)';
	@override String get fullTL => 'Tetra League (Obecny Sezon, pełny)';
	@override String get ar => 'Punkty osiągnięć';
}

// Path: savedDataDestination
class _TranslationsSavedDataDestinationPlPl implements TranslationsSavedDataDestinationEn {
	_TranslationsSavedDataDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zapisane Dane';
	@override String get tip => 'Wybierz nazwę użytkownika po lewej stronie, aby zobaczyć powiązane z nią dane';
	@override String seasonTLstates({required Object s}) => 'Stany Sezonu ${s} TL';
	@override String get TLrecords => 'Rekordy TL';
}

// Path: settingsDestination
class _TranslationsSettingsDestinationPlPl implements TranslationsSettingsDestinationEn {
	_TranslationsSettingsDestinationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ustawienia';
	@override String get general => 'Ogólne';
	@override String get customization => 'Personalizacja';
	@override String get database => 'Lokalna baza danych';
	@override String get checking => 'Sprawdzanie...';
	@override String get enterToSubmit => 'Naciśnij Enter, aby przesłać';
	@override String get account => 'Twoje konto w TETR.IO';
	@override String get accountDescription => 'Statystyki tego gracza zostaną załadowane początkowo zaraz po uruchomieniu aplikacji. Domyślnie ładuje moje statystyki (dan63). Aby to zmienić, wprowadź swój nick tutaj.';
	@override String get done => 'Gotowe!';
	@override String get noSuchAccount => 'Nie ma takiego konta';
	@override String get language => 'Język';
	@override String languageDescription({required Object languages}) => 'Tetra Stats zostały przetłumaczone na ${languages}. Domyślnie aplikacja wybierze twój język systemowy lub angielski, jeśli ustawienia regionalne twojego systemu nie są dostępne.';
	@override String languages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		zero: 'zero języków',
		one: '${n} język',
		two: '${n} języki',
		few: '${n} języki',
		many: '${n} języków',
		other: '${n} języków',
	);
	@override String get updateInTheBackground => 'Aktualizuj dane w tle';
	@override String get updateInTheBackgroundDescription => 'Jeśli włączone, Tetra Stats będzie próbowało otrzymać nowe informacje po wygaśnięciu pamięci podręcznej. Zwykle dzieje się to co 5 minut';
	@override String get munchLimit => 'Limit for Minomuncher analysis';
	@override String get munchLimitDescription => 'By default, minomuncher will analyse first 10 available replays. If you want more, you can adjust it here (max of 25).';
	@override String get munchLimitTooMuch => 'Too much, rejected';
	@override String get compareStats => 'Porównaj statystyki TL ze średnimi rang';
	@override String get compareStatsDescription => 'Jeśli włączone, Tetra Stats zapewni dodatkowe pomiary, które pozwolą ci porównać siebie do średniego gracza w twojej randze. Będzie to widoczne w ten sposób — statystyki będą podświetlane odpowiednim kolorem, najedź na nie kursorem, aby zobaczyć więcej informacji.';
	@override String get showPosition => 'Pokaż pozycję w rankingu według statystyk';
	@override String get showPositionDescription => 'To może zająć trochę czasu (i ruchu), ale pozwoli Ci zobaczyć swoją pozycję na tablicy wyników, posortowaną według statystyk';
	@override String get accentColor => 'Kolor akcentu';
	@override String get accentColorDescription => 'Ten kolor jest widoczny w tej aplikacji i zazwyczaj podkreśla interaktywne elementy interfejsu użytkownika.';
	@override String get accentColorModale => 'Wybierz kolor akcentu';
	@override String get timestamps => 'Format znaczników czasu';
	@override String timestampsDescriptionPart1({required Object d}) => 'Możesz wybrać, w jaki sposób znaczniki czasu pokazują czas. Domyślnie pokazują czas w strefie czasowej GMT, sformatowany zgodnie z wybraną lokalizacją, przykład: ${d}.';
	@override String timestampsDescriptionPart2({required Object y, required Object r}) => 'Jest również:\n• Ustawienia regionalne sformatowane w twojej strefie czasowej: ${y}\n• Względny znacznik czasu: ${r}';
	@override String get timestampsAbsoluteGMT => 'Bezwzględny (GMT)';
	@override String get timestampsAbsoluteLocalTime => 'Bezwzględny (Twoja strefa czasowa)';
	@override String get timestampsRelative => 'Względny';
	@override String get sheetbotLikeGraphs => 'Zachowanie wykresów radarowych podobne do Sheetbota';
	@override String get sheetbotLikeGraphsDescription => 'Mimo tego, że rozważałem to, sposób działania wykresów w SheetBocie nie jest zbyt poprawny, niektórzy byli zdziwieni, że -0,5 stride nie wygląda w ten sam sposób jak jest to pokazane na wykresach SheetBota. Więc jesteśmy tutaj: jeśli ta opcja jest włączona, punkty na wykresie mogą wyświetlić się po przeciwnej stronie wykresu, jeśli wartości są negatywne.';
	@override String get oskKagariGimmick => 'Osk-Kagari gimmick';
	@override String get oskKagariGimmickDescription => 'Jeśli włączone, zamiast rangi oska, :kagari: zostanie wyrenderowana.';
	@override String get bytesOfDataStored => 'przechowywanych danych';
	@override String get TLrecordsSaved => 'Rekordy Tetra League zapisane';
	@override String get TLplayerstatesSaved => 'Stany graczy Tetra League zapisane';
	@override String get fixButton => 'Napraw';
	@override String get compressButton => 'Kompresuj';
	@override String get exportDB => 'Eksportuj lokalną bazę danych';
	@override String get desktopExportAlertTitle => 'Eksport na aplikację pulpitową';
	@override String get desktopExportText => 'Wygląda na to, że używasz tej aplikacji na komputerze. Sprawdź folder dokumentów, powinieneś znaleźć plik "TetraStats.db". Skopiuj go gdzieś';
	@override String get androidExportAlertTitle => 'Eksport Android';
	@override String androidExportText({required Object exportedDB}) => 'Wyeksportowano\n${exportedDB}';
	@override String get importDB => 'Zaimportuj lokalną bazę danych';
	@override String get importDBDescription => 'Przywróć kopię zapasową. Zauważ, że już zapisana baza danych zostanie nadpisana.';
	@override String get importWrongFileType => 'Nieprawidłowy typ pliku';
}

// Path: homeNavigation
class _TranslationsHomeNavigationPlPl implements TranslationsHomeNavigationEn {
	_TranslationsHomeNavigationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Podsumowanie';
	@override String get standing => 'Miejsce';
	@override String get seasons => 'Sezony';
	@override String get mathces => 'Mecze';
	@override String get pb => 'PB';
	@override String get normal => 'Normal';
	@override String get expert => 'Ekspert';
	@override String get expertRecords => 'Rekordy trybu Ekspert';
}

// Path: graphsNavigation
class _TranslationsGraphsNavigationPlPl implements TranslationsGraphsNavigationEn {
	_TranslationsGraphsNavigationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get history => 'Historia gracza';
	@override String get league => 'Stan Ligi';
	@override String get cutoffs => 'Historia Cutoffów';
}

// Path: calcNavigation
class _TranslationsCalcNavigationPlPl implements TranslationsCalcNavigationEn {
	_TranslationsCalcNavigationPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get stats => 'Kalkulator statystyk';
	@override String get damage => 'Kalkulator obrażeń';
}

// Path: firstTimeView
class _TranslationsFirstTimeViewPlPl implements TranslationsFirstTimeViewEn {
	_TranslationsFirstTimeViewPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Witaj w Tetra Stats';
	@override String get description => 'Serwis umożliwiający śledzenie różnych statystyk dla TETR.IO';
	@override String get nicknameQuestion => 'Jaki jest Twój nick?';
	@override String get inpuntHint => 'Wpisz tutaj... (3-16 symboli)';
	@override String get emptyInputError => 'Nie można przesłać pustego ciągu';
	@override String niceToSeeYou({required Object n}) => 'Miło cię widzieć, ${n}';
	@override String get letsTakeALook => 'Spójrzmy na Twoje statystyki...';
	@override String get skip => 'Pomiń';
}

// Path: aboutView
class _TranslationsAboutViewPlPl implements TranslationsAboutViewEn {
	_TranslationsAboutViewPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'O Tetra Stats';
	@override String get about => 'Tetra Stats to serwis, który działa za pomocą API TETR.IO Tetra Channel, dostarczając z niego dane i kalkulując dodatkowe metryki na podstawie tych danych. Serwis pozwala użytkownikowi śledzić swoje postępy w Tetra League za pomocą funkcji "Śledź", która zapisuje wszystkie zmiany w Tetra League do lokalnej bazy danych (nie jest to automatyczne, musisz odwiedzać serwis od czasu do czasu), aby gracz mógł przejrzeć te zmiany na wykresach.\n\nBeanserver blaster jest częścią Tetra Stats, który oddzielił się w skrypt serwerowy. Zapewnia pełną tablicę rankingów Tetra League, pozwalając Tetra Stats sortować rankingi za pomocą jakichkolwiek parametrów i budować wykresy punktowe, które pozwalają użytkownikowi analizować swoje tendencje w Tetra League. Daje także dostęp do historii cutoffów Tetra League, które mogą być przeglądane przez użytkownika zna wykresach.\n\nW planach jest dodanie analizy powtórek i historii turniejów, więc oczekujcie nowości!\n\nSerwis nie jest powiązany z TETR.IO lub oskiem w jakikolwiek sposób.';
	@override String get appVersion => 'Wersja aplikacji';
	@override String build({required Object build}) => 'Build ${build}';
	@override String get GHrepo => 'Repozytorium GitHub';
	@override String get submitAnIssue => 'Zgłoś problem';
	@override String get credits => 'Podziękowania';
	@override String get authorAndDeveloper => 'Autor i deweloper';
	@override String get providedFormulas => 'Dostarczył(a) formuły';
	@override String get providedS1history => 'Dostarczył(a) historię S1';
	@override String get inoue => 'Inoue (graber powtórek)';
	@override String get zhCNlocale => 'Język chiński uproszczony';
	@override String get deDElocale => 'Język niemiecki';
	@override String get koKRlocale => 'Język koreański';
	@override String get plPLlocale => 'Język polski';
	@override String withFixesBy({required Object username}) => 'Z poprawkami ${username}';
	@override String get supportHim => 'Wesprzyj go!';
}

// Path: stats
class _TranslationsStatsPlPl implements TranslationsStatsEn {
	_TranslationsStatsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => 'Data rejestracji';
	@override String get gametime => 'Czas gry';
	@override String get ogp => 'Rozegrane gry online';
	@override String get ogw => 'Wygrane gry online';
	@override String get followers => 'Obserwujących';
	@override late final _TranslationsStatsXpPlPl xp = _TranslationsStatsXpPlPl._(_root);
	@override late final _TranslationsStatsTrPlPl tr = _TranslationsStatsTrPlPl._(_root);
	@override late final _TranslationsStatsGlickoPlPl glicko = _TranslationsStatsGlickoPlPl._(_root);
	@override late final _TranslationsStatsRdPlPl rd = _TranslationsStatsRdPlPl._(_root);
	@override late final _TranslationsStatsGlixarePlPl glixare = _TranslationsStatsGlixarePlPl._(_root);
	@override late final _TranslationsStatsS1trPlPl s1tr = _TranslationsStatsS1trPlPl._(_root);
	@override late final _TranslationsStatsGpPlPl gp = _TranslationsStatsGpPlPl._(_root);
	@override late final _TranslationsStatsGwPlPl gw = _TranslationsStatsGwPlPl._(_root);
	@override late final _TranslationsStatsWinratePlPl winrate = _TranslationsStatsWinratePlPl._(_root);
	@override late final _TranslationsStatsApmPlPl apm = _TranslationsStatsApmPlPl._(_root);
	@override late final _TranslationsStatsPpsPlPl pps = _TranslationsStatsPpsPlPl._(_root);
	@override late final _TranslationsStatsVsPlPl vs = _TranslationsStatsVsPlPl._(_root);
	@override late final _TranslationsStatsAppPlPl app = _TranslationsStatsAppPlPl._(_root);
	@override late final _TranslationsStatsVsapmPlPl vsapm = _TranslationsStatsVsapmPlPl._(_root);
	@override late final _TranslationsStatsDssPlPl dss = _TranslationsStatsDssPlPl._(_root);
	@override late final _TranslationsStatsDspPlPl dsp = _TranslationsStatsDspPlPl._(_root);
	@override late final _TranslationsStatsAppdspPlPl appdsp = _TranslationsStatsAppdspPlPl._(_root);
	@override late final _TranslationsStatsCheesePlPl cheese = _TranslationsStatsCheesePlPl._(_root);
	@override late final _TranslationsStatsGbePlPl gbe = _TranslationsStatsGbePlPl._(_root);
	@override late final _TranslationsStatsNyaappPlPl nyaapp = _TranslationsStatsNyaappPlPl._(_root);
	@override late final _TranslationsStatsAreaPlPl area = _TranslationsStatsAreaPlPl._(_root);
	@override late final _TranslationsStatsEtrPlPl etr = _TranslationsStatsEtrPlPl._(_root);
	@override late final _TranslationsStatsEtraccPlPl etracc = _TranslationsStatsEtraccPlPl._(_root);
	@override late final _TranslationsStatsOpenerPlPl opener = _TranslationsStatsOpenerPlPl._(_root);
	@override late final _TranslationsStatsPlonkPlPl plonk = _TranslationsStatsPlonkPlPl._(_root);
	@override late final _TranslationsStatsStridePlPl stride = _TranslationsStatsStridePlPl._(_root);
	@override late final _TranslationsStatsInfdsPlPl infds = _TranslationsStatsInfdsPlPl._(_root);
	@override late final _TranslationsStatsAltitudePlPl altitude = _TranslationsStatsAltitudePlPl._(_root);
	@override late final _TranslationsStatsClimbSpeedPlPl climbSpeed = _TranslationsStatsClimbSpeedPlPl._(_root);
	@override late final _TranslationsStatsPeakClimbSpeedPlPl peakClimbSpeed = _TranslationsStatsPeakClimbSpeedPlPl._(_root);
	@override late final _TranslationsStatsKosPlPl kos = _TranslationsStatsKosPlPl._(_root);
	@override late final _TranslationsStatsB2bPlPl b2b = _TranslationsStatsB2bPlPl._(_root);
	@override late final _TranslationsStatsFinessePlPl finesse = _TranslationsStatsFinessePlPl._(_root);
	@override late final _TranslationsStatsFinesseFaultsPlPl finesseFaults = _TranslationsStatsFinesseFaultsPlPl._(_root);
	@override late final _TranslationsStatsTotalTimePlPl totalTime = _TranslationsStatsTotalTimePlPl._(_root);
	@override late final _TranslationsStatsLevelPlPl level = _TranslationsStatsLevelPlPl._(_root);
	@override late final _TranslationsStatsPiecesPlPl pieces = _TranslationsStatsPiecesPlPl._(_root);
	@override late final _TranslationsStatsSppPlPl spp = _TranslationsStatsSppPlPl._(_root);
	@override late final _TranslationsStatsKpPlPl kp = _TranslationsStatsKpPlPl._(_root);
	@override late final _TranslationsStatsKppPlPl kpp = _TranslationsStatsKppPlPl._(_root);
	@override late final _TranslationsStatsKpsPlPl kps = _TranslationsStatsKpsPlPl._(_root);
	@override late final _TranslationsStatsAplPlPl apl = _TranslationsStatsAplPlPl._(_root);
	@override late final _TranslationsStatsQuadEfficiencyPlPl quadEfficiency = _TranslationsStatsQuadEfficiencyPlPl._(_root);
	@override late final _TranslationsStatsTspinEfficiencyPlPl tspinEfficiency = _TranslationsStatsTspinEfficiencyPlPl._(_root);
	@override late final _TranslationsStatsAllspinEfficiencyPlPl allspinEfficiency = _TranslationsStatsAllspinEfficiencyPlPl._(_root);
	@override String blitzScore({required Object p}) => '${p} punktów';
	@override String levelUpRequirement({required Object p}) => 'Wymagania awansowania: ${p}';
	@override String get piecesTotal => 'Łączna liczba postawionych klocków';
	@override String get piecesWithPerfectFinesse => 'Położone z perfekcyjną finezją';
	@override String get score => 'Wynik';
	@override String get lines => 'Linie';
	@override String get linesShort => 'L';
	@override String get pcs => 'Czyste Pola';
	@override String get holds => 'Przechowania';
	@override String get spike => 'Najwyższy Spike';
	@override String top({required Object percentage}) => 'Top ${percentage}';
	@override String topRank({required Object rank}) => 'Najwyższa ranga: ${rank}';
	@override String get floor => 'Piętro';
	@override String get split => 'Split';
	@override String get total => 'Łącznie';
	@override String get sent => 'Wysłano';
	@override String get received => 'Otrzymane';
	@override String get placement => 'Pozycja';
	@override String get peak => 'Szczyt';
	@override String get overall => 'Ogólnie';
	@override String get midgame => 'Środek gry';
	@override String get efficiency => 'Wydajność';
	@override String get upstack => 'Upstack';
	@override String get downstack => 'Downstack';
	@override String get variance => 'Wariancja';
	@override String get burst => 'Seria';
	@override String get length => 'Długość';
	@override String get rate => 'Częstość';
	@override String get secsDS => 'Secs/DS';
	@override String get secsCheese => 'Secs/Ser';
	@override String get attackCheesiness => 'Nieład ataków';
	@override String get downstackingRatio => 'Współczynnik downstackowania';
	@override String get clearTypes => 'Typy Clearów';
	@override String get wellColumnDistribution => 'Dystrybucja ';
	@override String get allSpins => 'All Spiny';
	@override String get sankeyTitle => 'Wykres nadchodzących ataków Sankey';
	@override String get incomingAttack => 'Nadchodzący atak';
	@override String get clean => 'Czyste śmieci';
	@override String get cancelled => 'Anulowane';
	@override String get cheeseTanked => 'Przyjęty ser';
	@override String get cleanTanked => 'Przyjęte czyste śmieci';
	@override String get kills => 'Zabójstwa';
	@override String get deaths => 'Śmierci';
	@override String get ppsDistribution => 'Rozkład PPS';
	@override String qpWithMods({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		one: 'Z 1 modem',
		two: 'Z ${n} modami',
		few: 'Z ${n} modami',
		many: 'Z ${n} modami',
		other: 'Z ${n} modami',
	);
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		zero: '${n} naciśnięć klawiszy',
		one: '${n} naciśnięcie klawisza',
		two: '${n} naciśnięcia klawiszy',
		few: '${n} naciśnięcia klawiszy',
		many: '${n} naciśnięć klawiszy',
		other: '${n} naciśnięć klawiszy',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		zero: '${n} T-spinów łącznie',
		one: '${n} T-spin łącznie',
		two: '${n} T-spiny łącznie',
		few: '${n} T-spiny łącznie',
		many: '${n} T-spinów łącznie',
		other: '${n} T-spinów łącznie',
	);
	@override String linesCleared({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		zero: '${n} linii wyczyszczonych',
		one: '${n} linia wyczyszczona',
		two: '${n} linie wyczyszczone',
		few: '${n} linie wyczyszczone',
		many: '${n} linii wyczyszczonych',
		other: '${n} linii wyczyszczonych',
	);
	@override late final _TranslationsStatsGraphsPlPl graphs = _TranslationsStatsGraphsPlPl._(_root);
	@override String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		zero: '${n} graczy',
		one: '${n} gracz',
		two: '${n} graczy',
		few: '${n} graczy',
		many: '${n} graczy',
		other: '${n} graczy',
	);
	@override String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
		zero: '${n} gier',
		one: '${n} gra',
		two: '${n} gry',
		few: '${n} gry',
		many: '${n} gier',
		other: '${n} gier',
	);
	@override late final _TranslationsStatsLineClearPlPl lineClear = _TranslationsStatsLineClearPlPl._(_root);
	@override late final _TranslationsStatsLineClearsPlPl lineClears = _TranslationsStatsLineClearsPlPl._(_root);
	@override String get mini => 'Mini';
	@override String get tSpin => 'T-spin';
	@override String get tSpins => 'T-spiny';
	@override String get spin => 'Spin';
	@override String get spins => 'Spiny';
}

// Path: stats.xp
class _TranslationsStatsXpPlPl implements TranslationsStatsXpEn {
	_TranslationsStatsXpPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'XP';
	@override String get full => 'Punkty doświadczenia';
}

// Path: stats.tr
class _TranslationsStatsTrPlPl implements TranslationsStatsTrEn {
	_TranslationsStatsTrPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => 'Tetra Rating';
}

// Path: stats.glicko
class _TranslationsStatsGlickoPlPl implements TranslationsStatsGlickoEn {
	_TranslationsStatsGlickoPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => 'Glicko';
}

// Path: stats.rd
class _TranslationsStatsRdPlPl implements TranslationsStatsRdEn {
	_TranslationsStatsRdPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'RD';
	@override String get full => 'Odchylenie Ratingu';
}

// Path: stats.glixare
class _TranslationsStatsGlixarePlPl implements TranslationsStatsGlixareEn {
	_TranslationsStatsGlixarePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _TranslationsStatsS1trPlPl implements TranslationsStatsS1trEn {
	_TranslationsStatsS1trPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'S1 TR';
	@override String get full => 'TR w stylu Sezonu 1';
}

// Path: stats.gp
class _TranslationsStatsGpPlPl implements TranslationsStatsGpEn {
	_TranslationsStatsGpPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'RG';
	@override String get full => 'Rozegrane gry';
}

// Path: stats.gw
class _TranslationsStatsGwPlPl implements TranslationsStatsGwEn {
	_TranslationsStatsGwPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'WG';
	@override String get full => 'Wygrane gry';
}

// Path: stats.winrate
class _TranslationsStatsWinratePlPl implements TranslationsStatsWinrateEn {
	_TranslationsStatsWinratePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => '%WG';
	@override String get full => 'Współczynnik zwycięstw';
}

// Path: stats.apm
class _TranslationsStatsApmPlPl implements TranslationsStatsApmEn {
	_TranslationsStatsApmPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => 'Atak na minutę';
}

// Path: stats.pps
class _TranslationsStatsPpsPlPl implements TranslationsStatsPpsEn {
	_TranslationsStatsPpsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => 'Klocki na sekundę';
}

// Path: stats.vs
class _TranslationsStatsVsPlPl implements TranslationsStatsVsEn {
	_TranslationsStatsVsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => 'Wynik Versus';
}

// Path: stats.app
class _TranslationsStatsAppPlPl implements TranslationsStatsAppEn {
	_TranslationsStatsAppPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => 'Atak na klocek';
}

// Path: stats.vsapm
class _TranslationsStatsVsapmPlPl implements TranslationsStatsVsapmEn {
	_TranslationsStatsVsapmPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _TranslationsStatsDssPlPl implements TranslationsStatsDssEn {
	_TranslationsStatsDssPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => 'Downstack na sekundę';
}

// Path: stats.dsp
class _TranslationsStatsDspPlPl implements TranslationsStatsDspEn {
	_TranslationsStatsDspPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => 'Downstack na klocek';
}

// Path: stats.appdsp
class _TranslationsStatsAppdspPlPl implements TranslationsStatsAppdspEn {
	_TranslationsStatsAppdspPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _TranslationsStatsCheesePlPl implements TranslationsStatsCheeseEn {
	_TranslationsStatsCheesePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Ser';
	@override String get full => 'Indeks Sera';
}

// Path: stats.gbe
class _TranslationsStatsGbePlPl implements TranslationsStatsGbeEn {
	_TranslationsStatsGbePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => 'Wydajność śmieci';
}

// Path: stats.nyaapp
class _TranslationsStatsNyaappPlPl implements TranslationsStatsNyaappEn {
	_TranslationsStatsNyaappPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => 'Ważone APP';
}

// Path: stats.area
class _TranslationsStatsAreaPlPl implements TranslationsStatsAreaEn {
	_TranslationsStatsAreaPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Obszar';
	@override String get full => 'Obszar';
}

// Path: stats.etr
class _TranslationsStatsEtrPlPl implements TranslationsStatsEtrEn {
	_TranslationsStatsEtrPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => 'Szacowane TR';
}

// Path: stats.etracc
class _TranslationsStatsEtraccPlPl implements TranslationsStatsEtraccEn {
	_TranslationsStatsEtraccPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => 'Dokładność szacowanego TR';
}

// Path: stats.opener
class _TranslationsStatsOpenerPlPl implements TranslationsStatsOpenerEn {
	_TranslationsStatsOpenerPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Opener';
	@override String get full => 'Opener';
}

// Path: stats.plonk
class _TranslationsStatsPlonkPlPl implements TranslationsStatsPlonkEn {
	_TranslationsStatsPlonkPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Plonk';
	@override String get full => 'Plonk';
}

// Path: stats.stride
class _TranslationsStatsStridePlPl implements TranslationsStatsStrideEn {
	_TranslationsStatsStridePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Stride';
	@override String get full => 'Stride';
}

// Path: stats.infds
class _TranslationsStatsInfdsPlPl implements TranslationsStatsInfdsEn {
	_TranslationsStatsInfdsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Inf. DS';
	@override String get full => 'Nieskończony Downstack';
}

// Path: stats.altitude
class _TranslationsStatsAltitudePlPl implements TranslationsStatsAltitudeEn {
	_TranslationsStatsAltitudePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'm';
	@override String get full => 'Wysokość';
}

// Path: stats.climbSpeed
class _TranslationsStatsClimbSpeedPlPl implements TranslationsStatsClimbSpeedEn {
	_TranslationsStatsClimbSpeedPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'CSP';
	@override String get full => 'Prędkość wspinaczki';
	@override String get gaugetTitle => 'Prędkość\nwspinaczki';
}

// Path: stats.peakClimbSpeed
class _TranslationsStatsPeakClimbSpeedPlPl implements TranslationsStatsPeakClimbSpeedEn {
	_TranslationsStatsPeakClimbSpeedPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Najwyższe CSP';
	@override String get full => 'Najwyższa prędkość wspinania';
	@override String get gaugetTitle => 'Szczyt';
}

// Path: stats.kos
class _TranslationsStatsKosPlPl implements TranslationsStatsKosEn {
	_TranslationsStatsKosPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'KO';
	@override String get full => 'Eliminacje';
}

// Path: stats.b2b
class _TranslationsStatsB2bPlPl implements TranslationsStatsB2bEn {
	_TranslationsStatsB2bPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => 'Back-To-Back';
}

// Path: stats.finesse
class _TranslationsStatsFinessePlPl implements TranslationsStatsFinesseEn {
	_TranslationsStatsFinessePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'F';
	@override String get full => 'Finezja';
	@override String get widgetTitle => 'inezja';
}

// Path: stats.finesseFaults
class _TranslationsStatsFinesseFaultsPlPl implements TranslationsStatsFinesseFaultsEn {
	_TranslationsStatsFinesseFaultsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'FF';
	@override String get full => 'Błędy Finezji';
}

// Path: stats.totalTime
class _TranslationsStatsTotalTimePlPl implements TranslationsStatsTotalTimeEn {
	_TranslationsStatsTotalTimePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Czas';
	@override String get full => 'Łączny czas';
	@override String get widgetTitle => 'ączny czas';
}

// Path: stats.level
class _TranslationsStatsLevelPlPl implements TranslationsStatsLevelEn {
	_TranslationsStatsLevelPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Lvl';
	@override String get full => 'Poziom';
}

// Path: stats.pieces
class _TranslationsStatsPiecesPlPl implements TranslationsStatsPiecesEn {
	_TranslationsStatsPiecesPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => 'Klocki';
}

// Path: stats.spp
class _TranslationsStatsSppPlPl implements TranslationsStatsSppEn {
	_TranslationsStatsSppPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => 'Punkty na klocek';
}

// Path: stats.kp
class _TranslationsStatsKpPlPl implements TranslationsStatsKpEn {
	_TranslationsStatsKpPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => 'Naciśnięte klawisze';
}

// Path: stats.kpp
class _TranslationsStatsKppPlPl implements TranslationsStatsKppEn {
	_TranslationsStatsKppPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => 'Naciśnięcia klawiszy na klocek';
}

// Path: stats.kps
class _TranslationsStatsKpsPlPl implements TranslationsStatsKpsEn {
	_TranslationsStatsKpsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => 'Naciśnięcia klawiszy na sekundę';
}

// Path: stats.apl
class _TranslationsStatsAplPlPl implements TranslationsStatsAplEn {
	_TranslationsStatsAplPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'APL';
	@override String get full => 'Atak na linię';
}

// Path: stats.quadEfficiency
class _TranslationsStatsQuadEfficiencyPlPl implements TranslationsStatsQuadEfficiencyEn {
	_TranslationsStatsQuadEfficiencyPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Wyd. Q';
	@override String get full => 'Wydajność Quadów';
}

// Path: stats.tspinEfficiency
class _TranslationsStatsTspinEfficiencyPlPl implements TranslationsStatsTspinEfficiencyEn {
	_TranslationsStatsTspinEfficiencyPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Wyd. T';
	@override String get full => 'Wydajność T-spinów';
}

// Path: stats.allspinEfficiency
class _TranslationsStatsAllspinEfficiencyPlPl implements TranslationsStatsAllspinEfficiencyEn {
	_TranslationsStatsAllspinEfficiencyPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get short => 'Wyd. All';
	@override String get full => 'Wydajność All-spinów';
}

// Path: stats.graphs
class _TranslationsStatsGraphsPlPl implements TranslationsStatsGraphsEn {
	_TranslationsStatsGraphsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get attack => 'Atak';
	@override String get speed => 'Prędkość';
	@override String get defense => 'Obrona';
	@override String get cheese => 'Ser';
}

// Path: stats.lineClear
class _TranslationsStatsLineClearPlPl implements TranslationsStatsLineClearEn {
	_TranslationsStatsLineClearPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

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
class _TranslationsStatsLineClearsPlPl implements TranslationsStatsLineClearsEn {
	_TranslationsStatsLineClearsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get zero => 'Zero';
	@override String get single => 'Single';
	@override String get double => 'Double';
	@override String get triple => 'Triple';
	@override String get quad => 'Quady';
	@override String get penta => 'Penty';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsPlPl {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'Angielski (English)';
			case 'locales.ru-RU': return 'Rosyjski (Русский)';
			case 'locales.ko-KR': return 'Koreański (한국인)';
			case 'locales.zh-CN': return 'Chiński uproszczony (简体中文)';
			case 'locales.de-DE': return 'Niemiecki (Deutsch)';
			case 'locales.pl-PL': return 'Polski';
			case 'gamemodes.league': return 'Tetra League';
			case 'gamemodes.zenith': return 'Quick Play';
			case 'gamemodes.zenithex': return 'Quick Play Ekspert';
			case 'gamemodes.40l': return '40 Line';
			case 'gamemodes.blitz': return 'Blitz';
			case 'gamemodes.5mblast': return '5,000,000 Blast';
			case 'gamemodes.zen': return 'Zen';
			case 'destinations.home': return 'Strona Główna';
			case 'destinations.graphs': return 'Wykresy';
			case 'destinations.leaderboards': return 'Rankingi';
			case 'destinations.cutoffs': return 'Cutoffy';
			case 'destinations.calc': return 'Kalkulator';
			case 'destinations.info': return 'Centrum informacji';
			case 'destinations.data': return 'Zapisane Dane';
			case 'destinations.settings': return 'Ustawienia';
			case 'playerRole.user': return 'Użytkownik';
			case 'playerRole.banned': return 'Zbanowany';
			case 'playerRole.bot': return 'Bot';
			case 'playerRole.sysop': return 'Operator systemowy';
			case 'playerRole.admin': return 'Administrator';
			case 'playerRole.mod': return 'Moderator';
			case 'playerRole.halfmod': return 'Moderator Społeczności';
			case 'playerRole.anon': return 'Anonim';
			case 'goBackButton': return 'Powrót';
			case 'nanow': return 'Obecnie niedostępne...';
			case 'seasonEnds': return ({required Object countdown}) => 'Sezon kończy się za ${countdown}';
			case 'seasonEnded': return 'Sezon zakończył się';
			case 'overallPB': return ({required Object pb}) => 'Ogólne PB: ${pb} m';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} gier do osiągnięcia rangi';
			case 'numOfVictories': return ({required Object wins}) => '~${wins} zwycięstw';
			case 'promotionOnNextWin': return 'Awans przy następnej wygranej';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses} przegranych';
			case 'demotionOnNextLoss': return 'Spadek przy następnej przegranej';
			case 'records': return 'Rekordy';
			case 'nerdStats': return 'Statystyki Dla Nerdów';
			case 'playstyles': return 'Style Gry';
			case 'horoscopes': return 'Horoskopy';
			case 'relatedAchievements': return 'Powiązane Osiągnięcia';
			case 'season': return 'Sezon';
			case 'smooth': return 'Wygładź';
			case 'dateAndTime': return 'Data i Czas';
			case 'TLfullLBnote': return 'Wymagające, ale pozwala ci sortować graczy za pomocą ich statystyk i rang';
			case 'rank': return 'Ranga';
			case 'verdictGeneral': return ({required Object n, required Object verdict, required Object rank}) => '${n} ${verdict} ${rank}';
			case 'verdictBetter': return 'powyżej średniej';
			case 'verdictWorse': return 'za średnią';
			case 'localStanding': return 'lokalnie';
			case 'xp.title': return 'Poziom XP';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => 'Postęp do następnego poziomu: ${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => 'Postęp od 0XP do poziomu ${goal}: ${percentage} (pozostało ${left} XP)';
			case 'gametime.title': return 'Dokładny czas gry';
			case 'gametime.gametimeAday': return ({required Object gametime}) => 'Średnio ${gametime} dziennie';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'To ${years} lat,\nlub ${months} miesięcy,\nlub ${days} dni,\nlub ${minutes} minut\nlub ${seconds} sekund';
			case 'whichOne': return 'Które?';
			case 'track': return 'Śledź';
			case 'stopTracking': return 'Przestań śledzić';
			case 'supporter': return ({required Object tier}) => 'Supporter poziomu ${tier}';
			case 'comparingWith': return ({required Object newDate, required Object oldDate}) => 'Dane z ${newDate} w porównaniu z ${oldDate}';
			case 'compare': return 'Porównaj';
			case 'comparison': return 'Porównanie';
			case 'enterUsername': return 'Podaj nazwę użytkownika lub \$avgX (Gdzie X to ranga)';
			case 'general': return 'Ogólne';
			case 'badges': return 'Odznaki';
			case 'obtainDate': return ({required Object date}) => 'Otrzymano ${date}';
			case 'assignedManualy': return 'Ta odznaka została manualnie przydzielona przez administratorów TETR.IO';
			case 'distinguishment': return 'Wyróżnienie';
			case 'banned': return 'Zbanowany';
			case 'bannedSubtext': return 'Bany są nakładane kiedy zasady TETR.IO są złamane';
			case 'badStanding': return 'Złe zachowanie';
			case 'badStandingSubtext': return 'Jeden lub więcej nałożonych banów';
			case 'botAccount': return 'Konto Bota';
			case 'botAccountSubtext': return ({required Object botMaintainers}) => 'Operowany przez ${botMaintainers}';
			case 'copiedToClipboard': return 'Skopiowano do schowka!';
			case 'bio': return 'Bio';
			case 'news': return 'Aktualności';
			case 'matchResult.victory': return 'Zwycięstwo';
			case 'matchResult.defeat': return 'Porażka';
			case 'matchResult.tie': return 'Remis';
			case 'matchResult.dqvictory': return 'Przeciwnik został zdyskwalifikowany';
			case 'matchResult.dqdefeat': return 'Zdyskwalifikowany';
			case 'matchResult.nocontest': return 'Brak kontestu';
			case 'matchResult.nullified': return 'Unieważniony';
			case 'distinguishments.noHeader': return 'Brak nagłówka';
			case 'distinguishments.noFooter': return 'Brak stopki';
			case 'distinguishments.twc': return 'Światowy Czempion TETR.IO';
			case 'distinguishments.twcYear': return ({required Object year}) => 'Mistrzostwa Świata w TETR.IO ${year}';
			case 'newsEntries.leaderboard': return ({required InlineSpan rank, required InlineSpan gametype}) => TextSpan(children: [
				const TextSpan(text: 'Zdobył(a) № '),
				rank,
				const TextSpan(text: ' w '),
				gametype,
			]);
			case 'newsEntries.personalbest': return ({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
				const TextSpan(text: 'Osiągnął/Osiągnęła nowe PB w '),
				gametype,
				const TextSpan(text: ' wynoszące '),
				pb,
			]);
			case 'newsEntries.badge': return ({required InlineSpan badge}) => TextSpan(children: [
				const TextSpan(text: 'Zdobył(a) odznakę '),
				badge,
			]);
			case 'newsEntries.rankup': return ({required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: 'Zdobył(a) rangę '),
				rank,
				const TextSpan(text: ' w Tetra League'),
			]);
			case 'newsEntries.supporter': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Został(a) '),
				s('TETR.IO supporter'),
				const TextSpan(text: 'em'),
			]);
			case 'newsEntries.supporter_gift': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				const TextSpan(text: 'Otrzymał(a) prezent '),
				s('TETR.IO supporter'),
			]);
			case 'newsEntries.unknown': return ({required InlineSpan type}) => TextSpan(children: [
				const TextSpan(text: 'Nieznane wieści typu '),
				type,
			]);
			case 'rankupMiddle': return ({required Object r}) => 'ranga ${r}';
			case 'copyUserID': return 'Kliknij aby skopiować ID użytkownika';
			case 'searchHint': return 'Nazwa użytkownika lub ID';
			case 'navMenu': return 'Menu nawigacji';
			case 'navMenuTooltip': return 'Otwórz menu nawigacji';
			case 'refresh': return 'Odśwież dane';
			case 'searchButton': return 'Szukaj';
			case 'trackedPlayers': return 'Śledzeni gracze';
			case 'standing': return 'Miejsce';
			case 'previousSeasons': return 'Poprzednie sezony';
			case 'checkingCache': return 'Sprawdzanie pamięci podręcznej...';
			case 'fetchingRecords': return 'Pobieranie rekordów...';
			case 'munching': return 'Munching...';
			case 'outOf': return 'z';
			case 'replaysDone': return 'Wwykonane powtórki';
			case 'analysis': return 'Analiza';
			case 'minomuncherMention': return 'za pomocą MinoMuncher przez Freyhoe';
			case 'recent': return 'Ostatnie';
			case 'top': return 'Najlepszy';
			case 'noRecord': return 'Brak rekordu';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => 'Istotność: ${date}';
			case 'snackBarMessages.stateRemoved': return ({required Object date}) => 'Stan ${date} został usunięty z bazy danych!';
			case 'snackBarMessages.matchRemoved': return ({required Object date}) => 'Mecz z ${date} został usunięty z bazy danych!';
			case 'snackBarMessages.notForWeb': return 'Funkcja nie jest dostępna w wersji internetowej';
			case 'snackBarMessages.importSuccess': return 'Zaimportowano pomyślnie';
			case 'snackBarMessages.importCancelled': return 'Anulowano importowanie';
			case 'errors.noRecords': return 'Brak wpisów';
			case 'errors.notEnoughData': return 'Za mało danych';
			case 'errors.noHistorySaved': return 'Brak zapisanej historii';
			case 'errors.connection': return ({required Object code, required Object message}) => 'Problem z połączeniem: ${code} ${message}';
			case 'errors.noSuchUser': return 'Użytkownik nie istnieje';
			case 'errors.noSuchUserSub': return 'Albo niepoprawnie wpisałeś nazwę użytkownika, albo konto nie istnieje';
			case 'errors.discordNotAssigned': return 'Nie znaleziono połączeń';
			case 'errors.discordNotAssignedSub': return 'Twoje zapytanie powinno wyglądać jak opisane w [API](https://tetr.io/about/api/#userssearchquery)';
			case 'errors.history': return 'Brak historii dla tego gracza';
			case 'errors.actionSuggestion': return 'Być może chcesz';
			case 'errors.p1nkl0bst3rTLmatches': return 'Nie znaleziono meczów Tetra League';
			case 'errors.clientException': return 'Brak połączenia z Internetem';
			case 'errors.forbidden': return 'Twój adres IP jest zablokowany';
			case 'errors.forbiddenSub': return ({required Object nickname}) => 'Jeśli korzystasz z VPN lub Proxy, wyłącz go. Jeśli to nie pomoże, skontaktuj się z ${nickname}';
			case 'errors.tooManyRequests': return 'Zostałeś ograniczony.';
			case 'errors.tooManyRequestsSub': return 'Zaczekaj chwilę i spróbuj ponownie.';
			case 'errors.internal': return 'Coś się stało po stronie tetr.io';
			case 'errors.internalSub': return 'osk, prawdopodobnie, już o tym wie';
			case 'errors.internalWebVersion': return 'Coś się stało po stronie tetr.io (lub na oskware_bridge, nwm wsm)';
			case 'errors.internalWebVersionSub': return 'Jeśli strona statusu osk mówi, że wszystko jest w porządku, poinformuj dan63047 o tym problemie';
			case 'errors.oskwareBridge': return 'Coś się stało z oskware_bridge';
			case 'errors.oskwareBridgeSub': return 'Daj znać dan63047';
			case 'errors.p1nkl0bst3rForbidden': return 'API firm trzecich zablokowało Twój adres IP';
			case 'errors.p1nkl0bst3rTooManyRequests': return 'Zbyt wiele zapytań do API osób trzecich. Spróbuj ponownie później';
			case 'errors.p1nkl0bst3rinternal': return 'Coś się stało po stronie p1nkl0bst3r';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'Coś się wydarzyło po stronie p1nkl0bst3r (lub na oskware_bridge, idk)';
			case 'errors.replayAlreadySaved': return 'Powtórka już zapisana';
			case 'errors.replayExpired': return 'Powtórka wygasła i nie jest już dostępna';
			case 'errors.replayRejected': return 'API firm trzecich zablokowało Twój adres IP';
			case 'actions.cancel': return 'Anuluj';
			case 'actions.submit': return 'Zatwierdź';
			case 'actions.ok': return 'Ok';
			case 'actions.apply': return 'Zastosuj';
			case 'actions.refresh': return 'Odśwież';
			case 'graphsDestination.fetchAndsaveTLHistory': return 'Pobierz historię';
			case 'graphsDestination.fetchAndSaveOldTLmatches': return 'Pobierz historię meczy Tetra League';
			case 'graphsDestination.fetchAndsaveTLHistoryResult': return ({required Object number}) => 'Znaleziono ${number} stanów';
			case 'graphsDestination.fetchAndSaveOldTLmatchesResult': return ({required Object number}) => 'Znaleziono ${number} meczy';
			case 'graphsDestination.gamesPlayed': return ({required Object games}) => 'Zagrano ${games} gier';
			case 'graphsDestination.dateAndTime': return 'Data i czas';
			case 'graphsDestination.filterModaleTitle': return 'Filtruj rangi na wykresie';
			case 'filterModale.all': return 'Wszystkie';
			case 'cutoffsDestination.title': return 'Stan Tetra League';
			case 'cutoffsDestination.relevance': return ({required Object timestamp}) => 'z ${timestamp}';
			case 'cutoffsDestination.actual': return 'Prawdziwy';
			case 'cutoffsDestination.target': return 'Docelowy';
			case 'cutoffsDestination.cutoffTR': return 'Odcięcie TR';
			case 'cutoffsDestination.targetTR': return 'Docelowy TR';
			case 'cutoffsDestination.state': return 'Stan';
			case 'cutoffsDestination.advanced': return 'Zaawansowane';
			case 'cutoffsDestination.players': return ({required Object n}) => 'Gracze (${n})';
			case 'cutoffsDestination.moreInfo': return 'Więcej informacji';
			case 'cutoffsDestination.NumberOne': return ({required Object tr}) => '№ 1 posiada ${tr} TR';
			case 'cutoffsDestination.inflated': return ({required Object tr}) => 'Podwyższone o ${tr} TR';
			case 'cutoffsDestination.notInflated': return 'Nie jest podwyższone';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => 'Obniżone o ${tr} TR';
			case 'cutoffsDestination.notDeflated': return 'Nie jest obniżone';
			case 'cutoffsDestination.wellDotDotDot': return 'Cóż...';
			case 'cutoffsDestination.fromPlace': return ({required Object n}) => 'z № ${n}';
			case 'cutoffsDestination.viewButton': return 'Pokaż';
			case 'rankView.rankTitle': return ({required Object rank}) => 'Dane rangi ${rank}';
			case 'rankView.everyoneTitle': return 'Cały ranking';
			case 'rankView.trRange': return 'Zakres TR';
			case 'rankView.supposedToBe': return 'Powinno być';
			case 'rankView.gap': return ({required Object value}) => '${value} różnicy';
			case 'rankView.trGap': return ({required Object value}) => '${value} TR różnicy';
			case 'rankView.deflationGap': return 'Różnica deflacji';
			case 'rankView.inflationGap': return 'Różnica inflacji';
			case 'rankView.LBposRange': return 'Zakres pozycji w rankingu';
			case 'rankView.overpopulated': return ({required Object players}) => 'Przepełniony o ${players}';
			case 'rankView.underpopulated': return ({required Object players}) => 'Deficyt o ${players}';
			case 'rankView.PlayersEqualSupposedToBe': return 'cute';
			case 'rankView.avgStats': return 'Średnie statystyki';
			case 'rankView.avgForRank': return ({required Object rank}) => 'Średnia dla rangi ${rank}';
			case 'rankView.avgNerdStats': return 'Średnie statystyki dla nerdów';
			case 'rankView.minimums': return 'Minima';
			case 'rankView.maximums': return 'Maksyma';
			case 'stateView.title': return ({required Object date}) => 'Stan z ${date}';
			case 'tlMatchView.match': return 'Mecz';
			case 'tlMatchView.vs': return 'vs';
			case 'tlMatchView.winner': return 'Zwycięzca';
			case 'tlMatchView.roundNumber': return ({required Object n}) => 'Runda ${n}';
			case 'tlMatchView.statsFor': return 'Statystyki dla';
			case 'tlMatchView.numberOfRounds': return 'Ilość rund';
			case 'tlMatchView.matchLength': return 'Długość meczu';
			case 'tlMatchView.roundLength': return 'Długość rundy';
			case 'tlMatchView.matchStats': return 'Statystyki meczu';
			case 'tlMatchView.downloadReplay': return 'Pobierz powtórkę .ttrm';
			case 'tlMatchView.openReplay': return 'Otwórz powtórkę w TETR.IO';
			case 'calcDestination.placeholders': return ({required Object stat}) => 'Wprowadź ${stat}';
			case 'calcDestination.tip': return 'Wprowadź wartości i naciśnij "Kalkuluj", aby zobaczyć wykalkulowane statystyki dla Nerdów';
			case 'calcDestination.invalidValues': return 'Podaj prawidłową wartość';
			case 'calcDestination.statsCalcButton': return 'Kalkuluj';
			case 'calcDestination.damageCalcTip': return 'Kliknij na akcje po lewej stronie, aby dodać je tutaj';
			case 'calcDestination.clearAll': return 'Wyczyść wszystko';
			case 'calcDestination.actions': return 'Działania';
			case 'calcDestination.results': return 'Wyniki';
			case 'calcDestination.rules': return 'Zasady';
			case 'calcDestination.noSpinClears': return 'Bez Clearów Spinami';
			case 'calcDestination.spins': return 'Spiny';
			case 'calcDestination.miniSpins': return 'Mini Spiny';
			case 'calcDestination.noLineclear': return 'Brak lineclearów (Break Combo)';
			case 'calcDestination.custom': return 'Własne';
			case 'calcDestination.multiplier': return 'Mnożnik';
			case 'calcDestination.pcDamage': return 'Obrażenia Perfect Cleara';
			case 'calcDestination.comboTable': return 'Tabela Combo';
			case 'calcDestination.b2bChaining': return 'Chainowanie Back-To-Back';
			case 'calcDestination.surgeStartAtB2B': return 'Początkowy B2B';
			case 'calcDestination.surgeStartAmount': return 'Wartość początkowa';
			case 'calcDestination.totalDamage': return 'Łączne obrażenia';
			case 'calcDestination.lineclears': return 'Wyczyszczone Linie';
			case 'calcDestination.combo': return 'Kombo';
			case 'calcDestination.surge': return 'Wyładowanie';
			case 'calcDestination.pcs': return 'PC';
			case 'infoDestination.title': return 'Centrum informacji';
			case 'infoDestination.sprintAndBlitzAverages': return 'Średnie 40 Lines i Blitz';
			case 'infoDestination.sprintAndBlitzAveragesDescription': return 'Ponieważ kalkulacja 40 linii i średnich Blitz jest żmudnym procesem, jest on aktualizowany tylko raz na jakiś czas. Kliknij tytuł tej karty, aby zobaczyć pełną tabelę 40 linii i średnich wartości Blitz';
			case 'infoDestination.tetraStatsWiki': return 'Tetra Stats Wiki';
			case 'infoDestination.tetraStatsWikiDescription': return 'Dowiedz się więcej o funkcjach i statystykach Tetra Stats';
			case 'infoDestination.about': return 'O Tetra Stats';
			case 'infoDestination.aboutDescription': return 'Stworzone przez dan63\n';
			case 'leaderboardsDestination.title': return 'Rankingi';
			case 'leaderboardsDestination.tl': return 'Tetra League (Obecny Sezon)';
			case 'leaderboardsDestination.fullTL': return 'Tetra League (Obecny Sezon, pełny)';
			case 'leaderboardsDestination.ar': return 'Punkty osiągnięć';
			case 'savedDataDestination.title': return 'Zapisane Dane';
			case 'savedDataDestination.tip': return 'Wybierz nazwę użytkownika po lewej stronie, aby zobaczyć powiązane z nią dane';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => 'Stany Sezonu ${s} TL';
			case 'savedDataDestination.TLrecords': return 'Rekordy TL';
			case 'settingsDestination.title': return 'Ustawienia';
			case 'settingsDestination.general': return 'Ogólne';
			case 'settingsDestination.customization': return 'Personalizacja';
			case 'settingsDestination.database': return 'Lokalna baza danych';
			case 'settingsDestination.checking': return 'Sprawdzanie...';
			case 'settingsDestination.enterToSubmit': return 'Naciśnij Enter, aby przesłać';
			case 'settingsDestination.account': return 'Twoje konto w TETR.IO';
			case 'settingsDestination.accountDescription': return 'Statystyki tego gracza zostaną załadowane początkowo zaraz po uruchomieniu aplikacji. Domyślnie ładuje moje statystyki (dan63). Aby to zmienić, wprowadź swój nick tutaj.';
			case 'settingsDestination.done': return 'Gotowe!';
			case 'settingsDestination.noSuchAccount': return 'Nie ma takiego konta';
			case 'settingsDestination.language': return 'Język';
			case 'settingsDestination.languageDescription': return ({required Object languages}) => 'Tetra Stats zostały przetłumaczone na ${languages}. Domyślnie aplikacja wybierze twój język systemowy lub angielski, jeśli ustawienia regionalne twojego systemu nie są dostępne.';
			case 'settingsDestination.languages': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				zero: 'zero języków',
				one: '${n} język',
				two: '${n} języki',
				few: '${n} języki',
				many: '${n} języków',
				other: '${n} języków',
			);
			case 'settingsDestination.updateInTheBackground': return 'Aktualizuj dane w tle';
			case 'settingsDestination.updateInTheBackgroundDescription': return 'Jeśli włączone, Tetra Stats będzie próbowało otrzymać nowe informacje po wygaśnięciu pamięci podręcznej. Zwykle dzieje się to co 5 minut';
			case 'settingsDestination.munchLimit': return 'Limit for Minomuncher analysis';
			case 'settingsDestination.munchLimitDescription': return 'By default, minomuncher will analyse first 10 available replays. If you want more, you can adjust it here (max of 25).';
			case 'settingsDestination.munchLimitTooMuch': return 'Too much, rejected';
			case 'settingsDestination.compareStats': return 'Porównaj statystyki TL ze średnimi rang';
			case 'settingsDestination.compareStatsDescription': return 'Jeśli włączone, Tetra Stats zapewni dodatkowe pomiary, które pozwolą ci porównać siebie do średniego gracza w twojej randze. Będzie to widoczne w ten sposób — statystyki będą podświetlane odpowiednim kolorem, najedź na nie kursorem, aby zobaczyć więcej informacji.';
			case 'settingsDestination.showPosition': return 'Pokaż pozycję w rankingu według statystyk';
			case 'settingsDestination.showPositionDescription': return 'To może zająć trochę czasu (i ruchu), ale pozwoli Ci zobaczyć swoją pozycję na tablicy wyników, posortowaną według statystyk';
			case 'settingsDestination.accentColor': return 'Kolor akcentu';
			case 'settingsDestination.accentColorDescription': return 'Ten kolor jest widoczny w tej aplikacji i zazwyczaj podkreśla interaktywne elementy interfejsu użytkownika.';
			case 'settingsDestination.accentColorModale': return 'Wybierz kolor akcentu';
			case 'settingsDestination.timestamps': return 'Format znaczników czasu';
			case 'settingsDestination.timestampsDescriptionPart1': return ({required Object d}) => 'Możesz wybrać, w jaki sposób znaczniki czasu pokazują czas. Domyślnie pokazują czas w strefie czasowej GMT, sformatowany zgodnie z wybraną lokalizacją, przykład: ${d}.';
			case 'settingsDestination.timestampsDescriptionPart2': return ({required Object y, required Object r}) => 'Jest również:\n• Ustawienia regionalne sformatowane w twojej strefie czasowej: ${y}\n• Względny znacznik czasu: ${r}';
			case 'settingsDestination.timestampsAbsoluteGMT': return 'Bezwzględny (GMT)';
			case 'settingsDestination.timestampsAbsoluteLocalTime': return 'Bezwzględny (Twoja strefa czasowa)';
			case 'settingsDestination.timestampsRelative': return 'Względny';
			case 'settingsDestination.sheetbotLikeGraphs': return 'Zachowanie wykresów radarowych podobne do Sheetbota';
			case 'settingsDestination.sheetbotLikeGraphsDescription': return 'Mimo tego, że rozważałem to, sposób działania wykresów w SheetBocie nie jest zbyt poprawny, niektórzy byli zdziwieni, że -0,5 stride nie wygląda w ten sam sposób jak jest to pokazane na wykresach SheetBota. Więc jesteśmy tutaj: jeśli ta opcja jest włączona, punkty na wykresie mogą wyświetlić się po przeciwnej stronie wykresu, jeśli wartości są negatywne.';
			case 'settingsDestination.oskKagariGimmick': return 'Osk-Kagari gimmick';
			case 'settingsDestination.oskKagariGimmickDescription': return 'Jeśli włączone, zamiast rangi oska, :kagari: zostanie wyrenderowana.';
			case 'settingsDestination.bytesOfDataStored': return 'przechowywanych danych';
			case 'settingsDestination.TLrecordsSaved': return 'Rekordy Tetra League zapisane';
			case 'settingsDestination.TLplayerstatesSaved': return 'Stany graczy Tetra League zapisane';
			case 'settingsDestination.fixButton': return 'Napraw';
			case 'settingsDestination.compressButton': return 'Kompresuj';
			case 'settingsDestination.exportDB': return 'Eksportuj lokalną bazę danych';
			case 'settingsDestination.desktopExportAlertTitle': return 'Eksport na aplikację pulpitową';
			case 'settingsDestination.desktopExportText': return 'Wygląda na to, że używasz tej aplikacji na komputerze. Sprawdź folder dokumentów, powinieneś znaleźć plik "TetraStats.db". Skopiuj go gdzieś';
			case 'settingsDestination.androidExportAlertTitle': return 'Eksport Android';
			case 'settingsDestination.androidExportText': return ({required Object exportedDB}) => 'Wyeksportowano\n${exportedDB}';
			case 'settingsDestination.importDB': return 'Zaimportuj lokalną bazę danych';
			case 'settingsDestination.importDBDescription': return 'Przywróć kopię zapasową. Zauważ, że już zapisana baza danych zostanie nadpisana.';
			case 'settingsDestination.importWrongFileType': return 'Nieprawidłowy typ pliku';
			case 'homeNavigation.overview': return 'Podsumowanie';
			case 'homeNavigation.standing': return 'Miejsce';
			case 'homeNavigation.seasons': return 'Sezony';
			case 'homeNavigation.mathces': return 'Mecze';
			case 'homeNavigation.pb': return 'PB';
			case 'homeNavigation.normal': return 'Normal';
			case 'homeNavigation.expert': return 'Ekspert';
			case 'homeNavigation.expertRecords': return 'Rekordy trybu Ekspert';
			case 'graphsNavigation.history': return 'Historia gracza';
			case 'graphsNavigation.league': return 'Stan Ligi';
			case 'graphsNavigation.cutoffs': return 'Historia Cutoffów';
			case 'calcNavigation.stats': return 'Kalkulator statystyk';
			case 'calcNavigation.damage': return 'Kalkulator obrażeń';
			case 'firstTimeView.welcome': return 'Witaj w Tetra Stats';
			case 'firstTimeView.description': return 'Serwis umożliwiający śledzenie różnych statystyk dla TETR.IO';
			case 'firstTimeView.nicknameQuestion': return 'Jaki jest Twój nick?';
			case 'firstTimeView.inpuntHint': return 'Wpisz tutaj... (3-16 symboli)';
			case 'firstTimeView.emptyInputError': return 'Nie można przesłać pustego ciągu';
			case 'firstTimeView.niceToSeeYou': return ({required Object n}) => 'Miło cię widzieć, ${n}';
			case 'firstTimeView.letsTakeALook': return 'Spójrzmy na Twoje statystyki...';
			case 'firstTimeView.skip': return 'Pomiń';
			case 'aboutView.title': return 'O Tetra Stats';
			case 'aboutView.about': return 'Tetra Stats to serwis, który działa za pomocą API TETR.IO Tetra Channel, dostarczając z niego dane i kalkulując dodatkowe metryki na podstawie tych danych. Serwis pozwala użytkownikowi śledzić swoje postępy w Tetra League za pomocą funkcji "Śledź", która zapisuje wszystkie zmiany w Tetra League do lokalnej bazy danych (nie jest to automatyczne, musisz odwiedzać serwis od czasu do czasu), aby gracz mógł przejrzeć te zmiany na wykresach.\n\nBeanserver blaster jest częścią Tetra Stats, który oddzielił się w skrypt serwerowy. Zapewnia pełną tablicę rankingów Tetra League, pozwalając Tetra Stats sortować rankingi za pomocą jakichkolwiek parametrów i budować wykresy punktowe, które pozwalają użytkownikowi analizować swoje tendencje w Tetra League. Daje także dostęp do historii cutoffów Tetra League, które mogą być przeglądane przez użytkownika zna wykresach.\n\nW planach jest dodanie analizy powtórek i historii turniejów, więc oczekujcie nowości!\n\nSerwis nie jest powiązany z TETR.IO lub oskiem w jakikolwiek sposób.';
			case 'aboutView.appVersion': return 'Wersja aplikacji';
			case 'aboutView.build': return ({required Object build}) => 'Build ${build}';
			case 'aboutView.GHrepo': return 'Repozytorium GitHub';
			case 'aboutView.submitAnIssue': return 'Zgłoś problem';
			case 'aboutView.credits': return 'Podziękowania';
			case 'aboutView.authorAndDeveloper': return 'Autor i deweloper';
			case 'aboutView.providedFormulas': return 'Dostarczył(a) formuły';
			case 'aboutView.providedS1history': return 'Dostarczył(a) historię S1';
			case 'aboutView.inoue': return 'Inoue (graber powtórek)';
			case 'aboutView.zhCNlocale': return 'Język chiński uproszczony';
			case 'aboutView.deDElocale': return 'Język niemiecki';
			case 'aboutView.koKRlocale': return 'Język koreański';
			case 'aboutView.plPLlocale': return 'Język polski';
			case 'aboutView.withFixesBy': return ({required Object username}) => 'Z poprawkami ${username}';
			case 'aboutView.supportHim': return 'Wesprzyj go!';
			case 'stats.registrationDate': return 'Data rejestracji';
			case 'stats.gametime': return 'Czas gry';
			case 'stats.ogp': return 'Rozegrane gry online';
			case 'stats.ogw': return 'Wygrane gry online';
			case 'stats.followers': return 'Obserwujących';
			case 'stats.xp.short': return 'XP';
			case 'stats.xp.full': return 'Punkty doświadczenia';
			case 'stats.tr.short': return 'TR';
			case 'stats.tr.full': return 'Tetra Rating';
			case 'stats.glicko.short': return 'Glicko';
			case 'stats.glicko.full': return 'Glicko';
			case 'stats.rd.short': return 'RD';
			case 'stats.rd.full': return 'Odchylenie Ratingu';
			case 'stats.glixare.short': return 'GXE';
			case 'stats.glixare.full': return 'GLIXARE';
			case 'stats.s1tr.short': return 'S1 TR';
			case 'stats.s1tr.full': return 'TR w stylu Sezonu 1';
			case 'stats.gp.short': return 'RG';
			case 'stats.gp.full': return 'Rozegrane gry';
			case 'stats.gw.short': return 'WG';
			case 'stats.gw.full': return 'Wygrane gry';
			case 'stats.winrate.short': return '%WG';
			case 'stats.winrate.full': return 'Współczynnik zwycięstw';
			case 'stats.apm.short': return 'APM';
			case 'stats.apm.full': return 'Atak na minutę';
			case 'stats.pps.short': return 'PPS';
			case 'stats.pps.full': return 'Klocki na sekundę';
			case 'stats.vs.short': return 'VS';
			case 'stats.vs.full': return 'Wynik Versus';
			case 'stats.app.short': return 'APP';
			case 'stats.app.full': return 'Atak na klocek';
			case 'stats.vsapm.short': return 'VS/APM';
			case 'stats.vsapm.full': return 'VS / APM';
			case 'stats.dss.short': return 'DS/S';
			case 'stats.dss.full': return 'Downstack na sekundę';
			case 'stats.dsp.short': return 'DS/P';
			case 'stats.dsp.full': return 'Downstack na klocek';
			case 'stats.appdsp.short': return 'APP+DSP';
			case 'stats.appdsp.full': return 'APP + DSP';
			case 'stats.cheese.short': return 'Ser';
			case 'stats.cheese.full': return 'Indeks Sera';
			case 'stats.gbe.short': return 'GbE';
			case 'stats.gbe.full': return 'Wydajność śmieci';
			case 'stats.nyaapp.short': return 'wAPP';
			case 'stats.nyaapp.full': return 'Ważone APP';
			case 'stats.area.short': return 'Obszar';
			case 'stats.area.full': return 'Obszar';
			case 'stats.etr.short': return 'eTR';
			case 'stats.etr.full': return 'Szacowane TR';
			case 'stats.etracc.short': return '±eTR';
			case 'stats.etracc.full': return 'Dokładność szacowanego TR';
			case 'stats.opener.short': return 'Opener';
			case 'stats.opener.full': return 'Opener';
			case 'stats.plonk.short': return 'Plonk';
			case 'stats.plonk.full': return 'Plonk';
			case 'stats.stride.short': return 'Stride';
			case 'stats.stride.full': return 'Stride';
			case 'stats.infds.short': return 'Inf. DS';
			case 'stats.infds.full': return 'Nieskończony Downstack';
			case 'stats.altitude.short': return 'm';
			case 'stats.altitude.full': return 'Wysokość';
			case 'stats.climbSpeed.short': return 'CSP';
			case 'stats.climbSpeed.full': return 'Prędkość wspinaczki';
			case 'stats.climbSpeed.gaugetTitle': return 'Prędkość\nwspinaczki';
			case 'stats.peakClimbSpeed.short': return 'Najwyższe CSP';
			case 'stats.peakClimbSpeed.full': return 'Najwyższa prędkość wspinania';
			case 'stats.peakClimbSpeed.gaugetTitle': return 'Szczyt';
			case 'stats.kos.short': return 'KO';
			case 'stats.kos.full': return 'Eliminacje';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return 'Back-To-Back';
			case 'stats.finesse.short': return 'F';
			case 'stats.finesse.full': return 'Finezja';
			case 'stats.finesse.widgetTitle': return 'inezja';
			case 'stats.finesseFaults.short': return 'FF';
			case 'stats.finesseFaults.full': return 'Błędy Finezji';
			case 'stats.totalTime.short': return 'Czas';
			case 'stats.totalTime.full': return 'Łączny czas';
			case 'stats.totalTime.widgetTitle': return 'ączny czas';
			case 'stats.level.short': return 'Lvl';
			case 'stats.level.full': return 'Poziom';
			case 'stats.pieces.short': return 'P';
			case 'stats.pieces.full': return 'Klocki';
			case 'stats.spp.short': return 'SPP';
			case 'stats.spp.full': return 'Punkty na klocek';
			case 'stats.kp.short': return 'KP';
			case 'stats.kp.full': return 'Naciśnięte klawisze';
			case 'stats.kpp.short': return 'KPP';
			case 'stats.kpp.full': return 'Naciśnięcia klawiszy na klocek';
			case 'stats.kps.short': return 'KPS';
			case 'stats.kps.full': return 'Naciśnięcia klawiszy na sekundę';
			case 'stats.apl.short': return 'APL';
			case 'stats.apl.full': return 'Atak na linię';
			case 'stats.quadEfficiency.short': return 'Wyd. Q';
			case 'stats.quadEfficiency.full': return 'Wydajność Quadów';
			case 'stats.tspinEfficiency.short': return 'Wyd. T';
			case 'stats.tspinEfficiency.full': return 'Wydajność T-spinów';
			case 'stats.allspinEfficiency.short': return 'Wyd. All';
			case 'stats.allspinEfficiency.full': return 'Wydajność All-spinów';
			case 'stats.blitzScore': return ({required Object p}) => '${p} punktów';
			case 'stats.levelUpRequirement': return ({required Object p}) => 'Wymagania awansowania: ${p}';
			case 'stats.piecesTotal': return 'Łączna liczba postawionych klocków';
			case 'stats.piecesWithPerfectFinesse': return 'Położone z perfekcyjną finezją';
			case 'stats.score': return 'Wynik';
			case 'stats.lines': return 'Linie';
			case 'stats.linesShort': return 'L';
			case 'stats.pcs': return 'Czyste Pola';
			case 'stats.holds': return 'Przechowania';
			case 'stats.spike': return 'Najwyższy Spike';
			case 'stats.top': return ({required Object percentage}) => 'Top ${percentage}';
			case 'stats.topRank': return ({required Object rank}) => 'Najwyższa ranga: ${rank}';
			case 'stats.floor': return 'Piętro';
			case 'stats.split': return 'Split';
			case 'stats.total': return 'Łącznie';
			case 'stats.sent': return 'Wysłano';
			case 'stats.received': return 'Otrzymane';
			case 'stats.placement': return 'Pozycja';
			case 'stats.peak': return 'Szczyt';
			case 'stats.overall': return 'Ogólnie';
			case 'stats.midgame': return 'Środek gry';
			case 'stats.efficiency': return 'Wydajność';
			case 'stats.upstack': return 'Upstack';
			case 'stats.downstack': return 'Downstack';
			case 'stats.variance': return 'Wariancja';
			case 'stats.burst': return 'Seria';
			case 'stats.length': return 'Długość';
			case 'stats.rate': return 'Częstość';
			case 'stats.secsDS': return 'Secs/DS';
			case 'stats.secsCheese': return 'Secs/Ser';
			case 'stats.attackCheesiness': return 'Nieład ataków';
			case 'stats.downstackingRatio': return 'Współczynnik downstackowania';
			case 'stats.clearTypes': return 'Typy Clearów';
			case 'stats.wellColumnDistribution': return 'Dystrybucja ';
			case 'stats.allSpins': return 'All Spiny';
			case 'stats.sankeyTitle': return 'Wykres nadchodzących ataków Sankey';
			case 'stats.incomingAttack': return 'Nadchodzący atak';
			case 'stats.clean': return 'Czyste śmieci';
			case 'stats.cancelled': return 'Anulowane';
			case 'stats.cheeseTanked': return 'Przyjęty ser';
			case 'stats.cleanTanked': return 'Przyjęte czyste śmieci';
			case 'stats.kills': return 'Zabójstwa';
			case 'stats.deaths': return 'Śmierci';
			case 'stats.ppsDistribution': return 'Rozkład PPS';
			case 'stats.qpWithMods': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				one: 'Z 1 modem',
				two: 'Z ${n} modami',
				few: 'Z ${n} modami',
				many: 'Z ${n} modami',
				other: 'Z ${n} modami',
			);
			case 'stats.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				zero: '${n} naciśnięć klawiszy',
				one: '${n} naciśnięcie klawisza',
				two: '${n} naciśnięcia klawiszy',
				few: '${n} naciśnięcia klawiszy',
				many: '${n} naciśnięć klawiszy',
				other: '${n} naciśnięć klawiszy',
			);
			case 'stats.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				zero: '${n} T-spinów łącznie',
				one: '${n} T-spin łącznie',
				two: '${n} T-spiny łącznie',
				few: '${n} T-spiny łącznie',
				many: '${n} T-spinów łącznie',
				other: '${n} T-spinów łącznie',
			);
			case 'stats.linesCleared': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				zero: '${n} linii wyczyszczonych',
				one: '${n} linia wyczyszczona',
				two: '${n} linie wyczyszczone',
				few: '${n} linie wyczyszczone',
				many: '${n} linii wyczyszczonych',
				other: '${n} linii wyczyszczonych',
			);
			case 'stats.graphs.attack': return 'Atak';
			case 'stats.graphs.speed': return 'Prędkość';
			case 'stats.graphs.defense': return 'Obrona';
			case 'stats.graphs.cheese': return 'Ser';
			case 'stats.players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				zero: '${n} graczy',
				one: '${n} gracz',
				two: '${n} graczy',
				few: '${n} graczy',
				many: '${n} graczy',
				other: '${n} graczy',
			);
			case 'stats.games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(n,
				zero: '${n} gier',
				one: '${n} gra',
				two: '${n} gry',
				few: '${n} gry',
				many: '${n} gier',
				other: '${n} gier',
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
			case 'stats.lineClears.zero': return 'Zero';
			case 'stats.lineClears.single': return 'Single';
			case 'stats.lineClears.double': return 'Double';
			case 'stats.lineClears.triple': return 'Triple';
			case 'stats.lineClears.quad': return 'Quady';
			case 'stats.lineClears.penta': return 'Penty';
			case 'stats.mini': return 'Mini';
			case 'stats.tSpin': return 'T-spin';
			case 'stats.tSpins': return 'T-spiny';
			case 'stats.spin': return 'Spin';
			case 'stats.spins': return 'Spiny';
			case 'countries.': return 'Światowy';
			case 'countries.AF': return 'Afganistan';
			case 'countries.AX': return 'Wyspy Alandzkie';
			case 'countries.AL': return 'Albania';
			case 'countries.DZ': return 'Algieria';
			case 'countries.AS': return 'Samoa Amerykańska';
			case 'countries.AD': return 'Andora';
			case 'countries.AO': return 'Angola';
			case 'countries.AI': return 'Anguilla';
			case 'countries.AQ': return 'Antarktyka';
			case 'countries.AG': return 'Antigua i Barbuda';
			case 'countries.AR': return 'Argentyna';
			case 'countries.AM': return 'Armenia';
			case 'countries.AW': return 'Aruba';
			case 'countries.AU': return 'Australia';
			case 'countries.AT': return 'Austria';
			case 'countries.AZ': return 'Azerbejdżan';
			case 'countries.BS': return 'Bahamy';
			case 'countries.BH': return 'Bahrajn';
			case 'countries.BD': return 'Bangladesz';
			case 'countries.BB': return 'Barbados';
			case 'countries.BY': return 'Białoruś';
			case 'countries.BE': return 'Belgia';
			case 'countries.BZ': return 'Belize';
			case 'countries.BJ': return 'Benin';
			case 'countries.BM': return 'Bermudy';
			case 'countries.BT': return 'Bhutan';
			case 'countries.BO': return 'Wielonarodowe Państwo Boliwii';
			case 'countries.BA': return 'Bośnia i Hercegowina';
			case 'countries.BW': return 'Botswana';
			case 'countries.BV': return 'Wyspa Bouveta';
			case 'countries.BR': return 'Brazylia';
			case 'countries.IO': return 'Brytyjskie Terytorium Oceanu Indyjskiego';
			case 'countries.BN': return 'Brunei Darussalam';
			case 'countries.BG': return 'Bułgaria';
			case 'countries.BF': return 'Burkina Faso';
			case 'countries.BI': return 'Burundi';
			case 'countries.KH': return 'Kambodża';
			case 'countries.CM': return 'Kamerun';
			case 'countries.CA': return 'Kanada';
			case 'countries.CV': return 'Wyspy Zielonego Przylądka';
			case 'countries.BQ': return 'Niderlandy Karaibskie';
			case 'countries.KY': return 'Kajmany';
			case 'countries.CF': return 'Republika Środkowoafrykańska';
			case 'countries.TD': return 'Czad';
			case 'countries.CL': return 'Czile';
			case 'countries.CN': return 'Chiny';
			case 'countries.CX': return 'Wyspa Wielkanocna';
			case 'countries.CC': return 'Wyspy Kokosowe (Keeling)';
			case 'countries.CO': return 'Kolumbia';
			case 'countries.KM': return 'Związek Komorów';
			case 'countries.CG': return 'Kongo';
			case 'countries.CD': return 'Demokratyczna Republika Konga';
			case 'countries.CK': return 'Wyspy Cooka';
			case 'countries.CR': return 'Kostaryka';
			case 'countries.CI': return 'Wybrzeże Kości Słoniowej';
			case 'countries.HR': return 'Chorwacja';
			case 'countries.CU': return 'Kuba';
			case 'countries.CW': return 'Curacao';
			case 'countries.CY': return 'Cypr';
			case 'countries.CZ': return 'Republika Czeska';
			case 'countries.DK': return 'Dania';
			case 'countries.DJ': return 'Dżibuti';
			case 'countries.DM': return 'Dominikana';
			case 'countries.DO': return 'Republika Dominikany';
			case 'countries.EC': return 'Ekwador';
			case 'countries.EG': return 'Egipt';
			case 'countries.SV': return 'El Salvador';
			case 'countries.GB-ENG': return 'Anglia';
			case 'countries.GQ': return 'Gwinea Równikowa';
			case 'countries.ER': return 'Erytrea';
			case 'countries.EE': return 'Estonia';
			case 'countries.ET': return 'Etiopia';
			case 'countries.EU': return 'Europa';
			case 'countries.FK': return 'Falklandy (Malwiny)';
			case 'countries.FO': return 'Wyspy Owcze';
			case 'countries.FJ': return 'Fidżi';
			case 'countries.FI': return 'Finlandia';
			case 'countries.FR': return 'Francja';
			case 'countries.GF': return 'Gujana Francuska';
			case 'countries.PF': return 'Polinezja Francuska';
			case 'countries.TF': return 'Francuskie Terytoria Południowe i Antarktyczne';
			case 'countries.GA': return 'Gabon';
			case 'countries.GM': return 'Gambia';
			case 'countries.GE': return 'Gruzja';
			case 'countries.DE': return 'Niemcy';
			case 'countries.GH': return 'Ghana';
			case 'countries.GI': return 'Gibraltar';
			case 'countries.GR': return 'Grecja';
			case 'countries.GL': return 'Grenlandia';
			case 'countries.GD': return 'Grenada';
			case 'countries.GP': return 'Gwadelupa';
			case 'countries.GU': return 'Guam';
			case 'countries.GT': return 'Gwatemala';
			case 'countries.GG': return 'Wyspa Guernsey';
			case 'countries.GN': return 'Gwinea';
			case 'countries.GW': return 'Gwinea Bissau';
			case 'countries.GY': return 'Gujana';
			case 'countries.HT': return 'Haiti';
			case 'countries.HM': return 'Wyspy Heard i McDonalda';
			case 'countries.VA': return 'Stolica Apostolska (Watykan)';
			case 'countries.HN': return 'Honduras';
			case 'countries.HK': return 'Hongkong';
			case 'countries.HU': return 'Węgry';
			case 'countries.IS': return 'Islandia';
			case 'countries.IN': return 'Indie';
			case 'countries.ID': return 'Indonezja';
			case 'countries.IR': return 'Iran';
			case 'countries.IQ': return 'Irak';
			case 'countries.IE': return 'Irlandia';
			case 'countries.IM': return 'Wyspa Man';
			case 'countries.IL': return 'Izrael';
			case 'countries.IT': return 'Włochy';
			case 'countries.JM': return 'Jamajka';
			case 'countries.JP': return 'Japonia';
			case 'countries.JE': return 'Jersey';
			case 'countries.JO': return 'Jordania';
			case 'countries.KZ': return 'Kazachstan';
			case 'countries.KE': return 'Kenia';
			case 'countries.KI': return 'Kiribati';
			case 'countries.KP': return 'Koreańska Republika Ludowo-Demokratyczna';
			case 'countries.KR': return 'Korea Południowa';
			case 'countries.XK': return 'Kosowo';
			case 'countries.KW': return 'Kuwejt';
			case 'countries.KG': return 'Kirgistan';
			case 'countries.LA': return 'Laotańska Republika Ludowo-Demokratyczna';
			case 'countries.LV': return 'Łotwa';
			case 'countries.LB': return 'Lebanon';
			case 'countries.LS': return 'Lesotho';
			case 'countries.LR': return 'Republika Liberii';
			case 'countries.LY': return 'Libia';
			case 'countries.LI': return 'Liechtenstein';
			case 'countries.LT': return 'Litwa';
			case 'countries.LU': return 'Luksemburg';
			case 'countries.MO': return 'Makau';
			case 'countries.MK': return 'Republika Macedonii Północnej';
			case 'countries.MG': return 'Madagaskar';
			case 'countries.MW': return 'Malawi';
			case 'countries.MY': return 'Malezja';
			case 'countries.MV': return 'Malediwy';
			case 'countries.ML': return 'Mali';
			case 'countries.MT': return 'Malta';
			case 'countries.MH': return 'Wyspy Marshalla';
			case 'countries.MQ': return 'Martynika';
			case 'countries.MR': return 'Mauretania';
			case 'countries.MU': return 'Mauritius';
			case 'countries.YT': return 'Majotta';
			case 'countries.MX': return 'Meksyk';
			case 'countries.FM': return 'Mikronezja';
			case 'countries.MD': return 'Republika Mołdowy';
			case 'countries.MC': return 'Monako';
			case 'countries.ME': return 'Czarnogóra';
			case 'countries.MA': return 'Maroko';
			case 'countries.MN': return 'Mongolia';
			case 'countries.MS': return 'Montserrat';
			case 'countries.MZ': return 'Mozambik';
			case 'countries.MM': return 'Mjanma';
			case 'countries.NA': return 'Namibia';
			case 'countries.NR': return 'Nauru';
			case 'countries.NP': return 'Nepal';
			case 'countries.NL': return 'Holandia (Królestwo Niderlandów)';
			case 'countries.AN': return 'Antyle Holenderskie';
			case 'countries.NC': return 'Nowa Kaledonia';
			case 'countries.NZ': return 'Nowa Zelandia';
			case 'countries.NI': return 'Nikaragua';
			case 'countries.NE': return 'Niger';
			case 'countries.NG': return 'Nigeria';
			case 'countries.NU': return 'Niue';
			case 'countries.NF': return 'Wyspa Norfolk';
			case 'countries.GB-NIR': return 'Irlandia Północna';
			case 'countries.MP': return 'Mariany Północne';
			case 'countries.NO': return 'Norwegia';
			case 'countries.OM': return 'Oman';
			case 'countries.PK': return 'Pakistan';
			case 'countries.PW': return 'Palau';
			case 'countries.PS': return 'Palestyna';
			case 'countries.PA': return 'Panama';
			case 'countries.PG': return 'Papua-Nowa Gwinea';
			case 'countries.PY': return 'Paragwaj';
			case 'countries.PE': return 'Peru';
			case 'countries.PH': return 'Filipiny';
			case 'countries.PN': return 'Pitcairn';
			case 'countries.PL': return 'Polska';
			case 'countries.PT': return 'Portugalia';
			case 'countries.PR': return 'Portoryko';
			case 'countries.QA': return 'Katar';
			case 'countries.RE': return 'Reunion';
			case 'countries.RO': return 'Rumunia';
			case 'countries.RU': return 'Federacja Rosyjska';
			case 'countries.RW': return 'Rwanda';
			case 'countries.BL': return 'Saint-Barthélemy';
			case 'countries.SH': return 'Wyspa Świętej Heleny';
			case 'countries.KN': return 'Saint Kitts i Nevis';
			case 'countries.LC': return 'Saint Lucia';
			case 'countries.MF': return 'Saint Martin';
			case 'countries.PM': return 'Saint-Pierre i Miquelon';
			case 'countries.VC': return 'Saint Vincent i Grenadyny';
			case 'countries.WS': return 'Samoa';
			case 'countries.SM': return 'San Marino';
			case 'countries.ST': return 'Wyspy Świętego Tomasza i Książęca';
			case 'countries.SA': return 'Arabia Saudyjska';
			case 'countries.GB-SCT': return 'Szkocja';
			case 'countries.SN': return 'Senegal';
			case 'countries.RS': return 'Serbia';
			case 'countries.SC': return 'Seszele';
			case 'countries.SL': return 'Sierra Leone';
			case 'countries.SG': return 'Singapur';
			case 'countries.SX': return 'Sint Maarten (część duńska)';
			case 'countries.SK': return 'Słowacja';
			case 'countries.SI': return 'Słowenia';
			case 'countries.SB': return 'Wyspy Salomona';
			case 'countries.SO': return 'Somalia';
			case 'countries.ZA': return 'Afryka Południowa';
			case 'countries.GS': return 'Georgia Południowa i Sandwich Południowy';
			case 'countries.SS': return 'Sudan Południowy';
			case 'countries.ES': return 'Hiszpania';
			case 'countries.LK': return 'Sri Lanka';
			case 'countries.SD': return 'Sudan';
			case 'countries.SR': return 'Surinam';
			case 'countries.SJ': return 'Wyspy Svalbard i Jan Mayen';
			case 'countries.SZ': return 'Suazi';
			case 'countries.SE': return 'Szwecja';
			case 'countries.CH': return 'Szwajcaria';
			case 'countries.SY': return 'Syryjska Republika Arabska';
			case 'countries.TW': return 'Tajwan';
			case 'countries.TJ': return 'Tadżykistan';
			case 'countries.TZ': return 'Zjednoczona Republika Tanzanii';
			case 'countries.TH': return 'Tajlandia';
			case 'countries.TL': return 'Timor Wschodni';
			case 'countries.TG': return 'Togo';
			case 'countries.TK': return 'Tokelau';
			case 'countries.TO': return 'Tonga';
			case 'countries.TT': return 'Trynidad i Tobago';
			case 'countries.TN': return 'Tunezja';
			case 'countries.TR': return 'Turcja';
			case 'countries.TM': return 'Turkmenistan';
			case 'countries.TC': return 'Wyspy Turks i Caicos';
			case 'countries.TV': return 'Tuvalu';
			case 'countries.UG': return 'Uganda';
			case 'countries.UA': return 'Ukraina';
			case 'countries.AE': return 'Zjednoczone Emiraty Arabskie';
			case 'countries.GB': return 'Wielka Brytania';
			case 'countries.US': return 'Stany Zjednoczone';
			case 'countries.UY': return 'Urugwaj';
			case 'countries.UM': return 'Małe Wyspy Północne USA';
			case 'countries.UZ': return 'Uzbekistan';
			case 'countries.VU': return 'Vanuatu';
			case 'countries.VE': return 'Boliwariańska Republika Wenezueli';
			case 'countries.VN': return 'Wietnam';
			case 'countries.VG': return 'Brytyjskie Wyspy Dziewicze';
			case 'countries.VI': return 'Wyspy Dziewicze Stanów Zjednoczonych';
			case 'countries.GB-WLS': return 'Walia';
			case 'countries.WF': return 'Wallis i Futuna';
			case 'countries.EH': return 'Sahara Zachodnia';
			case 'countries.YE': return 'Jemen';
			case 'countries.ZM': return 'Zambia';
			case 'countries.ZW': return 'Zimbabwe';
			case 'countries.XX': return 'Nieznane';
			case 'countries.XM': return 'Księżyc';
			default: return null;
		}
	}
}

