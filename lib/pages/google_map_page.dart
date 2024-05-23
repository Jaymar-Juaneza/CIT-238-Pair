import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map_app/constants.dart' as Constants;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();
  late GoogleMapController _mapController;

  static const mainGate = LatLng(10.714672039183245, 122.5631586967368);
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

  static const List<LatLng> fencedArea = [
    LatLng(10.712162054533518, 122.56006282897181),
    LatLng(10.712562697946783, 122.56017156214433),
    LatLng(10.713169041789557, 122.56022837763386),
    LatLng(10.71340855208601, 122.56061913326653),
    LatLng(10.715539646815808, 122.56266160248877),
    LatLng(10.712261768444545, 122.56475999644381),
    LatLng(10.711904541982362, 122.56348557470139),
    LatLng(10.712014876291816, 122.56338777277831),
    LatLng(10.71253185422399, 122.5628991575448),
    LatLng(10.712650624422835, 122.56225699928213),
    LatLng(10.712012234045023, 122.56148263199195),
    LatLng(10.712156985467729, 122.5601529866808),
  ];

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  LatLng? tappedMarkerLatLng;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
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
      markers: _createMarkers(),
      polylines: Set<Polyline>.of(polylines.values),
      polygons: {_createPolygon()},
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _setMapBounds(controller);
      },
      minMaxZoomPreference: const MinMaxZoomPreference(17, 20),
      onTap: _handleMapTap,
    ),
  );

  Set<Marker> _createMarkers() {
    return {
      if (currentPosition != null)
        Marker(
          markerId: const MarkerId('currentLocation'),
          icon: BitmapDescriptor.defaultMarker,
          position: currentPosition!,
        ),
      generateMarker(mainGate, 'Main Gate', 'assets/Loc_pix/Gate.jpg',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)),
      generateMarker(culturalCenter, 'WVSU Cultural Center', 'assets/Loc_pix/cultu.jpg'),
      generateMarker(coc, 'College of Communication', 'assets/Loc_pix/SL.png'),
      generateMarker(admin, 'Administration Building', 'assets/Loc_pix/ADMIN.jpg'),
      generateMarker(monofo, 'Monofo Building', 'assets/Loc_pix/Minifo.jpg'),
      generateMarker(quezonhall, 'Quezon Hall', 'assets/Loc_pix/quezon.jpeg'),
      generateMarker(hometel, 'Hometel', 'assets/Loc_pix/SL.png'),
      generateMarker(magsaysayhall, 'Magsaysay Hall', 'assets/Loc_pix/SL.png'),
      generateMarker(ils, 'NAB Building', 'assets/Loc_pix/SL.png'),
      generateMarker(claroRectoHall, 'Claro Recto Hall', 'assets/Loc_pix/SL.png'),
      generateMarker(com, 'College of Medicine', 'assets/Loc_pix/roxas.jpeg'),
      generateMarker(cict, 'CICT Building', 'assets/Loc_pix/cict.jpeg'),
      generateMarker(lopezJaena, 'Lopez Jaena Hall', 'assets/Loc_pix/Lopez.jpeg'),
      generateMarker(rizalhall, 'Rizal Hall', 'assets/Loc_pix/SL.png'),
      generateMarker(nursing, 'Nursing Building', 'assets/Loc_pix/nursing.jpeg'),
      generateMarker(coop, 'Coop Building', 'assets/Loc_pix/SL.png'),
      generateMarker(gchall, 'GC Hall', 'assets/Loc_pix/SL.png'),
      generateMarker(urdc, 'URDC Building', 'assets/Loc_pix/urdc.jpg'),
      generateMarker(binhi, 'Binhi Building', 'assets/Loc_pix/SL.png'),
    };
    
  }

  Polygon _createPolygon() {
    return Polygon(
      polygonId: const PolygonId('fencedArea'),
      points: fencedArea,
      strokeColor: Colors.red,
      strokeWidth: 2,
      fillColor: Colors.red.withOpacity(0.15),
    );
  }

  void _setMapBounds(GoogleMapController controller) async {
    final bounds = LatLngBounds(
      southwest: LatLng(10.712162054533518, 122.56006282897181),
      northeast: LatLng(10.715539646815808, 122.56475999644381),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 0));
  }

  Marker generateMarker(LatLng position, String markerId, String imageAssetPath, [BitmapDescriptor? icon]) {
    return Marker(
      markerId: MarkerId(markerId),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      position: position,
      onTap: () {
        _handleMarkerTap(context, markerId, imageAssetPath, position);
      },
    );
  }

  void _handleMarkerTap(BuildContext context, String markerId, String imageAssetPath, LatLng position) {
    _drawPolylineFromMainGate(position); // Draw route from main gate to tapped marker
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(markerId),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(imageAssetPath),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchLocationUpdates() async {
    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
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

  Future<void> _drawPolylineFromMainGate(LatLng destination) async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.googleMapsApiKey,
      PointLatLng(mainGate.latitude, mainGate.longitude),
      PointLatLng(destination.latitude, destination.longitude),
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

      setState(() => polylines[id] = polyline);
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

      setState(() => polylines[id] = polyline);
    }
  }
}

