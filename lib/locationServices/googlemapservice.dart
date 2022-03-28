import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapapi/locationServices/location.dart';

class GoogleMapService extends StatefulWidget {
  @override
  State<GoogleMapService> createState() => _GoogleMapServiceState();
}

class _GoogleMapServiceState extends State<GoogleMapService> {
  Set<Marker> _marker = {};
  Completer<GoogleMapController> _mapcontroller = Completer();
  TextEditingController _controller = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _marker.add(
        Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(30.191644, 74.490898),
          infoWindow: InfoWindow(title: "Home-Street", snippet: "Patel Nagar"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map"),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Search"),
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      var place =
                          await LocationService().getplace(_controller.text);
                      gotoplace(place);
                    })
              ],
            ),
            Expanded(
              child: GoogleMap(
                markers: _marker,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(30.191644, 74.490898),
                  zoom: 16,
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> gotoplace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lan = place['geometry']['location']['lan'];
    final GoogleMapController mapController = await _mapcontroller.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lan), zoom: 15),
      ),
    );
  }
}
