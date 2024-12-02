import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';

class FakeDistinguishmentThingy extends StatelessWidget{
  final bool banned;
  final bool badStanding;
  final bool bot;
  final String? botMaintainers;

  FakeDistinguishmentThingy({super.key, this.banned = false, this.badStanding = false, this.bot = false, this.botMaintainers});

  Color getCardTint(){
    if (banned) return Colors.red;
    if (badStanding) return Colors.redAccent;
    if (bot) return const Color.fromARGB(255, 60, 93, 55);
    return theme.colorScheme.surface;
  }

  InlineSpan getDistinguishmentTitle() {
    String text = "";
    if (banned) text = t.banned;
    if (badStanding) text = t.badStanding;
    if (bot) text = t.botAccount;
    return TextSpan(text: text.toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white));
  }

  String getDistinguishmentSubtitle(){
    if (banned) return t.bannedSubtext;
    if (badStanding) return t.badStandingSubtext;
    if (bot) return t.botAccountSubtext(botMaintainers: botMaintainers!);
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: getCardTint(),
      child: Container(
        decoration: banned ? const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Color.fromARGB(171, 244, 67, 54), Color.fromARGB(171, 244, 67, 54)],
            stops: [0.1, 0.9, 0.01],
            tileMode: TileMode.mirror,
            begin: Alignment.topLeft,
            end: AlignmentDirectional(-0.95, -0.95)
          )
        ) : null,
        child: Column(
          children: [
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [getDistinguishmentTitle()],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              child: Text(getDistinguishmentSubtitle(), style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  } 
}