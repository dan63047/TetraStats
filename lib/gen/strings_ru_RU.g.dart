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
class TranslationsRuRu implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRuRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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

	late final TranslationsRuRu _root = this; // ignore: unused_field

	@override 
	TranslationsRuRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRuRu(meta: meta ?? this.$meta);

	// Translations
	@override Map<String, String> get locales => {
		'en': 'Английский (English)',
		'ru-RU': 'Русский',
		'ko-KR': 'Корейский (한국인)',
		'zh-CN': 'Упрощенный Китайский (简体中文)',
		'de-DE': 'Немецкий (Deutsch)',
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
	@override late final _TranslationsDestinationsRuRu destinations = _TranslationsDestinationsRuRu._(_root);
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
	@override late final _TranslationsXpRuRu xp = _TranslationsXpRuRu._(_root);
	@override late final _TranslationsGametimeRuRu gametime = _TranslationsGametimeRuRu._(_root);
	@override String get whichOne => 'Какой из?';
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
	@override late final _TranslationsMatchResultRuRu matchResult = _TranslationsMatchResultRuRu._(_root);
	@override late final _TranslationsDistinguishmentsRuRu distinguishments = _TranslationsDistinguishmentsRuRu._(_root);
	@override late final _TranslationsNewsEntriesRuRu newsEntries = _TranslationsNewsEntriesRuRu._(_root);
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
	@override String get checkingCache => 'Проверяем кеш...';
	@override String get fetchingRecords => 'Получаем список матчей...';
	@override String get munching => 'Анализируем...';
	@override String get outOf => 'из';
	@override String get replaysDone => 'повторов обработано';
	@override String get analysis => 'Анализ';
	@override String get minomuncherMention => 'с помощью MinoMuncher от Freyhoe';
	@override String get recent => 'Недавние';
	@override String get top => 'Топ';
	@override String get noRecord => 'Нет записи';
	@override String sprintAndBlitsRelevance({required Object date}) => 'Актуальность: ${date}';
	@override late final _TranslationsSnackBarMessagesRuRu snackBarMessages = _TranslationsSnackBarMessagesRuRu._(_root);
	@override late final _TranslationsErrorsRuRu errors = _TranslationsErrorsRuRu._(_root);
	@override late final _TranslationsActionsRuRu actions = _TranslationsActionsRuRu._(_root);
	@override late final _TranslationsGraphsDestinationRuRu graphsDestination = _TranslationsGraphsDestinationRuRu._(_root);
	@override late final _TranslationsFilterModaleRuRu filterModale = _TranslationsFilterModaleRuRu._(_root);
	@override late final _TranslationsCutoffsDestinationRuRu cutoffsDestination = _TranslationsCutoffsDestinationRuRu._(_root);
	@override late final _TranslationsRankViewRuRu rankView = _TranslationsRankViewRuRu._(_root);
	@override late final _TranslationsStateViewRuRu stateView = _TranslationsStateViewRuRu._(_root);
	@override late final _TranslationsTlMatchViewRuRu tlMatchView = _TranslationsTlMatchViewRuRu._(_root);
	@override late final _TranslationsCalcDestinationRuRu calcDestination = _TranslationsCalcDestinationRuRu._(_root);
	@override late final _TranslationsInfoDestinationRuRu infoDestination = _TranslationsInfoDestinationRuRu._(_root);
	@override late final _TranslationsLeaderboardsDestinationRuRu leaderboardsDestination = _TranslationsLeaderboardsDestinationRuRu._(_root);
	@override late final _TranslationsSavedDataDestinationRuRu savedDataDestination = _TranslationsSavedDataDestinationRuRu._(_root);
	@override late final _TranslationsSettingsDestinationRuRu settingsDestination = _TranslationsSettingsDestinationRuRu._(_root);
	@override late final _TranslationsHomeNavigationRuRu homeNavigation = _TranslationsHomeNavigationRuRu._(_root);
	@override late final _TranslationsGraphsNavigationRuRu graphsNavigation = _TranslationsGraphsNavigationRuRu._(_root);
	@override late final _TranslationsCalcNavigationRuRu calcNavigation = _TranslationsCalcNavigationRuRu._(_root);
	@override late final _TranslationsFirstTimeViewRuRu firstTimeView = _TranslationsFirstTimeViewRuRu._(_root);
	@override late final _TranslationsAboutViewRuRu aboutView = _TranslationsAboutViewRuRu._(_root);
	@override late final _TranslationsStatsRuRu stats = _TranslationsStatsRuRu._(_root);
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
class _TranslationsDestinationsRuRu implements TranslationsDestinationsEn {
	_TranslationsDestinationsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsXpRuRu implements TranslationsXpEn {
	_TranslationsXpRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уровень Опыта';
	@override String progressToNextLevel({required Object percentage}) => 'Прогресс до следующего уровня: ${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => 'Прогресс с 0 XP до уровня ${goal}: ${percentage} (${left} XP осталось)';
}

// Path: gametime
class _TranslationsGametimeRuRu implements TranslationsGametimeEn {
	_TranslationsGametimeRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Времени проведено в игре';
	@override String gametimeAday({required Object gametime}) => '${gametime} в день в среднем';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => 'Это ${years} лет,\nили ${months} месяцев,\nили ${days} дней,\nили ${minutes} минут\nили ${seconds} секунд';
}

// Path: matchResult
class _TranslationsMatchResultRuRu implements TranslationsMatchResultEn {
	_TranslationsMatchResultRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsDistinguishmentsRuRu implements TranslationsDistinguishmentsEn {
	_TranslationsDistinguishmentsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get noHeader => 'Заголовок отсутствует';
	@override String get noFooter => 'Подзаголовок отсуствует';
	@override String get twc => 'Чемпион мира TETR.IO';
	@override String twcYear({required Object year}) => 'Чемпионат мира по TETR.IO ${year} года';
}

// Path: newsEntries
class _TranslationsNewsEntriesRuRu implements TranslationsNewsEntriesEn {
	_TranslationsNewsEntriesRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsSnackBarMessagesRuRu implements TranslationsSnackBarMessagesEn {
	_TranslationsSnackBarMessagesRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => 'Состояние от ${date} удалено из базы данных!';
	@override String matchRemoved({required Object date}) => 'Матч от ${date} удален из базы данных!';
	@override String get notForWeb => 'Функция недоступна для веб-версии';
	@override String get importSuccess => 'Импорт выполнен успешно';
	@override String get importCancelled => 'Импорт был отменен';
}

// Path: errors
class _TranslationsErrorsRuRu implements TranslationsErrorsEn {
	_TranslationsErrorsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get noRecords => 'Нет записей';
	@override String get notEnoughData => 'Недостаточно данных';
	@override String get noHistorySaved => 'Нет сохраненной истории';
	@override String connection({required Object code, required Object message}) => 'Проблема с подключением: ${code} ${message}';
	@override String get noSuchUser => 'Нет такого пользователя';
	@override String get noSuchUserSub => 'Либо вы опечатались, либо аккаунт больше не существует';
	@override String get discordNotAssigned => 'Нет связей с данным аккаунтом';
	@override String get discordNotAssignedSub => 'Убедитесь, что ваш запрос соответствует формату, описанному в [документации API](https://tetr.io/about/api/#userssearchquery)';
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
class _TranslationsActionsRuRu implements TranslationsActionsEn {
	_TranslationsActionsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отменить';
	@override String get submit => 'Подтвердить';
	@override String get ok => 'ОК';
	@override String get apply => 'Применить';
	@override String get refresh => 'Обновить';
}

// Path: graphsDestination
class _TranslationsGraphsDestinationRuRu implements TranslationsGraphsDestinationEn {
	_TranslationsGraphsDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get fetchAndsaveTLHistory => 'Получить историю';
	@override String get fetchAndSaveOldTLmatches => 'Получить историю матчей Тетра Лиги';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '${number} состояний было найдено';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} матчей было найдено';
	@override String gamesPlayed({required Object games}) => '${games} сыграно';
	@override String get dateAndTime => 'Дата и время';
	@override String get filterModaleTitle => 'Фильтровать график по рангам';
}

// Path: filterModale
class _TranslationsFilterModaleRuRu implements TranslationsFilterModaleEn {
	_TranslationsFilterModaleRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get all => 'Все';
}

// Path: cutoffsDestination
class _TranslationsCutoffsDestinationRuRu implements TranslationsCutoffsDestinationEn {
	_TranslationsCutoffsDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsRankViewRuRu implements TranslationsRankViewEn {
	_TranslationsRankViewRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsStateViewRuRu implements TranslationsStateViewEn {
	_TranslationsStateViewRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => 'Состояние от ${date}';
}

// Path: tlMatchView
class _TranslationsTlMatchViewRuRu implements TranslationsTlMatchViewEn {
	_TranslationsTlMatchViewRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsCalcDestinationRuRu implements TranslationsCalcDestinationEn {
	_TranslationsCalcDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => 'Введите ваш ${stat}';
	@override String get tip => 'Введите значения и нажмите "Считать", чтобы увидеть статистику для задротов';
	@override String get invalidValues => 'Пожалуйста, введите корректные значения';
	@override String get statsCalcButton => 'Считать';
	@override String get damageCalcTip => 'Нажмите на действия слева, чтобы добавить их сюда';
	@override String get clearAll => 'Очистить';
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
class _TranslationsInfoDestinationRuRu implements TranslationsInfoDestinationEn {
	_TranslationsInfoDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsLeaderboardsDestinationRuRu implements TranslationsLeaderboardsDestinationEn {
	_TranslationsLeaderboardsDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Таблицы лидеров';
	@override String get tl => 'Тетра Лига (Текущий сезон)';
	@override String get fullTL => 'Тетра Лига (Текущий сезон, вся за раз)';
	@override String get ar => 'Очки достижений';
}

// Path: savedDataDestination
class _TranslationsSavedDataDestinationRuRu implements TranslationsSavedDataDestinationEn {
	_TranslationsSavedDataDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Сохранённые данные';
	@override String get tip => 'Выберите никнейм слева, чтобы увидеть данные ассоциированные с ним';
	@override String seasonTLstates({required Object s}) => 'TL ${s} сезона';
	@override String get TLrecords => 'Записи TL';
}

// Path: settingsDestination
class _TranslationsSettingsDestinationRuRu implements TranslationsSettingsDestinationEn {
	_TranslationsSettingsDestinationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
	@override String get compareStatsDescription => 'Если включено, Tetra Stats загрузит средние значения и будет сравнивать вас со средними значениями вашего ранга. В результате этого почти каждый пункт статистики обретёт цвет, наводите курсор, чтобы узнать больше.';
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
class _TranslationsHomeNavigationRuRu implements TranslationsHomeNavigationEn {
	_TranslationsHomeNavigationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsGraphsNavigationRuRu implements TranslationsGraphsNavigationEn {
	_TranslationsGraphsNavigationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get history => 'История игрока';
	@override String get league => 'Состояние Лиги';
	@override String get cutoffs => 'История рангов';
}

// Path: calcNavigation
class _TranslationsCalcNavigationRuRu implements TranslationsCalcNavigationEn {
	_TranslationsCalcNavigationRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get stats => 'Калькулятор статистики';
	@override String get damage => 'Калькулятор урона';
}

// Path: firstTimeView
class _TranslationsFirstTimeViewRuRu implements TranslationsFirstTimeViewEn {
	_TranslationsFirstTimeViewRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsAboutViewRuRu implements TranslationsAboutViewEn {
	_TranslationsAboutViewRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
	@override String get deDElocale => 'Перевёл на немецкий';
	@override String get koKRlocale => 'Перевели на корейский';
	@override String get supportHim => 'Поддержите его!';
}

// Path: stats
class _TranslationsStatsRuRu implements TranslationsStatsEn {
	_TranslationsStatsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => 'Дата регистрации';
	@override String get gametime => 'Время в игре';
	@override String get ogp => 'Онлайн игр';
	@override String get ogw => 'Онлайн побед';
	@override String get followers => 'Подписчиков';
	@override late final _TranslationsStatsXpRuRu xp = _TranslationsStatsXpRuRu._(_root);
	@override late final _TranslationsStatsTrRuRu tr = _TranslationsStatsTrRuRu._(_root);
	@override late final _TranslationsStatsGlickoRuRu glicko = _TranslationsStatsGlickoRuRu._(_root);
	@override late final _TranslationsStatsRdRuRu rd = _TranslationsStatsRdRuRu._(_root);
	@override late final _TranslationsStatsGlixareRuRu glixare = _TranslationsStatsGlixareRuRu._(_root);
	@override late final _TranslationsStatsS1trRuRu s1tr = _TranslationsStatsS1trRuRu._(_root);
	@override late final _TranslationsStatsGpRuRu gp = _TranslationsStatsGpRuRu._(_root);
	@override late final _TranslationsStatsGwRuRu gw = _TranslationsStatsGwRuRu._(_root);
	@override late final _TranslationsStatsWinrateRuRu winrate = _TranslationsStatsWinrateRuRu._(_root);
	@override late final _TranslationsStatsApmRuRu apm = _TranslationsStatsApmRuRu._(_root);
	@override late final _TranslationsStatsPpsRuRu pps = _TranslationsStatsPpsRuRu._(_root);
	@override late final _TranslationsStatsVsRuRu vs = _TranslationsStatsVsRuRu._(_root);
	@override late final _TranslationsStatsAppRuRu app = _TranslationsStatsAppRuRu._(_root);
	@override late final _TranslationsStatsVsapmRuRu vsapm = _TranslationsStatsVsapmRuRu._(_root);
	@override late final _TranslationsStatsDssRuRu dss = _TranslationsStatsDssRuRu._(_root);
	@override late final _TranslationsStatsDspRuRu dsp = _TranslationsStatsDspRuRu._(_root);
	@override late final _TranslationsStatsAppdspRuRu appdsp = _TranslationsStatsAppdspRuRu._(_root);
	@override late final _TranslationsStatsCheeseRuRu cheese = _TranslationsStatsCheeseRuRu._(_root);
	@override late final _TranslationsStatsGbeRuRu gbe = _TranslationsStatsGbeRuRu._(_root);
	@override late final _TranslationsStatsNyaappRuRu nyaapp = _TranslationsStatsNyaappRuRu._(_root);
	@override late final _TranslationsStatsAreaRuRu area = _TranslationsStatsAreaRuRu._(_root);
	@override late final _TranslationsStatsEtrRuRu etr = _TranslationsStatsEtrRuRu._(_root);
	@override late final _TranslationsStatsEtraccRuRu etracc = _TranslationsStatsEtraccRuRu._(_root);
	@override late final _TranslationsStatsOpenerRuRu opener = _TranslationsStatsOpenerRuRu._(_root);
	@override late final _TranslationsStatsPlonkRuRu plonk = _TranslationsStatsPlonkRuRu._(_root);
	@override late final _TranslationsStatsStrideRuRu stride = _TranslationsStatsStrideRuRu._(_root);
	@override late final _TranslationsStatsInfdsRuRu infds = _TranslationsStatsInfdsRuRu._(_root);
	@override late final _TranslationsStatsAltitudeRuRu altitude = _TranslationsStatsAltitudeRuRu._(_root);
	@override late final _TranslationsStatsClimbSpeedRuRu climbSpeed = _TranslationsStatsClimbSpeedRuRu._(_root);
	@override late final _TranslationsStatsPeakClimbSpeedRuRu peakClimbSpeed = _TranslationsStatsPeakClimbSpeedRuRu._(_root);
	@override late final _TranslationsStatsKosRuRu kos = _TranslationsStatsKosRuRu._(_root);
	@override late final _TranslationsStatsB2bRuRu b2b = _TranslationsStatsB2bRuRu._(_root);
	@override late final _TranslationsStatsFinesseRuRu finesse = _TranslationsStatsFinesseRuRu._(_root);
	@override late final _TranslationsStatsFinesseFaultsRuRu finesseFaults = _TranslationsStatsFinesseFaultsRuRu._(_root);
	@override late final _TranslationsStatsTotalTimeRuRu totalTime = _TranslationsStatsTotalTimeRuRu._(_root);
	@override late final _TranslationsStatsLevelRuRu level = _TranslationsStatsLevelRuRu._(_root);
	@override late final _TranslationsStatsPiecesRuRu pieces = _TranslationsStatsPiecesRuRu._(_root);
	@override late final _TranslationsStatsSppRuRu spp = _TranslationsStatsSppRuRu._(_root);
	@override late final _TranslationsStatsKpRuRu kp = _TranslationsStatsKpRuRu._(_root);
	@override late final _TranslationsStatsKppRuRu kpp = _TranslationsStatsKppRuRu._(_root);
	@override late final _TranslationsStatsKpsRuRu kps = _TranslationsStatsKpsRuRu._(_root);
	@override late final _TranslationsStatsAplRuRu apl = _TranslationsStatsAplRuRu._(_root);
	@override late final _TranslationsStatsQuadEfficiencyRuRu quadEfficiency = _TranslationsStatsQuadEfficiencyRuRu._(_root);
	@override late final _TranslationsStatsTspinEfficiencyRuRu tspinEfficiency = _TranslationsStatsTspinEfficiencyRuRu._(_root);
	@override late final _TranslationsStatsAllspinEfficiencyRuRu allspinEfficiency = _TranslationsStatsAllspinEfficiencyRuRu._(_root);
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
	@override String get overall => 'В среднем';
	@override String get midgame => 'Midgame';
	@override String get efficiency => 'Эффективность';
	@override String get upstack => 'Upstack';
	@override String get downstack => 'Downstack';
	@override String get variance => 'Дисперсия';
	@override String get burst => 'Burst';
	@override String get length => 'Длина';
	@override String get rate => 'Rate';
	@override String get secsDS => 'Secs/DS';
	@override String get secsCheese => 'Secs/Cheese';
	@override String get attackCheesiness => 'Сырность атаки';
	@override String get downstackingRatio => 'Downstacking Ratio';
	@override String get clearTypes => 'Clear Types';
	@override String get wellColumnDistribution => 'Распределение колодцев';
	@override String get allSpins => 'All Spins';
	@override String get sankeyTitle => 'График входящих атак';
	@override String get incomingAttack => 'Входящие атаки';
	@override String get clean => 'Clean';
	@override String get cancelled => 'Cancelled';
	@override String get cheeseTanked => 'Cheese Tanked';
	@override String get cleanTanked => 'Clean Tanked';
	@override String get kills => 'Убийств';
	@override String get deaths => 'Смертей';
	@override String get ppsDistribution => 'Распределение PPS';
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
	@override late final _TranslationsStatsGraphsRuRu graphs = _TranslationsStatsGraphsRuRu._(_root);
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
	@override late final _TranslationsStatsLineClearRuRu lineClear = _TranslationsStatsLineClearRuRu._(_root);
	@override late final _TranslationsStatsLineClearsRuRu lineClears = _TranslationsStatsLineClearsRuRu._(_root);
	@override String get mini => 'Mini';
	@override String get tSpin => 'T-spin';
	@override String get tSpins => 'T-spins';
	@override String get spin => 'Spin';
	@override String get spins => 'Spins';
}

// Path: stats.xp
class _TranslationsStatsXpRuRu implements TranslationsStatsXpEn {
	_TranslationsStatsXpRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Опыт';
	@override String get full => 'Очки опыта';
}

// Path: stats.tr
class _TranslationsStatsTrRuRu implements TranslationsStatsTrEn {
	_TranslationsStatsTrRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => 'Тетра Рейтинг';
}

// Path: stats.glicko
class _TranslationsStatsGlickoRuRu implements TranslationsStatsGlickoEn {
	_TranslationsStatsGlickoRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => 'Glicko';
}

// Path: stats.rd
class _TranslationsStatsRdRuRu implements TranslationsStatsRdEn {
	_TranslationsStatsRdRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'RD';
	@override String get full => 'Отклонение Рейтинга';
}

// Path: stats.glixare
class _TranslationsStatsGlixareRuRu implements TranslationsStatsGlixareEn {
	_TranslationsStatsGlixareRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _TranslationsStatsS1trRuRu implements TranslationsStatsS1trEn {
	_TranslationsStatsS1trRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'S1 TR';
	@override String get full => 'TR как в первом сезоне';
}

// Path: stats.gp
class _TranslationsStatsGpRuRu implements TranslationsStatsGpEn {
	_TranslationsStatsGpRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GP';
	@override String get full => 'Матчей';
}

// Path: stats.gw
class _TranslationsStatsGwRuRu implements TranslationsStatsGwEn {
	_TranslationsStatsGwRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GW';
	@override String get full => 'Побед';
}

// Path: stats.winrate
class _TranslationsStatsWinrateRuRu implements TranslationsStatsWinrateEn {
	_TranslationsStatsWinrateRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'WR%';
	@override String get full => 'Процент побед';
}

// Path: stats.apm
class _TranslationsStatsApmRuRu implements TranslationsStatsApmEn {
	_TranslationsStatsApmRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => 'Атаки в Минуту';
}

// Path: stats.pps
class _TranslationsStatsPpsRuRu implements TranslationsStatsPpsEn {
	_TranslationsStatsPpsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => 'Фигур в Секунду';
}

// Path: stats.vs
class _TranslationsStatsVsRuRu implements TranslationsStatsVsEn {
	_TranslationsStatsVsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => 'Показатель Versus';
}

// Path: stats.app
class _TranslationsStatsAppRuRu implements TranslationsStatsAppEn {
	_TranslationsStatsAppRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => 'Атаки на Фигуру';
}

// Path: stats.vsapm
class _TranslationsStatsVsapmRuRu implements TranslationsStatsVsapmEn {
	_TranslationsStatsVsapmRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _TranslationsStatsDssRuRu implements TranslationsStatsDssEn {
	_TranslationsStatsDssRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => 'Спуск в секунду';
}

// Path: stats.dsp
class _TranslationsStatsDspRuRu implements TranslationsStatsDspEn {
	_TranslationsStatsDspRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => 'Спуск на фигуру';
}

// Path: stats.appdsp
class _TranslationsStatsAppdspRuRu implements TranslationsStatsAppdspEn {
	_TranslationsStatsAppdspRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _TranslationsStatsCheeseRuRu implements TranslationsStatsCheeseEn {
	_TranslationsStatsCheeseRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Cheese';
	@override String get full => 'Индекс Сыра';
}

// Path: stats.gbe
class _TranslationsStatsGbeRuRu implements TranslationsStatsGbeEn {
	_TranslationsStatsGbeRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => 'Эффективность Мусора';
}

// Path: stats.nyaapp
class _TranslationsStatsNyaappRuRu implements TranslationsStatsNyaappEn {
	_TranslationsStatsNyaappRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => 'Weighted APP';
}

// Path: stats.area
class _TranslationsStatsAreaRuRu implements TranslationsStatsAreaEn {
	_TranslationsStatsAreaRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Area';
	@override String get full => 'Area';
}

// Path: stats.etr
class _TranslationsStatsEtrRuRu implements TranslationsStatsEtrEn {
	_TranslationsStatsEtrRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => 'Расчётный TR';
}

// Path: stats.etracc
class _TranslationsStatsEtraccRuRu implements TranslationsStatsEtraccEn {
	_TranslationsStatsEtraccRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => 'Точность расчёта';
}

// Path: stats.opener
class _TranslationsStatsOpenerRuRu implements TranslationsStatsOpenerEn {
	_TranslationsStatsOpenerRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Opener';
	@override String get full => 'Опенер';
}

// Path: stats.plonk
class _TranslationsStatsPlonkRuRu implements TranslationsStatsPlonkEn {
	_TranslationsStatsPlonkRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Plonk';
	@override String get full => 'Плонк';
}

// Path: stats.stride
class _TranslationsStatsStrideRuRu implements TranslationsStatsStrideEn {
	_TranslationsStatsStrideRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Stride';
	@override String get full => 'Страйд';
}

// Path: stats.infds
class _TranslationsStatsInfdsRuRu implements TranslationsStatsInfdsEn {
	_TranslationsStatsInfdsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Inf. DS';
	@override String get full => 'Бесконечный спуск';
}

// Path: stats.altitude
class _TranslationsStatsAltitudeRuRu implements TranslationsStatsAltitudeEn {
	_TranslationsStatsAltitudeRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'м';
	@override String get full => 'Высота';
}

// Path: stats.climbSpeed
class _TranslationsStatsClimbSpeedRuRu implements TranslationsStatsClimbSpeedEn {
	_TranslationsStatsClimbSpeedRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'CSP';
	@override String get full => 'Скорость подъёма';
	@override String get gaugetTitle => 'Скорость\nПодъёма';
}

// Path: stats.peakClimbSpeed
class _TranslationsStatsPeakClimbSpeedRuRu implements TranslationsStatsPeakClimbSpeedEn {
	_TranslationsStatsPeakClimbSpeedRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Пик CSP';
	@override String get full => 'Пиковая скорость подъёма';
	@override String get gaugetTitle => 'Пик';
}

// Path: stats.kos
class _TranslationsStatsKosRuRu implements TranslationsStatsKosEn {
	_TranslationsStatsKosRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KO\'s';
	@override String get full => 'Выбил';
}

// Path: stats.b2b
class _TranslationsStatsB2bRuRu implements TranslationsStatsB2bEn {
	_TranslationsStatsB2bRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => 'Back-To-Back';
}

// Path: stats.finesse
class _TranslationsStatsFinesseRuRu implements TranslationsStatsFinesseEn {
	_TranslationsStatsFinesseRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'F';
	@override String get full => 'Техника';
	@override String get widgetTitle => 'Техника';
}

// Path: stats.finesseFaults
class _TranslationsStatsFinesseFaultsRuRu implements TranslationsStatsFinesseFaultsEn {
	_TranslationsStatsFinesseFaultsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'FF';
	@override String get full => 'Ошибок техники';
}

// Path: stats.totalTime
class _TranslationsStatsTotalTimeRuRu implements TranslationsStatsTotalTimeEn {
	_TranslationsStatsTotalTimeRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Время';
	@override String get full => 'Общее время';
	@override String get widgetTitle => 'Общее время';
}

// Path: stats.level
class _TranslationsStatsLevelRuRu implements TranslationsStatsLevelEn {
	_TranslationsStatsLevelRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Лвл';
	@override String get full => 'Уровень';
}

// Path: stats.pieces
class _TranslationsStatsPiecesRuRu implements TranslationsStatsPiecesEn {
	_TranslationsStatsPiecesRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => 'Фигур';
}

// Path: stats.spp
class _TranslationsStatsSppRuRu implements TranslationsStatsSppEn {
	_TranslationsStatsSppRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => 'Очков на Фигуру';
}

// Path: stats.kp
class _TranslationsStatsKpRuRu implements TranslationsStatsKpEn {
	_TranslationsStatsKpRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => 'Нажатий клавиш';
}

// Path: stats.kpp
class _TranslationsStatsKppRuRu implements TranslationsStatsKppEn {
	_TranslationsStatsKppRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => 'Нажатий клавиш на Фигуру';
}

// Path: stats.kps
class _TranslationsStatsKpsRuRu implements TranslationsStatsKpsEn {
	_TranslationsStatsKpsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => 'Нажатий клавиш в Секунду';
}

// Path: stats.apl
class _TranslationsStatsAplRuRu implements TranslationsStatsAplEn {
	_TranslationsStatsAplRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'APL';
	@override String get full => 'Атаки на Линию';
}

// Path: stats.quadEfficiency
class _TranslationsStatsQuadEfficiencyRuRu implements TranslationsStatsQuadEfficiencyEn {
	_TranslationsStatsQuadEfficiencyRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'Q Eff.';
	@override String get full => 'Эффективность quad-ов';
}

// Path: stats.tspinEfficiency
class _TranslationsStatsTspinEfficiencyRuRu implements TranslationsStatsTspinEfficiencyEn {
	_TranslationsStatsTspinEfficiencyRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'T Eff.';
	@override String get full => 'Эффективность Т-спинов';
}

// Path: stats.allspinEfficiency
class _TranslationsStatsAllspinEfficiencyRuRu implements TranslationsStatsAllspinEfficiencyEn {
	_TranslationsStatsAllspinEfficiencyRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get short => 'All Eff.';
	@override String get full => 'Эффективность All-спинов';
}

// Path: stats.graphs
class _TranslationsStatsGraphsRuRu implements TranslationsStatsGraphsEn {
	_TranslationsStatsGraphsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

	// Translations
	@override String get attack => 'Атака';
	@override String get speed => 'Скорость';
	@override String get defense => 'Оборона';
	@override String get cheese => 'Сыр';
}

// Path: stats.lineClear
class _TranslationsStatsLineClearRuRu implements TranslationsStatsLineClearEn {
	_TranslationsStatsLineClearRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
class _TranslationsStatsLineClearsRuRu implements TranslationsStatsLineClearsEn {
	_TranslationsStatsLineClearsRuRu._(this._root);

	final TranslationsRuRu _root; // ignore: unused_field

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
extension on TranslationsRuRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'Английский (English)';
			case 'locales.ru-RU': return 'Русский';
			case 'locales.ko-KR': return 'Корейский (한국인)';
			case 'locales.zh-CN': return 'Упрощенный Китайский (简体中文)';
			case 'locales.de-DE': return 'Немецкий (Deutsch)';
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
			case 'whichOne': return 'Какой из?';
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
			case 'checkingCache': return 'Проверяем кеш...';
			case 'fetchingRecords': return 'Получаем список матчей...';
			case 'munching': return 'Анализируем...';
			case 'outOf': return 'из';
			case 'replaysDone': return 'повторов обработано';
			case 'analysis': return 'Анализ';
			case 'minomuncherMention': return 'с помощью MinoMuncher от Freyhoe';
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
			case 'errors.discordNotAssigned': return 'Нет связей с данным аккаунтом';
			case 'errors.discordNotAssignedSub': return 'Убедитесь, что ваш запрос соответствует формату, описанному в [документации API](https://tetr.io/about/api/#userssearchquery)';
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
			case 'graphsDestination.fetchAndsaveTLHistory': return 'Получить историю';
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
			case 'calcDestination.invalidValues': return 'Пожалуйста, введите корректные значения';
			case 'calcDestination.statsCalcButton': return 'Считать';
			case 'calcDestination.damageCalcTip': return 'Нажмите на действия слева, чтобы добавить их сюда';
			case 'calcDestination.clearAll': return 'Очистить';
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
			case 'settingsDestination.compareStatsDescription': return 'Если включено, Tetra Stats загрузит средние значения и будет сравнивать вас со средними значениями вашего ранга. В результате этого почти каждый пункт статистики обретёт цвет, наводите курсор, чтобы узнать больше.';
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
			case 'aboutView.deDElocale': return 'Перевёл на немецкий';
			case 'aboutView.koKRlocale': return 'Перевели на корейский';
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
			case 'stats.apl.short': return 'APL';
			case 'stats.apl.full': return 'Атаки на Линию';
			case 'stats.quadEfficiency.short': return 'Q Eff.';
			case 'stats.quadEfficiency.full': return 'Эффективность quad-ов';
			case 'stats.tspinEfficiency.short': return 'T Eff.';
			case 'stats.tspinEfficiency.full': return 'Эффективность Т-спинов';
			case 'stats.allspinEfficiency.short': return 'All Eff.';
			case 'stats.allspinEfficiency.full': return 'Эффективность All-спинов';
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
			case 'stats.overall': return 'В среднем';
			case 'stats.midgame': return 'Midgame';
			case 'stats.efficiency': return 'Эффективность';
			case 'stats.upstack': return 'Upstack';
			case 'stats.downstack': return 'Downstack';
			case 'stats.variance': return 'Дисперсия';
			case 'stats.burst': return 'Burst';
			case 'stats.length': return 'Длина';
			case 'stats.rate': return 'Rate';
			case 'stats.secsDS': return 'Secs/DS';
			case 'stats.secsCheese': return 'Secs/Cheese';
			case 'stats.attackCheesiness': return 'Сырность атаки';
			case 'stats.downstackingRatio': return 'Downstacking Ratio';
			case 'stats.clearTypes': return 'Clear Types';
			case 'stats.wellColumnDistribution': return 'Распределение колодцев';
			case 'stats.allSpins': return 'All Spins';
			case 'stats.sankeyTitle': return 'График входящих атак';
			case 'stats.incomingAttack': return 'Входящие атаки';
			case 'stats.clean': return 'Clean';
			case 'stats.cancelled': return 'Cancelled';
			case 'stats.cheeseTanked': return 'Cheese Tanked';
			case 'stats.cleanTanked': return 'Clean Tanked';
			case 'stats.kills': return 'Убийств';
			case 'stats.deaths': return 'Смертей';
			case 'stats.ppsDistribution': return 'Распределение PPS';
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

