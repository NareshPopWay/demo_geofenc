

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:demo_geofenc/Model/location_data_model.dart';

class APiProvider {

  Future<List<LocationDataModel>> fetchLIVELocationData() async {
    final url = Uri.parse('http://116.72.8.100:2202/api/CommanAPI/GetLocationList?VendorID=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      log('fetchLIVELocationData :- $data');
      return data.map((json) => LocationDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load location data');
    }
  }
}