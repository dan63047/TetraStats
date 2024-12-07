import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/copy_to_clipboard.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/compare_view_tiles.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:transparent_image/transparent_image.dart';

class UserThingy extends StatefulWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final bool initIsTracking;
  final Function setState;
  
  const UserThingy({super.key, required this.player, required this.initIsTracking, required this.showStateTimestamp, required this.setState});

  @override
  State<UserThingy> createState() => _UserThingyState();
}

class _UserThingyState extends State<UserThingy> with SingleTickerProviderStateMixin {
  late AnimationController _addToTrackAnimController;
  late Animation _addToTrackAnim;

  @override
  void initState(){
    _addToTrackAnimController = AnimationController(
      value: widget.initIsTracking ? 1.0 : 0.0,
      duration: Durations.extralong4,
      vsync: this,
    );
    _addToTrackAnim = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
      parent: _addToTrackAnimController,
      curve: Cubic(.15,-0.40,.86,-0.39),
      reverseCurve: Cubic(0,.99,.99,1.01)
    ));
    
    super.initState();
  }

  @override
  void dispose() {
    _addToTrackAnimController.dispose();
    super.dispose();
  }

  Color roleColor(String role){
    switch (role){
      case "sysop":
        return const Color.fromARGB(255, 23, 165, 133);
      case "admin":
        return const Color.fromARGB(255, 255, 78, 138);
      case "mod":
        return const Color.fromARGB(255, 204, 128, 242);
      case "halfmod":
        return const Color.fromARGB(255, 95, 118, 254);
      case "bot":
        return const Color.fromARGB(255, 60, 93, 55);
      case "banned":
        return const Color.fromARGB(255, 248, 28, 28);
      default:
        return Colors.white10;
    }
  }

  String fontStyle(int length){
    if (length < 10) return "Eurostile Round Extended";
    else if (length < 13) return "Eurostile Round";
    else return "Eurostile Round Condensed";
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      double pfpHeight = 128;
      int xpTableID = 0;

      while (widget.player.xp > xpTableScuffed.values.toList()[xpTableID]) {
        xpTableID++;
      }

      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 960),
                height: widget.player.bannerRevision != null ? 218.0 : 138.0,
                child: Stack(
                //clipBehavior: Clip.none,
                children: [
                  // TODO: osk banner can cause memory leak
                  if (widget.player.bannerRevision != null) FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${widget.player.userId}&rv=${widget.player.bannerRevision}" : "https://tetr.io/user-content/banners/${widget.player.userId}.jpg?rv=${widget.player.bannerRevision}",
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                    height: 120,
                    fadeInCurve: Easing.standard, fadeInDuration: Durations.long4
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 90.0 : 10.0,
                    left: 16.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: widget.player.role == "banned"
                        ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: pfpHeight,)
                        : widget.player.avatarRevision != null
                          ? FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${widget.player.userId}&rv=${widget.player.avatarRevision}" : "https://tetr.io/user-content/avatars/${widget.player.userId}.jpg?rv=${widget.player.avatarRevision}",
                            fit: BoxFit.fitHeight, height: 128, placeholder: kTransparentImage, fadeInCurve: Easing.emphasizedDecelerate, fadeInDuration: Durations.long4)
                          : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight),
                    )
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 120.0 : 40.0,
                    left: 160.0,
                    child: Tooltip(
                      message: "${widget.player.userId}\n(${t.copyUserID})",
                      child: RichText(text: TextSpan(text: widget.player.username, style: TextStyle(
                          fontFamily: fontStyle(widget.player.username.length),
                          fontSize: 28,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                            copyToClipboard(widget.player.userId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copiedToClipboard)));
                          }
                        )
                      ) 
                    ),
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 160.0 : 80.0,
                    left: 160.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Tooltip(
                            message: t.playerRole[widget.player.role]??"Unknown role ${widget.player.role}",
                            child: Chip(label: Text(widget.player.role.toUpperCase(), style: const TextStyle(shadows: textShadow),), padding: const EdgeInsets.all(0.0), color: WidgetStatePropertyAll(roleColor(widget.player.role)))
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontFamily: "Eurostile Round"),
                            children:
                            [
                            if (widget.player.friendCount > 0) WidgetSpan(child: Tooltip(message: t.stats.followers, child: Icon(Icons.person)), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (widget.player.friendCount > 0) TextSpan(text: "${intf.format(widget.player.friendCount)} "),
                            if (widget.player.supporterTier > 0) WidgetSpan(child: Tooltip(message: t.supporter(tier: widget.player.supporterTier), child: Icon(widget.player.supporterTier > 1 ? Icons.star : Icons.star_border, color: widget.player.supporterTier > 1 ? Colors.yellowAccent : Colors.white)), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (widget.player.supporterTier > 0) TextSpan(text: widget.player.supporterTier.toString(), style: TextStyle(color: widget.player.supporterTier > 1 ? Colors.yellowAccent : Colors.white)),
                            ] 
                          ) 
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 193.0 : 113.0,
                    left: 160.0,
                    child: SizedBox(
                      width: 270,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontFamily: "Eurostile Round"),
                          children: [
                            TextSpan(text: timestamp(widget.player.registrationTime), style: const TextStyle(color: Colors.grey)),
                            if (widget.player.country != null) TextSpan(text: " • ${t.countries[widget.player.country]}")
                          ]
                        )
                      ),
                    )
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 126.0 : 46.0,
                    right: 16.0,
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        style: const TextStyle(fontFamily: "Eurostile Round"),
                        children: [
                          TextSpan(text: "Level ${(widget.player.level.isNegative || widget.player.level.isNaN) ? "---" : intf.format(widget.player.level.floor())}", style: TextStyle(decoration: (widget.player.level.isNegative || widget.player.level.isNaN) ? null : TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: (widget.player.level.isNegative || widget.player.level.isNaN) ? Colors.grey : Colors.white), recognizer: (widget.player.level.isNegative || widget.player.level.isNaN) ? null : TapGestureRecognizer()?..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("${t.stats.level.full} ${intf.format(widget.player.level.floor())}", textAlign: TextAlign.center),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      "${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2).format(widget.player.xp)} ${t.stats.xp.short}",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontWeight: FontWeight.bold)
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: SfLinearGauge(
                                        minimum: 0,
                                        maximum: 1,
                                        interval: 1, 
                                        ranges: [
                                          LinearGaugeRange(startValue: 0, endValue: widget.player.level - widget.player.level.floor(), color: Colors.cyanAccent),
                                          LinearGaugeRange(startValue: 0, endValue: (widget.player.xp / xpTableScuffed.values.toList()[xpTableID]), color: Colors.redAccent, position: LinearElementPosition.cross)
                                          ],
                                        showTicks: true,
                                        showLabels: false
                                        ),
                                    ),
                                    Text(t.xp.progressToNextLevel(percentage: percentage.format((widget.player.level - widget.player.level.floor())))),
                                    Text(t.xp.progressTowardsGoal(goal: xpTableScuffed.keys.toList()[xpTableID], percentage: percentage.format(widget.player.xp / xpTableScuffed.values.toList()[xpTableID]), left: NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(xpTableScuffed.values.toList()[xpTableID] - widget.player.xp)))
                                    ]
                                    ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(t.actions.ok),
                                    onPressed: () {Navigator.of(context).pop();}
                                  )  
                                ]
                              )
                            );
                          }),
                          const TextSpan(text:"\n"),
                          TextSpan(text: widget.player.gameTime.isNegative ? "-h --m" : playtime(widget.player.gameTime), style: TextStyle(color: widget.player.gameTime.isNegative ? Colors.grey : Colors.white, decoration: widget.player.gameTime.isNegative ? null : TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted), recognizer: !widget.player.gameTime.isNegative ? (TapGestureRecognizer()..onTap = (){
                            Duration accountAge = DateTime.timestamp().difference(widget.player.registrationTime);
                            Duration avgGametimeADay = Duration(microseconds: (widget.player.gameTime.inMicroseconds / accountAge.inDays).floor());
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(t.gametime.title, textAlign: TextAlign.center),  
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                    RichText(text: TextSpan(
                                      style: TextStyle(fontFamily: "Eurostile Round", color: Colors.white, fontSize: 28),
                                      children: [
                                        TextSpan(text: "${intf.format(widget.player.gameTime.inHours)}"),
                                        TextSpan(text: ":${nonsecs.format(widget.player.gameTime.inMinutes%60)}:${nonsecs.format(widget.player.gameTime.inSeconds%60)}"),
                                        TextSpan(text: ".${nonsecs3.format(widget.player.gameTime.inMicroseconds%1000000)}", style: TextStyle(fontSize: 14))
                                      ]
                                    )),
                                    Text(t.gametime.gametimeAday(gametime: playtime(avgGametimeADay))),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        t.gametime.breakdown(
                                          years: f4.format(widget.player.gameTime.inSeconds/31536000),
                                          months: f4.format(widget.player.gameTime.inSeconds/2628000),
                                          days: f4.format(widget.player.gameTime.inSeconds/86400),
                                          minutes: f2.format(widget.player.gameTime.inMilliseconds/60000),
                                          seconds: intf.format(widget.player.gameTime.inSeconds)
                                        )
                                      ),
                                    )
                                    ]
                                    ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(t.actions.ok),
                                    onPressed: () {Navigator.of(context).pop();}
                                  )  
                                ]
                              )
                            );
                          }) : null),
                          const TextSpan(text:"\n"),
                          TextSpan(text: widget.player.gamesWon > -1 ? intf.format(widget.player.gamesWon) : "---", style: TextStyle(color: widget.player.gamesWon > -1 ? Colors.white : Colors.grey)),
                          TextSpan(text: "/${widget.player.gamesPlayed > -1 ? intf.format(widget.player.gamesPlayed) : "---"}", style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
                        ]
                      )
                    )
                  )
                ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _addToTrackAnim,
                    builder: (context, child) {
                      double firstButtonPosition = 0+(_addToTrackAnim.value as double)*25;
                      double secondButtonPosition = -25+(_addToTrackAnim.value as double)*25;
                      double firstButtonOpacity = 1-(_addToTrackAnim.value as double)*2;
                      double secondButtonOpacity = _addToTrackAnim.value*2-1;
                      return ElevatedButton.icon(
                      onPressed: (){
                        _addToTrackAnimController.value == 1 ? teto.deletePlayerToTrack(widget.player.userId) : teto.addPlayerToTrack(widget.player); 
                        _addToTrackAnim.isCompleted ? _addToTrackAnimController.reverse() : _addToTrackAnimController.forward();
                      },
                      icon: _addToTrackAnim.value < 0.5 ? Opacity(
                        opacity: min(1, firstButtonOpacity),
                        child: Transform.translate(
                          offset: Offset(0, _addToTrackAnim.status == AnimationStatus.forward ? firstButtonPosition*4 : firstButtonPosition),
                          child: Transform.rotate(
                            angle:_addToTrackAnim.status == AnimationStatus.forward ? (_addToTrackAnim.value as double)*2 : 0,
                            child: const Icon(Icons.person_add),
                          ),
                        ),
                      ) : Container(
                        transform: Matrix4.translationValues(secondButtonPosition*5, -secondButtonPosition*25, 0),
                        child: Opacity(
                          opacity: max(0, min(1, secondButtonOpacity)),
                          child: Transform.rotate(
                            angle:_addToTrackAnim.status == AnimationStatus.reverse ? (1-_addToTrackAnim.value as double)*-20 : 0,
                            child: const Icon(Icons.person_remove)
                          )
                        )
                      ),
                      label: _addToTrackAnim.value < 0.5 ? Container(
                        transform: Matrix4.translationValues(0, firstButtonPosition, 0),
                        child: Opacity(
                          opacity: max(min(1, firstButtonOpacity), 0),
                          child: Text(_addToTrackAnimController.isAnimating && _addToTrackAnim.status == AnimationStatus.forward ? t.settingsDestination.done : t.track)
                        )
                      ) : Container(
                        transform: Matrix4.translationValues(0, secondButtonPosition, 0),
                        child: Opacity(
                          opacity: max(0, min(1, secondButtonOpacity)),
                          child: Text(_addToTrackAnimController.isAnimating && _addToTrackAnim.status == AnimationStatus.reverse ? t.settingsDestination.done : t.stopTracking)
                        )
                      ),
                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0))))));
                    },
                  )),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CompareView(widget.player),
                      ),
                      );
                    },
                    icon: const Icon(Icons.balance),
                    label: Text(t.compare),
                    style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)))))
                  )
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
