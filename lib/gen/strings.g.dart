/// Generated file. Do not edit.
///
/// Locales: 2
/// Strings: 154 (77 per locale)
///
/// Built on 2023-07-10 at 17:08 UTC

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
enum AppLocale with BaseAppLocale<AppLocale, _StringsEn> {
	en(languageCode: 'en', build: _StringsEn.build),
	ru(languageCode: 'ru', build: _StringsRu.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, _StringsEn> build;

	/// Gets current instance managed by [LocaleSettings].
	_StringsEn get translations => LocaleSettings.instance.translationMap[this]!;
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
_StringsEn get t => LocaleSettings.instance.currentTranslations;

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
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context).translations;
}

/// The provider for method B
class TranslationProvider extends BaseTranslationProvider<AppLocale, _StringsEn> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, _StringsEn> of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	_StringsEn get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, _StringsEn> {
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
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, _StringsEn> {
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
class _StringsEn implements BaseTranslations<AppLocale, _StringsEn> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
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
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	Map<String, String> get locales => {
		'en': 'English',
		'ru': 'Russian (Русский)',
	};
	String get tetraLeague => 'Tetra League';
	String get tlRecords => 'TL Records';
	String get history => 'History';
	String get sprint => '40 Lines';
	String get blitz => 'Blitz';
	String get other => 'Other';
	String get zen => 'Zen';
	String get bio => 'Bio';
	String get refresh => 'Refresh';
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
	String get noRecord => 'No record';
	String get notEnoughData => 'Not enough data';
	String get noHistorySaved => 'No history saved';
	String obtainDate({required Object date}) => 'Obtained ${date}';
	String fetchDate({required Object date}) => 'Fetched ${date}';
	String get exactGametime => 'Exact gametime';
	String get bigRedBanned => 'BANNED';
	String get bigRedBadStanding => 'BAD STANDING';
	String get copiedToClipboard => 'Copied to clipboard!';
	String get playerRoleAccount => ' account ';
	String get wasFromBeginning => 'that was from very beginning';
	String get created => 'created';
	String get botCreatedBy => 'by';
	String get notSupporter => 'Not a supporter';
	String get assignedManualy => 'That badge was assigned manualy by TETR.IO admins';
	String supporter({required Object tier}) => 'Supporter tier ${tier}';
	String comparingWith({required Object date}) => 'Comparing with data from ${date}';
	String get top => 'Top';
	String get topRank => 'Top Rank';
	String get decaying => 'Decaying';
	String gamesUntilRanked({required Object left}) => '${left} games until being ranked';
	String get nerdStats => 'Nerd Stats';
	late final _StringsStatCellNumEn statCellNum = _StringsStatCellNumEn._(_root);
	Map<String, String> get playerRole => {
		'user': 'User',
		'banned': 'Banned',
		'bot': 'Bot',
		'sysop': 'System operator',
		'admin': 'Admin',
		'mod': 'Moderator',
		'halfmod': 'Community moderator',
	};
	late final _StringsNumOfGameActionsEn numOfGameActions = _StringsNumOfGameActionsEn._(_root);
	late final _StringsPopupActionsEn popupActions = _StringsPopupActionsEn._(_root);
}

// Path: statCellNum
class _StringsStatCellNumEn {
	_StringsStatCellNumEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get xpLevel => 'XP Level';
	String get hoursPlayed => 'Hours\nPlayed';
	String get onlineGames => 'Online\nGames';
	String get gamesWon => 'Games\nWon';
	String get friends => 'Friends';
	String get apm => 'Attack\nPer Minute';
	String get vs => 'Versus\nScore';
	String get lbp => 'Leaderboard\nplacement';
	String get lbpc => 'Country LB\nplacement';
	String get gamesPlayed => 'Games\nplayed';
	String get gamesWonTL => 'Games\nWon';
	String get winrate => 'Winrate\nprecentage';
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
}

// Path: numOfGameActions
class _StringsNumOfGameActionsEn {
	_StringsNumOfGameActionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get pc => 'All Clears';
	String get hold => 'Holds';
	String get tspinsTotal => 'T-spins total';
	String get lineClears => 'Line clears';
}

// Path: popupActions
class _StringsPopupActionsEn {
	_StringsPopupActionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get ok => 'OK';
}

// Path: <root>
class _StringsRu implements _StringsEn {

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
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsRu _root = this; // ignore: unused_field

	// Translations
	@override Map<String, String> get locales => {
		'en': 'Английский (English)',
		'ru': 'Русский',
	};
	@override String get tetraLeague => 'Тетра Лига';
	@override String get tlRecords => 'Матчи ТЛ';
	@override String get history => 'История';
	@override String get sprint => '40 линий';
	@override String get blitz => 'Блиц';
	@override String get other => 'Другое';
	@override String get zen => 'Дзен';
	@override String get bio => 'Биография';
	@override String get refresh => 'Обновить';
	@override String get showStoredData => 'Показать сохранённые данные';
	@override String get statsCalc => 'Калькулятор статистики';
	@override String get settings => 'Настройки';
	@override String get track => 'Отслеживать';
	@override String get stopTracking => 'Перестать\nотслеживать';
	@override String get becameTracked => 'Добавлен в список отслеживания!';
	@override String get stoppedBeingTracked => 'Удалён из списка отслеживания!';
	@override String get compare => 'Сравнить';
	@override String get tlLeaderboard => 'Таблица лидеров Тетра Лиги';
	@override String get noRecords => 'Нет записей';
	@override String get noRecord => 'Нет рекорда';
	@override String get notEnoughData => 'Недостаточно данных';
	@override String get noHistorySaved => 'Нет сохранённой истории';
	@override String obtainDate({required Object date}) => 'Получено ${date}';
	@override String fetchDate({required Object date}) => 'На момент ${date}';
	@override String get exactGametime => 'Время, проведённое в игре';
	@override String get bigRedBanned => 'ЗАБАНЕН';
	@override String get bigRedBadStanding => 'ПЛОХАЯ РЕПУТАЦИЯ';
	@override String get copiedToClipboard => 'Скопировано в буфер обмена!';
	@override String get playerRoleAccount => ', аккаунт которого ';
	@override String get wasFromBeginning => 'существовал с самого начала';
	@override String get created => 'создан';
	@override String get botCreatedBy => 'игроком';
	@override String get notSupporter => 'Нет саппортерки';
	@override String supporter({required Object tier}) => 'Саппортерка ${tier} уровня';
	@override String get assignedManualy => 'Этот значок был присвоен вручную администрацией TETR.IO';
	@override String comparingWith({required Object date}) => 'Сравнивая с данными от ${date}';
	@override String get top => 'Топ';
	@override String get topRank => 'Топ Ранг';
	@override String get decaying => 'Загнивает';
	@override String gamesUntilRanked({required Object left}) => '${left} матчей до получения рейтинга';
	@override String get nerdStats => 'Для задротов';
	@override late final _StringsStatCellNumRu statCellNum = _StringsStatCellNumRu._(_root);
	@override Map<String, String> get playerRole => {
		'user': 'Пользователь',
		'banned': 'Заблокированный пользователь',
		'bot': 'Бот',
		'sysop': 'Системный оператор',
		'admin': 'Администратор',
		'mod': 'Модератор',
		'halfmod': 'Модератор сообщества',
	};
	@override late final _StringsNumOfGameActionsRu numOfGameActions = _StringsNumOfGameActionsRu._(_root);
	@override late final _StringsPopupActionsRu popupActions = _StringsPopupActionsRu._(_root);
}

// Path: statCellNum
class _StringsStatCellNumRu implements _StringsStatCellNumEn {
	_StringsStatCellNumRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get xpLevel => 'Уровень\nопыта';
	@override String get hoursPlayed => 'Часов\nСыграно';
	@override String get onlineGames => 'Онлайн\nИгр';
	@override String get gamesWon => 'Онлайн\nПобед';
	@override String get friends => 'Друзей';
	@override String get apm => 'Атака в\nМинуту';
	@override String get vs => 'Показатель\nVersus';
	@override String get lbp => 'Положение\nв рейтинге';
	@override String get lbpc => 'Положение\nв рейтинге страны';
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
}

// Path: numOfGameActions
class _StringsNumOfGameActionsRu implements _StringsNumOfGameActionsEn {
	_StringsNumOfGameActionsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get pc => 'Все чисто';
	@override String get hold => 'В запас';
	@override String get tspinsTotal => 'T-spins всего';
	@override String get lineClears => 'Линий очищено';
}

// Path: popupActions
class _StringsPopupActionsRu implements _StringsPopupActionsEn {
	_StringsPopupActionsRu._(this._root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get ok => 'OK';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'English';
			case 'locales.ru': return 'Russian (Русский)';
			case 'tetraLeague': return 'Tetra League';
			case 'tlRecords': return 'TL Records';
			case 'history': return 'History';
			case 'sprint': return '40 Lines';
			case 'blitz': return 'Blitz';
			case 'other': return 'Other';
			case 'zen': return 'Zen';
			case 'bio': return 'Bio';
			case 'refresh': return 'Refresh';
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
			case 'noRecord': return 'No record';
			case 'notEnoughData': return 'Not enough data';
			case 'noHistorySaved': return 'No history saved';
			case 'obtainDate': return ({required Object date}) => 'Obtained ${date}';
			case 'fetchDate': return ({required Object date}) => 'Fetched ${date}';
			case 'exactGametime': return 'Exact gametime';
			case 'bigRedBanned': return 'BANNED';
			case 'bigRedBadStanding': return 'BAD STANDING';
			case 'copiedToClipboard': return 'Copied to clipboard!';
			case 'playerRoleAccount': return ' account ';
			case 'wasFromBeginning': return 'that was from very beginning';
			case 'created': return 'created';
			case 'botCreatedBy': return 'by';
			case 'notSupporter': return 'Not a supporter';
			case 'assignedManualy': return 'That badge was assigned manualy by TETR.IO admins';
			case 'supporter': return ({required Object tier}) => 'Supporter tier ${tier}';
			case 'comparingWith': return ({required Object date}) => 'Comparing with data from ${date}';
			case 'top': return 'Top';
			case 'topRank': return 'Top Rank';
			case 'decaying': return 'Decaying';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} games until being ranked';
			case 'nerdStats': return 'Nerd Stats';
			case 'statCellNum.xpLevel': return 'XP Level';
			case 'statCellNum.hoursPlayed': return 'Hours\nPlayed';
			case 'statCellNum.onlineGames': return 'Online\nGames';
			case 'statCellNum.gamesWon': return 'Games\nWon';
			case 'statCellNum.friends': return 'Friends';
			case 'statCellNum.apm': return 'Attack\nPer Minute';
			case 'statCellNum.vs': return 'Versus\nScore';
			case 'statCellNum.lbp': return 'Leaderboard\nplacement';
			case 'statCellNum.lbpc': return 'Country LB\nplacement';
			case 'statCellNum.gamesPlayed': return 'Games\nplayed';
			case 'statCellNum.gamesWonTL': return 'Games\nWon';
			case 'statCellNum.winrate': return 'Winrate\nprecentage';
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
			case 'playerRole.user': return 'User';
			case 'playerRole.banned': return 'Banned';
			case 'playerRole.bot': return 'Bot';
			case 'playerRole.sysop': return 'System operator';
			case 'playerRole.admin': return 'Admin';
			case 'playerRole.mod': return 'Moderator';
			case 'playerRole.halfmod': return 'Community moderator';
			case 'numOfGameActions.pc': return 'All Clears';
			case 'numOfGameActions.hold': return 'Holds';
			case 'numOfGameActions.tspinsTotal': return 'T-spins total';
			case 'numOfGameActions.lineClears': return 'Line clears';
			case 'popupActions.ok': return 'OK';
			default: return null;
		}
	}
}

extension on _StringsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'Английский (English)';
			case 'locales.ru': return 'Русский';
			case 'tetraLeague': return 'Тетра Лига';
			case 'tlRecords': return 'Матчи ТЛ';
			case 'history': return 'История';
			case 'sprint': return '40 линий';
			case 'blitz': return 'Блиц';
			case 'other': return 'Другое';
			case 'zen': return 'Дзен';
			case 'bio': return 'Биография';
			case 'refresh': return 'Обновить';
			case 'showStoredData': return 'Показать сохранённые данные';
			case 'statsCalc': return 'Калькулятор статистики';
			case 'settings': return 'Настройки';
			case 'track': return 'Отслеживать';
			case 'stopTracking': return 'Перестать\nотслеживать';
			case 'becameTracked': return 'Добавлен в список отслеживания!';
			case 'stoppedBeingTracked': return 'Удалён из списка отслеживания!';
			case 'compare': return 'Сравнить';
			case 'tlLeaderboard': return 'Таблица лидеров Тетра Лиги';
			case 'noRecords': return 'Нет записей';
			case 'noRecord': return 'Нет рекорда';
			case 'notEnoughData': return 'Недостаточно данных';
			case 'noHistorySaved': return 'Нет сохранённой истории';
			case 'obtainDate': return ({required Object date}) => 'Получено ${date}';
			case 'fetchDate': return ({required Object date}) => 'На момент ${date}';
			case 'exactGametime': return 'Время, проведённое в игре';
			case 'bigRedBanned': return 'ЗАБАНЕН';
			case 'bigRedBadStanding': return 'ПЛОХАЯ РЕПУТАЦИЯ';
			case 'copiedToClipboard': return 'Скопировано в буфер обмена!';
			case 'playerRoleAccount': return ', аккаунт которого ';
			case 'wasFromBeginning': return 'существовал с самого начала';
			case 'created': return 'создан';
			case 'botCreatedBy': return 'игроком';
			case 'notSupporter': return 'Нет саппортерки';
			case 'supporter': return ({required Object tier}) => 'Саппортерка ${tier} уровня';
			case 'assignedManualy': return 'Этот значок был присвоен вручную администрацией TETR.IO';
			case 'comparingWith': return ({required Object date}) => 'Сравнивая с данными от ${date}';
			case 'top': return 'Топ';
			case 'topRank': return 'Топ Ранг';
			case 'decaying': return 'Загнивает';
			case 'gamesUntilRanked': return ({required Object left}) => '${left} матчей до получения рейтинга';
			case 'nerdStats': return 'Для задротов';
			case 'statCellNum.xpLevel': return 'Уровень\nопыта';
			case 'statCellNum.hoursPlayed': return 'Часов\nСыграно';
			case 'statCellNum.onlineGames': return 'Онлайн\nИгр';
			case 'statCellNum.gamesWon': return 'Онлайн\nПобед';
			case 'statCellNum.friends': return 'Друзей';
			case 'statCellNum.apm': return 'Атака в\nМинуту';
			case 'statCellNum.vs': return 'Показатель\nVersus';
			case 'statCellNum.lbp': return 'Положение\nв рейтинге';
			case 'statCellNum.lbpc': return 'Положение\nв рейтинге страны';
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
			case 'playerRole.user': return 'Пользователь';
			case 'playerRole.banned': return 'Заблокированный пользователь';
			case 'playerRole.bot': return 'Бот';
			case 'playerRole.sysop': return 'Системный оператор';
			case 'playerRole.admin': return 'Администратор';
			case 'playerRole.mod': return 'Модератор';
			case 'playerRole.halfmod': return 'Модератор сообщества';
			case 'numOfGameActions.pc': return 'Все чисто';
			case 'numOfGameActions.hold': return 'В запас';
			case 'numOfGameActions.tspinsTotal': return 'T-spins всего';
			case 'numOfGameActions.lineClears': return 'Линий очищено';
			case 'popupActions.ok': return 'OK';
			default: return null;
		}
	}
}
