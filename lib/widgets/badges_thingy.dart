import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/badge.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class BadgesThingy extends StatelessWidget{
  final List<Badge> badges;

  const BadgesThingy({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Row(
              children: [
                const Text("Badges", style: TextStyle(fontFamily: "Eurostile Round Extended")),
                const Spacer(),
                Text(intf.format(badges.length))
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var badge in badges)
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
                            child: Text(t.actions.ok),
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
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBadge&badge=${badge.badgeId}" : "https://tetr.io/res/badges/${badge.badgeId}.png",
                          height: 32,
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
    );
  }
}