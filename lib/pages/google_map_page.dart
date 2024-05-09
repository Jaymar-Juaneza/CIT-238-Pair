import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_app/constants.dart' as Constants; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();

  static const wvsu = LatLng(10.713813016557683, 122.562420935689);
  static const culturalCenter = LatLng(10.714717218977253, 122.56274398495192);
  static const coc = LatLng(10.714731253260675, 122.56216551074581);
  static const admin = LatLng(10.714153137171767, 122.56206378022915);
  static const monofo = LatLng(10.713541983525266, 122.56223098354855);
  static const quezonhall = LatLng(10.7131978245614, 122.56270237659399);
  static const hometel = LatLng(10.712908675836438, 122.56270070456334);
  static const magsaysayhall = LatLng(10.712933159065075, 122.5632917281835);
  static const ils = LatLng(10.713427668879882, 122.56358935007543);
  static const claroRectoHall = LatLng(10.712131427146293, 122.56387526775507);
  static const com = LatLng(10.712766200686554, 122.56185436616856);
  static const cict = LatLng(10.713304270148281, 122.56149005389763);
  static const lopezJaena = LatLng(10.713984172456238, 122.5616458603664);
  static const rizalhall = LatLng(10.713795060712528, 122.5614029855178);
  static const nursing = LatLng(10.713202960075657, 122.5609974303304);
  static const coop = LatLng(10.71293955371625, 122.56116469319585);
  static const gchall = LatLng(10.71292154301467, 122.5607362252506);
  static const urdc = LatLng(10.712664890433325, 122.56055292347806);
  static const binhi = LatLng(10.712390226903574, 122.56032379626237);

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  LatLng? tappedMarkerLatLng;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeMap();
    });
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
              
              mapType: MapType.satellite,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: wvsu,
                  zoom: 20,
                ),
                markers: {
                  if (currentPosition != null)
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: currentPosition!,
                    ),
                  generateMarker(culturalCenter, 'culturalCenter'),
                  generateMarker(coc, 'coc'),
                  generateMarker(admin, 'admin'),
                  generateMarker(monofo, 'monofo'),
                  generateMarker(quezonhall, 'quezonhall'),
                  generateMarker(hometel, 'hometel'),
                  generateMarker(magsaysayhall, 'magsaysayhall'),
                  generateMarker(ils, 'ils'),
                  generateMarker(claroRectoHall, 'claroRectoHall'),
                  generateMarker(com, 'com'),
                  generateMarker(cict, 'cict'),
                  generateMarker(lopezJaena, 'lopezJaena'),
                  generateMarker(rizalhall, 'rizalhall'),
                  generateMarker(nursing, 'nursing'),
                  generateMarker(coop, 'coop'),
                  generateMarker(gchall, 'gchall'),
                  generateMarker(urdc, 'urdc'),
                  generateMarker(binhi, 'binhi'),
                },
                polylines: Set<Polyline>.of(polylines.values),
                onTap: _handleMapTap, 
              ),
      );

  Marker generateMarker(LatLng position, String markerId) {
    return Marker(
      markerId: MarkerId(markerId),
      icon: BitmapDescriptor.defaultMarker,
      position: position,
    );
  }

  Future<void> fetchLocationUpdates() async {
 

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  void _handleMapTap(LatLng tapPosition) {
    if (currentPosition != null) {
      setState(() {
        tappedMarkerLatLng = tapPosition;
        polylines.clear();
      });
      _drawPolylineFromCurrentLocation(tapPosition);
    }
  }

  Future<void> _drawPolylineFromCurrentLocation(LatLng tapPosition) async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.googleMapsApiKey,
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      PointLatLng(tapPosition.latitude, tapPosition.longitude),
    );

    if (result.points.isNotEmpty) {
      final polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      const id = PolylineId('polyline');
      final polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 5,
      );

      setState(() => polylines[id] = polyline); // Add the poly
    }
  }
}