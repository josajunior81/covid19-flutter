class Stats {
  final StatsData data;

  Stats({this.data});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(data: StatsData.fromJson(json['data']));
  }
}

class StatsData {
  final String lastChecked;
  final List<Covid19Stats> states;

  StatsData({this.lastChecked, this.states});

  factory StatsData.fromJson(Map<String, dynamic> json) {
    var statesFromJson = json['covid19Stats'];
    // List<Covid19Stats> stateList = statesFromJson.cast<Covid19Stats>();
    List<Covid19Stats> stateList = new List();

    statesFromJson.forEach((e) {
      stateList.add(Covid19Stats.fromJson(e));
    });

    return StatsData(lastChecked: json['lastChecked'], states: stateList);
  }
}

class Covid19Stats {
  // String city;
  // final String country;
  // final String lastUpdate;
  // final String keyId;
  final String province;
  final int confirmed;
  final int deaths;
  final int recovered;

  Covid19Stats(
      {this.province,
      this.confirmed,
      this.deaths,
      this.recovered});

  factory Covid19Stats.fromJson(Map<String, dynamic> json) {
    return Covid19Stats(
        province: json['province'],
        confirmed: json['confirmed'],
        deaths: json['deaths'],
        recovered: json['recovered']);
  }
}
