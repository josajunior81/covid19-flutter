class Total {
  final CovidData data;

  Total({this.data});

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(data: CovidData.fromJson(json['data']));
  }
}

class CovidData {
  int recovered;
  int deaths;
  final int confirmed;
  final String lastChecked;

  CovidData({this.recovered, this.deaths, this.confirmed, this.lastChecked});

  factory CovidData.fromJson(Map<String, dynamic> json) {
    return CovidData(
      recovered: json['recovered'],
      deaths: json['deaths'],
      confirmed: json['confirmed'],
      lastChecked: json['lastChecked']
    );
  }
}