import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:tetra_stats/views/about_view.dart';
import 'package:tetra_stats/views/sprint_and_blitz_averages.dart';

class DestinationInfo extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationInfo({super.key, required this.constraints});

  @override
  State<DestinationInfo> createState() => _DestinationInfo();  
}

class InfoCard extends StatelessWidget {
  final double height;
  final double viewportWidth;
  final String assetLink;
  final String? assetLinkOnFocus;
  final String title;
  final String description;
  final void Function() onPressed;

  const InfoCard({required this.height, this.viewportWidth = double.infinity, required this.assetLink, required this.title, required this.description, this.assetLinkOnFocus, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: viewportWidth > 768.0 ? SizedBox(
        width: 450,
        height: height,
        child: Column(
          children: [
            Image.asset(assetLink, fit: BoxFit.cover, height: 300.0),
            TextButton(child: Text(title, style: Theme.of(context).textTheme.titleLarge!.copyWith(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted), textAlign: TextAlign.center), onPressed: onPressed),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(description),
            ),
            Spacer()
          ],
        ),
      ) : SizedBox(
        width: viewportWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(assetLink, fit: BoxFit.cover, width: 200.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(child: Text(title, style: Theme.of(context).textTheme.titleLarge!.copyWith(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, fontSize: 28), textAlign: TextAlign.center), onPressed: onPressed),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(description),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}

class _DestinationInfo extends State<DestinationInfo> {
  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [
      InfoCard(
        height: widget.constraints.maxHeight - 77,
        viewportWidth: widget.constraints.maxWidth,
        assetLink: "res/images/info card 1.png",
        title: t.infoDestination.sprintAndBlitzAverages,
        description: "${t.infoDestination.sprintAndBlitzAveragesDescription}\n\n${t.sprintAndBlitsRelevance(date: DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).format(sprintAndBlitzRelevance))}",
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SprintAndBlitzView(),
          ));
        }
      ),
      InfoCard(
        height: widget.constraints.maxHeight - 77,
        viewportWidth: widget.constraints.maxWidth,
        assetLink: "res/images/info card 2.png",
        title: t.infoDestination.tetraStatsWiki,
        description: t.infoDestination.tetraStatsWikiDescription,
        onPressed: (){
          launchInBrowser(Uri.https("github.com", "dan63047/TetraStats/wiki"));
        }
      ),
      InfoCard(
        height: widget.constraints.maxHeight - 77,
        viewportWidth: widget.constraints.maxWidth,
        assetLink: "res/images/info card 3.png",
        title: t.infoDestination.about,
        description: t.infoDestination.aboutDescription,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AboutView(),
          ));
        },
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Center(child: Text(t.infoDestination.title, style: Theme.of(context).textTheme.titleLarge)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: widget.constraints.maxWidth > 768.0 ? Row(children: cards) : Column(children: cards),
        )
      ],
    );
  }
}
