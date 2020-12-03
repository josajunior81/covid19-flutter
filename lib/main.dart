import 'dart:convert';

import 'package:covid19/TotalModel.dart';
import 'package:covid19/description.dart';
import 'package:covid19/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = 'pt_BR';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Covid-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Stats> futureStats;

  int totalConfirmed = 0;
  int totalRecovered = 0;
  int totalDeaths = 0;
  int totalRecovering = 0;

  @override
  void initState() {
    super.initState();
    futureStats = fetchData("/v1/stats");
  }

  var headers = {
    "x-rapidapi-key": "0941749131mshf09c19bd4d0c56fp12fb36jsnf582ff280d8c",
    "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
    "useQueryString": "true"
  };

  var params = {"country": "Brazil"};

  Future<Stats> fetchData(String path) async {
    var headers = {
      "x-rapidapi-key": "0941749131mshf09c19bd4d0c56fp12fb36jsnf582ff280d8c",
      "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
      "useQueryString": "true"
    };

    var params = {"country": "Brazil"};

    var uri = Uri.https(
        "covid-19-coronavirus-statistics.p.rapidapi.com", path, params);

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var stats = Stats.fromJson(jsonDecode(response.body));
      stats.data.states.forEach((elem) {
        totalRecovered += elem.recovered;
        totalDeaths += elem.deaths;
        totalConfirmed += elem.confirmed;
      });
      totalRecovering = totalConfirmed - (totalRecovered + totalDeaths);
      return stats;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Stats>(
          future: futureStats,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return totalWidget(snapshot.data.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          }),
    );
  }

  Widget totalWidget(StatsData data) {
    List<Covid19Stats> stats = data.states;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      "Total de casos: ",
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: Text("${Helpers.numFormatter(totalConfirmed)}"),
                    ),
                  ]),
                  Row(children: [
                    Text("Percentual de Mortos: "),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: Text(
                          "${Helpers.percentFormatter(Helpers.calcPercent(totalConfirmed, totalDeaths))}"),
                    ),
                  ]),
                  Row(children: [
                    Text("Percentual de Recuperados: "),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: Text(
                          "${Helpers.percentFormatter(Helpers.calcPercent(totalConfirmed, totalRecovered))}"),
                    ),
                  ]),
                  Row(children: [
                    Text("Percentual em Recuperação: "),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: Text(
                          "${Helpers.percentFormatter(Helpers.calcPercent(totalConfirmed, (totalRecovering)))}"),
                    ),
                  ]),
                ],
              )),
        ),
        Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Description(item: stats[index]),
                        ),
                      );
                    },
                    title: Text(
                      stats[index].province,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Casos confirmados: "),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                  "${Helpers.numFormatter(stats[index].confirmed)}"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Total de recuperados: "),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                  "${Helpers.numFormatter(stats[index].recovered)}"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Total em recuperação: "),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                  "${Helpers.numFormatter(stats[index].confirmed - (stats[index].recovered + stats[index].deaths))}"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Total de mortes: "),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                  "${Helpers.numFormatter(stats[index].deaths)}"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: stats.length))
      ],
    );
  }
}

class Helpers {
  static double calcPercent(var total, var value) {
    return (value * 100) / total;
  }

  static String percentFormatter(num value) {
    return value.toStringAsPrecision(3);
  }

  static String numFormatter(var value) {
    return value.toString().replaceAllMapped(
        RegExp(r'[0-9](?=(?:[0-9]{3})+(?![0-9]))'),
        (match) => "${match.group(0)}.");
  }
}
