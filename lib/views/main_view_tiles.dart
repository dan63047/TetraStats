import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';

class MainView extends StatefulWidget {
  final String? player;
  /// The very first view, that user see when he launch this programm.
  /// By default it loads my or defined in preferences user stats, but
  /// if [player] username or id provided, it loads his stats. Also it hides menu drawer and three dots menu.
  const MainView({super.key, this.player});

  @override
  State<MainView> createState() => _MainState();
}

TetrioPlayer testPlayer = TetrioPlayer(
  userId: "6098518e3d5155e6ec429cdc",
  username: "dan63",
  registrationTime: DateTime(2002, 2, 25, 9, 30, 01),
  avatarRevision: 1704835194288,
  bannerRevision: 1661462402700,
  role: "sysop",
  country: "BY",
  state: DateTime(1970),
  badges: [
    Badge(badgeId: "kod_founder", label: "Убил оска", ts: DateTime(2023, 6, 27, 18, 51, 49)),
    Badge(badgeId: "kod_by_founder", label: "Убит оском", ts: DateTime(2023, 6, 27, 18, 51, 51)),
    Badge(badgeId: "5mblast_1", label: "5M Blast Winner"),
    Badge(badgeId: "20tsd", label: "20 TSD"),
    Badge(badgeId: "allclear", label: "10PC's"),
    Badge(badgeId: "100player", label: "Won some shit"),
    Badge(badgeId: "founder", label: "osk"),
    Badge(badgeId: "early-supporter", label: "Sus"),
    Badge(badgeId: "bugbounty", label: "Break some ribbons"),
    Badge(badgeId: "infdev", label: "Closed player")
  ],
  friendCount: 69,
  gamesPlayed: 13747,
  gamesWon: 6523,
  gameTime: Duration(days: 79, minutes: 28, seconds: 23, microseconds: 637591),
  xp: 1415239,
  supporterTier: 2,
  verified: true,
  connections: null,
  tlSeason1: TetraLeagueAlpha(timestamp: DateTime(1970), gamesPlayed: 28, gamesWon: 14, bestRank: "x", decaying: false, rating: 23500.6194, rank: "x", percentileRank: "x", percentile: 0.00, standing: 1, standingLocal: 1, nextAt: -1, prevAt: 500),
  distinguishment: Distinguishment(type: "twc", detail: "2023"),
  bio: "кровбер не в палку, без последнего тспина - 32 атаки. кровбер не в палку, без первого тсм и последнего тспина - 30 атаки. кровбер в палку с б2б - 38 атаки.(5 б2б)(не знаю от чего зависит) кровбер в палку с б2б - 36 атаки.(5 б2б)(не знаю от чего зависит)"
);
News testNews = News("6098518e3d5155e6ec429cdc", [
  NewsEntry(type: "personalbest", data: {"gametype": "40l", "result": 23.232}, timestamp: DateTime(2002, 2, 25, 10, 30, 01)),
  NewsEntry(type: "personalbest", data: {"gametype": "blitz", "result": 23.232}, timestamp: DateTime(2002, 2, 25, 10, 30, 02)),
  NewsEntry(type: "personalbest", data: {"gametype": "5mblast", "result": 23.232}, timestamp: DateTime(2002, 2, 25, 10, 30, 03)),
]);

class _MainState extends State<MainView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(
      children: [
        NavigationRail(
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: Text('First'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.book),
              label: Text('Second'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.star_border),
              selectedIcon: Icon(Icons.star),
              label: Text('Third'),
            )
          ],
          selectedIndex: 0
          ),
          SizedBox(
            width: 450.0,
            child: Column(
              children: [
                NewUserThingy(player: testPlayer, showStateTimestamp: false, setState: setState),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: ElevatedButton.icon(onPressed: (){print("ok, and?");}, icon: Icon(Icons.person_add), label: Text(t.track), style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(12.0), right: Radius.zero)))))),
                      Expanded(child: ElevatedButton.icon(onPressed: (){print("ok, and?");}, icon: Icon(Icons.balance), label: Text(t.compare), style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.zero, right: Radius.circular(12.0)))))))
                    ],
                  ),
                ),
                Card(
                  surfaceTintColor: theme.colorScheme.surface,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: Row(
                          children: [
                            Text("Badges", style: TextStyle(fontFamily: "Eurostile Round Extended")),
                            Spacer(),
                            Text(intf.format(testPlayer.badges.length))
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var badge in testPlayer.badges)
                            IconButton(
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(badge.label, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: 25,
                                            children: [
                                              Image.asset("res/tetrio_badges/${badge.badgeId}.png"),
                                              Text(badge.ts != null
                                                  ? t.obtainDate(date: timestamp(badge.ts!))
                                                  : t.assignedManualy),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(t.popupActions.ok),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                                ),
                                tooltip: badge.label,
                                icon: Image.asset(
                                  "res/tetrio_badges/${badge.badgeId}.png",
                                  height: 32,
                                  width: 32,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBadge&badge=${badge.badgeId}" : "https://tetr.io/res/badges/${badge.badgeId}.png",
                                      height: 32,
                                      width: 32,
                                      errorBuilder:(context, error, stackTrace) {
                                        return Image.asset("res/icons/kagari.png", height: 32, width: 32);
                                      }
                                    ); 
                                  },
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (testPlayer.distinguishment != null) DistinguishmentThingy(testPlayer.distinguishment!),
                if (testPlayer.bio != null) Card(
                  surfaceTintColor: theme.colorScheme.surface,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(), 
                          Text(t.bio, style: TextStyle(fontFamily: "Eurostile Round Extended")),
                          Spacer()
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: MarkdownBody(data: testPlayer.bio!, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center)),
                      )
                    ],
                  ),
                ),
                //if (testNews != null && testNews!.news.isNotEmpty)
                Expanded(child: NewsThingy(testNews))
              ],
            )
          ),
          SizedBox(
            width: 450.0,
            child: Column(
              children: [
                
              ],
            ),
          )
      ],
    ));
  }
}

class NewsThingy extends StatelessWidget{
  final News news;

  NewsThingy(this.news);

  ListTile getNewsTile(NewsEntry news){
    Map<String, String> gametypes = {
      "40l": t.sprint,
      "blitz": t.blitz,
      "5mblast": "5,000,000 Blast"
    };

    // Individuly handle each entry type
    switch (news.type) {
      case "leaderboard":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.leaderboardStart,
              children: [
                TextSpan(text: "№${news.data["rank"]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.leaderboardMiddle),
                TextSpan(text: "№${gametypes[news.data["gametype"]]}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
        );
      case "personalbest":
      return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.personalbest,
              children: [
                TextSpan(text: "${gametypes[news.data["gametype"]]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.personalbestMiddle),
                TextSpan(text: news.data["gametype"] == "blitz" ? NumberFormat.decimalPattern().format(news.data["result"]) : get40lTime((news.data["result"]*1000).floor()), style: const TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/icons/improvement-local.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "badge":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.badgeStart,
              children: [
                TextSpan(text: "${news.data["label"]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.badgeEnd)
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/tetrio_badges/${news.data["type"]}.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "rankup":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.rankupStart,
              children: [
                TextSpan(text: t.newsParts.rankupMiddle(r: news.data["rank"].toString().toUpperCase()), style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.rankupEnd)
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/tetrio_tl_alpha_ranks/${news.data["rank"]}.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "supporter":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.supporterStart,
              children: [
                TextSpan(text: t.newsParts.tetoSupporter, style: const TextStyle(fontWeight: FontWeight.bold))
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/icons/supporter-tag.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "supporter_gift":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.supporterGiftStart,
              children: [
                TextSpan(text: t.newsParts.tetoSupporter, style: const TextStyle(fontWeight: FontWeight.bold))
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/icons/supporter-tag.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      default: // if type is unknown
      return ListTile(
        title: Text(t.newsParts.unknownNews(type: news.type)),
        subtitle: Text(timestamp(news.timestamp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: theme.colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Spacer(), 
                Text(t.news, style: TextStyle(fontFamily: "Eurostile Round Extended")),
                Spacer()
              ]
            ),
            for (NewsEntry entry in news.news) getNewsTile(entry)
          ],
        ),
      ),
    );
  }

}

class DistinguishmentThingy extends StatelessWidget{
  final Distinguishment distinguishment;

  DistinguishmentThingy(this.distinguishment, {super.key});

  List<InlineSpan> getDistinguishmentTitle(String? text) {
    // TWC champions don't have header in their distinguishments
    if (distinguishment.type == "twc") return [const TextSpan(text: "TETR.IO World Champion", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellowAccent))];
    // In case if it missing for some other reason, return this 
    if (text == null) return [const TextSpan(text: "Header is missing", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent))];
    
    // Handling placeholders for logos
    var exploded = text.split(" "); // wtf PHP reference?
    List<InlineSpan> result = [];
    for (String shit in exploded){
      switch (shit) { // if %% thingy was found, insert svg of icon
        case "%osk%":
          result.add(WidgetSpan(child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SvgPicture.asset("res/icons/osk.svg", height: 28),
          )));
          break;
        case "%tetrio%":
          result.add(WidgetSpan(child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SvgPicture.asset("res/icons/tetrio-logo.svg", height: 28),
          )));
          break;
        default: // if not, insert text span
          result.add(TextSpan(text: " $shit", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)));
      }
    }
    return result;
  }

  /// Distinguishment title is barely predictable thing.
  /// Receives [text], which is footer and returns sets of widgets for RichText widget
  String getDistinguishmentSubtitle(String? text){
    // TWC champions don't have footer in their distinguishments
    if (distinguishment.type == "twc") return "${distinguishment.detail} TETR.IO World Championship";
    // In case if it missing for some other reason, return this 
    if (text == null) return "Footer is missing";
    // If everything ok, return as it is
    return text;
  }
  
  Color getCardTint(String type, String detail){
    switch(type){
      case "staff":
        switch(detail){
          case "founder": return Color(0xAAFD82D4);
          case "kagarin": return Color(0xAAFF0060);
          case "team": return Color(0xAAFACC2E);
          case "team-minor": return Color(0xAAF5BD45);
          case "administrator": return Color(0xAAFF4E8A);
          case "globalmod": return Color(0xAAE878FF);
          case "communitymod": return Color(0xAA4E68FB);
          case "alumni": return Color(0xAA6057DB);
          default: return theme.colorScheme.surface;
        }
      case "champion":
        switch (detail){
          case "blitz":
          case "40l": return Color(0xAACCF5F6);
          case "league": return Color(0xAAFFDB31);
        }
      case "twc": return Color(0xAAFFDB31);
      default: return theme.colorScheme.surface;
    }
    return theme.colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: getCardTint(distinguishment.type, distinguishment.detail??"null"),
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Text(t.distinguishment, style: TextStyle(fontFamily: "Eurostile Round Extended")),
              Spacer()
            ],
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: getDistinguishmentTitle(distinguishment.header),
            ),
          ),
          Text(getDistinguishmentSubtitle(distinguishment.footer), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class NewUserThingy extends StatelessWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final Function setState;
  
  const NewUserThingy({super.key, required this.player, required this.showStateTimestamp, required this.setState});

  Color roleColor(String role){
    switch (role){
      case "sysop":
        return Color.fromARGB(255, 23, 165, 133);
      case "admin":
        return Color.fromARGB(255, 255, 78, 138);
      case "mod":
        return Color.fromARGB(255, 204, 128, 242);
      case "halfmod":
        return Color.fromARGB(255, 95, 118, 254);
      case "bot":
        return Color.fromARGB(255, 60, 93, 55);
      case "banned":
        return Color.fromARGB(255, 248, 28, 28);
      default:
        return Colors.white10;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      double pfpHeight = 128;
      int xpTableID = 0;

      while (player.xp > xpTableScuffed.values.toList()[xpTableID]) {
        xpTableID++;
      }

      return Card(
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 960),
                height: player.bannerRevision != null ? 218.0 : 138.0,
                child: Stack(
                //clipBehavior: Clip.none,
                children: [
                  if (player.bannerRevision != null) Image.network(kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${player.userId}&rv=${player.bannerRevision}" : "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                    fit: BoxFit.cover,
                    height: 120,
                    //width: 450,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 90.0 : 10.0,
                    left: 16.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                        ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: pfpHeight,)
                        : player.avatarRevision != null
                          ? Image.network(kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${player.userId}&rv=${player.avatarRevision}" : "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                            // TODO: osk banner can cause memory leak
                      fit: BoxFit.fitHeight, height: 128, errorBuilder: (context, error, stackTrace) {
                        return Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight);
                        })
                          : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight),
                    )
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 120.0 : 40.0,
                    left: 160.0,
                    child: Text(player.username,
                      //softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontFamily: "Eurostile Round Extended",
                        fontSize: 28,
                      )
                    ),
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 160.0 : 80.0,
                    left: 160.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Chip(label: Text(player.role.toUpperCase(), style: TextStyle(shadows: textShadow),), padding: EdgeInsets.all(0.0), color: MaterialStatePropertyAll(roleColor(player.role))),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: "Eurostile Round"),
                            children:
                            [
                            if (player.friendCount > 0) WidgetSpan(child: Icon(Icons.person), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (player.friendCount > 0) TextSpan(text: "${intf.format(player.friendCount)} "),
                            if (player.supporterTier > 0) WidgetSpan(child: Icon(player.supporterTier > 1 ? Icons.star : Icons.star_border, color: player.supporterTier > 1 ? Colors.yellowAccent : Colors.white), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (player.supporterTier > 0) TextSpan(text: player.supporterTier.toString(), style: TextStyle(color: player.supporterTier > 1 ? Colors.yellowAccent : Colors.white)),
                            ] 
                          ) 
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 193.0 : 113.0,
                    left: 160.0,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontFamily: "Eurostile Round"),
                        children: [
                          if (player.country != null) TextSpan(text: "${t.countries[player.country]} • "),
                          TextSpan(text: "${player.registrationTime == null ? t.wasFromBeginning : '${timestamp(player.registrationTime!)}'}", style: TextStyle(color: Colors.grey))
                        ]
                      )
                    )
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 126.0 : 46.0,
                    right: 16.0,
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        style: TextStyle(fontFamily: "Eurostile Round"),
                        children: [
                          TextSpan(text: "Level ${intf.format(player.level.floor())}", recognizer: TapGestureRecognizer()..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Level ${intf.format(player.level.floor())}"),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      "${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2).format(player.xp)} XP",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontWeight: FontWeight.bold)
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: SfLinearGauge(
                                        minimum: 0,
                                        maximum: 1,
                                        interval: 1, 
                                        ranges: [
                                          LinearGaugeRange(startValue: 0, endValue: player.level - player.level.floor(), color: Colors.cyanAccent),
                                          LinearGaugeRange(startValue: 0, endValue: (player.xp / xpTableScuffed.values.toList()[xpTableID]), color: Colors.redAccent, position: LinearElementPosition.cross)
                                          ],
                                        showTicks: true,
                                        showLabels: false
                                        ),
                                    ),
                                    Text("${t.statCellNum.xpProgress}: ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} %"),
                                    Text("${t.statCellNum.xpFrom0ToLevel(n: xpTableScuffed.keys.toList()[xpTableID])}: ${((player.xp / xpTableScuffed.values.toList()[xpTableID]) * 100).toStringAsFixed(2)} % (${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(xpTableScuffed.values.toList()[xpTableID] - player.xp)} ${t.statCellNum.xpLeft})")
                                    ]
                                    ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {Navigator.of(context).pop();}
                                  )  
                                ]
                              )
                            );
                          }),
                          TextSpan(text:"\n"),
                          TextSpan(text: player.gameTime.isNegative ? "-h --m" : playtime(player.gameTime), style: TextStyle(color: player.gameTime.isNegative ? Colors.grey : Colors.white), recognizer: TapGestureRecognizer()..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(t.exactGametime),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      //"${intf.format(testPlayer.gameTime.inDays)} d\n${nonsecs.format(testPlayer.gameTime.inHours%24)} h\n${nonsecs.format(testPlayer.gameTime.inMinutes%60)} m\n${nonsecs.format(testPlayer.gameTime.inSeconds%60)} s\n${nonsecs3.format(testPlayer.gameTime.inMilliseconds%1000)} ms\n${nonsecs.format(testPlayer.gameTime.inMicroseconds%1000)} μs",
                                      "${intf.format(testPlayer.gameTime.inDays)}d ${nonsecs.format(testPlayer.gameTime.inHours%24)}h ${nonsecs.format(testPlayer.gameTime.inMinutes%60)}m ${nonsecs.format(testPlayer.gameTime.inSeconds%60)}s ${nonsecs3.format(testPlayer.gameTime.inMilliseconds%1000)}ms ${nonsecs.format(testPlayer.gameTime.inMicroseconds%1000)}μs",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 24)
                                      ),
                                    ]
                                    ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {Navigator.of(context).pop();}
                                  )  
                                ]
                              )
                            );
                          }),
                          TextSpan(text:"\n"),
                          TextSpan(text: "${player.gamesWon > -1 ? intf.format(player.gamesWon) : "---"}", style: TextStyle(color: player.gamesWon > -1 ? Colors.white : Colors.grey)),
                          TextSpan(text: "/${player.gamesPlayed > -1 ? intf.format(player.gamesPlayed) : "---"}", style: TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
                        ]
                      )
                    )
                  )
                ],
                          ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     ElevatedButton.icon(onPressed: (){print("ok, and?");}, icon: Icon(Icons.person_add), label: Text(t.track), style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(8), right: Radius.zero))))),
              //     ElevatedButton.icon(onPressed: (){print("ok, and?");}, icon: Icon(Icons.balance), label: Text(t.compare), style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.zero, right: Radius.circular(8))))))
              //   ]
              // )
            ],
          ),
        ),
      );
    });
  }
}