import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

Widget circularChart({@required Size size, @required double colorProportion}) {
  return AnimatedCircularChart(
    size: size,
    initialChartData: <CircularStackEntry>[
      CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              colorProportion * 5,
              const Color.fromRGBO(0, 255, 17, 1),
            ),
            CircularSegmentEntry(
              (20 - colorProportion) * 5,
              Colors.white,
            ),
          ]
      ),
    ],
    chartType: CircularChartType.Radial,
    percentageValues: true,
    holeLabel: colorProportion.toInt().toString(),
    labelStyle: const TextStyle(
      fontSize: 32,
      fontFamily: 'roboto',
      color: Colors.white,
    ),
  );
}