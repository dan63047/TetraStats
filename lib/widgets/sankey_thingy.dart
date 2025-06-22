import 'dart:math';

import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/sankey_graph.dart';

class SankeyThingy extends StatelessWidget{
  final List<MinomuncherData> data;
  final double width;
  const SankeyThingy(this.data, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    List<SankeyDataSet> sankeys = [];
    Map<String, Color> nodeColors = {};
    for (MinomuncherData e in data){
      List<SankeyNode> sankeyNodes = [
        SankeyNode(id: 0, label: '${t.stats.incomingAttack} ${percentage.format(1)}'),
        SankeyNode(id: 1, label: '${t.stats.cheese.short} ${percentage.format(e.cheeseLinesRecieved)}'),
        SankeyNode(id: 2, label: '${t.stats.clean} ${percentage.format(e.cleanLinesRecieved)}'),
        SankeyNode(id: 3, label: '${t.stats.cancelled} ${percentage.format(e.cheeseLinesCancelled + e.cleanLinesCancelled)}'),
        SankeyNode(id: 4, label: '${t.stats.cheeseTanked} ${percentage.format(e.cheeseLinesTanked + e.cleanLinesTankedAsCheese)}'),
        SankeyNode(id: 5, label: '${t.stats.cleanTanked} ${percentage.format(e.cleanLinesTankedAsClean)}'),
      ];
      List<SankeyLink> sankeyLinks = [
        SankeyLink(source: sankeyNodes[0], target: sankeyNodes[1], value: e.cheeseLinesRecieved * 100),
        SankeyLink(source: sankeyNodes[0], target: sankeyNodes[2], value: e.cleanLinesRecieved * 100),
        SankeyLink(source: sankeyNodes[1], target: sankeyNodes[3], value: e.cheeseLinesCancelled * 100),
        SankeyLink(source: sankeyNodes[1], target: sankeyNodes[4], value: e.cheeseLinesTanked * 100),
        SankeyLink(source: sankeyNodes[2], target: sankeyNodes[3], value: e.cheeseLinesCancelled * 100),
        SankeyLink(source: sankeyNodes[2], target: sankeyNodes[4], value: e.cleanLinesTankedAsCheese * 100),
        SankeyLink(source: sankeyNodes[2], target: sankeyNodes[5], value: e.cleanLinesTankedAsClean * 100)
      ];
      SankeyDataSet sankeyDataSet = SankeyDataSet(nodes: sankeyNodes, links: sankeyLinks);
      final sankey = generateSankeyLayout(
        width: min(width - 32, 768),
        height: 400,
        nodeWidth: 20,
        nodePadding: 15,
      );
      sankeyDataSet.layout(sankey);
      sankeys.add(sankeyDataSet);
      nodeColors = generateDefaultNodeColorMap(sankeyNodes);
    }
    List<Widget> list = [Text(t.stats.sankeyTitle, style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall)];
    for (int i = 0; i < data.length; i++){
      if (data.length > 1) list.add(Text(data[i].nick, style: Theme.of(context).textTheme.titleSmall));
      list.add(SankeyDiagramWidget(
        data: sankeys[i],
        nodeColors: nodeColors,
        size: Size(min(width - 32, 768), 400.0),
        showLabels: true,
      ));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: list,
        )
      )
    );
  }
}