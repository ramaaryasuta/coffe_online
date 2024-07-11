import 'package:coffeonline/screens/orders/models/ongoing_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MerchMap extends StatefulWidget {
  MerchMap({
    super.key,
    required this.latitudeBuyer,
    required this.longitudeBuyer,
    required this.latitudeMerchant,
    required this.longitudeMerchant,
  });

  double latitudeBuyer, longitudeBuyer, latitudeMerchant, longitudeMerchant;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MerchMap> {
  late GoogleMapController mapController;

  LatLng? buyerLoc; // lokasi mu
  LatLng? merchLoc; // Lokasi Penjual
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    buyerLoc = LatLng(
      widget.latitudeBuyer,
      widget.longitudeBuyer,
    );

    merchLoc = LatLng(
      widget.latitudeMerchant,
      widget.longitudeMerchant,
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("Lokasi Pembeli"),
        position: buyerLoc!,
        infoWindow: const InfoWindow(title: "Lokasi Pembeli"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId("Lokasi Saya"),
        position: merchLoc!,
        infoWindow: InfoWindow(title: "Lokasi Saya"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    _getRoute();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getRoute() async {
    String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";
    String apiKey = "AIzaSyB_q3Y7dnCikWdwmEFs6tR-jnypbJ5AJSE";

    Dio dio = Dio();
    Response response = await dio.get(baseUrl, queryParameters: {
      "origin": "${buyerLoc!.latitude},${buyerLoc!.longitude}",
      "destination": "${merchLoc!.latitude},${merchLoc!.longitude}",
      "key": apiKey,
    });

    if (response.statusCode == 200) {
      var body = response.data;
      List<LatLng> routeCoords = [];
      if (body['routes'].length > 0) {
        body['routes'][0]['legs'][0]['steps'].forEach((step) {
          routeCoords.add(LatLng(
              step['start_location']['lat'], step['start_location']['lng']));
          routeCoords.add(
              LatLng(step['end_location']['lat'], step['end_location']['lng']));
        });
      }
      _drawRoute(routeCoords);
    } else {
      throw Exception('Failed to load route');
    }
  }

  void _drawRoute(List<LatLng> routeCoords) {
    setState(() {
      _polyLines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: routeCoords,
          color: Colors.blue,
          width: 3,
        ),
      );
    });
  }

  final Set<Polyline> _polyLines = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: buyerLoc!,
        zoom: 13.0,
      ),
      markers: _markers,
      polylines: _polyLines,
    );
  }
}
