import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peduli_beacon/bluetooth_enable.dart';
import 'package:peduli_beacon/detail_screen.dart';
import 'package:peduli_beacon/model/beacons.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:peduli_beacon/model/places.dart';

class BeaconScreen extends StatefulWidget {
  @override
  State<BeaconScreen> createState() => _BeaconScreenState();
}

class _BeaconScreenState extends State<BeaconScreen> {
  TextStyle titleNameStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);

  TextStyle nameStyle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[500]);

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  var isRunning = false;
  bool isListen = false;
  String _beaconResult = 'Not Scanned Yet.';
  List<String> _results = [];
  List<Beacon> listBeacons = [];

  TextSpan textSpan(param1, param2) {
    return TextSpan(children: [
      TextSpan(text: param1, style: titleNameStyle),
      TextSpan(text: param2, style: nameStyle)
    ]);
  }

  @override
  void initState() {
    super.initState();
    setBtOn();
    BeaconsPlugin.setDebugLevel(0);
    initBeacon();
    BeaconsPlugin.startMonitoring();

    setState(() {
      isRunning = !isRunning;
    });
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      for (var b in listBeacons) {
        b.statusMakesure++;
        if (b.statusMakesure > 3) {
          setState(() {
            listBeacons.remove(b);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    BeaconsPlugin.stopMonitoring();
    beaconEventsController.close();
    super.dispose();
  }

  Future initBeacon() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      await BeaconsPlugin.clearDisclosureDialogShowFlag(true);
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);
    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          isListen = true;
          if (data.isNotEmpty && isRunning) {
            setState(() {
              _beaconResult = data;
              _results.add(_beaconResult);
              var beaconData = Beacon.fromJson(jsonDecode(data));
              if (listBeacons.isNotEmpty) {
                if (listBeacons.any((item) => item.mac == beaconData.mac)) {
                  Beacon out = listBeacons
                      .firstWhere((element) => element.mac == beaconData.mac);
                  setState(() {
                    out.distanceNow = beaconData.distanceNow;
                    out.statusMakesure = 0;  
                  });
                  
                } else {
                  setState(() {
                    listBeacons.add(beaconData);  
                  });
                  
                }
              } else {
                setState(() {
                  listBeacons.add(beaconData);  
                });
              }
            });
            // print('Beacons data received: ' + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print('error: ' + error);
        });

    // if (Platform.isAndroid) {
    //   BeaconsPlugin.channel.setMethodCallHandler((call) async {
    //     if (call.method == 'scannerReady') {
    //       await BeaconsPlugin.startMonitoring();
    //       setState(() {
    //         isRunning = true;
    //       });
    //     }
    //   });
    // } else if (Platform.isIOS) {
    //   await BeaconsPlugin.startMonitoring();
    //   setState(() {
    //     isRunning = true;
    //   });
    // }

    if (!mounted) return;
  }

  PlaceCheckIn checkBeaconPlaces(Beacon beacon) {
    return listPlaceCheckIn.firstWhere(
        (element) => element.uuid.toLowerCase() == beacon.uuid.toLowerCase(),
        orElse: () => PlaceCheckIn(
            name: '',
            image: '',
            address: '',
            categoryActivity: '',
            maxCapacity: 0,
            currentCapacity: 0,
            uuid: ''));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Beacon Area'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: ListView.builder(
          itemCount: listBeacons.length,
          itemBuilder: (BuildContext, index) {
            final Beacon beacon = listBeacons[index];
            PlaceCheckIn place = checkBeaconPlaces(beacon);
            return Visibility(
              visible: (place.uuid != '') ? true : false,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailScreen(place: place);
                      }));
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue,
                          child: Image.asset(place.image ,fit: BoxFit.fill,),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RichText(text: textSpan('Name:  ', place.name)),
                                RichText(text: textSpan('UUID:  ', beacon.uuid)),
                                // RichText(
                                //     text: textSpan(
                                //         'Major:  ', beacon.major.toString())),
                                // RichText(
                                //     text: textSpan(
                                //         'Minor:  ', beacon.minor.toString())),
                                RichText(
                                    text: textSpan(
                                        'Distance:  ', beacon.distance.toString()))
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
