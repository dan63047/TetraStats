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
  final bool smallValue; // it's about size lol
  final String? undervalue; //what?
  final List<InlineSpan> endvalue; // ...

  const AboutCard(this.title, this.value, this.undervalue, this.endvalue, {this.smallValue=false});

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
        Divider(),
        Text(value, textAlign: TextAlign.center, style: smallValue ? null : Theme.of(context).textTheme.headlineMedium),
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
      windowManager.setTitle(t.aboutView.title);
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: t.goBackButton,
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
              child: Text(t.aboutView.title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
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
                          child: Text(textAlign: TextAlign.center, t.aboutView.about),
                        ),
                      ),
                    ),
                  ],
                )),
                AboutCard(t.aboutView.appVersion, packageInfo.version, t.aboutView.build(build: packageInfo.buildNumber), [
                  TextSpan(text: "${packageInfo.appName} (${packageInfo.packageName}) • "),
                  TextSpan(text: t.aboutView.GHrepo, style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("github.com", "dan63047/TetraStats"));}),
                  TextSpan(text: " • "),
                  TextSpan(text: t.aboutView.submitAnIssue, style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("github.com", "dan63047/TetraStats/issues/new/choose"));}),
                ]),
                Card(child: Center(child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 18.0),
                  child: Text(t.aboutView.credits, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                ))),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.authorAndDeveloper, "dan63", null, [
                      TextSpan(text: t.aboutView.supportHim, style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: Theme.of(context).colorScheme.primary), recognizer: TapGestureRecognizer()..onTap = (){launchInBrowser(Uri.https("dan63.by", "donate"));})
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.providedFormulas, "kerrmunism", null, [
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.providedS1history, "p1nkl0bst3r", null, [
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.inoue, "szy", null, [
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.zhCNlocale, "neko_ab4093", null, [
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.deDElocale, "founntain", null, [
                    ])),
                    FractionallySizedBox(widthFactor: 1/((MediaQuery.of(context).size.width/600).ceil()), child: AboutCard(t.aboutView.koKRlocale, "Tau, ctpw, PyHoKxvx, muqhc,\nxantho, mazohu, CEL_ESTIAL, pensil", null, [
                    ], smallValue: true)),
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
