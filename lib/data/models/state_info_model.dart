class StateInfoModel{
  String countryCode;
  String nameCountry;
  num latitude;
  num longitude;
  num confirmed;
  num dead;
  num recovered;
  num active;
  String updated;

  StateInfoModel({
    this.countryCode,
    this.nameCountry,
    this.latitude,
    this.longitude,
    this.confirmed,
    this.recovered,
    this.dead,
    this.updated,
    this.active
  });
  static StateInfoModel fromJson(Map<String, dynamic> json) => StateInfoModel(
    countryCode: json['country_code'] as String,
    nameCountry: json['location'] as String,
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    confirmed: json['confirmed'] as num,
    dead: json['dead'] as num ?? 0,
    recovered: json['recovered'] as num ?? 0,
    updated: json['updated'] as String,
    active: (json['confirmed'] as num) - (json['dead'] as num ?? 0) - (json['recovered'] as num ?? 0)
  );
}