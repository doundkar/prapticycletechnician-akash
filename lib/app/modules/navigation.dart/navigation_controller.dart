import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class NavigationController extends GetxController {
  Position? currentPosition;
  List<LatLng> routePoints = [];
  String? eLoc;
  double? etaInMinutes;
  double? distanceInKm;

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
      // print("Token Error: ${response.body}");
      return null;
    }
  }

  /// 1. Get eLoc from address (NO TOKEN REQUIRED if key configured)
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
      final data = jsonDecode(response.body);
      eLoc = data['copResults']['eLoc'];
      await getRouteFromELoc(); // call route after getting eLoc
    } else {
      Get.snackbar("Geocode Error", "Geocode Error: ${response.body}");
    }
  }

  /// 2. Get current location
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
       Get.snackbar(
        "Warning",
        "Please enable the location",
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
      return;
      // throw "Location services are disabled";
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
     Get.snackbar(
        "Error",
        "Location permission permanently denied",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    update();
  }

  Future<void> getRouteFromELoc() async {
    if (currentPosition == null || eLoc == null) return;

    try {
      DirectionResponse? response = await MapplsDirection(
        origin: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        destinationMapplsPin: eLoc,
        overview: "full",
        geometries: "polyline",
      ).callDirection();

      if (response != null &&
          response.routes != null &&
          response.routes!.isNotEmpty) {
        final route = response.routes![0];

  
        etaInMinutes = (route.duration ?? 0) / 60;

    
        distanceInKm = (route.distance ?? 0) / 1000;

        // print("etaInMinutes:: ${etaInMinutes}");
        // print("distanceInKm:: ${distanceInKm}");
        String encoded = response.routes![0].geometry!;

        routePoints = decodePolyline(encoded);
        if (routePoints.isNotEmpty) {}

        for (int i = 0; i < routePoints.length && i < 5; i++) {}
        update();
      }
    } catch (e) {
      Get.snackbar(
        "Direction error",
        "Direction Error: $e",
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> result = polylinePoints.decodePolyline(encoded);

    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}
