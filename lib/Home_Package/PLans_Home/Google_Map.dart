import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MyGoogleMap extends StatefulWidget {
  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  Completer<GoogleMapController> _completer = Completer();
  static const LatLng _center = const LatLng(33.8938, 35.5018);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  var myPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onTap: (_lastMapPosition) {
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(_lastMapPosition.toString()),
                      position: _lastMapPosition,
                      infoWindow: InfoWindow(
                        title: 'This is a Title',
                        snippet: 'This is a snippet',
                      ),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  );
                });
              },
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            myPlace != null
                ? Center(
                    child: Text(myPlace),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 26,
                    ),
//                    `button(_onMapTypeButtonPressed, Icons.map, 'MapType'),`
                    SizedBox(
                      height: 16,
                    ),
                    button(() async {
                      Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: "AIzaSyDFutHxeyr5we-GrU4d5DkvSKYsSmV_EKY",
                          language: "en",
                          components: [
                            Component(Component.country, "lb"),
                          ]);
                      setState(() {
                        myPlace = p.description;
                      });
                      print(p.description);
                      print(p.reference);
                      print(p.id);
                      print(p.matchedSubstrings);
                      print(p.placeId);
                      print(p.structuredFormatting);
                      print(p.terms);
                      print(p.types);
                    }, Icons.add_location, 'Markers'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _completer.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget button(Function function, IconData icon, String _heroTag) {
    return FloatingActionButton(
      heroTag: _heroTag,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36,
      ),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }
}
