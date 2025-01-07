class Country {
  int? id;
  String? countryName;

  Country({this.id, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['countryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['countryName'] = countryName;
    return data;
  }
}
