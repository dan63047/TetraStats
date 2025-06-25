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
class TranslationsKoKr implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKoKr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.koKr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko-KR>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsKoKr _root = this; // ignore: unused_field

	@override 
	TranslationsKoKr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKoKr(meta: meta ?? this.$meta);

	// Translations
	@override Map<String, String> get locales => {
		'en': '영어 (English)',
		'ru-RU': '러시아어 (Русский)',
		'ko-KR': '한국어',
		'zh-CN': '중국어 간체 (简体中文)',
		'de-DE': '독일어 (Deutsch)',
	};
	@override Map<String, String> get gamemodes => {
		'league': '테트라 리그',
		'zenith': '퀵 플레이',
		'zenithex': '전문가용 퀵 플레이',
		'40l': '40라인',
		'blitz': '블리츠',
		'5mblast': '5,000,000 블라스트',
		'zen': '젠',
	};
	@override late final _TranslationsDestinationsKoKr destinations = _TranslationsDestinationsKoKr._(_root);
	@override Map<String, String> get playerRole => {
		'user': '사용자',
		'banned': '밴',
		'bot': '봇',
		'sysop': '시스템 운영자',
		'admin': '관리자',
		'mod': '운영자',
		'halfmod': '커뮤니티 운영자',
		'anon': '익명',
	};
	@override String get goBackButton => '뒤로';
	@override String get nanow => '지금은 사용할 수 없습니다...';
	@override String seasonEnds({required Object countdown}) => '시즌이 ${countdown} 뒤에 종료됩니다';
	@override String get seasonEnded => '시즌이 종료되었습니다';
	@override String overallPB({required Object pb}) => '개인 최고 기록: ${pb} m';
	@override String gamesUntilRanked({required Object left}) => '랭크를 얻으려면 ${left}판을 더 플레이하세요';
	@override String numOfVictories({required Object wins}) => '~${wins}승';
	@override String get promotionOnNextWin => '승리 시 승급';
	@override String numOfdefeats({required Object losses}) => '~${losses}패';
	@override String get demotionOnNextLoss => '패배 시 강등';
	@override String get records => '기록';
	@override String get nerdStats => '세부 스탯';
	@override String get playstyles => '플레이스타일';
	@override String get horoscopes => '천궁도';
	@override String get relatedAchievements => '관련 업적';
	@override String get season => '시즌';
	@override String get smooth => '부드러운';
	@override String get dateAndTime => '날짜 / 시간';
	@override String get TLfullLBnote => '용량이 크지만, 플레이어들을 스탯으로 줄세우거나 랭크로 걸러낼 수 있게 해 줍니다';
	@override String get rank => '랭크';
	@override String verdictGeneral({required Object rank, required Object n, required Object verdict}) => '${rank} 평균보다 ${n} ${verdict}';
	@override String get verdictBetter => '앞섬';
	@override String get verdictWorse => '뒤쳐짐';
	@override String get localStanding => '국가 순위';
	@override late final _TranslationsXpKoKr xp = _TranslationsXpKoKr._(_root);
	@override late final _TranslationsGametimeKoKr gametime = _TranslationsGametimeKoKr._(_root);
	@override String get whichOne => 'Which one?';
	@override String get track => '추적하기';
	@override String get stopTracking => '추적 취소하기';
	@override String supporter({required Object tier}) => '서포터 ${tier}티어';
	@override String comparingWith({required Object oldDate, required Object newDate}) => '${oldDate} 와 ${newDate} 의 데이터를 비교 중';
	@override String get compare => '비교하기';
	@override String get comparison => '비교';
	@override String get enterUsername => '입력하세요: 닉네임 혹은 \$avgX (X는 랭크를 의미)';
	@override String get general => '일반';
	@override String get badges => '배지들';
	@override String obtainDate({required Object date}) => '${date}에 얻음';
	@override String get assignedManualy => '이 배지는 TETR.IO 관리자에 의해 부여되었습니다';
	@override String get distinguishment => '타이틀';
	@override String get banned => '밴';
	@override String get bannedSubtext => 'TETR.IO 약관이나 규칙을 어기면 밴이 조치됩니다';
	@override String get badStanding => '나쁜 평판';
	@override String get badStandingSubtext => '최소 한 번 밴을 당한 기록이 있습니다';
	@override String get botAccount => '봇 계정';
	@override String botAccountSubtext({required Object botMaintainers}) => '${botMaintainers}에 의해 운영됨';
	@override String get copiedToClipboard => '클립보드에 복사되었습니다!';
	@override String get bio => '자기소개';
	@override String get news => '뉴스';
	@override late final _TranslationsMatchResultKoKr matchResult = _TranslationsMatchResultKoKr._(_root);
	@override late final _TranslationsDistinguishmentsKoKr distinguishments = _TranslationsDistinguishmentsKoKr._(_root);
	@override late final _TranslationsNewsEntriesKoKr newsEntries = _TranslationsNewsEntriesKoKr._(_root);
	@override String rankupMiddle({required Object r}) => '${r} 랭크';
	@override String get copyUserID => '클릭하여 유저 ID를 복사';
	@override String get searchHint => '닉네임 또는 ID';
	@override String get navMenu => '탐색 메뉴';
	@override String get navMenuTooltip => '메뉴 열기';
	@override String get refresh => '정보 새로고침';
	@override String get searchButton => '검색';
	@override String get trackedPlayers => '추적된 플레이어들';
	@override String get standing => '순위';
	@override String get previousSeasons => '이전 시즌들';
	@override String get checkingCache => 'Checking cache...';
	@override String get fetchingRecords => 'Fetching Records...';
	@override String get munching => 'Munching...';
	@override String get outOf => 'out of';
	@override String get replaysDone => 'replays done';
	@override String get analysis => 'Analysis';
	@override String get minomuncherMention => 'via MinoMuncher by Freyhoe';
	@override String get recent => '최근';
	@override String get top => '상위';
	@override String get noRecord => '기록 없음';
	@override String sprintAndBlitsRelevance({required Object date}) => '갱신일: ${date}';
	@override late final _TranslationsSnackBarMessagesKoKr snackBarMessages = _TranslationsSnackBarMessagesKoKr._(_root);
	@override late final _TranslationsErrorsKoKr errors = _TranslationsErrorsKoKr._(_root);
	@override late final _TranslationsActionsKoKr actions = _TranslationsActionsKoKr._(_root);
	@override late final _TranslationsGraphsDestinationKoKr graphsDestination = _TranslationsGraphsDestinationKoKr._(_root);
	@override late final _TranslationsFilterModaleKoKr filterModale = _TranslationsFilterModaleKoKr._(_root);
	@override late final _TranslationsCutoffsDestinationKoKr cutoffsDestination = _TranslationsCutoffsDestinationKoKr._(_root);
	@override late final _TranslationsRankViewKoKr rankView = _TranslationsRankViewKoKr._(_root);
	@override late final _TranslationsStateViewKoKr stateView = _TranslationsStateViewKoKr._(_root);
	@override late final _TranslationsTlMatchViewKoKr tlMatchView = _TranslationsTlMatchViewKoKr._(_root);
	@override late final _TranslationsCalcDestinationKoKr calcDestination = _TranslationsCalcDestinationKoKr._(_root);
	@override late final _TranslationsInfoDestinationKoKr infoDestination = _TranslationsInfoDestinationKoKr._(_root);
	@override late final _TranslationsLeaderboardsDestinationKoKr leaderboardsDestination = _TranslationsLeaderboardsDestinationKoKr._(_root);
	@override late final _TranslationsSavedDataDestinationKoKr savedDataDestination = _TranslationsSavedDataDestinationKoKr._(_root);
	@override late final _TranslationsSettingsDestinationKoKr settingsDestination = _TranslationsSettingsDestinationKoKr._(_root);
	@override late final _TranslationsHomeNavigationKoKr homeNavigation = _TranslationsHomeNavigationKoKr._(_root);
	@override late final _TranslationsGraphsNavigationKoKr graphsNavigation = _TranslationsGraphsNavigationKoKr._(_root);
	@override late final _TranslationsCalcNavigationKoKr calcNavigation = _TranslationsCalcNavigationKoKr._(_root);
	@override late final _TranslationsFirstTimeViewKoKr firstTimeView = _TranslationsFirstTimeViewKoKr._(_root);
	@override late final _TranslationsAboutViewKoKr aboutView = _TranslationsAboutViewKoKr._(_root);
	@override late final _TranslationsStatsKoKr stats = _TranslationsStatsKoKr._(_root);
	@override Map<String, String> get countries => {
		'': '전 세계',
		'AF': '아프가니스탄',
		'AX': '올란드 제도',
		'AL': '알바니아',
		'DZ': '알제리',
		'AS': '미국령 사모아',
		'AD': '안도라',
		'AO': '앙골라',
		'AI': '앵귈라',
		'AQ': '남극',
		'AG': '앤티가 바부다',
		'AR': '아르헨티나',
		'AM': '아르메니아',
		'AW': '아루바',
		'AU': '호주',
		'AT': '오스트리아',
		'AZ': '아제르바이잔',
		'BS': '바하마',
		'BH': '바레인',
		'BD': '방글라데시',
		'BB': '바베이도스',
		'BY': '벨라루스',
		'BE': '벨기에',
		'BZ': '벨리즈',
		'BJ': '베냉',
		'BM': '버뮤다',
		'BT': '부탄',
		'BO': '볼리비아',
		'BA': '보스니아 헤르체고비나',
		'BW': '보츠와나',
		'BV': '부베섬',
		'BR': '브라질',
		'IO': '영국령 인도양 지역',
		'BN': '브루나이',
		'BG': '불가리아',
		'BF': '부르키나파소',
		'BI': '부룬디',
		'KH': '캄보디아',
		'CM': '카메룬',
		'CA': '캐나다',
		'CV': '카보베르데',
		'BQ': '네덜란드령 카리브섬',
		'KY': '케이맨 제도',
		'CF': '중앙아프리카 공화국',
		'TD': '차드',
		'CL': '칠레',
		'CN': '중국',
		'CX': '크리스마스섬',
		'CC': '코코스(킬링)제도',
		'CO': '콜롬비아',
		'KM': '코모로',
		'CG': '콩고',
		'CD': '콩고 민주 공화국',
		'CK': '쿡 제도',
		'CR': '코스타리카',
		'CI': '코트디부아르',
		'HR': '크로아티아',
		'CU': '쿠바',
		'CW': '퀴라소',
		'CY': '키프로스',
		'CZ': '체코',
		'DK': '덴마크',
		'DJ': '지부티',
		'DM': '도미니카',
		'DO': '도미니카 공화국',
		'EC': '에콰도르',
		'EG': '이집트',
		'SV': '엘살바도르',
		'GB-ENG': '잉글랜드',
		'GQ': '적도 기니',
		'ER': '에리트레아',
		'EE': '에스토니아',
		'ET': '에티오피아',
		'EU': '유럽 연합',
		'FK': '포클랜드 제도',
		'FO': '페로 제도',
		'FJ': '피지',
		'FI': '핀란드',
		'FR': '프랑스',
		'GF': '프랑스령 기아나',
		'PF': '프랑스령 폴리네시아',
		'TF': '프랑스령 남방',
		'GA': '가봉',
		'GM': '감비아',
		'GE': '조지아',
		'DE': '독일',
		'GH': '가나',
		'GI': '지브롤터',
		'GR': '그리스',
		'GL': '그린란드',
		'GD': '그레나다',
		'GP': '과들루프',
		'GU': '괌',
		'GT': '과테말라',
		'GG': '건지섬',
		'GN': '기니',
		'GW': '기니비사우',
		'GY': '가이아나',
		'HT': '아이티',
		'HM': '허드 맥도널드 제도',
		'VA': '교황청 (바티칸 시국)',
		'HN': '온두라스',
		'HK': '홍콩',
		'HU': '헝가리',
		'IS': '아이슬란드',
		'IN': '인도',
		'ID': '인도네시아',
		'IR': '이란',
		'IQ': '이라크',
		'IE': '아일랜드',
		'IM': '맨섬',
		'IL': '이스라엘',
		'IT': '이탈리아',
		'JM': '자메이카',
		'JP': '일본',
		'JE': '저지섬',
		'JO': '요르단',
		'KZ': '카자흐스탄',
		'KE': '케냐',
		'KI': '키리바시',
		'KP': '조선민주주의인민공화국',
		'KR': '대한민국',
		'XK': '코소보',
		'KW': '쿠웨이트',
		'KG': '키르기스스탄',
		'LA': '라오스',
		'LV': '라트비아',
		'LB': '레바논',
		'LS': '레소토',
		'LR': '라이베리아',
		'LY': '리비아',
		'LI': '리히텐슈타인',
		'LT': '리투아니아',
		'LU': '룩셈부르크',
		'MO': '마카오',
		'MK': '북마케도니아',
		'MG': '마다가스카르',
		'MW': '말라위',
		'MY': '말레이시아',
		'MV': '몰디브',
		'ML': '말리',
		'MT': '몰타',
		'MH': '마셜 제도',
		'MQ': '마르티니크',
		'MR': '모리타니',
		'MU': '모리셔스',
		'YT': '마요트',
		'MX': '멕시코',
		'FM': '미크로네시아 연방',
		'MD': '몰도바',
		'MC': '모나코',
		'ME': '몬테네그로',
		'MA': '모로코',
		'MN': '몽골',
		'MS': '몬트세랫',
		'MZ': '모잠비크',
		'MM': '미얀마',
		'NA': '나미비아',
		'NR': '나우루',
		'NP': '네팔',
		'NL': '네덜란드',
		'AN': '네덜란드령 안틸레스',
		'NC': '뉴칼레도니아',
		'NZ': '뉴질랜드',
		'NI': '니카라과',
		'NE': '니제르',
		'NG': '나이지리아',
		'NU': '니우에',
		'NF': '노퍽섬',
		'GB-NIR': '북아일랜드',
		'MP': '북마리아나 제도',
		'NO': '노르웨이',
		'OM': '오만',
		'PK': '파키스탄',
		'PW': '팔라우',
		'PS': '팔레스타인',
		'PA': '파나마',
		'PG': '파푸아뉴기니',
		'PY': '파라과이',
		'PE': '페루',
		'PH': '필리핀',
		'PN': '핏케언 제도',
		'PL': '폴란드',
		'PT': '포르투갈',
		'PR': '푸에르토리코',
		'QA': '카타르',
		'RE': '레위니옹',
		'RO': '루마니아',
		'RU': '러시아',
		'RW': '르완다',
		'BL': '생바르텔레미',
		'SH': '세인트헬레나 어센션 트리스탄다쿠냐',
		'KN': '세인트키츠 네비스',
		'LC': '세인트 루시아',
		'MF': '생마르탱',
		'PM': '생피에르 미클롱',
		'VC': '세인트 빈센트 그레나딘',
		'WS': '사모아',
		'SM': '산마리노',
		'ST': '상투메 프린시페',
		'SA': '사우디아라비아',
		'GB-SCT': '스코틀랜드',
		'SN': '세네갈',
		'RS': '세르비아',
		'SC': '세이셸',
		'SL': '시에라리온',
		'SG': '싱가포르',
		'SX': '신트마르턴 (네덜란드령)',
		'SK': '슬로바키아',
		'SI': '슬로베니아',
		'SB': '솔로몬 제도',
		'SO': '소말리아',
		'ZA': '남아프리카 공화국',
		'GS': '사우스조지아 사우스샌드위치 제도',
		'SS': '남수단',
		'ES': '스페인',
		'LK': '스리랑카',
		'SD': '수단',
		'SR': '수리남',
		'SJ': '스발바르 얀마옌 제도',
		'SZ': '에스와티니',
		'SE': '스웨덴',
		'CH': '스위스',
		'SY': '시리아',
		'TW': '대만',
		'TJ': '타지키스탄',
		'TZ': '탄자니아',
		'TH': '태국',
		'TL': '동티모르',
		'TG': '토고',
		'TK': '토켈라우',
		'TO': '통가',
		'TT': '트리니다드 토바고',
		'TN': '튀니지',
		'TR': '튀르키예',
		'TM': '투르크메니스탄',
		'TC': '터크스 케이커스 제도',
		'TV': '투발루',
		'UG': '우간다',
		'UA': '우크라이나',
		'AE': '아랍에미리트',
		'GB': '영국',
		'US': '미국',
		'UY': '우루과이',
		'UM': '미국령 군소 제도',
		'UZ': '우즈베키스탄',
		'VU': '바누아투',
		'VE': '볼리비아 베네수엘라',
		'VN': '베트남',
		'VG': '영국령 버진아일랜드',
		'VI': '미국령 버진아일랜드',
		'GB-WLS': '웨일스',
		'WF': '왈리스 푸투나 제도',
		'EH': '서사하라',
		'YE': '예멘',
		'ZM': '잠비아',
		'ZW': '짐바브웨',
		'XX': '국적 정보 없음',
		'XM': '달',
	};
}

// Path: destinations
class _TranslationsDestinationsKoKr implements TranslationsDestinationsEn {
	_TranslationsDestinationsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get home => '홈';
	@override String get graphs => '그래프';
	@override String get leaderboards => '리더보드';
	@override String get cutoffs => '커트라인';
	@override String get calc => '계산기';
	@override String get info => '정보';
	@override String get data => '저장된 데이터';
	@override String get settings => '설정';
}

// Path: xp
class _TranslationsXpKoKr implements TranslationsXpEn {
	_TranslationsXpKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '경험치 레벨';
	@override String progressToNextLevel({required Object percentage}) => '다음 레벨까지 ${percentage}';
	@override String progressTowardsGoal({required Object goal, required Object percentage, required Object left}) => '0 XP에서 레벨 ${goal}까지 진행도: ${percentage} (${left} XP 남음)';
}

// Path: gametime
class _TranslationsGametimeKoKr implements TranslationsGametimeEn {
	_TranslationsGametimeKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '정확한 플레이 시간';
	@override String gametimeAday({required Object gametime}) => '일평균 ${gametime}';
	@override String breakdown({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => '${years}년, \n또는 ${months}개월,\n또는 ${days}일,\n또는 ${minutes}분,\n또는 ${seconds}초';
}

// Path: matchResult
class _TranslationsMatchResultKoKr implements TranslationsMatchResultEn {
	_TranslationsMatchResultKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get victory => '승리';
	@override String get defeat => '패배';
	@override String get tie => '무승부';
	@override String get dqvictory => '상대의 연결이 끊어짐';
	@override String get dqdefeat => '실격패';
	@override String get nocontest => '경기 취소';
	@override String get nullified => '경기 무효';
}

// Path: distinguishments
class _TranslationsDistinguishmentsKoKr implements TranslationsDistinguishmentsEn {
	_TranslationsDistinguishmentsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get noHeader => '헤더를 찾을 수 없음';
	@override String get noFooter => '푸터를 찾을 수 없음';
	@override String get twc => 'TETR.IO 세계 챔피언';
	@override String twcYear({required Object year}) => '${year} TETR.IO 세계 챔피언십';
}

// Path: newsEntries
class _TranslationsNewsEntriesKoKr implements TranslationsNewsEntriesEn {
	_TranslationsNewsEntriesKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override TextSpan leaderboard({required InlineSpan gametype, required InlineSpan rank}) => TextSpan(children: [
		gametype,
		const TextSpan(text: '에서 '),
		rank,
		const TextSpan(text: '등을 달성했습니다'),
	]);
	@override TextSpan personalbest({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
		gametype,
		const TextSpan(text: '에서 '),
		pb,
		const TextSpan(text: '의 최고 기록을 달성했습니다'),
	]);
	@override TextSpan badge({required InlineSpan badge}) => TextSpan(children: [
		const TextSpan(text: '배지 획득: '),
		badge,
	]);
	@override TextSpan rankup({required InlineSpan rank}) => TextSpan(children: [
		const TextSpan(text: '테트라 리그 '),
		rank,
		const TextSpan(text: ' 달성'),
	]);
	@override TextSpan supporter({required InlineSpanBuilder s}) => TextSpan(children: [
		s('TETR.IO supporter'),
		const TextSpan(text: ' 가 되었습니다'),
	]);
	@override TextSpan supporter_gift({required InlineSpanBuilder s}) => TextSpan(children: [
		s('TETR.IO supporter'),
		const TextSpan(text: ' 를 선물받았습니다'),
	]);
	@override TextSpan unknown({required InlineSpan type}) => TextSpan(children: [
		type,
		const TextSpan(text: ' 종류의 확인되지 않은 소식'),
	]);
}

// Path: snackBarMessages
class _TranslationsSnackBarMessagesKoKr implements TranslationsSnackBarMessagesEn {
	_TranslationsSnackBarMessagesKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String stateRemoved({required Object date}) => '${date} 상태가 데이터베이스에서 제거되었어요!';
	@override String matchRemoved({required Object date}) => '${date} 매치가 데이터베이스에서 제거되었어요!';
	@override String get notForWeb => '웹 버전은 지원하지 않는 기능이에요';
	@override String get importSuccess => '불러오기 성공';
	@override String get importCancelled => '불러오기 거부됨';
}

// Path: errors
class _TranslationsErrorsKoKr implements TranslationsErrorsEn {
	_TranslationsErrorsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get noRecords => '기록 없음';
	@override String get notEnoughData => '데이터가 충분하지 않음';
	@override String get noHistorySaved => '저장된 기록 없음';
	@override String connection({required Object code, required Object message}) => '연결 문제 발생: ${code} ${message}';
	@override String get noSuchUser => '사용자를 찾을 수 없습니다';
	@override String get noSuchUserSub => '당신이 오타를 냈거나, 그 계정이 사라졌을 수 있습니다';
	@override String get discordNotAssigned => '연결을 찾을 수 없습니다';
	@override String get discordNotAssignedSub => '쿼리는 [API 가이드](https://tetr.io/about/api/#userssearchquery)에 설명된 대로 표시되어야 합니다';
	@override String get history => '기록 찾기 실패';
	@override String get actionSuggestion => '이것을 찾으셨나요?';
	@override String get p1nkl0bst3rTLmatches => '테트라 리그 기록 없음';
	@override String get clientException => '인터넷 연결 없음';
	@override String get forbidden => '당신의 IP주소가 차단되었습니다';
	@override String forbiddenSub({required Object nickname}) => '만약 VPN이나 프록시 우회를 사용하고 계신다면 꺼 주세요. 그래도 문제가 발생하면, ${nickname} 에게 문의해 주세요';
	@override String get tooManyRequests => '레이트 리밋에 걸렸습니다.';
	@override String get tooManyRequestsSub => '잠시 기다렸다가 다시 시도해주세요';
	@override String get internal => 'TETR.IO측에 문제가 일어났습니다';
	@override String get internalSub => '(osk는 이 문제에 대해 이미 알고 있을 것입니다)';
	@override String get internalWebVersion => 'TETR.IO측 (또는 oskware_bridge, 솔직히 잘은 모르겠네요)에 문제가 일어났습니다';
	@override String get internalWebVersionSub => '만약 osk의 서버 상태 페이지(status.osk.sh)에 오류가 없다고 나온다면, dan63047에게 이 문제를 알려주세요';
	@override String get oskwareBridge => 'oskware_bridge에 문제가 일어났습니다';
	@override String get oskwareBridgeSub => 'dan63047에게 이 문제를 알려주세요';
	@override String get p1nkl0bst3rForbidden => '서드 파티 API가 당신의 IP 주소를 차단했습니다';
	@override String get p1nkl0bst3rTooManyRequests => '서드 파티 API에 너무 많은 요청이 들어왔습니다. 나중에 다시 시도해 주세요';
	@override String get p1nkl0bst3rinternal => 'p1nkl0bst3r측에 문제가 일어났습니다';
	@override String get p1nkl0bst3rinternalWebVersion => 'p1nkl0bst3r 측 (또는 oskware_bridge, 솔직히 잘은 모르겠네요)에 문제가 일어났습니다';
	@override String get replayAlreadySaved => '리플레이가 이미 저장됨';
	@override String get replayExpired => '리플레이가 만료되었으며 더 이상 볼 수 없습니다';
	@override String get replayRejected => '서드 파티 API가 당신의 IP 주소를 차단했습니다';
}

// Path: actions
class _TranslationsActionsKoKr implements TranslationsActionsEn {
	_TranslationsActionsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get submit => '제출';
	@override String get ok => '확인';
	@override String get apply => '적용';
	@override String get refresh => '새로고침';
}

// Path: graphsDestination
class _TranslationsGraphsDestinationKoKr implements TranslationsGraphsDestinationEn {
	_TranslationsGraphsDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get fetchAndsaveTLHistory => '기록 불러오기';
	@override String get fetchAndSaveOldTLmatches => '테트라 리그 경기 기록 불러오기';
	@override String fetchAndsaveTLHistoryResult({required Object number}) => '${number}개 상태가 발견됨';
	@override String fetchAndSaveOldTLmatchesResult({required Object number}) => '${number} 개의 경기를 찾았습니다';
	@override String gamesPlayed({required Object games}) => '${games} 판 플레이함';
	@override String get dateAndTime => '날짜 및 시간';
	@override String get filterModaleTitle => '랭크별로 그래프 필터링하기';
}

// Path: filterModale
class _TranslationsFilterModaleKoKr implements TranslationsFilterModaleEn {
	_TranslationsFilterModaleKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get all => '모두';
}

// Path: cutoffsDestination
class _TranslationsCutoffsDestinationKoKr implements TranslationsCutoffsDestinationEn {
	_TranslationsCutoffsDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '테트라 리그 상황';
	@override String relevance({required Object timestamp}) => '${timestamp} 기준';
	@override String get actual => '실제';
	@override String get target => '목표';
	@override String get cutoffTR => '현재 커트라인';
	@override String get targetTR => '의도된 커트라인';
	@override String get state => '인플레이션/디플레이션';
	@override String get advanced => '고급';
	@override String players({required Object n}) => '플레이어 수 (${n})';
	@override String get moreInfo => '추가 정보';
	@override String NumberOne({required Object tr}) => '현재 1위: ${tr} TR';
	@override String inflated({required Object tr}) => '${tr} TR 인플레이션';
	@override String get notInflated => '인플레이션 없음';
	@override String deflated({required Object tr}) => '${tr} TR 디플레이션';
	@override String get notDeflated => '디플레이션 없음';
	@override String get wellDotDotDot => '음...';
	@override String fromPlace({required Object n}) => '${n}위까지';
	@override String get viewButton => '보기';
}

// Path: rankView
class _TranslationsRankViewKoKr implements TranslationsRankViewEn {
	_TranslationsRankViewKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String rankTitle({required Object rank}) => '${rank} 랭크 정보';
	@override String get everyoneTitle => '전체 리더보드';
	@override String get trRange => 'TR 범위';
	@override String get supposedToBe => '의도된 범위';
	@override String gap({required Object value}) => '${value} 범위';
	@override String trGap({required Object value}) => '${value} TR 범위';
	@override String get deflationGap => '디플레이션 범위';
	@override String get inflationGap => '인플레이션 범위';
	@override String get LBposRange => '리더보드 순위 구간';
	@override String overpopulated({required Object players}) => '실제로는 ${players} 더 많음';
	@override String underpopulated({required Object players}) => '실제로는 ${players} 더 적음';
	@override String get PlayersEqualSupposedToBe => '귀엽다';
	@override String get avgStats => '평균 스탯';
	@override String avgForRank({required Object rank}) => '${rank} 랭크 평균';
	@override String get avgNerdStats => '평균 세부 스탯';
	@override String get minimums => '최소';
	@override String get maximums => '최대';
}

// Path: stateView
class _TranslationsStateViewKoKr implements TranslationsStateViewEn {
	_TranslationsStateViewKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String title({required Object date}) => '${date} 당시 상태';
}

// Path: tlMatchView
class _TranslationsTlMatchViewKoKr implements TranslationsTlMatchViewEn {
	_TranslationsTlMatchViewKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get match => '경기';
	@override String get vs => 'vs';
	@override String get winner => '승자';
	@override String roundNumber({required Object n}) => '라운드 ${n}';
	@override String get statsFor => '스탯의 분야:';
	@override String get numberOfRounds => '라운드 수';
	@override String get matchLength => '경기 길이';
	@override String get roundLength => '라운드 길이';
	@override String get matchStats => '경기 스탯';
	@override String get downloadReplay => '.ttrm 리플레이 다운로드';
	@override String get openReplay => 'TETR.IO에서 리플레이 열기';
}

// Path: calcDestination
class _TranslationsCalcDestinationKoKr implements TranslationsCalcDestinationEn {
	_TranslationsCalcDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String placeholders({required Object stat}) => '당신의 ${stat}을 입력하세요';
	@override String get tip => '값을 입력하고 "계산" 버튼을 눌러 세부 스탯을 확인하세요';
	@override String get invalidValues => 'Please, enter valid values';
	@override String get statsCalcButton => '계산';
	@override String get damageCalcTip => '왼쪽에서 줄 클리어를 눌러 여기 추가하세요';
	@override String get clearAll => 'Clear all';
	@override String get actions => '줄 클리어';
	@override String get results => '결과';
	@override String get rules => '규칙';
	@override String get noSpinClears => '스핀이 아닌 줄 클리어';
	@override String get spins => '스핀';
	@override String get miniSpins => '스핀 미니';
	@override String get noLineclear => '줄 클리어 없음 (콤보 끊김)';
	@override String get custom => '직접 입력';
	@override String get multiplier => '멀티플라이어';
	@override String get pcDamage => '퍼펙트 클리어 데미지';
	@override String get comboTable => '콤보 테이블';
	@override String get b2bChaining => '백투백 체인';
	@override String get surgeStartAtB2B => '서지가 시작되는 백투백';
	@override String get surgeStartAmount => '서지 시작 시 대미지';
	@override String get totalDamage => '총 대미지';
	@override String get lineclears => '지운 줄';
	@override String get combo => '콤보';
	@override String get surge => '서지';
	@override String get pcs => '퍼펙트 클리어';
}

// Path: infoDestination
class _TranslationsInfoDestinationKoKr implements TranslationsInfoDestinationEn {
	_TranslationsInfoDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '정보';
	@override String get sprintAndBlitzAverages => '40 라인 & 블리츠 랭크별 평균치';
	@override String get sprintAndBlitzAveragesDescription => '40 라인과 블리츠 평균을 계산하는 것은 고된 작업이기 때문에 가끔씩 업데이트됩니다. 전체 40 라인과 블리츠 평균 표를 보려면 제목을 클릭하세요';
	@override String get tetraStatsWiki => 'Tetra Stats 위키 (영어)';
	@override String get tetraStatsWikiDescription => 'Tetra Stats가 제공하는 기능과 통계에 대한 더 자세한 정보를 알아보세요';
	@override String get about => 'Tetra Stats에 대해';
	@override String get aboutDescription => 'dan63에 의해 제작됨\n';
}

// Path: leaderboardsDestination
class _TranslationsLeaderboardsDestinationKoKr implements TranslationsLeaderboardsDestinationEn {
	_TranslationsLeaderboardsDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '리더보드';
	@override String get tl => '테트라 리그 (현재 시즌)';
	@override String get fullTL => '테트라 리그 (현재 시즌, 전체 스탯)';
	@override String get ar => '업적 점수';
}

// Path: savedDataDestination
class _TranslationsSavedDataDestinationKoKr implements TranslationsSavedDataDestinationEn {
	_TranslationsSavedDataDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '저장된 정보';
	@override String get tip => '왼쪽의 닉네임을 누르시면 정보가 표시됩니다';
	@override String seasonTLstates({required Object s}) => '시즌 ${s} 테트라 리그 상황';
	@override String get TLrecords => '테트라 리그 기록';
}

// Path: settingsDestination
class _TranslationsSettingsDestinationKoKr implements TranslationsSettingsDestinationEn {
	_TranslationsSettingsDestinationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => '설정';
	@override String get general => '일반';
	@override String get customization => '사용자 설정';
	@override String get database => '로컬 데이터베이스';
	@override String get checking => '확인 중...';
	@override String get enterToSubmit => 'Enter 키를 눌러 제출하세요';
	@override String get account => '당신의 TETR.IO 계정';
	@override String get accountDescription => '앱이 실행되면 해당 플레이어의 스탯이 불러와집니다. 나의 (dan63) 스탯을 불러오는 게 기본값입니다. 바꾸려면, 당신의 닉네임을 입력하세요.';
	@override String get done => '완료!';
	@override String get noSuchAccount => '그런 계정이 없음';
	@override String get language => '언어';
	@override String languageDescription({required Object languages}) => 'Tetra Stats는 ${languages}로 번역되었습니다. 기본적으로 이 앱은 사용자의 시스템 언어를 고르지만, 만약 시스템 언어 번역이 지원되지 않는다면 영어를 고릅니다.';
	@override String languages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		zero: '0개의 언어',
		one: '${n}개의 언어',
		two: '${n}개의 언어',
		few: '${n}개의 언어',
		many: '${n}개의 언어',
		other: '${n}개의 언어',
	);
	@override String get updateInTheBackground => '백그라운드에서 정보 업데이트';
	@override String get updateInTheBackgroundDescription => '켜져 있다면, Tetra Stats는 캐시가 만료될 때마다 새로운 정보를 받으려고 시도할 것입니다. 주로 이는 5분마다 일어납니다.';
	@override String get compareStats => '테트라 리그 스탯을 랭크 평균과 비교하기';
	@override String get compareStatsDescription => '켜져 있다면, Tetra Stats는 당신이 당신의 랭크의 평균적인 플레이어와 스탯을 비교할 수 있도록 당신의 스탯을 알맞은 색으로 강조할 것입니다. 스탯 위에 커서를 올려 더 많은 정보를 확인하세요.';
	@override String get showPosition => '리더보드에서 스탯별 순위 표시';
	@override String get showPositionDescription => '켜져 있다면, 로딩 시간이 더 길어지지만 당신의 스탯별 순위를 볼 수 있도록 합니다';
	@override String get accentColor => '강조 색';
	@override String get accentColorDescription => '강조 색은 앱 곳곳에서 주로 상호작용 가능한 요소를 강조하기 위해 사용됩니다.';
	@override String get accentColorModale => '강조 색 고르기';
	@override String get timestamps => '시간 표시 형식';
	@override String timestampsDescriptionPart1({required Object d}) => '시각 표시 형식을 고릅니다. 기본 설정은 협정 세계시 (UTC)기준 시각을 언어에 맞는 형식으로 표시하는 것입니다. 예시: ${d}.';
	@override String timestampsDescriptionPart2({required Object y, required Object r}) => '또한 다음과 같은 시간 표시 형식도 고를 수 있습니다:\n• 언어에 맞는 형식, 사용자의 시간대: ${y}\n• 상대적인 시간 표시: ${r}';
	@override String get timestampsAbsoluteGMT => '협정 세계시 (UTC) 기준';
	@override String get timestampsAbsoluteLocalTime => '사용자의 시간대 기준';
	@override String get timestampsRelative => '상대적인 시간 표시';
	@override String get sheetbotLikeGraphs => '레이더 그래프를 Sheetbot의 형식으로 표시';
	@override String get sheetbotLikeGraphsDescription => '저는 Sheetbot 형식의 레이더 그래프가 별로 정확하지 않다고 판단하였지만, 몇몇 사람들은 -0.5 스트라이딩 스탯이 Sheetbot 그래프에서처럼 표시되지 않는 것을 보고 혼란스러워 했습니다. 따라서, 이 설정이 켜져 있다면, 레이더 그래프의 점들은 스탯이 음수일 때 반대쪽에 나타날 것입니다.';
	@override String get oskKagariGimmick => 'Osk-Kagari 기믹';
	@override String get oskKagariGimmickDescription => '켜져 있다면, osk의 랭크 대신 :kagari:가 표시됩니다.';
	@override String get bytesOfDataStored => '만큼의 데이터가 저장됨';
	@override String get TLrecordsSaved => '테트라 리그 기록 저장됨';
	@override String get TLplayerstatesSaved => '테트라 리그 플레이어스탯 저장됨';
	@override String get fixButton => '수정';
	@override String get compressButton => '압축';
	@override String get exportDB => '로컬 저장소로 내보내기';
	@override String get desktopExportAlertTitle => '데스크탑용 내보내기';
	@override String get desktopExportText => '데스크탑 버전으로 앱을 사용하시는 것 같군요. 문서 폴더로 들어가서, "TetraStats.db"를 찾고, 어딘가로 복사하세요';
	@override String get androidExportAlertTitle => '안드로이드용 내보내기';
	@override String androidExportText({required Object exportedDB}) => '내보내기 완료.\n${exportedDB}';
	@override String get importDB => '로컬 저장소에서 가져오기';
	@override String get importDBDescription => '백업을 복구합니다. 저장되어 있던 데이터베이스가 덮어씌워질 것임을 알려드립니다.';
	@override String get importWrongFileType => '잘못된 파일 형식';
}

// Path: homeNavigation
class _TranslationsHomeNavigationKoKr implements TranslationsHomeNavigationEn {
	_TranslationsHomeNavigationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get overview => '둘러보기';
	@override String get standing => '순위';
	@override String get seasons => '시즌';
	@override String get mathces => '매치';
	@override String get pb => '개인 최고 기록';
	@override String get normal => '일반';
	@override String get expert => '전문가';
	@override String get expertRecords => '기록 내보내기';
}

// Path: graphsNavigation
class _TranslationsGraphsNavigationKoKr implements TranslationsGraphsNavigationEn {
	_TranslationsGraphsNavigationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get history => '플레이어 기록';
	@override String get league => '리그 현황';
	@override String get cutoffs => '커트라인 기록';
}

// Path: calcNavigation
class _TranslationsCalcNavigationKoKr implements TranslationsCalcNavigationEn {
	_TranslationsCalcNavigationKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get stats => '스탯 계산기';
	@override String get damage => '데미지 계산기';
}

// Path: firstTimeView
class _TranslationsFirstTimeViewKoKr implements TranslationsFirstTimeViewEn {
	_TranslationsFirstTimeViewKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Tetra Stats에 오신 것을 환영합니다';
	@override String get description => 'TETR.IO에 대한 다양한 통계를 추적할 수 있는 서비스';
	@override String get nicknameQuestion => '당신의 TETR.IO 닉네임은 무엇인가요?';
	@override String get inpuntHint => '여기 입력해주세요...(3-16자)';
	@override String get emptyInputError => '닉네임을 입력해 주세요';
	@override String niceToSeeYou({required Object n}) => '반갑습니다, ${n}';
	@override String get letsTakeALook => '당신의 통계를 살펴보겠습니다...';
	@override String get skip => '건너뛰기';
}

// Path: aboutView
class _TranslationsAboutViewKoKr implements TranslationsAboutViewEn {
	_TranslationsAboutViewKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tetra Stats에 대해';
	@override String get about => 'Tetra Stats는 TETR.IO 테트라 채널의 API를 활용하여 정보를 제공하고, 이 정보에 따른 추가적인 수치를 계산하는 서비스입니다. 이 서비스는 사용자가 테트라 리그에서 어떻게 발전하는지 추적할 수 있는 "추적" 기능을 제공합니다. 이 기능은 모든 테트라 리그에서의 변화를 로컬 데이터베이스에 기록하여(실시간으로 기록되지는 않습니다) 사용자가 이를 그래프로 볼 수 있도록 합니다. \n\nBeanserver Blaster는 Tetra Stats의 일부이며, 서버 사이드 스크립트로 떨어져 나왔습니다. Beanserver Blaster는 테트라 리그의 완전한 리더보드와 랭크 컷 등의 정보를 제공하여 Tetra Stats가 리더보드를 원하는 방식으로 정렬하고, 산점도 그래프를 그릴 수 있도록 돕는 역할을 합니다. 이를 통해 사용자는 테트라 리그의 추세를 분석할 수 있습니다. \n\n앞으로 리플레이 분석과 대회 기록 기능을 추가할 계획이 있으니, 계속해서 이 프로젝트에 관심을 기울여 주세요!\n\n이 서비스는 어떠한 방식으로도 TETR.IO 또는 osk와 직접적으로 연관되어 있지 않습니다.';
	@override String get appVersion => '앱 버전';
	@override String build({required Object build}) => '빌드 ${build}';
	@override String get GHrepo => '깃헙 리포지트리';
	@override String get submitAnIssue => '문제 보고하기';
	@override String get credits => '크레딧';
	@override String get authorAndDeveloper => '제작 & 개발';
	@override String get providedFormulas => '공식 제공';
	@override String get providedS1history => '테트라 리그 시즌 1 기록 제공';
	@override String get inoue => 'Inoue (리플레이 그래버)';
	@override String get zhCNlocale => '중국어 간체 번역';
	@override String get deDElocale => '독일어 번역';
	@override String get koKRlocale => '한국어 번역';
	@override String get supportHim => '후원하기';
}

// Path: stats
class _TranslationsStatsKoKr implements TranslationsStatsEn {
	_TranslationsStatsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get registrationDate => '가입일';
	@override String get gametime => '플레이 시간';
	@override String get ogp => '온라인 게임을 플레이함';
	@override String get ogw => '온라인 게임을 이김';
	@override String get followers => '팔로워';
	@override late final _TranslationsStatsXpKoKr xp = _TranslationsStatsXpKoKr._(_root);
	@override late final _TranslationsStatsTrKoKr tr = _TranslationsStatsTrKoKr._(_root);
	@override late final _TranslationsStatsGlickoKoKr glicko = _TranslationsStatsGlickoKoKr._(_root);
	@override late final _TranslationsStatsRdKoKr rd = _TranslationsStatsRdKoKr._(_root);
	@override late final _TranslationsStatsGlixareKoKr glixare = _TranslationsStatsGlixareKoKr._(_root);
	@override late final _TranslationsStatsS1trKoKr s1tr = _TranslationsStatsS1trKoKr._(_root);
	@override late final _TranslationsStatsGpKoKr gp = _TranslationsStatsGpKoKr._(_root);
	@override late final _TranslationsStatsGwKoKr gw = _TranslationsStatsGwKoKr._(_root);
	@override late final _TranslationsStatsWinrateKoKr winrate = _TranslationsStatsWinrateKoKr._(_root);
	@override late final _TranslationsStatsApmKoKr apm = _TranslationsStatsApmKoKr._(_root);
	@override late final _TranslationsStatsPpsKoKr pps = _TranslationsStatsPpsKoKr._(_root);
	@override late final _TranslationsStatsVsKoKr vs = _TranslationsStatsVsKoKr._(_root);
	@override late final _TranslationsStatsAppKoKr app = _TranslationsStatsAppKoKr._(_root);
	@override late final _TranslationsStatsVsapmKoKr vsapm = _TranslationsStatsVsapmKoKr._(_root);
	@override late final _TranslationsStatsDssKoKr dss = _TranslationsStatsDssKoKr._(_root);
	@override late final _TranslationsStatsDspKoKr dsp = _TranslationsStatsDspKoKr._(_root);
	@override late final _TranslationsStatsAppdspKoKr appdsp = _TranslationsStatsAppdspKoKr._(_root);
	@override late final _TranslationsStatsCheeseKoKr cheese = _TranslationsStatsCheeseKoKr._(_root);
	@override late final _TranslationsStatsGbeKoKr gbe = _TranslationsStatsGbeKoKr._(_root);
	@override late final _TranslationsStatsNyaappKoKr nyaapp = _TranslationsStatsNyaappKoKr._(_root);
	@override late final _TranslationsStatsAreaKoKr area = _TranslationsStatsAreaKoKr._(_root);
	@override late final _TranslationsStatsEtrKoKr etr = _TranslationsStatsEtrKoKr._(_root);
	@override late final _TranslationsStatsEtraccKoKr etracc = _TranslationsStatsEtraccKoKr._(_root);
	@override late final _TranslationsStatsOpenerKoKr opener = _TranslationsStatsOpenerKoKr._(_root);
	@override late final _TranslationsStatsPlonkKoKr plonk = _TranslationsStatsPlonkKoKr._(_root);
	@override late final _TranslationsStatsStrideKoKr stride = _TranslationsStatsStrideKoKr._(_root);
	@override late final _TranslationsStatsInfdsKoKr infds = _TranslationsStatsInfdsKoKr._(_root);
	@override late final _TranslationsStatsAltitudeKoKr altitude = _TranslationsStatsAltitudeKoKr._(_root);
	@override late final _TranslationsStatsClimbSpeedKoKr climbSpeed = _TranslationsStatsClimbSpeedKoKr._(_root);
	@override late final _TranslationsStatsPeakClimbSpeedKoKr peakClimbSpeed = _TranslationsStatsPeakClimbSpeedKoKr._(_root);
	@override late final _TranslationsStatsKosKoKr kos = _TranslationsStatsKosKoKr._(_root);
	@override late final _TranslationsStatsB2bKoKr b2b = _TranslationsStatsB2bKoKr._(_root);
	@override late final _TranslationsStatsFinesseKoKr finesse = _TranslationsStatsFinesseKoKr._(_root);
	@override late final _TranslationsStatsFinesseFaultsKoKr finesseFaults = _TranslationsStatsFinesseFaultsKoKr._(_root);
	@override late final _TranslationsStatsTotalTimeKoKr totalTime = _TranslationsStatsTotalTimeKoKr._(_root);
	@override late final _TranslationsStatsLevelKoKr level = _TranslationsStatsLevelKoKr._(_root);
	@override late final _TranslationsStatsPiecesKoKr pieces = _TranslationsStatsPiecesKoKr._(_root);
	@override late final _TranslationsStatsSppKoKr spp = _TranslationsStatsSppKoKr._(_root);
	@override late final _TranslationsStatsKpKoKr kp = _TranslationsStatsKpKoKr._(_root);
	@override late final _TranslationsStatsKppKoKr kpp = _TranslationsStatsKppKoKr._(_root);
	@override late final _TranslationsStatsKpsKoKr kps = _TranslationsStatsKpsKoKr._(_root);
	@override late final _TranslationsStatsAplKoKr apl = _TranslationsStatsAplKoKr._(_root);
	@override late final _TranslationsStatsQuadEfficiencyKoKr quadEfficiency = _TranslationsStatsQuadEfficiencyKoKr._(_root);
	@override late final _TranslationsStatsTspinEfficiencyKoKr tspinEfficiency = _TranslationsStatsTspinEfficiencyKoKr._(_root);
	@override late final _TranslationsStatsAllspinEfficiencyKoKr allspinEfficiency = _TranslationsStatsAllspinEfficiencyKoKr._(_root);
	@override String blitzScore({required Object p}) => '${p}점';
	@override String levelUpRequirement({required Object p}) => '레벨업까지 ${p}점';
	@override String get piecesTotal => '놓은 미노 수';
	@override String get piecesWithPerfectFinesse => '피네스를 지킨 미노';
	@override String get score => '점수';
	@override String get lines => '줄';
	@override String get linesShort => '줄';
	@override String get pcs => '퍼펙트 클리어';
	@override String get holds => '홀드';
	@override String get spike => '최고 스파이크';
	@override String top({required Object percentage}) => '상위 ${percentage}';
	@override String topRank({required Object rank}) => '최고 랭크: ${rank}';
	@override String get floor => '층수';
	@override String get split => '부분';
	@override String get total => '전체';
	@override String get sent => '보낸 줄';
	@override String get received => '받은 줄';
	@override String get placement => '위치';
	@override String get peak => '고점';
	@override String get overall => 'Overall';
	@override String get midgame => 'Midgame';
	@override String get efficiency => 'Efficiency';
	@override String get upstack => 'Upstack';
	@override String get downstack => 'Downstack';
	@override String get variance => 'Variance';
	@override String get burst => 'Burst';
	@override String get length => 'Length';
	@override String get rate => 'Rate';
	@override String get secsDS => 'Secs/DS';
	@override String get secsCheese => 'Secs/Cheese';
	@override String get attackCheesiness => 'Attack Cheesiness';
	@override String get downstackingRatio => 'Downstacking Ratio';
	@override String get clearTypes => 'Clear Types';
	@override String get wellColumnDistribution => 'Well Column Distribution';
	@override String get allSpins => 'All Spins';
	@override String get sankeyTitle => 'Incoming Attack Sankey Chart';
	@override String get incomingAttack => 'Incoming Attack';
	@override String get clean => 'Clean';
	@override String get cancelled => 'Cancelled';
	@override String get cheeseTanked => 'Cheese Tanked';
	@override String get cleanTanked => 'Clean Tanked';
	@override String get kills => 'Kills';
	@override String get deaths => 'Deaths';
	@override String get ppsDistribution => 'PPS distribution';
	@override String qpWithMods({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		one: '1개 모드 사용',
		two: '${n}개 모드 사용',
		few: '${n}개 모드 사용',
		many: '${n}개 모드 사용',
		other: '${n}개 모드 사용',
	);
	@override String inputs({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		zero: '키를 ${n}번 누름',
		one: '키를 ${n}번 누름',
		two: '키를 ${n}번 누름',
		few: '키를 ${n}번 누름',
		many: '키를 ${n}번 누름',
		other: '키를 ${n}번 누름',
	);
	@override String tspinsTotal({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		zero: '총 ${n}번의 T스핀 수행',
		one: '총 ${n}번의 T스핀 수행',
		two: '총 ${n}번의 T스핀 수행',
		few: '총 ${n}번의 T스핀 수행',
		many: '총 ${n}번의 T스핀 수행',
		other: '총 ${n}번의 T스핀 수행',
	);
	@override String linesCleared({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		zero: '${n}줄 제거',
		one: '${n}줄 제거',
		two: '${n}줄 제거',
		few: '${n}줄 제거',
		many: '${n}줄 제거',
		other: '${n}줄 제거',
	);
	@override late final _TranslationsStatsGraphsKoKr graphs = _TranslationsStatsGraphsKoKr._(_root);
	@override String players({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		zero: '${n} 플레이어',
		one: '${n} 플레이어',
		two: '${n} 플레이어',
		few: '${n} 플레이어',
		many: '${n} 플레이어',
		other: '${n} 플레이어',
	);
	@override String games({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
		zero: '${n} 게임',
		one: '${n} 게임',
		two: '${n} 게임',
		few: '${n} 게임',
		many: '${n} 게임',
		other: '${n} 게임',
	);
	@override late final _TranslationsStatsLineClearKoKr lineClear = _TranslationsStatsLineClearKoKr._(_root);
	@override late final _TranslationsStatsLineClearsKoKr lineClears = _TranslationsStatsLineClearsKoKr._(_root);
	@override String get mini => '미니';
	@override String get tSpin => 'T스핀';
	@override String get tSpins => 'T스핀';
	@override String get spin => '스핀';
	@override String get spins => '스핀';
}

// Path: stats.xp
class _TranslationsStatsXpKoKr implements TranslationsStatsXpEn {
	_TranslationsStatsXpKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'XP';
	@override String get full => '경험치';
}

// Path: stats.tr
class _TranslationsStatsTrKoKr implements TranslationsStatsTrEn {
	_TranslationsStatsTrKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'TR';
	@override String get full => '테트라 레이팅';
}

// Path: stats.glicko
class _TranslationsStatsGlickoKoKr implements TranslationsStatsGlickoEn {
	_TranslationsStatsGlickoKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Glicko';
	@override String get full => '글리코';
}

// Path: stats.rd
class _TranslationsStatsRdKoKr implements TranslationsStatsRdEn {
	_TranslationsStatsRdKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'RD';
	@override String get full => '레이팅 편차';
}

// Path: stats.glixare
class _TranslationsStatsGlixareKoKr implements TranslationsStatsGlixareEn {
	_TranslationsStatsGlixareKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'GXE';
	@override String get full => 'GLIXARE';
}

// Path: stats.s1tr
class _TranslationsStatsS1trKoKr implements TranslationsStatsS1trEn {
	_TranslationsStatsS1trKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '시즌 1 TR';
	@override String get full => '시즌 1 기준 TR';
}

// Path: stats.gp
class _TranslationsStatsGpKoKr implements TranslationsStatsGpEn {
	_TranslationsStatsGpKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'GP';
	@override String get full => '게임을 플레이함';
}

// Path: stats.gw
class _TranslationsStatsGwKoKr implements TranslationsStatsGwEn {
	_TranslationsStatsGwKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'GW';
	@override String get full => '게임을 이김';
}

// Path: stats.winrate
class _TranslationsStatsWinrateKoKr implements TranslationsStatsWinrateEn {
	_TranslationsStatsWinrateKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'WR%';
	@override String get full => '승률';
}

// Path: stats.apm
class _TranslationsStatsApmKoKr implements TranslationsStatsApmEn {
	_TranslationsStatsApmKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'APM';
	@override String get full => '분당 공격';
}

// Path: stats.pps
class _TranslationsStatsPpsKoKr implements TranslationsStatsPpsEn {
	_TranslationsStatsPpsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'PPS';
	@override String get full => '초당 미노';
}

// Path: stats.vs
class _TranslationsStatsVsKoKr implements TranslationsStatsVsEn {
	_TranslationsStatsVsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS';
	@override String get full => '대결 점수';
}

// Path: stats.app
class _TranslationsStatsAppKoKr implements TranslationsStatsAppEn {
	_TranslationsStatsAppKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP';
	@override String get full => '미노당 공격';
}

// Path: stats.vsapm
class _TranslationsStatsVsapmKoKr implements TranslationsStatsVsapmEn {
	_TranslationsStatsVsapmKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'VS/APM';
	@override String get full => 'VS / APM';
}

// Path: stats.dss
class _TranslationsStatsDssKoKr implements TranslationsStatsDssEn {
	_TranslationsStatsDssKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/S';
	@override String get full => '초당 깎기';
}

// Path: stats.dsp
class _TranslationsStatsDspKoKr implements TranslationsStatsDspEn {
	_TranslationsStatsDspKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'DS/P';
	@override String get full => '미노당 깎기';
}

// Path: stats.appdsp
class _TranslationsStatsAppdspKoKr implements TranslationsStatsAppdspEn {
	_TranslationsStatsAppdspKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'APP+DSP';
	@override String get full => 'APP + DSP';
}

// Path: stats.cheese
class _TranslationsStatsCheeseKoKr implements TranslationsStatsCheeseEn {
	_TranslationsStatsCheeseKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '치즈';
	@override String get full => '치즈 지수';
}

// Path: stats.gbe
class _TranslationsStatsGbeKoKr implements TranslationsStatsGbeEn {
	_TranslationsStatsGbeKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'GbE';
	@override String get full => '쓰레기줄 효율';
}

// Path: stats.nyaapp
class _TranslationsStatsNyaappKoKr implements TranslationsStatsNyaappEn {
	_TranslationsStatsNyaappKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'wAPP';
	@override String get full => '가중 APP';
}

// Path: stats.area
class _TranslationsStatsAreaKoKr implements TranslationsStatsAreaEn {
	_TranslationsStatsAreaKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Area';
	@override String get full => '영역';
}

// Path: stats.etr
class _TranslationsStatsEtrKoKr implements TranslationsStatsEtrEn {
	_TranslationsStatsEtrKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'eTR';
	@override String get full => '예상 TR';
}

// Path: stats.etracc
class _TranslationsStatsEtraccKoKr implements TranslationsStatsEtraccEn {
	_TranslationsStatsEtraccKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '±eTR';
	@override String get full => '예상 TR 오차';
}

// Path: stats.opener
class _TranslationsStatsOpenerKoKr implements TranslationsStatsOpenerEn {
	_TranslationsStatsOpenerKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Opener';
	@override String get full => '오프너';
}

// Path: stats.plonk
class _TranslationsStatsPlonkKoKr implements TranslationsStatsPlonkEn {
	_TranslationsStatsPlonkKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Plonk';
	@override String get full => '플롱크';
}

// Path: stats.stride
class _TranslationsStatsStrideKoKr implements TranslationsStatsStrideEn {
	_TranslationsStatsStrideKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Stride';
	@override String get full => '스트라이드';
}

// Path: stats.infds
class _TranslationsStatsInfdsKoKr implements TranslationsStatsInfdsEn {
	_TranslationsStatsInfdsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Inf. DS';
	@override String get full => '지속 깎기';
}

// Path: stats.altitude
class _TranslationsStatsAltitudeKoKr implements TranslationsStatsAltitudeEn {
	_TranslationsStatsAltitudeKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'm';
	@override String get full => '고도';
}

// Path: stats.climbSpeed
class _TranslationsStatsClimbSpeedKoKr implements TranslationsStatsClimbSpeedEn {
	_TranslationsStatsClimbSpeedKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '등반 속도';
	@override String get full => '등반 속도';
	@override String get gaugetTitle => '등반\n속도';
}

// Path: stats.peakClimbSpeed
class _TranslationsStatsPeakClimbSpeedKoKr implements TranslationsStatsPeakClimbSpeedEn {
	_TranslationsStatsPeakClimbSpeedKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '최고 등반 속도';
	@override String get full => '최고 등반 속도';
	@override String get gaugetTitle => '고점';
}

// Path: stats.kos
class _TranslationsStatsKosKoKr implements TranslationsStatsKosEn {
	_TranslationsStatsKosKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '처치';
	@override String get full => '처치한 플레이어';
}

// Path: stats.b2b
class _TranslationsStatsB2bKoKr implements TranslationsStatsB2bEn {
	_TranslationsStatsB2bKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'B2B';
	@override String get full => '백투백';
}

// Path: stats.finesse
class _TranslationsStatsFinesseKoKr implements TranslationsStatsFinesseEn {
	_TranslationsStatsFinesseKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'F';
	@override String get full => '피네스';
	@override String get widgetTitle => 'inesse';
}

// Path: stats.finesseFaults
class _TranslationsStatsFinesseFaultsKoKr implements TranslationsStatsFinesseFaultsEn {
	_TranslationsStatsFinesseFaultsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'FF';
	@override String get full => '피네스 오류';
}

// Path: stats.totalTime
class _TranslationsStatsTotalTimeKoKr implements TranslationsStatsTotalTimeEn {
	_TranslationsStatsTotalTimeKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '시간';
	@override String get full => '총 시간';
	@override String get widgetTitle => 'otal Time';
}

// Path: stats.level
class _TranslationsStatsLevelKoKr implements TranslationsStatsLevelEn {
	_TranslationsStatsLevelKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => '레벨';
	@override String get full => '레벨';
}

// Path: stats.pieces
class _TranslationsStatsPiecesKoKr implements TranslationsStatsPiecesEn {
	_TranslationsStatsPiecesKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'P';
	@override String get full => '미노';
}

// Path: stats.spp
class _TranslationsStatsSppKoKr implements TranslationsStatsSppEn {
	_TranslationsStatsSppKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'SPP';
	@override String get full => '미노당 점수';
}

// Path: stats.kp
class _TranslationsStatsKpKoKr implements TranslationsStatsKpEn {
	_TranslationsStatsKpKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'KP';
	@override String get full => '키 입력';
}

// Path: stats.kpp
class _TranslationsStatsKppKoKr implements TranslationsStatsKppEn {
	_TranslationsStatsKppKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPP';
	@override String get full => '미노당 키 입력';
}

// Path: stats.kps
class _TranslationsStatsKpsKoKr implements TranslationsStatsKpsEn {
	_TranslationsStatsKpsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'KPS';
	@override String get full => '초당 키 입력';
}

// Path: stats.apl
class _TranslationsStatsAplKoKr implements TranslationsStatsAplEn {
	_TranslationsStatsAplKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'APL';
	@override String get full => 'Attack Per Line';
}

// Path: stats.quadEfficiency
class _TranslationsStatsQuadEfficiencyKoKr implements TranslationsStatsQuadEfficiencyEn {
	_TranslationsStatsQuadEfficiencyKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'Q Eff.';
	@override String get full => 'Quad efficiency';
}

// Path: stats.tspinEfficiency
class _TranslationsStatsTspinEfficiencyKoKr implements TranslationsStatsTspinEfficiencyEn {
	_TranslationsStatsTspinEfficiencyKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'T Eff.';
	@override String get full => 'T-spin efficiency';
}

// Path: stats.allspinEfficiency
class _TranslationsStatsAllspinEfficiencyKoKr implements TranslationsStatsAllspinEfficiencyEn {
	_TranslationsStatsAllspinEfficiencyKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get short => 'All Eff.';
	@override String get full => 'All-spin efficiency';
}

// Path: stats.graphs
class _TranslationsStatsGraphsKoKr implements TranslationsStatsGraphsEn {
	_TranslationsStatsGraphsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get attack => '공격';
	@override String get speed => '속도';
	@override String get defense => '수비';
	@override String get cheese => '치즈';
}

// Path: stats.lineClear
class _TranslationsStatsLineClearKoKr implements TranslationsStatsLineClearEn {
	_TranslationsStatsLineClearKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get single => '싱글';
	@override String get double => '더블';
	@override String get triple => '트리플';
	@override String get quad => '쿼드';
	@override String get penta => '펜타';
	@override String get hexa => '헥사';
	@override String get hepta => '헵타';
	@override String get octa => '옥타';
	@override String get ennea => '에니아';
	@override String get deca => '데카';
	@override String get hendeca => '헨데카';
	@override String get dodeca => '도데카';
	@override String get triadeca => '트라이아데카';
	@override String get tessaradeca => '테사라데카';
	@override String get pentedeca => '펜타데카';
	@override String get hexadeca => '헥사데카';
	@override String get heptadeca => '헵타데카';
	@override String get octadeca => '옥타데카';
	@override String get enneadeca => '에니아데카';
	@override String get eicosa => '아이코사';
	@override String get kagaris => '카가리스';
}

// Path: stats.lineClears
class _TranslationsStatsLineClearsKoKr implements TranslationsStatsLineClearsEn {
	_TranslationsStatsLineClearsKoKr._(this._root);

	final TranslationsKoKr _root; // ignore: unused_field

	// Translations
	@override String get zero => '제로스';
	@override String get single => '싱글';
	@override String get double => '더블';
	@override String get triple => '트리플';
	@override String get quad => '쿼드';
	@override String get penta => '펜타';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsKoKr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return '영어 (English)';
			case 'locales.ru-RU': return '러시아어 (Русский)';
			case 'locales.ko-KR': return '한국어';
			case 'locales.zh-CN': return '중국어 간체 (简体中文)';
			case 'locales.de-DE': return '독일어 (Deutsch)';
			case 'gamemodes.league': return '테트라 리그';
			case 'gamemodes.zenith': return '퀵 플레이';
			case 'gamemodes.zenithex': return '전문가용 퀵 플레이';
			case 'gamemodes.40l': return '40라인';
			case 'gamemodes.blitz': return '블리츠';
			case 'gamemodes.5mblast': return '5,000,000 블라스트';
			case 'gamemodes.zen': return '젠';
			case 'destinations.home': return '홈';
			case 'destinations.graphs': return '그래프';
			case 'destinations.leaderboards': return '리더보드';
			case 'destinations.cutoffs': return '커트라인';
			case 'destinations.calc': return '계산기';
			case 'destinations.info': return '정보';
			case 'destinations.data': return '저장된 데이터';
			case 'destinations.settings': return '설정';
			case 'playerRole.user': return '사용자';
			case 'playerRole.banned': return '밴';
			case 'playerRole.bot': return '봇';
			case 'playerRole.sysop': return '시스템 운영자';
			case 'playerRole.admin': return '관리자';
			case 'playerRole.mod': return '운영자';
			case 'playerRole.halfmod': return '커뮤니티 운영자';
			case 'playerRole.anon': return '익명';
			case 'goBackButton': return '뒤로';
			case 'nanow': return '지금은 사용할 수 없습니다...';
			case 'seasonEnds': return ({required Object countdown}) => '시즌이 ${countdown} 뒤에 종료됩니다';
			case 'seasonEnded': return '시즌이 종료되었습니다';
			case 'overallPB': return ({required Object pb}) => '개인 최고 기록: ${pb} m';
			case 'gamesUntilRanked': return ({required Object left}) => '랭크를 얻으려면 ${left}판을 더 플레이하세요';
			case 'numOfVictories': return ({required Object wins}) => '~${wins}승';
			case 'promotionOnNextWin': return '승리 시 승급';
			case 'numOfdefeats': return ({required Object losses}) => '~${losses}패';
			case 'demotionOnNextLoss': return '패배 시 강등';
			case 'records': return '기록';
			case 'nerdStats': return '세부 스탯';
			case 'playstyles': return '플레이스타일';
			case 'horoscopes': return '천궁도';
			case 'relatedAchievements': return '관련 업적';
			case 'season': return '시즌';
			case 'smooth': return '부드러운';
			case 'dateAndTime': return '날짜 / 시간';
			case 'TLfullLBnote': return '용량이 크지만, 플레이어들을 스탯으로 줄세우거나 랭크로 걸러낼 수 있게 해 줍니다';
			case 'rank': return '랭크';
			case 'verdictGeneral': return ({required Object rank, required Object n, required Object verdict}) => '${rank} 평균보다 ${n} ${verdict}';
			case 'verdictBetter': return '앞섬';
			case 'verdictWorse': return '뒤쳐짐';
			case 'localStanding': return '국가 순위';
			case 'xp.title': return '경험치 레벨';
			case 'xp.progressToNextLevel': return ({required Object percentage}) => '다음 레벨까지 ${percentage}';
			case 'xp.progressTowardsGoal': return ({required Object goal, required Object percentage, required Object left}) => '0 XP에서 레벨 ${goal}까지 진행도: ${percentage} (${left} XP 남음)';
			case 'gametime.title': return '정확한 플레이 시간';
			case 'gametime.gametimeAday': return ({required Object gametime}) => '일평균 ${gametime}';
			case 'gametime.breakdown': return ({required Object years, required Object months, required Object days, required Object minutes, required Object seconds}) => '${years}년, \n또는 ${months}개월,\n또는 ${days}일,\n또는 ${minutes}분,\n또는 ${seconds}초';
			case 'whichOne': return 'Which one?';
			case 'track': return '추적하기';
			case 'stopTracking': return '추적 취소하기';
			case 'supporter': return ({required Object tier}) => '서포터 ${tier}티어';
			case 'comparingWith': return ({required Object oldDate, required Object newDate}) => '${oldDate} 와 ${newDate} 의 데이터를 비교 중';
			case 'compare': return '비교하기';
			case 'comparison': return '비교';
			case 'enterUsername': return '입력하세요: 닉네임 혹은 \$avgX (X는 랭크를 의미)';
			case 'general': return '일반';
			case 'badges': return '배지들';
			case 'obtainDate': return ({required Object date}) => '${date}에 얻음';
			case 'assignedManualy': return '이 배지는 TETR.IO 관리자에 의해 부여되었습니다';
			case 'distinguishment': return '타이틀';
			case 'banned': return '밴';
			case 'bannedSubtext': return 'TETR.IO 약관이나 규칙을 어기면 밴이 조치됩니다';
			case 'badStanding': return '나쁜 평판';
			case 'badStandingSubtext': return '최소 한 번 밴을 당한 기록이 있습니다';
			case 'botAccount': return '봇 계정';
			case 'botAccountSubtext': return ({required Object botMaintainers}) => '${botMaintainers}에 의해 운영됨';
			case 'copiedToClipboard': return '클립보드에 복사되었습니다!';
			case 'bio': return '자기소개';
			case 'news': return '뉴스';
			case 'matchResult.victory': return '승리';
			case 'matchResult.defeat': return '패배';
			case 'matchResult.tie': return '무승부';
			case 'matchResult.dqvictory': return '상대의 연결이 끊어짐';
			case 'matchResult.dqdefeat': return '실격패';
			case 'matchResult.nocontest': return '경기 취소';
			case 'matchResult.nullified': return '경기 무효';
			case 'distinguishments.noHeader': return '헤더를 찾을 수 없음';
			case 'distinguishments.noFooter': return '푸터를 찾을 수 없음';
			case 'distinguishments.twc': return 'TETR.IO 세계 챔피언';
			case 'distinguishments.twcYear': return ({required Object year}) => '${year} TETR.IO 세계 챔피언십';
			case 'newsEntries.leaderboard': return ({required InlineSpan gametype, required InlineSpan rank}) => TextSpan(children: [
				gametype,
				const TextSpan(text: '에서 '),
				rank,
				const TextSpan(text: '등을 달성했습니다'),
			]);
			case 'newsEntries.personalbest': return ({required InlineSpan gametype, required InlineSpan pb}) => TextSpan(children: [
				gametype,
				const TextSpan(text: '에서 '),
				pb,
				const TextSpan(text: '의 최고 기록을 달성했습니다'),
			]);
			case 'newsEntries.badge': return ({required InlineSpan badge}) => TextSpan(children: [
				const TextSpan(text: '배지 획득: '),
				badge,
			]);
			case 'newsEntries.rankup': return ({required InlineSpan rank}) => TextSpan(children: [
				const TextSpan(text: '테트라 리그 '),
				rank,
				const TextSpan(text: ' 달성'),
			]);
			case 'newsEntries.supporter': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				s('TETR.IO supporter'),
				const TextSpan(text: ' 가 되었습니다'),
			]);
			case 'newsEntries.supporter_gift': return ({required InlineSpanBuilder s}) => TextSpan(children: [
				s('TETR.IO supporter'),
				const TextSpan(text: ' 를 선물받았습니다'),
			]);
			case 'newsEntries.unknown': return ({required InlineSpan type}) => TextSpan(children: [
				type,
				const TextSpan(text: ' 종류의 확인되지 않은 소식'),
			]);
			case 'rankupMiddle': return ({required Object r}) => '${r} 랭크';
			case 'copyUserID': return '클릭하여 유저 ID를 복사';
			case 'searchHint': return '닉네임 또는 ID';
			case 'navMenu': return '탐색 메뉴';
			case 'navMenuTooltip': return '메뉴 열기';
			case 'refresh': return '정보 새로고침';
			case 'searchButton': return '검색';
			case 'trackedPlayers': return '추적된 플레이어들';
			case 'standing': return '순위';
			case 'previousSeasons': return '이전 시즌들';
			case 'checkingCache': return 'Checking cache...';
			case 'fetchingRecords': return 'Fetching Records...';
			case 'munching': return 'Munching...';
			case 'outOf': return 'out of';
			case 'replaysDone': return 'replays done';
			case 'analysis': return 'Analysis';
			case 'minomuncherMention': return 'via MinoMuncher by Freyhoe';
			case 'recent': return '최근';
			case 'top': return '상위';
			case 'noRecord': return '기록 없음';
			case 'sprintAndBlitsRelevance': return ({required Object date}) => '갱신일: ${date}';
			case 'snackBarMessages.stateRemoved': return ({required Object date}) => '${date} 상태가 데이터베이스에서 제거되었어요!';
			case 'snackBarMessages.matchRemoved': return ({required Object date}) => '${date} 매치가 데이터베이스에서 제거되었어요!';
			case 'snackBarMessages.notForWeb': return '웹 버전은 지원하지 않는 기능이에요';
			case 'snackBarMessages.importSuccess': return '불러오기 성공';
			case 'snackBarMessages.importCancelled': return '불러오기 거부됨';
			case 'errors.noRecords': return '기록 없음';
			case 'errors.notEnoughData': return '데이터가 충분하지 않음';
			case 'errors.noHistorySaved': return '저장된 기록 없음';
			case 'errors.connection': return ({required Object code, required Object message}) => '연결 문제 발생: ${code} ${message}';
			case 'errors.noSuchUser': return '사용자를 찾을 수 없습니다';
			case 'errors.noSuchUserSub': return '당신이 오타를 냈거나, 그 계정이 사라졌을 수 있습니다';
			case 'errors.discordNotAssigned': return '연결을 찾을 수 없습니다';
			case 'errors.discordNotAssignedSub': return '쿼리는 [API 가이드](https://tetr.io/about/api/#userssearchquery)에 설명된 대로 표시되어야 합니다';
			case 'errors.history': return '기록 찾기 실패';
			case 'errors.actionSuggestion': return '이것을 찾으셨나요?';
			case 'errors.p1nkl0bst3rTLmatches': return '테트라 리그 기록 없음';
			case 'errors.clientException': return '인터넷 연결 없음';
			case 'errors.forbidden': return '당신의 IP주소가 차단되었습니다';
			case 'errors.forbiddenSub': return ({required Object nickname}) => '만약 VPN이나 프록시 우회를 사용하고 계신다면 꺼 주세요. 그래도 문제가 발생하면, ${nickname} 에게 문의해 주세요';
			case 'errors.tooManyRequests': return '레이트 리밋에 걸렸습니다.';
			case 'errors.tooManyRequestsSub': return '잠시 기다렸다가 다시 시도해주세요';
			case 'errors.internal': return 'TETR.IO측에 문제가 일어났습니다';
			case 'errors.internalSub': return '(osk는 이 문제에 대해 이미 알고 있을 것입니다)';
			case 'errors.internalWebVersion': return 'TETR.IO측 (또는 oskware_bridge, 솔직히 잘은 모르겠네요)에 문제가 일어났습니다';
			case 'errors.internalWebVersionSub': return '만약 osk의 서버 상태 페이지(status.osk.sh)에 오류가 없다고 나온다면, dan63047에게 이 문제를 알려주세요';
			case 'errors.oskwareBridge': return 'oskware_bridge에 문제가 일어났습니다';
			case 'errors.oskwareBridgeSub': return 'dan63047에게 이 문제를 알려주세요';
			case 'errors.p1nkl0bst3rForbidden': return '서드 파티 API가 당신의 IP 주소를 차단했습니다';
			case 'errors.p1nkl0bst3rTooManyRequests': return '서드 파티 API에 너무 많은 요청이 들어왔습니다. 나중에 다시 시도해 주세요';
			case 'errors.p1nkl0bst3rinternal': return 'p1nkl0bst3r측에 문제가 일어났습니다';
			case 'errors.p1nkl0bst3rinternalWebVersion': return 'p1nkl0bst3r 측 (또는 oskware_bridge, 솔직히 잘은 모르겠네요)에 문제가 일어났습니다';
			case 'errors.replayAlreadySaved': return '리플레이가 이미 저장됨';
			case 'errors.replayExpired': return '리플레이가 만료되었으며 더 이상 볼 수 없습니다';
			case 'errors.replayRejected': return '서드 파티 API가 당신의 IP 주소를 차단했습니다';
			case 'actions.cancel': return '취소';
			case 'actions.submit': return '제출';
			case 'actions.ok': return '확인';
			case 'actions.apply': return '적용';
			case 'actions.refresh': return '새로고침';
			case 'graphsDestination.fetchAndsaveTLHistory': return '기록 불러오기';
			case 'graphsDestination.fetchAndSaveOldTLmatches': return '테트라 리그 경기 기록 불러오기';
			case 'graphsDestination.fetchAndsaveTLHistoryResult': return ({required Object number}) => '${number}개 상태가 발견됨';
			case 'graphsDestination.fetchAndSaveOldTLmatchesResult': return ({required Object number}) => '${number} 개의 경기를 찾았습니다';
			case 'graphsDestination.gamesPlayed': return ({required Object games}) => '${games} 판 플레이함';
			case 'graphsDestination.dateAndTime': return '날짜 및 시간';
			case 'graphsDestination.filterModaleTitle': return '랭크별로 그래프 필터링하기';
			case 'filterModale.all': return '모두';
			case 'cutoffsDestination.title': return '테트라 리그 상황';
			case 'cutoffsDestination.relevance': return ({required Object timestamp}) => '${timestamp} 기준';
			case 'cutoffsDestination.actual': return '실제';
			case 'cutoffsDestination.target': return '목표';
			case 'cutoffsDestination.cutoffTR': return '현재 커트라인';
			case 'cutoffsDestination.targetTR': return '의도된 커트라인';
			case 'cutoffsDestination.state': return '인플레이션/디플레이션';
			case 'cutoffsDestination.advanced': return '고급';
			case 'cutoffsDestination.players': return ({required Object n}) => '플레이어 수 (${n})';
			case 'cutoffsDestination.moreInfo': return '추가 정보';
			case 'cutoffsDestination.NumberOne': return ({required Object tr}) => '현재 1위: ${tr} TR';
			case 'cutoffsDestination.inflated': return ({required Object tr}) => '${tr} TR 인플레이션';
			case 'cutoffsDestination.notInflated': return '인플레이션 없음';
			case 'cutoffsDestination.deflated': return ({required Object tr}) => '${tr} TR 디플레이션';
			case 'cutoffsDestination.notDeflated': return '디플레이션 없음';
			case 'cutoffsDestination.wellDotDotDot': return '음...';
			case 'cutoffsDestination.fromPlace': return ({required Object n}) => '${n}위까지';
			case 'cutoffsDestination.viewButton': return '보기';
			case 'rankView.rankTitle': return ({required Object rank}) => '${rank} 랭크 정보';
			case 'rankView.everyoneTitle': return '전체 리더보드';
			case 'rankView.trRange': return 'TR 범위';
			case 'rankView.supposedToBe': return '의도된 범위';
			case 'rankView.gap': return ({required Object value}) => '${value} 범위';
			case 'rankView.trGap': return ({required Object value}) => '${value} TR 범위';
			case 'rankView.deflationGap': return '디플레이션 범위';
			case 'rankView.inflationGap': return '인플레이션 범위';
			case 'rankView.LBposRange': return '리더보드 순위 구간';
			case 'rankView.overpopulated': return ({required Object players}) => '실제로는 ${players} 더 많음';
			case 'rankView.underpopulated': return ({required Object players}) => '실제로는 ${players} 더 적음';
			case 'rankView.PlayersEqualSupposedToBe': return '귀엽다';
			case 'rankView.avgStats': return '평균 스탯';
			case 'rankView.avgForRank': return ({required Object rank}) => '${rank} 랭크 평균';
			case 'rankView.avgNerdStats': return '평균 세부 스탯';
			case 'rankView.minimums': return '최소';
			case 'rankView.maximums': return '최대';
			case 'stateView.title': return ({required Object date}) => '${date} 당시 상태';
			case 'tlMatchView.match': return '경기';
			case 'tlMatchView.vs': return 'vs';
			case 'tlMatchView.winner': return '승자';
			case 'tlMatchView.roundNumber': return ({required Object n}) => '라운드 ${n}';
			case 'tlMatchView.statsFor': return '스탯의 분야:';
			case 'tlMatchView.numberOfRounds': return '라운드 수';
			case 'tlMatchView.matchLength': return '경기 길이';
			case 'tlMatchView.roundLength': return '라운드 길이';
			case 'tlMatchView.matchStats': return '경기 스탯';
			case 'tlMatchView.downloadReplay': return '.ttrm 리플레이 다운로드';
			case 'tlMatchView.openReplay': return 'TETR.IO에서 리플레이 열기';
			case 'calcDestination.placeholders': return ({required Object stat}) => '당신의 ${stat}을 입력하세요';
			case 'calcDestination.tip': return '값을 입력하고 "계산" 버튼을 눌러 세부 스탯을 확인하세요';
			case 'calcDestination.invalidValues': return 'Please, enter valid values';
			case 'calcDestination.statsCalcButton': return '계산';
			case 'calcDestination.damageCalcTip': return '왼쪽에서 줄 클리어를 눌러 여기 추가하세요';
			case 'calcDestination.clearAll': return 'Clear all';
			case 'calcDestination.actions': return '줄 클리어';
			case 'calcDestination.results': return '결과';
			case 'calcDestination.rules': return '규칙';
			case 'calcDestination.noSpinClears': return '스핀이 아닌 줄 클리어';
			case 'calcDestination.spins': return '스핀';
			case 'calcDestination.miniSpins': return '스핀 미니';
			case 'calcDestination.noLineclear': return '줄 클리어 없음 (콤보 끊김)';
			case 'calcDestination.custom': return '직접 입력';
			case 'calcDestination.multiplier': return '멀티플라이어';
			case 'calcDestination.pcDamage': return '퍼펙트 클리어 데미지';
			case 'calcDestination.comboTable': return '콤보 테이블';
			case 'calcDestination.b2bChaining': return '백투백 체인';
			case 'calcDestination.surgeStartAtB2B': return '서지가 시작되는 백투백';
			case 'calcDestination.surgeStartAmount': return '서지 시작 시 대미지';
			case 'calcDestination.totalDamage': return '총 대미지';
			case 'calcDestination.lineclears': return '지운 줄';
			case 'calcDestination.combo': return '콤보';
			case 'calcDestination.surge': return '서지';
			case 'calcDestination.pcs': return '퍼펙트 클리어';
			case 'infoDestination.title': return '정보';
			case 'infoDestination.sprintAndBlitzAverages': return '40 라인 & 블리츠 랭크별 평균치';
			case 'infoDestination.sprintAndBlitzAveragesDescription': return '40 라인과 블리츠 평균을 계산하는 것은 고된 작업이기 때문에 가끔씩 업데이트됩니다. 전체 40 라인과 블리츠 평균 표를 보려면 제목을 클릭하세요';
			case 'infoDestination.tetraStatsWiki': return 'Tetra Stats 위키 (영어)';
			case 'infoDestination.tetraStatsWikiDescription': return 'Tetra Stats가 제공하는 기능과 통계에 대한 더 자세한 정보를 알아보세요';
			case 'infoDestination.about': return 'Tetra Stats에 대해';
			case 'infoDestination.aboutDescription': return 'dan63에 의해 제작됨\n';
			case 'leaderboardsDestination.title': return '리더보드';
			case 'leaderboardsDestination.tl': return '테트라 리그 (현재 시즌)';
			case 'leaderboardsDestination.fullTL': return '테트라 리그 (현재 시즌, 전체 스탯)';
			case 'leaderboardsDestination.ar': return '업적 점수';
			case 'savedDataDestination.title': return '저장된 정보';
			case 'savedDataDestination.tip': return '왼쪽의 닉네임을 누르시면 정보가 표시됩니다';
			case 'savedDataDestination.seasonTLstates': return ({required Object s}) => '시즌 ${s} 테트라 리그 상황';
			case 'savedDataDestination.TLrecords': return '테트라 리그 기록';
			case 'settingsDestination.title': return '설정';
			case 'settingsDestination.general': return '일반';
			case 'settingsDestination.customization': return '사용자 설정';
			case 'settingsDestination.database': return '로컬 데이터베이스';
			case 'settingsDestination.checking': return '확인 중...';
			case 'settingsDestination.enterToSubmit': return 'Enter 키를 눌러 제출하세요';
			case 'settingsDestination.account': return '당신의 TETR.IO 계정';
			case 'settingsDestination.accountDescription': return '앱이 실행되면 해당 플레이어의 스탯이 불러와집니다. 나의 (dan63) 스탯을 불러오는 게 기본값입니다. 바꾸려면, 당신의 닉네임을 입력하세요.';
			case 'settingsDestination.done': return '완료!';
			case 'settingsDestination.noSuchAccount': return '그런 계정이 없음';
			case 'settingsDestination.language': return '언어';
			case 'settingsDestination.languageDescription': return ({required Object languages}) => 'Tetra Stats는 ${languages}로 번역되었습니다. 기본적으로 이 앱은 사용자의 시스템 언어를 고르지만, 만약 시스템 언어 번역이 지원되지 않는다면 영어를 고릅니다.';
			case 'settingsDestination.languages': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				zero: '0개의 언어',
				one: '${n}개의 언어',
				two: '${n}개의 언어',
				few: '${n}개의 언어',
				many: '${n}개의 언어',
				other: '${n}개의 언어',
			);
			case 'settingsDestination.updateInTheBackground': return '백그라운드에서 정보 업데이트';
			case 'settingsDestination.updateInTheBackgroundDescription': return '켜져 있다면, Tetra Stats는 캐시가 만료될 때마다 새로운 정보를 받으려고 시도할 것입니다. 주로 이는 5분마다 일어납니다.';
			case 'settingsDestination.compareStats': return '테트라 리그 스탯을 랭크 평균과 비교하기';
			case 'settingsDestination.compareStatsDescription': return '켜져 있다면, Tetra Stats는 당신이 당신의 랭크의 평균적인 플레이어와 스탯을 비교할 수 있도록 당신의 스탯을 알맞은 색으로 강조할 것입니다. 스탯 위에 커서를 올려 더 많은 정보를 확인하세요.';
			case 'settingsDestination.showPosition': return '리더보드에서 스탯별 순위 표시';
			case 'settingsDestination.showPositionDescription': return '켜져 있다면, 로딩 시간이 더 길어지지만 당신의 스탯별 순위를 볼 수 있도록 합니다';
			case 'settingsDestination.accentColor': return '강조 색';
			case 'settingsDestination.accentColorDescription': return '강조 색은 앱 곳곳에서 주로 상호작용 가능한 요소를 강조하기 위해 사용됩니다.';
			case 'settingsDestination.accentColorModale': return '강조 색 고르기';
			case 'settingsDestination.timestamps': return '시간 표시 형식';
			case 'settingsDestination.timestampsDescriptionPart1': return ({required Object d}) => '시각 표시 형식을 고릅니다. 기본 설정은 협정 세계시 (UTC)기준 시각을 언어에 맞는 형식으로 표시하는 것입니다. 예시: ${d}.';
			case 'settingsDestination.timestampsDescriptionPart2': return ({required Object y, required Object r}) => '또한 다음과 같은 시간 표시 형식도 고를 수 있습니다:\n• 언어에 맞는 형식, 사용자의 시간대: ${y}\n• 상대적인 시간 표시: ${r}';
			case 'settingsDestination.timestampsAbsoluteGMT': return '협정 세계시 (UTC) 기준';
			case 'settingsDestination.timestampsAbsoluteLocalTime': return '사용자의 시간대 기준';
			case 'settingsDestination.timestampsRelative': return '상대적인 시간 표시';
			case 'settingsDestination.sheetbotLikeGraphs': return '레이더 그래프를 Sheetbot의 형식으로 표시';
			case 'settingsDestination.sheetbotLikeGraphsDescription': return '저는 Sheetbot 형식의 레이더 그래프가 별로 정확하지 않다고 판단하였지만, 몇몇 사람들은 -0.5 스트라이딩 스탯이 Sheetbot 그래프에서처럼 표시되지 않는 것을 보고 혼란스러워 했습니다. 따라서, 이 설정이 켜져 있다면, 레이더 그래프의 점들은 스탯이 음수일 때 반대쪽에 나타날 것입니다.';
			case 'settingsDestination.oskKagariGimmick': return 'Osk-Kagari 기믹';
			case 'settingsDestination.oskKagariGimmickDescription': return '켜져 있다면, osk의 랭크 대신 :kagari:가 표시됩니다.';
			case 'settingsDestination.bytesOfDataStored': return '만큼의 데이터가 저장됨';
			case 'settingsDestination.TLrecordsSaved': return '테트라 리그 기록 저장됨';
			case 'settingsDestination.TLplayerstatesSaved': return '테트라 리그 플레이어스탯 저장됨';
			case 'settingsDestination.fixButton': return '수정';
			case 'settingsDestination.compressButton': return '압축';
			case 'settingsDestination.exportDB': return '로컬 저장소로 내보내기';
			case 'settingsDestination.desktopExportAlertTitle': return '데스크탑용 내보내기';
			case 'settingsDestination.desktopExportText': return '데스크탑 버전으로 앱을 사용하시는 것 같군요. 문서 폴더로 들어가서, "TetraStats.db"를 찾고, 어딘가로 복사하세요';
			case 'settingsDestination.androidExportAlertTitle': return '안드로이드용 내보내기';
			case 'settingsDestination.androidExportText': return ({required Object exportedDB}) => '내보내기 완료.\n${exportedDB}';
			case 'settingsDestination.importDB': return '로컬 저장소에서 가져오기';
			case 'settingsDestination.importDBDescription': return '백업을 복구합니다. 저장되어 있던 데이터베이스가 덮어씌워질 것임을 알려드립니다.';
			case 'settingsDestination.importWrongFileType': return '잘못된 파일 형식';
			case 'homeNavigation.overview': return '둘러보기';
			case 'homeNavigation.standing': return '순위';
			case 'homeNavigation.seasons': return '시즌';
			case 'homeNavigation.mathces': return '매치';
			case 'homeNavigation.pb': return '개인 최고 기록';
			case 'homeNavigation.normal': return '일반';
			case 'homeNavigation.expert': return '전문가';
			case 'homeNavigation.expertRecords': return '기록 내보내기';
			case 'graphsNavigation.history': return '플레이어 기록';
			case 'graphsNavigation.league': return '리그 현황';
			case 'graphsNavigation.cutoffs': return '커트라인 기록';
			case 'calcNavigation.stats': return '스탯 계산기';
			case 'calcNavigation.damage': return '데미지 계산기';
			case 'firstTimeView.welcome': return 'Tetra Stats에 오신 것을 환영합니다';
			case 'firstTimeView.description': return 'TETR.IO에 대한 다양한 통계를 추적할 수 있는 서비스';
			case 'firstTimeView.nicknameQuestion': return '당신의 TETR.IO 닉네임은 무엇인가요?';
			case 'firstTimeView.inpuntHint': return '여기 입력해주세요...(3-16자)';
			case 'firstTimeView.emptyInputError': return '닉네임을 입력해 주세요';
			case 'firstTimeView.niceToSeeYou': return ({required Object n}) => '반갑습니다, ${n}';
			case 'firstTimeView.letsTakeALook': return '당신의 통계를 살펴보겠습니다...';
			case 'firstTimeView.skip': return '건너뛰기';
			case 'aboutView.title': return 'Tetra Stats에 대해';
			case 'aboutView.about': return 'Tetra Stats는 TETR.IO 테트라 채널의 API를 활용하여 정보를 제공하고, 이 정보에 따른 추가적인 수치를 계산하는 서비스입니다. 이 서비스는 사용자가 테트라 리그에서 어떻게 발전하는지 추적할 수 있는 "추적" 기능을 제공합니다. 이 기능은 모든 테트라 리그에서의 변화를 로컬 데이터베이스에 기록하여(실시간으로 기록되지는 않습니다) 사용자가 이를 그래프로 볼 수 있도록 합니다. \n\nBeanserver Blaster는 Tetra Stats의 일부이며, 서버 사이드 스크립트로 떨어져 나왔습니다. Beanserver Blaster는 테트라 리그의 완전한 리더보드와 랭크 컷 등의 정보를 제공하여 Tetra Stats가 리더보드를 원하는 방식으로 정렬하고, 산점도 그래프를 그릴 수 있도록 돕는 역할을 합니다. 이를 통해 사용자는 테트라 리그의 추세를 분석할 수 있습니다. \n\n앞으로 리플레이 분석과 대회 기록 기능을 추가할 계획이 있으니, 계속해서 이 프로젝트에 관심을 기울여 주세요!\n\n이 서비스는 어떠한 방식으로도 TETR.IO 또는 osk와 직접적으로 연관되어 있지 않습니다.';
			case 'aboutView.appVersion': return '앱 버전';
			case 'aboutView.build': return ({required Object build}) => '빌드 ${build}';
			case 'aboutView.GHrepo': return '깃헙 리포지트리';
			case 'aboutView.submitAnIssue': return '문제 보고하기';
			case 'aboutView.credits': return '크레딧';
			case 'aboutView.authorAndDeveloper': return '제작 & 개발';
			case 'aboutView.providedFormulas': return '공식 제공';
			case 'aboutView.providedS1history': return '테트라 리그 시즌 1 기록 제공';
			case 'aboutView.inoue': return 'Inoue (리플레이 그래버)';
			case 'aboutView.zhCNlocale': return '중국어 간체 번역';
			case 'aboutView.deDElocale': return '독일어 번역';
			case 'aboutView.koKRlocale': return '한국어 번역';
			case 'aboutView.supportHim': return '후원하기';
			case 'stats.registrationDate': return '가입일';
			case 'stats.gametime': return '플레이 시간';
			case 'stats.ogp': return '온라인 게임을 플레이함';
			case 'stats.ogw': return '온라인 게임을 이김';
			case 'stats.followers': return '팔로워';
			case 'stats.xp.short': return 'XP';
			case 'stats.xp.full': return '경험치';
			case 'stats.tr.short': return 'TR';
			case 'stats.tr.full': return '테트라 레이팅';
			case 'stats.glicko.short': return 'Glicko';
			case 'stats.glicko.full': return '글리코';
			case 'stats.rd.short': return 'RD';
			case 'stats.rd.full': return '레이팅 편차';
			case 'stats.glixare.short': return 'GXE';
			case 'stats.glixare.full': return 'GLIXARE';
			case 'stats.s1tr.short': return '시즌 1 TR';
			case 'stats.s1tr.full': return '시즌 1 기준 TR';
			case 'stats.gp.short': return 'GP';
			case 'stats.gp.full': return '게임을 플레이함';
			case 'stats.gw.short': return 'GW';
			case 'stats.gw.full': return '게임을 이김';
			case 'stats.winrate.short': return 'WR%';
			case 'stats.winrate.full': return '승률';
			case 'stats.apm.short': return 'APM';
			case 'stats.apm.full': return '분당 공격';
			case 'stats.pps.short': return 'PPS';
			case 'stats.pps.full': return '초당 미노';
			case 'stats.vs.short': return 'VS';
			case 'stats.vs.full': return '대결 점수';
			case 'stats.app.short': return 'APP';
			case 'stats.app.full': return '미노당 공격';
			case 'stats.vsapm.short': return 'VS/APM';
			case 'stats.vsapm.full': return 'VS / APM';
			case 'stats.dss.short': return 'DS/S';
			case 'stats.dss.full': return '초당 깎기';
			case 'stats.dsp.short': return 'DS/P';
			case 'stats.dsp.full': return '미노당 깎기';
			case 'stats.appdsp.short': return 'APP+DSP';
			case 'stats.appdsp.full': return 'APP + DSP';
			case 'stats.cheese.short': return '치즈';
			case 'stats.cheese.full': return '치즈 지수';
			case 'stats.gbe.short': return 'GbE';
			case 'stats.gbe.full': return '쓰레기줄 효율';
			case 'stats.nyaapp.short': return 'wAPP';
			case 'stats.nyaapp.full': return '가중 APP';
			case 'stats.area.short': return 'Area';
			case 'stats.area.full': return '영역';
			case 'stats.etr.short': return 'eTR';
			case 'stats.etr.full': return '예상 TR';
			case 'stats.etracc.short': return '±eTR';
			case 'stats.etracc.full': return '예상 TR 오차';
			case 'stats.opener.short': return 'Opener';
			case 'stats.opener.full': return '오프너';
			case 'stats.plonk.short': return 'Plonk';
			case 'stats.plonk.full': return '플롱크';
			case 'stats.stride.short': return 'Stride';
			case 'stats.stride.full': return '스트라이드';
			case 'stats.infds.short': return 'Inf. DS';
			case 'stats.infds.full': return '지속 깎기';
			case 'stats.altitude.short': return 'm';
			case 'stats.altitude.full': return '고도';
			case 'stats.climbSpeed.short': return '등반 속도';
			case 'stats.climbSpeed.full': return '등반 속도';
			case 'stats.climbSpeed.gaugetTitle': return '등반\n속도';
			case 'stats.peakClimbSpeed.short': return '최고 등반 속도';
			case 'stats.peakClimbSpeed.full': return '최고 등반 속도';
			case 'stats.peakClimbSpeed.gaugetTitle': return '고점';
			case 'stats.kos.short': return '처치';
			case 'stats.kos.full': return '처치한 플레이어';
			case 'stats.b2b.short': return 'B2B';
			case 'stats.b2b.full': return '백투백';
			case 'stats.finesse.short': return 'F';
			case 'stats.finesse.full': return '피네스';
			case 'stats.finesse.widgetTitle': return 'inesse';
			case 'stats.finesseFaults.short': return 'FF';
			case 'stats.finesseFaults.full': return '피네스 오류';
			case 'stats.totalTime.short': return '시간';
			case 'stats.totalTime.full': return '총 시간';
			case 'stats.totalTime.widgetTitle': return 'otal Time';
			case 'stats.level.short': return '레벨';
			case 'stats.level.full': return '레벨';
			case 'stats.pieces.short': return 'P';
			case 'stats.pieces.full': return '미노';
			case 'stats.spp.short': return 'SPP';
			case 'stats.spp.full': return '미노당 점수';
			case 'stats.kp.short': return 'KP';
			case 'stats.kp.full': return '키 입력';
			case 'stats.kpp.short': return 'KPP';
			case 'stats.kpp.full': return '미노당 키 입력';
			case 'stats.kps.short': return 'KPS';
			case 'stats.kps.full': return '초당 키 입력';
			case 'stats.apl.short': return 'APL';
			case 'stats.apl.full': return 'Attack Per Line';
			case 'stats.quadEfficiency.short': return 'Q Eff.';
			case 'stats.quadEfficiency.full': return 'Quad efficiency';
			case 'stats.tspinEfficiency.short': return 'T Eff.';
			case 'stats.tspinEfficiency.full': return 'T-spin efficiency';
			case 'stats.allspinEfficiency.short': return 'All Eff.';
			case 'stats.allspinEfficiency.full': return 'All-spin efficiency';
			case 'stats.blitzScore': return ({required Object p}) => '${p}점';
			case 'stats.levelUpRequirement': return ({required Object p}) => '레벨업까지 ${p}점';
			case 'stats.piecesTotal': return '놓은 미노 수';
			case 'stats.piecesWithPerfectFinesse': return '피네스를 지킨 미노';
			case 'stats.score': return '점수';
			case 'stats.lines': return '줄';
			case 'stats.linesShort': return '줄';
			case 'stats.pcs': return '퍼펙트 클리어';
			case 'stats.holds': return '홀드';
			case 'stats.spike': return '최고 스파이크';
			case 'stats.top': return ({required Object percentage}) => '상위 ${percentage}';
			case 'stats.topRank': return ({required Object rank}) => '최고 랭크: ${rank}';
			case 'stats.floor': return '층수';
			case 'stats.split': return '부분';
			case 'stats.total': return '전체';
			case 'stats.sent': return '보낸 줄';
			case 'stats.received': return '받은 줄';
			case 'stats.placement': return '위치';
			case 'stats.peak': return '고점';
			case 'stats.overall': return 'Overall';
			case 'stats.midgame': return 'Midgame';
			case 'stats.efficiency': return 'Efficiency';
			case 'stats.upstack': return 'Upstack';
			case 'stats.downstack': return 'Downstack';
			case 'stats.variance': return 'Variance';
			case 'stats.burst': return 'Burst';
			case 'stats.length': return 'Length';
			case 'stats.rate': return 'Rate';
			case 'stats.secsDS': return 'Secs/DS';
			case 'stats.secsCheese': return 'Secs/Cheese';
			case 'stats.attackCheesiness': return 'Attack Cheesiness';
			case 'stats.downstackingRatio': return 'Downstacking Ratio';
			case 'stats.clearTypes': return 'Clear Types';
			case 'stats.wellColumnDistribution': return 'Well Column Distribution';
			case 'stats.allSpins': return 'All Spins';
			case 'stats.sankeyTitle': return 'Incoming Attack Sankey Chart';
			case 'stats.incomingAttack': return 'Incoming Attack';
			case 'stats.clean': return 'Clean';
			case 'stats.cancelled': return 'Cancelled';
			case 'stats.cheeseTanked': return 'Cheese Tanked';
			case 'stats.cleanTanked': return 'Clean Tanked';
			case 'stats.kills': return 'Kills';
			case 'stats.deaths': return 'Deaths';
			case 'stats.ppsDistribution': return 'PPS distribution';
			case 'stats.qpWithMods': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				one: '1개 모드 사용',
				two: '${n}개 모드 사용',
				few: '${n}개 모드 사용',
				many: '${n}개 모드 사용',
				other: '${n}개 모드 사용',
			);
			case 'stats.inputs': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				zero: '키를 ${n}번 누름',
				one: '키를 ${n}번 누름',
				two: '키를 ${n}번 누름',
				few: '키를 ${n}번 누름',
				many: '키를 ${n}번 누름',
				other: '키를 ${n}번 누름',
			);
			case 'stats.tspinsTotal': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				zero: '총 ${n}번의 T스핀 수행',
				one: '총 ${n}번의 T스핀 수행',
				two: '총 ${n}번의 T스핀 수행',
				few: '총 ${n}번의 T스핀 수행',
				many: '총 ${n}번의 T스핀 수행',
				other: '총 ${n}번의 T스핀 수행',
			);
			case 'stats.linesCleared': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				zero: '${n}줄 제거',
				one: '${n}줄 제거',
				two: '${n}줄 제거',
				few: '${n}줄 제거',
				many: '${n}줄 제거',
				other: '${n}줄 제거',
			);
			case 'stats.graphs.attack': return '공격';
			case 'stats.graphs.speed': return '속도';
			case 'stats.graphs.defense': return '수비';
			case 'stats.graphs.cheese': return '치즈';
			case 'stats.players': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				zero: '${n} 플레이어',
				one: '${n} 플레이어',
				two: '${n} 플레이어',
				few: '${n} 플레이어',
				many: '${n} 플레이어',
				other: '${n} 플레이어',
			);
			case 'stats.games': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(n,
				zero: '${n} 게임',
				one: '${n} 게임',
				two: '${n} 게임',
				few: '${n} 게임',
				many: '${n} 게임',
				other: '${n} 게임',
			);
			case 'stats.lineClear.single': return '싱글';
			case 'stats.lineClear.double': return '더블';
			case 'stats.lineClear.triple': return '트리플';
			case 'stats.lineClear.quad': return '쿼드';
			case 'stats.lineClear.penta': return '펜타';
			case 'stats.lineClear.hexa': return '헥사';
			case 'stats.lineClear.hepta': return '헵타';
			case 'stats.lineClear.octa': return '옥타';
			case 'stats.lineClear.ennea': return '에니아';
			case 'stats.lineClear.deca': return '데카';
			case 'stats.lineClear.hendeca': return '헨데카';
			case 'stats.lineClear.dodeca': return '도데카';
			case 'stats.lineClear.triadeca': return '트라이아데카';
			case 'stats.lineClear.tessaradeca': return '테사라데카';
			case 'stats.lineClear.pentedeca': return '펜타데카';
			case 'stats.lineClear.hexadeca': return '헥사데카';
			case 'stats.lineClear.heptadeca': return '헵타데카';
			case 'stats.lineClear.octadeca': return '옥타데카';
			case 'stats.lineClear.enneadeca': return '에니아데카';
			case 'stats.lineClear.eicosa': return '아이코사';
			case 'stats.lineClear.kagaris': return '카가리스';
			case 'stats.lineClears.zero': return '제로스';
			case 'stats.lineClears.single': return '싱글';
			case 'stats.lineClears.double': return '더블';
			case 'stats.lineClears.triple': return '트리플';
			case 'stats.lineClears.quad': return '쿼드';
			case 'stats.lineClears.penta': return '펜타';
			case 'stats.mini': return '미니';
			case 'stats.tSpin': return 'T스핀';
			case 'stats.tSpins': return 'T스핀';
			case 'stats.spin': return '스핀';
			case 'stats.spins': return '스핀';
			case 'countries.': return '전 세계';
			case 'countries.AF': return '아프가니스탄';
			case 'countries.AX': return '올란드 제도';
			case 'countries.AL': return '알바니아';
			case 'countries.DZ': return '알제리';
			case 'countries.AS': return '미국령 사모아';
			case 'countries.AD': return '안도라';
			case 'countries.AO': return '앙골라';
			case 'countries.AI': return '앵귈라';
			case 'countries.AQ': return '남극';
			case 'countries.AG': return '앤티가 바부다';
			case 'countries.AR': return '아르헨티나';
			case 'countries.AM': return '아르메니아';
			case 'countries.AW': return '아루바';
			case 'countries.AU': return '호주';
			case 'countries.AT': return '오스트리아';
			case 'countries.AZ': return '아제르바이잔';
			case 'countries.BS': return '바하마';
			case 'countries.BH': return '바레인';
			case 'countries.BD': return '방글라데시';
			case 'countries.BB': return '바베이도스';
			case 'countries.BY': return '벨라루스';
			case 'countries.BE': return '벨기에';
			case 'countries.BZ': return '벨리즈';
			case 'countries.BJ': return '베냉';
			case 'countries.BM': return '버뮤다';
			case 'countries.BT': return '부탄';
			case 'countries.BO': return '볼리비아';
			case 'countries.BA': return '보스니아 헤르체고비나';
			case 'countries.BW': return '보츠와나';
			case 'countries.BV': return '부베섬';
			case 'countries.BR': return '브라질';
			case 'countries.IO': return '영국령 인도양 지역';
			case 'countries.BN': return '브루나이';
			case 'countries.BG': return '불가리아';
			case 'countries.BF': return '부르키나파소';
			case 'countries.BI': return '부룬디';
			case 'countries.KH': return '캄보디아';
			case 'countries.CM': return '카메룬';
			case 'countries.CA': return '캐나다';
			case 'countries.CV': return '카보베르데';
			case 'countries.BQ': return '네덜란드령 카리브섬';
			case 'countries.KY': return '케이맨 제도';
			case 'countries.CF': return '중앙아프리카 공화국';
			case 'countries.TD': return '차드';
			case 'countries.CL': return '칠레';
			case 'countries.CN': return '중국';
			case 'countries.CX': return '크리스마스섬';
			case 'countries.CC': return '코코스(킬링)제도';
			case 'countries.CO': return '콜롬비아';
			case 'countries.KM': return '코모로';
			case 'countries.CG': return '콩고';
			case 'countries.CD': return '콩고 민주 공화국';
			case 'countries.CK': return '쿡 제도';
			case 'countries.CR': return '코스타리카';
			case 'countries.CI': return '코트디부아르';
			case 'countries.HR': return '크로아티아';
			case 'countries.CU': return '쿠바';
			case 'countries.CW': return '퀴라소';
			case 'countries.CY': return '키프로스';
			case 'countries.CZ': return '체코';
			case 'countries.DK': return '덴마크';
			case 'countries.DJ': return '지부티';
			case 'countries.DM': return '도미니카';
			case 'countries.DO': return '도미니카 공화국';
			case 'countries.EC': return '에콰도르';
			case 'countries.EG': return '이집트';
			case 'countries.SV': return '엘살바도르';
			case 'countries.GB-ENG': return '잉글랜드';
			case 'countries.GQ': return '적도 기니';
			case 'countries.ER': return '에리트레아';
			case 'countries.EE': return '에스토니아';
			case 'countries.ET': return '에티오피아';
			case 'countries.EU': return '유럽 연합';
			case 'countries.FK': return '포클랜드 제도';
			case 'countries.FO': return '페로 제도';
			case 'countries.FJ': return '피지';
			case 'countries.FI': return '핀란드';
			case 'countries.FR': return '프랑스';
			case 'countries.GF': return '프랑스령 기아나';
			case 'countries.PF': return '프랑스령 폴리네시아';
			case 'countries.TF': return '프랑스령 남방';
			case 'countries.GA': return '가봉';
			case 'countries.GM': return '감비아';
			case 'countries.GE': return '조지아';
			case 'countries.DE': return '독일';
			case 'countries.GH': return '가나';
			case 'countries.GI': return '지브롤터';
			case 'countries.GR': return '그리스';
			case 'countries.GL': return '그린란드';
			case 'countries.GD': return '그레나다';
			case 'countries.GP': return '과들루프';
			case 'countries.GU': return '괌';
			case 'countries.GT': return '과테말라';
			case 'countries.GG': return '건지섬';
			case 'countries.GN': return '기니';
			case 'countries.GW': return '기니비사우';
			case 'countries.GY': return '가이아나';
			case 'countries.HT': return '아이티';
			case 'countries.HM': return '허드 맥도널드 제도';
			case 'countries.VA': return '교황청 (바티칸 시국)';
			case 'countries.HN': return '온두라스';
			case 'countries.HK': return '홍콩';
			case 'countries.HU': return '헝가리';
			case 'countries.IS': return '아이슬란드';
			case 'countries.IN': return '인도';
			case 'countries.ID': return '인도네시아';
			case 'countries.IR': return '이란';
			case 'countries.IQ': return '이라크';
			case 'countries.IE': return '아일랜드';
			case 'countries.IM': return '맨섬';
			case 'countries.IL': return '이스라엘';
			case 'countries.IT': return '이탈리아';
			case 'countries.JM': return '자메이카';
			case 'countries.JP': return '일본';
			case 'countries.JE': return '저지섬';
			case 'countries.JO': return '요르단';
			case 'countries.KZ': return '카자흐스탄';
			case 'countries.KE': return '케냐';
			case 'countries.KI': return '키리바시';
			case 'countries.KP': return '조선민주주의인민공화국';
			case 'countries.KR': return '대한민국';
			case 'countries.XK': return '코소보';
			case 'countries.KW': return '쿠웨이트';
			case 'countries.KG': return '키르기스스탄';
			case 'countries.LA': return '라오스';
			case 'countries.LV': return '라트비아';
			case 'countries.LB': return '레바논';
			case 'countries.LS': return '레소토';
			case 'countries.LR': return '라이베리아';
			case 'countries.LY': return '리비아';
			case 'countries.LI': return '리히텐슈타인';
			case 'countries.LT': return '리투아니아';
			case 'countries.LU': return '룩셈부르크';
			case 'countries.MO': return '마카오';
			case 'countries.MK': return '북마케도니아';
			case 'countries.MG': return '마다가스카르';
			case 'countries.MW': return '말라위';
			case 'countries.MY': return '말레이시아';
			case 'countries.MV': return '몰디브';
			case 'countries.ML': return '말리';
			case 'countries.MT': return '몰타';
			case 'countries.MH': return '마셜 제도';
			case 'countries.MQ': return '마르티니크';
			case 'countries.MR': return '모리타니';
			case 'countries.MU': return '모리셔스';
			case 'countries.YT': return '마요트';
			case 'countries.MX': return '멕시코';
			case 'countries.FM': return '미크로네시아 연방';
			case 'countries.MD': return '몰도바';
			case 'countries.MC': return '모나코';
			case 'countries.ME': return '몬테네그로';
			case 'countries.MA': return '모로코';
			case 'countries.MN': return '몽골';
			case 'countries.MS': return '몬트세랫';
			case 'countries.MZ': return '모잠비크';
			case 'countries.MM': return '미얀마';
			case 'countries.NA': return '나미비아';
			case 'countries.NR': return '나우루';
			case 'countries.NP': return '네팔';
			case 'countries.NL': return '네덜란드';
			case 'countries.AN': return '네덜란드령 안틸레스';
			case 'countries.NC': return '뉴칼레도니아';
			case 'countries.NZ': return '뉴질랜드';
			case 'countries.NI': return '니카라과';
			case 'countries.NE': return '니제르';
			case 'countries.NG': return '나이지리아';
			case 'countries.NU': return '니우에';
			case 'countries.NF': return '노퍽섬';
			case 'countries.GB-NIR': return '북아일랜드';
			case 'countries.MP': return '북마리아나 제도';
			case 'countries.NO': return '노르웨이';
			case 'countries.OM': return '오만';
			case 'countries.PK': return '파키스탄';
			case 'countries.PW': return '팔라우';
			case 'countries.PS': return '팔레스타인';
			case 'countries.PA': return '파나마';
			case 'countries.PG': return '파푸아뉴기니';
			case 'countries.PY': return '파라과이';
			case 'countries.PE': return '페루';
			case 'countries.PH': return '필리핀';
			case 'countries.PN': return '핏케언 제도';
			case 'countries.PL': return '폴란드';
			case 'countries.PT': return '포르투갈';
			case 'countries.PR': return '푸에르토리코';
			case 'countries.QA': return '카타르';
			case 'countries.RE': return '레위니옹';
			case 'countries.RO': return '루마니아';
			case 'countries.RU': return '러시아';
			case 'countries.RW': return '르완다';
			case 'countries.BL': return '생바르텔레미';
			case 'countries.SH': return '세인트헬레나 어센션 트리스탄다쿠냐';
			case 'countries.KN': return '세인트키츠 네비스';
			case 'countries.LC': return '세인트 루시아';
			case 'countries.MF': return '생마르탱';
			case 'countries.PM': return '생피에르 미클롱';
			case 'countries.VC': return '세인트 빈센트 그레나딘';
			case 'countries.WS': return '사모아';
			case 'countries.SM': return '산마리노';
			case 'countries.ST': return '상투메 프린시페';
			case 'countries.SA': return '사우디아라비아';
			case 'countries.GB-SCT': return '스코틀랜드';
			case 'countries.SN': return '세네갈';
			case 'countries.RS': return '세르비아';
			case 'countries.SC': return '세이셸';
			case 'countries.SL': return '시에라리온';
			case 'countries.SG': return '싱가포르';
			case 'countries.SX': return '신트마르턴 (네덜란드령)';
			case 'countries.SK': return '슬로바키아';
			case 'countries.SI': return '슬로베니아';
			case 'countries.SB': return '솔로몬 제도';
			case 'countries.SO': return '소말리아';
			case 'countries.ZA': return '남아프리카 공화국';
			case 'countries.GS': return '사우스조지아 사우스샌드위치 제도';
			case 'countries.SS': return '남수단';
			case 'countries.ES': return '스페인';
			case 'countries.LK': return '스리랑카';
			case 'countries.SD': return '수단';
			case 'countries.SR': return '수리남';
			case 'countries.SJ': return '스발바르 얀마옌 제도';
			case 'countries.SZ': return '에스와티니';
			case 'countries.SE': return '스웨덴';
			case 'countries.CH': return '스위스';
			case 'countries.SY': return '시리아';
			case 'countries.TW': return '대만';
			case 'countries.TJ': return '타지키스탄';
			case 'countries.TZ': return '탄자니아';
			case 'countries.TH': return '태국';
			case 'countries.TL': return '동티모르';
			case 'countries.TG': return '토고';
			case 'countries.TK': return '토켈라우';
			case 'countries.TO': return '통가';
			case 'countries.TT': return '트리니다드 토바고';
			case 'countries.TN': return '튀니지';
			case 'countries.TR': return '튀르키예';
			case 'countries.TM': return '투르크메니스탄';
			case 'countries.TC': return '터크스 케이커스 제도';
			case 'countries.TV': return '투발루';
			case 'countries.UG': return '우간다';
			case 'countries.UA': return '우크라이나';
			case 'countries.AE': return '아랍에미리트';
			case 'countries.GB': return '영국';
			case 'countries.US': return '미국';
			case 'countries.UY': return '우루과이';
			case 'countries.UM': return '미국령 군소 제도';
			case 'countries.UZ': return '우즈베키스탄';
			case 'countries.VU': return '바누아투';
			case 'countries.VE': return '볼리비아 베네수엘라';
			case 'countries.VN': return '베트남';
			case 'countries.VG': return '영국령 버진아일랜드';
			case 'countries.VI': return '미국령 버진아일랜드';
			case 'countries.GB-WLS': return '웨일스';
			case 'countries.WF': return '왈리스 푸투나 제도';
			case 'countries.EH': return '서사하라';
			case 'countries.YE': return '예멘';
			case 'countries.ZM': return '잠비아';
			case 'countries.ZW': return '짐바브웨';
			case 'countries.XX': return '국적 정보 없음';
			case 'countries.XM': return '달';
			default: return null;
		}
	}
}

