import 'package:covid19/main.dart';
import 'package:covid19/stats.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class Description extends StatelessWidget {
  final Covid19Stats item;
  List<charts.Series> seriesList;

  Description({Key key, @required this.item}) : super(key: key) {
    List<charts.Series<ChartLabel, int>> ls;
    final data = [
      new ChartLabel("Mortes", item.deaths),
      new ChartLabel("Recuperados", item.recovered),
      new ChartLabel(
          "Em recuperação", item.confirmed - (item.deaths + item.recovered)),
    ];
    seriesList = [
      new charts.Series<ChartLabel, String>(
        id: 'Covid-19',
        domainFn: (ChartLabel label, _) => label.stat,
        measureFn: (ChartLabel label, _) => label.amount,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (ChartLabel row, _) =>
            '${row.stat}: ${Helpers.numFormatter(row.amount)}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.province),
      ),
      body: new charts.PieChart(seriesList,
          animate: true,
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 150,
              arcRendererDecorators: [new charts.ArcLabelDecorator()])),
    );
  }
}

class ChartLabel {
  final String stat;
  final int amount;

  ChartLabel(this.stat, this.amount);
}
