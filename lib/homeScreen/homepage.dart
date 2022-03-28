import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:googlemapapi/bluetoothServices/bluetooth.dart';
import 'package:googlemapapi/cameraServices/camera.dart';
import 'package:googlemapapi/locationServices/googlemapservice.dart';
import 'package:googlemapapi/notificationServices/localNotification.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Position current;
  String address = "";

  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission _permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Please On your Service");
    }
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        print("User Denied the Permission");
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        current = position;
        address = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  ParticleOptions particleOptions = ParticleOptions(
    image: Image.asset('assets/star_stroke.png'),
    baseColor: Colors.blue,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("Platform Services"),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraCheck(),
                ),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlutterBlueApp(),
                  ),
                );
              }),
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalNotificationScreen(),
                  ),
                );
              })
        ],
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: particleOptions,
          paint: particlePaint,
        ),
        vsync: this,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Current Location : $address",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              current != null
                  ? Text(
                      'Latitude = ' + current.latitude.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  : Container(),
              current != null
                  ? Text(
                      'Longitude = ' + current.longitude.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () => currentPosition(),
                child: Text(" Get Location"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleMapService(),
            ),
          );
        },
        child: Icon(Icons.pin_drop_outlined),
      ),
    );
  }
}
