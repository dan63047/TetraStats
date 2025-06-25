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
class TranslationsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhCn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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

	late final TranslationsZhCn _root = this; // ignore: unused_field

	@override 
	TranslationsZhCn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhCn(meta: meta ?? this.$meta);

	// Translations
	@override Map<String, String> get locales => {
		'en': '英语 (English)',
		'ru-RU': '俄语 (Русский)',
		'ko-KR': '韩语 (한국인)',
		'zh-CN': '简体中文',
		'de-DE': '德语 (Deutsch)',
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
	@override late final _TranslationsDestinationsZhCn destinations = _TranslationsDestinationsZhCn._(_root);
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
	@override String verdictGeneral({required Object rank, required Object verdict, required Object n}) => '比 ${rank} 段平均数据${verdict} ${n}';
	@override String get verdictBetter => '好';
	@override String get verdictWorse => '差';
	@override String get localStanding => '本地';
	@override late final _TranslationsXpZhCn xp = _TranslationsXpZhCn._(_root);
	@override late final _TranslationsGametimeZhCn gametime = _TranslationsGametimeZhCn._(_root);
	@override String get whichOne => '哪一个？';
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
	@override late final _TranslationsMatchResultZhCn matchResult = _TranslationsMatchResultZhCn._(_root);
	@override late final _TranslationsDistinguishmentsZhCn distinguishments = _TranslationsDistinguishmentsZhCn._(_root);
	@override late final _TranslationsNewsEntriesZhCn newsEntries = _TranslationsNewsEntriesZhCn._(_root);
	@override String rankupMiddle({required Object r}) => '${r} 段';
	@override String get copyUserID => '点击以复制用户 ID';
	@override String get searchHint => '用户名或 ID';
	@override String get navMenu => '导航菜单';
	@override String get navMenuTooltip => '打开导航菜单';
	@override String get refresh => '刷新数据';
	@override String get searchButton => '搜索';
	@override String get trackedPlayers => '跟踪的玩家';
	@override String get standing => '排行';
	@override String get previousSeasons => '上赛季';
	@override String get checkingCache => '正在检查缓存……';
	@override String get fetchingRecords => '正在获取记录……';
	@override String get munching => '分析中……';
	@override String get outOf => '超出';
	@override String get replaysDone => '已完成回放';
	@override String get analysis => '分析';
	@override String get minomuncherMention => '通过由 Freyhoe 提供的 MinoMuncher';
	@override String get recent => '最近';
	@override String get top => '前';
	@override String get noRecord => '暂无记录';
	@override String sprintAndBlitsRelevance({required Object date}) => '${date}';
	@override late final _TranslationsSnackBarMessagesZhCn snackBarMessages = _TranslationsSnackBarMessagesZhCn._(_root);
	@override late final _TranslationsErrorsZhCn errors = _TranslationsErrorsZhCn._(_root);
	@override late final _TranslationsActionsZhCn actions = _TranslationsActionsZhCn._(_root);
	@override late final _TranslationsGraphsDestinationZhCn graphsDestination = _TranslationsGraphsDestinationZhCn._(_root);
	@override late final _TranslationsFilterModaleZhCn filterModale = _TranslationsFilterModaleZhCn._(_root);
	@override late final _TranslationsCutoffsDestinationZhCn cutoffsDestination = _TranslationsCutoffsDestinationZhCn._(_root);
	@override late final _TranslationsRankViewZhCn rankView = _TranslationsRankViewZhCn._(_root);
	@override late final _TranslationsStateViewZhCn stateView = _TranslationsStateViewZhCn._(_root);
	@override late final _TranslationsTlMatchViewZhCn tlMatchView = _TranslationsTlMatchViewZhCn._(_root);
	@override late final _TranslationsCalcDestinationZhCn calcDestination = _TranslationsCalcDestinationZhCn._(_root);
	@override late final _TranslationsInfoDestinationZhCn infoDestination = _TranslationsInfoDestinationZhCn._(_root);
	@override late final _TranslationsLeaderboardsDestinationZhCn leaderboardsDestination = _TranslationsLeaderboardsDestinationZhCn._(_root);
	@override late final _TranslationsSavedDataDestinationZhCn savedDataDestination = _TranslationsSavedDataDestinationZhCn._(_root);
	@override late final _TranslationsSettingsDestinationZhCn settingsDestination = _TranslationsSettingsDestinationZhCn._(_root);
	@override late final _TranslationsHomeNavigationZhCn homeNavigation = _TranslationsHomeNavigationZhCn._(_root);
	@override late final _TranslationsGraphsNavigationZhCn graphsNavigation = _TranslationsGraphsNavigationZhCn._(_root);
	@override late final _TranslationsCalcNavigationZhCn calcNavigation = _TranslationsCalcNavigationZhCn._(_root);
	@override late final _TranslationsFirstTimeViewZhCn firstTimeView = _TranslationsFirstTimeViewZhCn._(_root);
	@override late final _TranslationsAboutViewZhCn aboutView = _TranslationsAboutViewZhCn._(_root);
	@override late final _TranslationsStatsZhCn stats = _TranslationsStatsZhCn._(_root);
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
class _TranslationsDestinationsZhCn implements TranslationsDestinationsEn {
	_TranslationsDestinationsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsXpZhCn implements TranslationsXpEn {
	_TranslationsXpZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '经验等级';
	@override String progressToNextLevel({required Object percentage}) => '到下一等级的进度：${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => '从0级到${goal}级的进度：${percentage} (还差 ${left} 点经验值)';
}

// Path: gametime
class _TranslationsGametimeZhCn implements TranslationsGametimeEn {
	_TranslationsGametimeZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '精确游戏时长';
	@override String gametimeAday({required Object gametime}) => '平均每天${gametime}';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => '相当于 ${years} 年，\n${months} 月，\n${days} 天，\n${minutes} 分钟，\n${seconds} 秒';
}

// Path: matchResult
class _TranslationsMatchResultZhCn implements TranslationsMatchResultEn {
	_TranslationsMatchResultZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsDistinguishmentsZhCn implements TranslationsDistinguishmentsEn {
	_TranslationsDistinguishmentsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noHeader => '缺少标题';
	@override String get noFooter => '缺少页脚';
	@override String get twc => 'TETR.IO 世界冠军';
	@override String twcYear({required Object year}) => '${year} TETR.IO 世界杯';
}

// Path: newsEntries
class _TranslationsNewsEntriesZhCn implements TranslationsNewsEntriesEn {
	_TranslationsNewsEntriesZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsSnackBarMessagesZhCn implements TranslationsSnackBarMessagesEn {
	_TranslationsSnackBarMessagesZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => '成功移除${date}时的状态！';
	@override String matchRemoved({required Object date}) => '成功移除${date}时的一局！';
	@override String get notForWeb => '此功能在网络版本中不可用';
	@override String get importSuccess => '导入成功';
	@override String get importCancelled => '导入已取消';
}

// Path: errors
class _TranslationsErrorsZhCn implements TranslationsErrorsEn {
	_TranslationsErrorsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noRecords => '暂无记录';
	@override String get notEnoughData => '数据不足';
	@override String get noHistorySaved => '没有保存历史记录';
	@override String connection({required Object code, required Object message}) => '连接错误：${code} ${message}';
	@override String get noSuchUser => '用户不存在';
	@override String get noSuchUserSub => '您输入的内容有误，或者用户不存在';
	@override String get discordNotAssigned => '该Discord用户没有对应的TETR.IO账号';
	@override String get discordNotAssignedSub => '你所查询应来自 [API 指南](https://tetr.io/about/api/#userssearchquery)';
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
class _TranslationsActionsZhCn implements TranslationsActionsEn {
	_TranslationsActionsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get submit => '确定';
	@override String get ok => '确定';
	@override String get apply => '应用';
	@override String get refresh => '刷新';
}

// Path: graphsDestination
class _TranslationsGraphsDestinationZhCn implements TranslationsGraphsDestinationEn {
	_TranslationsGraphsDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsFilterModaleZhCn implements TranslationsFilterModaleEn {
	_TranslationsFilterModaleZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get all => '全部';
}

// Path: cutoffsDestination
class _TranslationsCutoffsDestinationZhCn implements TranslationsCutoffsDestinationEn {
	_TranslationsCutoffsDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
	@override String inflated({required Object tr}) => '超标 ${tr}';
	@override String get notInflated => '未超标';
	@override String deflated({required Object tr}) => '未达标 ${tr}';
	@override String get notDeflated => '达标';
	@override String get wellDotDotDot => '嗯…';
	@override String fromPlace({required Object n}) => '自 № ${n}';
	@override String get viewButton => '查看';
}

// Path: rankView
class _TranslationsRankViewZhCn implements TranslationsRankViewEn {
	_TranslationsRankViewZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsStateViewZhCn implements TranslationsStateViewEn {
	_TranslationsStateViewZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => '${date}的状态';
}

// Path: tlMatchView
class _TranslationsTlMatchViewZhCn implements TranslationsTlMatchViewEn {
	_TranslationsTlMatchViewZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsCalcDestinationZhCn implements TranslationsCalcDestinationEn {
	_TranslationsCalcDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => '输入你的${stat}';
	@override String get tip => '输入值并按 "计算" 来查看TA的详细信息';
	@override String get invalidValues => '请输入有效的值！';
	@override String get statsCalcButton => '计算';
	@override String get damageCalcTip => '点击左侧的操作在此添加';
	@override String get clearAll => '全部清除';
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
class _TranslationsInfoDestinationZhCn implements TranslationsInfoDestinationEn {
	_TranslationsInfoDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsLeaderboardsDestinationZhCn implements TranslationsLeaderboardsDestinationEn {
	_TranslationsLeaderboardsDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '排行榜';
	@override String get tl => 'Tetra 联赛（当前赛季）';
	@override String get fullTL => 'Tetra 联赛（当前赛季，完整）';
	@override String get ar => '成就点';
}

// Path: savedDataDestination
class _TranslationsSavedDataDestinationZhCn implements TranslationsSavedDataDestinationEn {
	_TranslationsSavedDataDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '已保存的数据';
	@override String get tip => '选择左边的昵称以查看与之相关的数据';
	@override String seasonTLstates({required Object s}) => '第${s}赛季状态';
	@override String get TLrecords => '联赛记录';
}

// Path: settingsDestination
class _TranslationsSettingsDestinationZhCn implements TranslationsSettingsDestinationEn {
	_TranslationsSettingsDestinationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsHomeNavigationZhCn implements TranslationsHomeNavigationEn {
	_TranslationsHomeNavigationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsGraphsNavigationZhCn implements TranslationsGraphsNavigationEn {
	_TranslationsGraphsNavigationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get history => '玩家历史记录';
	@override String get league => '联赛状态';
	@override String get cutoffs => '分段线历史';
}

// Path: calcNavigation
class _TranslationsCalcNavigationZhCn implements TranslationsCalcNavigationEn {
	_TranslationsCalcNavigationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get stats => '数据计算器';
	@override String get damage => '伤害计算器';
}

// Path: firstTimeView
class _TranslationsFirstTimeViewZhCn implements TranslationsFirstTimeViewEn {
	_TranslationsFirstTimeViewZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get welcome => '欢迎使用 Tetra Stats';
	@override String get description => '您跟踪TETR.IO的各种数据的好帮手';
	@override String get nicknameQuestion => '您的昵称是？';
	@override String get inpuntHint => '在此处输入... (3-16个符号)';
	@override String get emptyInputError => '不能提交空字符串';
	@override String niceToSeeYou({required Object n}) => '很高兴见到你，${n}';
	@override String get letsTakeALook => '让我们看看您的统计资料...';
	@override String get skip => '跳过';
}

// Path: aboutView
class _TranslationsAboutViewZhCn implements TranslationsAboutViewEn {
	_TranslationsAboutViewZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
	@override String get deDElocale => '德语翻译员';
	@override String get koKRlocale => '韩语翻译员';
	@override String get supportHim => '为他提供支持！';
}

// Path: stats
class _TranslationsStatsZhCn implements TranslationsStatsEn {
	_TranslationsStatsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => '注册时间';
	@override String get gametime => '游玩时长';
	@override String get ogp => '在线游戏次数';
	@override String get ogw => '在线游戏胜利次数';
	@override String get followers => '粉丝';
	@override late final _TranslationsStatsXpZhCn xp = _TranslationsStatsXpZhCn._(_root);
	@override late final _TranslationsStatsTrZhCn tr = _TranslationsStatsTrZhCn._(_root);
	@override late final _TranslationsStatsGlickoZhCn glicko = _TranslationsStatsGlickoZhCn._(_root);
	@override late final _TranslationsStatsRdZhCn rd = _TranslationsStatsRdZhCn._(_root);
	@override late final _TranslationsStatsGlixareZhCn glixare = _TranslationsStatsGlixareZhCn._(_root);
	@override late final _TranslationsStatsS1trZhCn s1tr = _TranslationsStatsS1trZhCn._(_root);
	@override late final _TranslationsStatsGpZhCn gp = _TranslationsStatsGpZhCn._(_root);
	@override late final _TranslationsStatsGwZhCn gw = _TranslationsStatsGwZhCn._(_root);
	@override late final _TranslationsStatsWinrateZhCn winrate = _TranslationsStatsWinrateZhCn._(_root);
	@override late final _TranslationsStatsApmZhCn apm = _TranslationsStatsApmZhCn._(_root);
	@override late final _TranslationsStatsPpsZhCn pps = _TranslationsStatsPpsZhCn._(_root);
	@override late final _TranslationsStatsVsZhCn vs = _TranslationsStatsVsZhCn._(_root);
	@override late final _TranslationsStatsAppZhCn app = _TranslationsStatsAppZhCn._(_root);
	@override late final _TranslationsStatsVsapmZhCn vsapm = _TranslationsStatsVsapmZhCn._(_root);
	@override late final _TranslationsStatsDssZhCn dss = _TranslationsStatsDssZhCn._(_root);
	@override late final _TranslationsStatsDspZhCn dsp = _TranslationsStatsDspZhCn._(_root);
	@override late final _TranslationsStatsAppdspZhCn appdsp = _TranslationsStatsAppdspZhCn._(_root);
	@override late final _TranslationsStatsCheeseZhCn cheese = _TranslationsStatsCheeseZhCn._(_root);
	@override late final _TranslationsStatsGbeZhCn gbe = _TranslationsStatsGbeZhCn._(_root);
	@override late final _TranslationsStatsNyaappZhCn nyaapp = _TranslationsStatsNyaappZhCn._(_root);
	@override late final _TranslationsStatsAreaZhCn area = _TranslationsStatsAreaZhCn._(_root);
	@override late final _TranslationsStatsEtrZhCn etr = _TranslationsStatsEtrZhCn._(_root);
	@override late final _TranslationsStatsEtraccZhCn etracc = _TranslationsStatsEtraccZhCn._(_root);
	@override late final _TranslationsStatsOpenerZhCn opener = _TranslationsStatsOpenerZhCn._(_root);
	@override late final _TranslationsStatsPlonkZhCn plonk = _TranslationsStatsPlonkZhCn._(_root);
	@override late final _TranslationsStatsStrideZhCn stride = _TranslationsStatsStrideZhCn._(_root);
	@override late final _TranslationsStatsInfdsZhCn infds = _TranslationsStatsInfdsZhCn._(_root);
	@override late final _TranslationsStatsAltitudeZhCn altitude = _TranslationsStatsAltitudeZhCn._(_root);
	@override late final _TranslationsStatsClimbSpeedZhCn climbSpeed = _TranslationsStatsClimbSpeedZhCn._(_root);
	@override late final _TranslationsStatsPeakClimbSpeedZhCn peakClimbSpeed = _TranslationsStatsPeakClimbSpeedZhCn._(_root);
	@override late final _TranslationsStatsKosZhCn kos = _TranslationsStatsKosZhCn._(_root);
	@override late final _TranslationsStatsB2bZhCn b2b = _TranslationsStatsB2bZhCn._(_root);
	@override late final _TranslationsStatsFinesseZhCn finesse = _TranslationsStatsFinesseZhCn._(_root);
	@override late final _TranslationsStatsFinesseFaultsZhCn finesseFaults = _TranslationsStatsFinesseFaultsZhCn._(_root);
	@override late final _TranslationsStatsTotalTimeZhCn totalTime = _TranslationsStatsTotalTimeZhCn._(_root);
	@override late final _TranslationsStatsLevelZhCn level = _TranslationsStatsLevelZhCn._(_root);
	@override late final _TranslationsStatsPiecesZhCn pieces = _TranslationsStatsPiecesZhCn._(_root);
	@override late final _TranslationsStatsSppZhCn spp = _TranslationsStatsSppZhCn._(_root);
	@override late final _TranslationsStatsKpZhCn kp = _TranslationsStatsKpZhCn._(_root);
	@override late final _TranslationsStatsKppZhCn kpp = _TranslationsStatsKppZhCn._(_root);
	@override late final _TranslationsStatsKpsZhCn kps = _TranslationsStatsKpsZhCn._(_root);
	@override late final _TranslationsStatsAplZhCn apl = _TranslationsStatsAplZhCn._(_root);
	@override late final _TranslationsStatsQuadEfficiencyZhCn quadEfficiency = _TranslationsStatsQuadEfficiencyZhCn._(_root);
	@override late final _TranslationsStatsTspinEfficiencyZhCn tspinEfficiency = _TranslationsStatsTspinEfficiencyZhCn._(_root);
	@override late final _TranslationsStatsAllspinEfficiencyZhCn allspinEfficiency = _TranslationsStatsAllspinEfficiencyZhCn._(_root);
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
	@override String get overall => '总体';
	@override String get midgame => '游戏中期';
	@override String get efficiency => '效率';
	@override String get upstack => '堆叠';
	@override String get downstack => '挖掘';
	@override String get variance => '方差';
	@override String get burst => '爆发';
	@override String get length => '长度';
	@override String get rate => '评分';
	@override String get secsDS => '秒/挖掘';
	@override String get secsCheese => '秒/混乱';
	@override String get attackCheesiness => '发送垃圾行混乱指数';
	@override String get downstackingRatio => '挖掘比率';
	@override String get clearTypes => '消除类型';
	@override String get wellColumnDistribution => '井列分布';
	@override String get allSpins => '全旋';
	@override String get sankeyTitle => '受到攻击图表';
	@override String get incomingAttack => '受到攻击';
	@override String get clean => '整洁垃圾行';
	@override String get cancelled => '垃圾行格挡';
	@override String get cheeseTanked => '混乱垃圾行接受';
	@override String get cleanTanked => '整洁垃圾行接受';
	@override String get kills => '击杀次数';
	@override String get deaths => '死亡次数';
	@override String get ppsDistribution => 'PPS 分布';
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
	@override late final _TranslationsStatsGraphsZhCn graphs = _TranslationsStatsGraphsZhCn._(_root);
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
	@override late final _TranslationsStatsLineClearZhCn lineClear = _TranslationsStatsLineClearZhCn._(_root);
	@override late final _TranslationsStatsLineClearsZhCn lineClears = _TranslationsStatsLineClearsZhCn._(_root);
	@override String get mini => 'Mini';
	@override String get tSpin => 'T-spin';
	@override String get tSpins => 'T-spins';
	@override String get spin => 'Spin';
	@override String get spins => 'Spins';
}

// Path: stats.xp
class _TranslationsStatsXpZhCn implements TranslationsStatsXpEn {
	_TranslationsStatsXpZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '经验值';
	@override String get full => '经验点';
}

// Path: stats.tr
class _TranslationsStatsTrZhCn implements TranslationsStatsTrEn {
	_TranslationsStatsTrZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => 'Tetra 评分';
}

// Path: stats.glicko
class _TranslationsStatsGlickoZhCn implements TranslationsStatsGlickoEn {
	_TranslationsStatsGlickoZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => 'Glicko';
}

// Path: stats.rd
class _TranslationsStatsRdZhCn implements TranslationsStatsRdEn {
	_TranslationsStatsRdZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'RD';
	@override String get full => '评分偏差';
}

// Path: stats.glixare
class _TranslationsStatsGlixareZhCn implements TranslationsStatsGlixareEn {
	_TranslationsStatsGlixareZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _TranslationsStatsS1trZhCn implements TranslationsStatsS1trEn {
	_TranslationsStatsS1trZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'S1 TR';
	@override String get full => '第 1 赛季式 TR';
}

// Path: stats.gp
class _TranslationsStatsGpZhCn implements TranslationsStatsGpEn {
	_TranslationsStatsGpZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GP';
	@override String get full => '总场数';
}

// Path: stats.gw
class _TranslationsStatsGwZhCn implements TranslationsStatsGwEn {
	_TranslationsStatsGwZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GW';
	@override String get full => '胜场数';
}

// Path: stats.winrate
class _TranslationsStatsWinrateZhCn implements TranslationsStatsWinrateEn {
	_TranslationsStatsWinrateZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'WR%';
	@override String get full => '胜率';
}

// Path: stats.apm
class _TranslationsStatsApmZhCn implements TranslationsStatsApmEn {
	_TranslationsStatsApmZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => '每分钟攻击数';
}

// Path: stats.pps
class _TranslationsStatsPpsZhCn implements TranslationsStatsPpsEn {
	_TranslationsStatsPpsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => '每秒块数';
}

// Path: stats.vs
class _TranslationsStatsVsZhCn implements TranslationsStatsVsEn {
	_TranslationsStatsVsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => 'VS 分数';
}

// Path: stats.app
class _TranslationsStatsAppZhCn implements TranslationsStatsAppEn {
	_TranslationsStatsAppZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => '每块攻击数';
}

// Path: stats.vsapm
class _TranslationsStatsVsapmZhCn implements TranslationsStatsVsapmEn {
	_TranslationsStatsVsapmZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _TranslationsStatsDssZhCn implements TranslationsStatsDssEn {
	_TranslationsStatsDssZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => '每秒挖掘数';
}

// Path: stats.dsp
class _TranslationsStatsDspZhCn implements TranslationsStatsDspEn {
	_TranslationsStatsDspZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => '每块挖掘数';
}

// Path: stats.appdsp
class _TranslationsStatsAppdspZhCn implements TranslationsStatsAppdspEn {
	_TranslationsStatsAppdspZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _TranslationsStatsCheeseZhCn implements TranslationsStatsCheeseEn {
	_TranslationsStatsCheeseZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'CI';
	@override String get full => '垃圾行混乱指数';
}

// Path: stats.gbe
class _TranslationsStatsGbeZhCn implements TranslationsStatsGbeEn {
	_TranslationsStatsGbeZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => '垃圾行效率';
}

// Path: stats.nyaapp
class _TranslationsStatsNyaappZhCn implements TranslationsStatsNyaappEn {
	_TranslationsStatsNyaappZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => '加权APP';
}

// Path: stats.area
class _TranslationsStatsAreaZhCn implements TranslationsStatsAreaEn {
	_TranslationsStatsAreaZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '面积';
	@override String get full => '面积';
}

// Path: stats.etr
class _TranslationsStatsEtrZhCn implements TranslationsStatsEtrEn {
	_TranslationsStatsEtrZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => '预测 TR';
}

// Path: stats.etracc
class _TranslationsStatsEtraccZhCn implements TranslationsStatsEtraccEn {
	_TranslationsStatsEtraccZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => '预测实际差量';
}

// Path: stats.opener
class _TranslationsStatsOpenerZhCn implements TranslationsStatsOpenerEn {
	_TranslationsStatsOpenerZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '定式';
	@override String get full => '定式';
}

// Path: stats.plonk
class _TranslationsStatsPlonkZhCn implements TranslationsStatsPlonkEn {
	_TranslationsStatsPlonkZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '低速';
	@override String get full => '低速';
}

// Path: stats.stride
class _TranslationsStatsStrideZhCn implements TranslationsStatsStrideEn {
	_TranslationsStatsStrideZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '快速';
	@override String get full => '快速';
}

// Path: stats.infds
class _TranslationsStatsInfdsZhCn implements TranslationsStatsInfdsEn {
	_TranslationsStatsInfdsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '挖掘';
	@override String get full => '挖掘';
}

// Path: stats.altitude
class _TranslationsStatsAltitudeZhCn implements TranslationsStatsAltitudeEn {
	_TranslationsStatsAltitudeZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'm';
	@override String get full => '高度';
}

// Path: stats.climbSpeed
class _TranslationsStatsClimbSpeedZhCn implements TranslationsStatsClimbSpeedEn {
	_TranslationsStatsClimbSpeedZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'CSP';
	@override String get full => '爬行速度';
	@override String get gaugetTitle => '爬行速度';
}

// Path: stats.peakClimbSpeed
class _TranslationsStatsPeakClimbSpeedZhCn implements TranslationsStatsPeakClimbSpeedEn {
	_TranslationsStatsPeakClimbSpeedZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '最高速';
	@override String get full => '最高爬行速度';
	@override String get gaugetTitle => '最高';
}

// Path: stats.kos
class _TranslationsStatsKosZhCn implements TranslationsStatsKosEn {
	_TranslationsStatsKosZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KO\'s';
	@override String get full => '击杀';
}

// Path: stats.b2b
class _TranslationsStatsB2bZhCn implements TranslationsStatsB2bEn {
	_TranslationsStatsB2bZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => '背靠背/满贯';
}

// Path: stats.finesse
class _TranslationsStatsFinesseZhCn implements TranslationsStatsFinesseEn {
	_TranslationsStatsFinesseZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '极';
	@override String get full => '极简率';
	@override String get widgetTitle => '极简率';
}

// Path: stats.finesseFaults
class _TranslationsStatsFinesseFaultsZhCn implements TranslationsStatsFinesseFaultsEn {
	_TranslationsStatsFinesseFaultsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '非极简';
	@override String get full => '非极简操作数';
}

// Path: stats.totalTime
class _TranslationsStatsTotalTimeZhCn implements TranslationsStatsTotalTimeEn {
	_TranslationsStatsTotalTimeZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => '时长';
	@override String get full => '总时长';
	@override String get widgetTitle => '总时长';
}

// Path: stats.level
class _TranslationsStatsLevelZhCn implements TranslationsStatsLevelEn {
	_TranslationsStatsLevelZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'Lvl';
	@override String get full => '等级';
}

// Path: stats.pieces
class _TranslationsStatsPiecesZhCn implements TranslationsStatsPiecesEn {
	_TranslationsStatsPiecesZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => '块';
}

// Path: stats.spp
class _TranslationsStatsSppZhCn implements TranslationsStatsSppEn {
	_TranslationsStatsSppZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => '每块得分';
}

// Path: stats.kp
class _TranslationsStatsKpZhCn implements TranslationsStatsKpEn {
	_TranslationsStatsKpZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => '按键';
}

// Path: stats.kpp
class _TranslationsStatsKppZhCn implements TranslationsStatsKppEn {
	_TranslationsStatsKppZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => '每块按键数';
}

// Path: stats.kps
class _TranslationsStatsKpsZhCn implements TranslationsStatsKpsEn {
	_TranslationsStatsKpsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => '每秒按键数';
}

// Path: stats.apl
class _TranslationsStatsAplZhCn implements TranslationsStatsAplEn {
	_TranslationsStatsAplZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'APL';
	@override String get full => '每行攻击数';
}

// Path: stats.quadEfficiency
class _TranslationsStatsQuadEfficiencyZhCn implements TranslationsStatsQuadEfficiencyEn {
	_TranslationsStatsQuadEfficiencyZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'Q Eff.';
	@override String get full => '四消效率';
}

// Path: stats.tspinEfficiency
class _TranslationsStatsTspinEfficiencyZhCn implements TranslationsStatsTspinEfficiencyEn {
	_TranslationsStatsTspinEfficiencyZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'T Eff.';
	@override String get full => 'T旋效率';
}

// Path: stats.allspinEfficiency
class _TranslationsStatsAllspinEfficiencyZhCn implements TranslationsStatsAllspinEfficiencyEn {
	_TranslationsStatsAllspinEfficiencyZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get short => 'All Eff.';
	@override String get full => '全旋效率';
}

// Path: stats.graphs
class _TranslationsStatsGraphsZhCn implements TranslationsStatsGraphsEn {
	_TranslationsStatsGraphsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get attack => '攻击';
	@override String get speed => '速度';
	@override String get defense => '防御';
	@override String get cheese => '奶酪层';
}

// Path: stats.lineClear
class _TranslationsStatsLineClearZhCn implements TranslationsStatsLineClearEn {
	_TranslationsStatsLineClearZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class _TranslationsStatsLineClearsZhCn implements TranslationsStatsLineClearsEn {
	_TranslationsStatsLineClearsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

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
extension on TranslationsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return '英语 (English)';
			case 'locales.ru-RU': return '俄语 (Русский)';
			case 'locales.ko-KR': return '韩语 (한국인)';
			case 'locales.zh-CN': return '简体中文';
			case 'locales.de-DE': return '德语 (Deutsch)';
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
			case 'verdictGeneral': return ({required Object rank, required Object verdict, required Object n}) => '比 ${rank} 段平均数据${verdict} ${n}';
			case 'verdictBetter': return '好';
			case 'verdictWorse': return '差';
			case 'localStanding': return '本地';
			case 'xp.title': return '经验等级';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => '到下一等级的进度：${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => '从0级到${goal}级的进度：${percentage} (还差 ${left} 点经验值)';
			case 'gametime.title': return '精确游戏时长';
			case 'gametime.gametimeAday': return ({required Object gametime}) => '平均每天${gametime}';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => '相当于 ${years} 年，\n${months} 月，\n${days} 天，\n${minutes} 分钟，\n${seconds} 秒';
			case 'whichOne': return '哪一个？';
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
			case 'distinguishments.noFooter': return '缺少页脚';
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
			case 'standing': return '排行';
			case 'previousSeasons': return '上赛季';
			case 'checkingCache': return '正在检查缓存……';
			case 'fetchingRecords': return '正在获取记录……';
			case 'munching': return '分析中……';
			case 'outOf': return '超出';
			case 'replaysDone': return '已完成回放';
			case 'analysis': return '分析';
			case 'minomuncherMention': return '通过由 Freyhoe 提供的 MinoMuncher';
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
			case 'errors.discordNotAssigned': return '该Discord用户没有对应的TETR.IO账号';
			case 'errors.discordNotAssignedSub': return '你所查询应来自 [API 指南](https://tetr.io/about/api/#userssearchquery)';
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
			case 'cutoffsDestination.inflated': return ({required Object tr}) => '超标 ${tr}';
			case 'cutoffsDestination.notInflated': return '未超标';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => '未达标 ${tr}';
			case 'cutoffsDestination.notDeflated': return '达标';
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
			case 'calcDestination.invalidValues': return '请输入有效的值！';
			case 'calcDestination.statsCalcButton': return '计算';
			case 'calcDestination.damageCalcTip': return '点击左侧的操作在此添加';
			case 'calcDestination.clearAll': return '全部清除';
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
			case 'firstTimeView.description': return '您跟踪TETR.IO的各种数据的好帮手';
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
			case 'aboutView.deDElocale': return '德语翻译员';
			case 'aboutView.koKRlocale': return '韩语翻译员';
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
			case 'stats.plonk.short': return '低速';
			case 'stats.plonk.full': return '低速';
			case 'stats.stride.short': return '快速';
			case 'stats.stride.full': return '快速';
			case 'stats.infds.short': return '挖掘';
			case 'stats.infds.full': return '挖掘';
			case 'stats.altitude.short': return 'm';
			case 'stats.altitude.full': return '高度';
			case 'stats.climbSpeed.short': return 'CSP';
			case 'stats.climbSpeed.full': return '爬行速度';
			case 'stats.climbSpeed.gaugetTitle': return '爬行速度';
			case 'stats.peakClimbSpeed.short': return '最高速';
			case 'stats.peakClimbSpeed.full': return '最高爬行速度';
			case 'stats.peakClimbSpeed.gaugetTitle': return '最高';
			case 'stats.kos.short': return 'KO\'s';
			case 'stats.kos.full': return '击杀';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return '背靠背/满贯';
			case 'stats.finesse.short': return '极';
			case 'stats.finesse.full': return '极简率';
			case 'stats.finesse.widgetTitle': return '极简率';
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
			case 'stats.apl.short': return 'APL';
			case 'stats.apl.full': return '每行攻击数';
			case 'stats.quadEfficiency.short': return 'Q Eff.';
			case 'stats.quadEfficiency.full': return '四消效率';
			case 'stats.tspinEfficiency.short': return 'T Eff.';
			case 'stats.tspinEfficiency.full': return 'T旋效率';
			case 'stats.allspinEfficiency.short': return 'All Eff.';
			case 'stats.allspinEfficiency.full': return '全旋效率';
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
			case 'stats.overall': return '总体';
			case 'stats.midgame': return '游戏中期';
			case 'stats.efficiency': return '效率';
			case 'stats.upstack': return '堆叠';
			case 'stats.downstack': return '挖掘';
			case 'stats.variance': return '方差';
			case 'stats.burst': return '爆发';
			case 'stats.length': return '长度';
			case 'stats.rate': return '评分';
			case 'stats.secsDS': return '秒/挖掘';
			case 'stats.secsCheese': return '秒/混乱';
			case 'stats.attackCheesiness': return '发送垃圾行混乱指数';
			case 'stats.downstackingRatio': return '挖掘比率';
			case 'stats.clearTypes': return '消除类型';
			case 'stats.wellColumnDistribution': return '井列分布';
			case 'stats.allSpins': return '全旋';
			case 'stats.sankeyTitle': return '受到攻击图表';
			case 'stats.incomingAttack': return '受到攻击';
			case 'stats.clean': return '整洁垃圾行';
			case 'stats.cancelled': return '垃圾行格挡';
			case 'stats.cheeseTanked': return '混乱垃圾行接受';
			case 'stats.cleanTanked': return '整洁垃圾行接受';
			case 'stats.kills': return '击杀次数';
			case 'stats.deaths': return '死亡次数';
			case 'stats.ppsDistribution': return 'PPS 分布';
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

