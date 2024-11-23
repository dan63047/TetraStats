import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:window_manager/window_manager.dart';

late String oldWindowTitle;
final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode);

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<StatefulWidget> createState() => AboutState();
}

class AboutCard extends StatelessWidget{
  final String title;
  final String value;
  final String? undervalue; //what?
  final List<InlineSpan> endvalue; // ...

  const AboutCard(this.title, this.value, this.undervalue, this.endvalue);

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
        Divider(),
        Text(value, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white)),
        if (undervalue != null) Text(undervalue!, textAlign: TextAlign.center),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey, height: 0.6),
              children: endvalue
            )
          ),
        )
      ],
    ));
  }
}

class AboutState extends State<AboutView> {

  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.settings}");
    }
    super.initState();
  }

  @override
  void dispose(){
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width >= 368;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Fuck go back',
          child: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(child: Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 18.0),
              child: Text("About Tetra Stats", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            ))),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 568.00),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Tetra Stats is a service, that works with TETR.IO Tetra Channel API, providing data from it and calculating some addtitional metrics, based on this data. Service allows user to track their progress in Tetra League with \"Track\" function, which records every Tetra League change into local database (not automatically, you have to visit service from time to time), so these changes could be looked through graphs.\n\nBeanserver blaster is a part of a Tetra Stats, that decoupled into a serverside script. It provides full Tetra League leaderboard, allowing Tetra Stats to sort leaderboard by any metric and build scatter chart, that allows user to analyse Tetra League trends. It also provides history of Tetra League ranks cutoffs, which can be viewed by user via graph as well.\n\nThere is a plans to add replay analysis and tournaments history, so stay tuned!\n\nService is not associated with TETR.IO or osk in any capacity."
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
                AboutCard("App Version", packageInfo.version, "Build ${packageInfo.buildNumber}", [
                  TextSpan(text: "${packageInfo.appName} (${packageInfo.packageName}) • "),
                  TextSpan(text: "GitHub Repo", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("github.com", "dan63047/TetraStats"));}),
                  TextSpan(text: " • "),
                  TextSpan(text: "Submit an issue", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("github.com", "dan63047/TetraStats/issues/new/choose"));}),
                ]),
                Card(child: Center(child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 18.0),
                  child: Text("Credits", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                ))),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard("Autor & developer", "dan63", null, [
                      TextSpan(text: "Support him!", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("dan63.by", "donate"));})
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard("Provided formulas", "kerrmunism", null, [
                      //TextSpan(text: "Support him!", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("paypal.com", "paypalme/Kerrmunism"));})
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard("Provided S1 history", "p1nkl0bst3r", null, [
                      //TextSpan(text: "Support him!", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("paypal.com", "paypalme/Kerrmunism"));})
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard("Inoue (replay grabber)", "szy", null, [
                      //TextSpan(text: "Support him!", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("paypal.com", "paypalme/Kerrmunism"));})
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard("Simplfied Chinise locale", "neko_ab4093", null, [
                      //TextSpan(text: "Support him!", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("paypal.com", "paypalme/Kerrmunism"));})
                    ])),
                  ],
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
