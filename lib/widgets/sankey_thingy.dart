import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/sankey_graph.dart';

class SankeyThingy extends StatelessWidget{
  final List<MinomuncherData> data;
  final double width;
  const SankeyThingy(this.data, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    List<SankeyNode> sankeyNodes = [
      SankeyNode(id: 0, label: 'Incoming Attack'),
      SankeyNode(id: 1, label: 'Cheese'),
      SankeyNode(id: 2, label: 'Clean'),
      SankeyNode(id: 3, label: 'Cancelled'),
      SankeyNode(id: 4, label: 'CheeseTanked'),
      SankeyNode(id: 5, label: 'CleanTanked'),
    ];
    List<SankeyLink> sankeyLinks = [
      SankeyLink(source: sankeyNodes[0], target: sankeyNodes[1], value: data[0].cheeseLinesRecieved * 100),
      SankeyLink(source: sankeyNodes[0], target: sankeyNodes[2], value: data[0].cleanLinesRecieved * 100),
      SankeyLink(source: sankeyNodes[1], target: sankeyNodes[3], value: data[0].cheeseLinesCancelled * 100),
      SankeyLink(source: sankeyNodes[1], target: sankeyNodes[4], value: data[0].cheeseLinesTanked * 100),
      SankeyLink(source: sankeyNodes[2], target: sankeyNodes[3], value: data[0].cheeseLinesCancelled * 100),
      SankeyLink(source: sankeyNodes[2], target: sankeyNodes[4], value: data[0].cleanLinesTankedAsCheese * 100),
      SankeyLink(source: sankeyNodes[2], target: sankeyNodes[5], value: data[0].cleanLinesTankedAsClean * 100)
    ];
    Map<String, Color> nodeColors = generateDefaultNodeColorMap(sankeyNodes);
    SankeyDataSet sankeyDataSet = SankeyDataSet(nodes: sankeyNodes, links: sankeyLinks);
    final sankey = generateSankeyLayout(
      width: 800,
      height: 400,
      nodeWidth: 20,
      nodePadding: 15,
    );
    sankeyDataSet.layout(sankey);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          children: [
            Text("Incoming Attack Sankey Chart", style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
              SankeyDiagramWidget(
                data: sankeyDataSet,
                nodeColors: nodeColors,
                size: Size(width, 400.0),
                showLabels: true,
              ),
          ],
        )
      )
    );
  }
}