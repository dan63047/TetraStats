import 'dart:math';

import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/widgets/sankey_graph.dart';

class SankeyThingy extends StatelessWidget{
  final List<MinomuncherData> data;
  final double width;
  const SankeyThingy(this.data, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    List<SankeyDataSet> sankeys = [];
    List<SankeyNode> sankeyNodes = [
      SankeyNode(id: 0, label: 'Incoming Attack'),
      SankeyNode(id: 1, label: 'Cheese'),
      SankeyNode(id: 2, label: 'Clean'),
      SankeyNode(id: 3, label: 'Cancelled'),
      SankeyNode(id: 4, label: 'CheeseTanked'),
      SankeyNode(id: 5, label: 'CleanTanked'),
    ];
    for (MinomuncherData e in data){
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
    }
    Map<String, Color> nodeColors = generateDefaultNodeColorMap(sankeyNodes);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Incoming Attack Sankey Chart", style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
              for (int i = 0; i < data.length; i++) SankeyDiagramWidget(
                data: sankeys[i],
                nodeColors: nodeColors,
                size: Size(min(width - 32, 768), 400.0),
                showLabels: true,
              ),
          ],
        )
      )
    );
  }
}