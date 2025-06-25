import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/player_leaderboard_position.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/gauget_thingy.dart';

class NerdStatsThingy extends StatelessWidget{
	final NerdStats nerdStats;
	final NerdStats? oldNerdStats;
  final String? rank;
	final CutoffTetrio? averages;
	final PlayerLeaderboardPosition? lbPos;
	final double width;

	const NerdStatsThingy({super.key, required this.nerdStats, this.oldNerdStats, this.rank, this.averages, this.lbPos, this.width = double.infinity});

	Widget big(){
		return Stack(
		  children: [
		    SizedBox(
		    	height: 256.0,
		    	width: 256.0,
		    	child: ClipRRect(
		    		borderRadius: BorderRadius.circular(1000),
		    		child: Container(
		    			decoration: BoxDecoration(gradient: RadialGradient(colors: [Colors.black12.withAlpha(100), Colors.black], radius: 0.6)),
		    			child: SfRadialGauge(
		    				axes: [
		    					RadialAxis(
		    					startAngle: 190,
		    					endAngle: 350,
		    					showLabels: false,
		    					showTicks: true,
		    					radiusFactor: 1,
		    					centerY: 0.5,
		    					minimum: 0,
		    					maximum: 1,
                  majorTickStyle: MajorTickStyle(
                thickness: 1.0,
                color: Colors.grey.shade800
              ),
                  minorTickStyle: MinorTickStyle(
                thickness: 1.0,
                color: Colors.grey.shade800
              ),
		    				ranges: [
		    					GaugeRange(startValue: 0, endValue: 0.2, color: Colors.red),
		    					GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.yellow),
		    					GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.green),
		    					GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.blue),
		    					GaugeRange(startValue: 0.8, endValue: 1, color: Colors.purple),
		    				],
		    				pointers: [
		    					NeedlePointer(
		    						value: nerdStats.app,
		    						enableAnimation: true,
		    						needleLength: 0.9,
		    						needleStartWidth: 2,
		    						needleEndWidth: 15,
		    						knobStyle: const KnobStyle(color: Colors.transparent),
		    						gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
		    					],
		    				annotations: [
		    					GaugeAnnotation(widget: Container(child:
		    					RichText(
		    						textAlign: TextAlign.center,
		    						text: TextSpan(
		    							style: const TextStyle(fontFamily: "Eurostile Round", color: Colors.white),
		    							children: [
		    								TextSpan(text: "${t.stats.app.short}\n"),
		    								TextSpan(text: f3.format(nerdStats.app), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100, color: getStatColor(nerdStats.app, averages?.nerdStats?.app, true))),
		    								if (lbPos != null) TextSpan(text: lbPos!.app!.position >= 1000 ? "\n${t.top} ${f2.format(lbPos!.app!.percentage*100)}%" : "\n№${lbPos!.app!.position}", style: TextStyle(color: getColorOfRank(lbPos!.app!.position))),
		    								if (oldNerdStats != null) TextSpan(text: "\n${comparef.format(nerdStats.app - oldNerdStats!.app)}", style: TextStyle(color: getDifferenceColor(nerdStats.app - oldNerdStats!.app)))
		    							]
		    					))),
		    					angle: 270,positionFactor: 0.5
		    					)],
		    					),
		    					RadialAxis(
		    						startAngle: 20,
		    						endAngle: 160,
		    						isInversed: true,
		    						showLabels: false,
		    						showTicks: true,
		    						radiusFactor: 1,
		    						centerY: 0.5,
		    						minimum: 1.8,
		    						maximum: 2.4,
                    majorTickStyle: MajorTickStyle(
                thickness: 1.0,
                color: Colors.grey.shade800
              ),
                  minorTickStyle: MinorTickStyle(
                thickness: 1.0,
                color: Colors.grey.shade800
              ),
		    					ranges: [
		    						GaugeRange(startValue: 1.8, endValue: 2.0, color: Colors.green),
		    						GaugeRange(startValue: 2.0, endValue: 2.2, color: Colors.blue),
		    						GaugeRange(startValue: 2.2, endValue: 2.4, color: Colors.purple),
		    					],
		    					pointers: [
		    						NeedlePointer(
		    							value: nerdStats.vsapm,
		    							enableAnimation: true,
		    							needleLength: 0.9,
		    							needleStartWidth: 2,
		    							needleEndWidth: 15,
		    							knobStyle: const KnobStyle(color: Colors.transparent),
		    							gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
		    						],
		    						annotations: [
		    							GaugeAnnotation(widget: Container(child:
		    							RichText(
		    								textAlign: TextAlign.center,
		    								text: TextSpan(
		    									style: const TextStyle(fontFamily: "Eurostile Round", color: Colors.white),
		    									children: [
		    										TextSpan(text: "${t.stats.vsapm.short}\n"),
		    										TextSpan(text: f3.format(nerdStats.vsapm), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100, color: getStatColor(nerdStats.vsapm, averages?.nerdStats?.vsapm, true))),
		    										if (lbPos != null) TextSpan(text: lbPos!.vsapm!.position >= 1000 ? "\n${t.top} ${f2.format(lbPos!.vsapm!.percentage*100)}%" : "\n№${lbPos!.vsapm!.position}", style: TextStyle(color: getColorOfRank(lbPos!.vsapm!.position))),
		    										if (oldNerdStats != null) TextSpan(text: "\n${comparef.format(nerdStats.vsapm - oldNerdStats!.vsapm)}", style: TextStyle(color: getDifferenceColor(nerdStats.vsapm - oldNerdStats!.vsapm))),
		    									]
		    							))),
		    							angle: 90,positionFactor: 0.5
		    							)
		    						],
		    					)
		    				]
		    			),
		    		),
		    	),
		    ),
		  ],
		);
	}

	Widget manySmalls(){
		return Wrap(
			alignment: WrapAlignment.center,
			spacing: 10.0,
			runSpacing: 10.0,
			runAlignment: WrapAlignment.start,
			children: [
				Tooltip(
					message: "${t.stats.dss.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f3.format(averages?.nerdStats?.dss)} ${t.stats.dss.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.dss,
						oldValue: oldNerdStats?.dss,
						min: 0, max: 1.0, tickInterval: .2,
						label: t.stats.dss.short,
						sideSize: 128.0, fractionDigits: 3,
						moreIsBetter: true,
						avgValue: averages?.nerdStats?.dss,
						lbPos: lbPos?.dss
					)
				),
				Tooltip(
					message: "${t.stats.dsp.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f3.format(averages?.nerdStats?.dsp)} ${t.stats.dsp.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.dsp,
						oldValue: oldNerdStats?.dsp,
						min: 0, max: 1.0, tickInterval: .2,
						label: t.stats.dsp.short,
						sideSize: 128.0, fractionDigits: 3,
						moreIsBetter: true,
						avgValue: averages?.nerdStats?.dsp,
						lbPos: lbPos?.dsp
					),
				),
				Tooltip(
					message: "${t.stats.appdsp.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f3.format(averages?.nerdStats?.appdsp)} ${t.stats.appdsp.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.appdsp,
						oldValue: oldNerdStats?.appdsp,
						min: 0, max: 1.2, tickInterval: .2,
						label: t.stats.appdsp.short,
						sideSize: 128.0, fractionDigits: 3,
						moreIsBetter: true,
						avgValue: averages?.nerdStats?.appdsp,
						lbPos: lbPos?.appdsp
					),
				),
				Tooltip(
					message: "${t.stats.cheese.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f2.format(averages?.nerdStats?.cheese)} ${t.stats.cheese.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.cheese,
						oldValue: oldNerdStats?.cheese,
						min: -80, max: 80, tickInterval: 40,
						label: t.stats.cheese.short,
						sideSize: 128.0, fractionDigits: 2,
						moreIsBetter: false,
						lbPos: lbPos?.cheese
					),
				),
				Tooltip(
					message: "${t.stats.gbe.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f3.format(averages?.nerdStats?.gbe)} ${t.stats.gbe.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.gbe,
						oldValue: oldNerdStats?.gbe,
						min: 0, max: 1.0, tickInterval: .2,
						label: t.stats.gbe.short,
						sideSize: 128.0, fractionDigits: 3,
						moreIsBetter: true,
						avgValue: averages?.nerdStats?.gbe,
						lbPos: lbPos?.gbe
					),
				),
				Tooltip(
					message: "${t.stats.nyaapp.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f3.format(averages?.nerdStats?.nyaapp)} ${t.stats.nyaapp.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.nyaapp,
						oldValue: oldNerdStats?.nyaapp,
						min: 0, max: 1.2, tickInterval: .2,
						label: t.stats.nyaapp.short,
						sideSize: 128.0, fractionDigits: 3,
						moreIsBetter: true,
						avgValue: averages?.nerdStats?.nyaapp,
						lbPos: lbPos?.nyaapp
					),
				),
				Tooltip(
					message: "${t.stats.area.full}${(averages != null) ? "\n${t.rankView.avgForRank(rank: rank??"lol")}: ${f1.format(averages?.nerdStats?.area)} ${t.stats.area.short}" : ""}",
					child: GaugetThingy(
						value: nerdStats.area,
						oldValue: oldNerdStats?.area,
						min: 0, max: 1000, tickInterval: 100,
						label: t.stats.area.short,
						sideSize: 128.0, fractionDigits: 1,
						moreIsBetter: true,
						avgValue: averages?.nerdStats?.area,
						lbPos: lbPos?.area
					),
				),
			],
		);
	}

	@override
	Widget build(BuildContext context) {
		return Card(
			child: Column(
				children: [
					Padding(
						padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
						child: width > 600 ? Row(
							crossAxisAlignment: CrossAxisAlignment.center,
							mainAxisSize: MainAxisSize.min,
							children: [
								big(),
								Expanded(child: manySmalls())
							]
						) : Center(
							child: Column(
								children: [
									big(),
									manySmalls()
								],
							),
						),
					),
				],
			)
		);
	} 
}