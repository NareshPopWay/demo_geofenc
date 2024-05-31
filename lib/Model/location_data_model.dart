// To parse this JSON data, do
//
//     final locationDataModel = locationDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<LocationDataModel> locationDataModelFromJson(String str) => List<LocationDataModel>.from(json.decode(str).map((x) => LocationDataModel.fromJson(x)));

String locationDataModelToJson(List<LocationDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationDataModel {
  int? vendorLocationId;
  int? vendorId;
  String? latitude;
  String? longitude;
  DateTime? locationDateTime;
  String? locationAddress;
  String? city;
  String? country;
  String? postalCode;

  LocationDataModel({
     this.vendorLocationId,
     this.vendorId,
     this.latitude,
     this.longitude,
     this.locationDateTime,
     this.locationAddress,
     this.city,
     this.country,
     this.postalCode,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) => LocationDataModel(
    vendorLocationId: json["VendorLocationID"],
    vendorId: json["VendorID"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
    locationDateTime: DateTime.parse(json["LocationDateTime"]),
    locationAddress: json["LocationAddress"],
    city: json["City"],
    country: json["Country"],
    postalCode: json["PostalCode"],
  );

  Map<String, dynamic> toJson() => {
    "VendorLocationID": vendorLocationId,
    "VendorID": vendorId,
    "Latitude": latitude,
    "Longitude": longitude,
    "LocationDateTime": locationDateTime,
    "LocationAddress": locationAddress,
    "City": city,
    "Country": country,
    "PostalCode": postalCode,
  };
}






