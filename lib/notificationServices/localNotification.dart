import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:googlemapapi/notificationServices/notification.dart';

import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }

  ParticleOptions particleOptions = ParticleOptions(
    image: Image.asset('assets/icy_logo.png'),
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
      appBar: AppBar(
        title: Text("Local Notifications"),
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: particleOptions,
          paint: particlePaint,
        ),
        vsync: this,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  NotificationService().cancelAllNotifications();
                },
                child: Container(
                  height: 40,
                  width: 200,
                  color: Colors.blue[300],
                  child: Center(
                    child: Text(
                      "Cancel All Notifications",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  NotificationService()
                      .showNotification(1, "Whatsapp", "Meeting at 6:00 PM", 2);
                },
                child: Container(
                  height: 40,
                  width: 200,
                  color: Colors.pink[300],
                  child: Center(
                    child: Text("Show Notification"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
