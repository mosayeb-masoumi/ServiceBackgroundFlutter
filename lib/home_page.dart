
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  String text = "Stop Service";


  @override
  Widget build(BuildContext context) {

    initializeService();

    return Scaffold(
      appBar: AppBar(title: Text("Service"),),
      body: Container(
        child: ListView(
          children: [

            ElevatedButton(
              child: Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService().sendData({"action": "setAsForeground"});
              },
            ),
            ElevatedButton(
              child: Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService().sendData({"action": "setAsBackground"});
              },
            ),
            ElevatedButton(
              child: Text(text),
              onPressed: () async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isServiceRunning();
                if (isRunning) {
                  initializeService();
                  service.sendData(
                    {"action": "stopService"},
                  );
                } else {
                  initializeService();
                  service.start();
                }

                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = 'Start Service';
                }
                setState(() {});
              },
            ),


          ],
        ),
      ),
    );

  }
}



/*********************** service settings************************/
//
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}


void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });
  int aa = 0;
  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();


    // send data to server

    aa++;
    service.setNotificationInfo(
      title: "My App Service",
      // content: "Updated at ${aa}",
      content: "Updated at ${DateTime.now()}",
    );


    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}
//
