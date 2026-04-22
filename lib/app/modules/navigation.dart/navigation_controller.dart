import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mappls_gl/mappls_gl.dart';

class NavigationController extends GetxController {

  Position? currentPosition;
  List<LatLng> routePoints = [];
  String? eLoc;


  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse("https://outpost.mappls.com/api/security/oauth/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "client_credentials",
        "client_id":
            "96dHZVzsAusZuZ9BjrJPyJunDlurNfOD8QrwbkW5qJXjQ7uS1c6EGhJLdZUif1VBPAjIb0rO-MysuDF6WDTWUA==",
        "client_secret":
            "lrFxI-iSEg_APYoLjegQZTB7zRsGAjaX6RvAduk27gpGASgvmAfYRfll7__K2cf7ELUCDbgJBqgROSOeNZDeYsIoGe71xiK-",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["access_token"];
    } else {
      print("Token Error: ${response.body}");
      return null;
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    final token = await getAccessToken();

    final url = Uri.parse(
      "https://atlas.mappls.com/api/places/geocode?address=${Uri.encodeComponent(address)}",
    );

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("data checked :: $data");
      eLoc = data['copResults']['eLoc'];
       await getPlaceDetail(eLoc.toString());
    } else {
      print("Error: ${response.body}");
    }
  }
Future<void> getPlaceDetail(String eLoc) async {
  final url = Uri.parse(
      "https://atlas.mappls.com/api/places/detail?place_id=$eLoc");

  final response = await http.get(
    url,
    headers: {
      "Authorization": "token ",
    },
  );

  print(response.body);
}

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw "Location services are disabled";
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw "Location permission permanently denied";
    }
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getRouteFromELoc() async {
    if (currentPosition == null || eLoc == null) return;

    String start = "${currentPosition!.latitude},${currentPosition!.longitude}";

    String url =
        "https://apis.mappls.com/advancedmaps/v1/35049988a9fc1f54a8746117b84b96c7/route?start=$start&end=$eLoc&overview=full";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String encoded = data['routes'][0]['geometry'];

      routePoints = decodePolyline(encoded);
    }
  }

List<LatLng> decodePolyline(String encoded) {
  PolylinePoints polylinePoints = PolylinePoints();

  List<PointLatLng> result =
      polylinePoints.decodePolyline(encoded);

  return result
      .map((e) => LatLng(e.latitude, e.longitude))
      .toList();
}
}
