import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peduli_beacon/beacon_screen.dart';
import 'package:peduli_beacon/bluetooth_enable.dart';
import 'package:peduli_beacon/detail_screen.dart';
import 'package:peduli_beacon/model/categories.dart';
import 'package:peduli_beacon/model/kelurahan.dart';
import 'package:peduli_beacon/model/places.dart';
import 'package:peduli_beacon/model/user.dart';
import 'package:peduli_beacon/utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: myTabs.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // List Of Tab

  List<Tab> myTabs = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.auto_graph,
          ),
          SizedBox(
            width: 10,
          ),
          Text('Statistik')
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.home),
          SizedBox(
            width: 10,
          ),
          Text('Home')
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.person_pin_circle_outlined),
          SizedBox(
            width: 10,
          ),
          Text('Akun')
        ],
      ),
    )
  ];

  // Usage Tab
  List<Widget> widgetTab = <Widget>[
    Container(
      color: Colors.red,
    ),
    homeContent(),
    Container(
      color: Colors.yellow,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          bottom: TabBar(
            padding: EdgeInsets.only(bottom: 5),
            indicator: BoxDecoration(
              color: Color.fromRGBO(220, 220, 220, .4),
              borderRadius: BorderRadius.circular(50),
            ),
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: widgetTab,
      ),
    );
  }
}

class homeContent extends StatefulWidget {
  // const homeContent({Key? key}) : super(key: key);

  @override
  State<homeContent> createState() => _homeContentState();
}

class _homeContentState extends State<homeContent> {
  TextEditingController _textController = TextEditingController(text: '');
  Completer<GoogleMapController> _mapController = Completer();
  // BluetoothEnable bluetoothenable = new BluetoothEnable();
  bool _showGoogleMap = false;

  static final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(-6.291437038569147, 106.7994719206544), zoom: 15);

  @override
  void initState() {
    super.initState();
    _showGoogleMap = false;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGoogleMap = true;
      });
    });
  }

  @override
  void dispose() {
    setBtOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 30,
            child: Container(
              height: 400,
              width: size.width,
              // color: Colors.grey[400],
              child: (_showGoogleMap)
                  ? GoogleMap(
                      initialCameraPosition: _initialPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                    )
                  : Container(),
            ),
          ),
          Container(
            height: size.height,
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: 70,
                  color: backgroundColor,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BeaconScreen();
                          })).then((value) {
                            setState(() {
                              if (user.checkinStatus) {
                                setBtOff();
                              }
                            });
                          });
                        },
                        child: Container(
                          // color: Colors.blue,
                          height: 60,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: <Color>[
                                Colors.blue[700]!,
                                Colors.blue[300]!
                              ])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Scan QR code di lokasi tujuan anda',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              Icon(Icons.qr_code_2_outlined,
                                  color: Colors.white, size: 30),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                          visible: user.checkinStatus,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                user.checkinStatus = false;
                              });
                            },
                            child: Container(
                              height: 60,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green[500]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${user.checkinPlace}',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Text('Check-Out',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2,
                                          decorationStyle:
                                              TextDecorationStyle.solid)),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Search Area
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    width: size.width * .93,
                    height: 55,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 3))
                        ]),
                    child: TextField(
                      controller: _textController,
                      style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.blue[700],
                            size: 30,
                          ),
                          hintText: 'Cari Zonasi..',
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 170,
                ),
                // ------- Kelurahan Section -----
                Container(
                  width: size.width,
                  height: 60,
                  // color: Colors.grey,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listKelurahan.length,
                      itemBuilder: (BuildContext, index) {
                        return Container(
                          width: 260,
                          margin: EdgeInsets.only(
                              left: 20,
                              right:
                                  (index == listKelurahan.length - 1) ? 20 : 0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.amber,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (listKelurahan[index].myLocation == true)
                                          ? 'Lokasi Anda'
                                          : 'Lokasi Sekitar',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      listKelurahan[index].name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 110,
                                height: 50,
                                decoration: BoxDecoration(
                                    color:
                                        (listKelurahan[index].risk == 'Tinggi')
                                            ? Colors.red
                                            : (listKelurahan[index].risk ==
                                                    'Sedang')
                                                ? Colors.amber
                                                : Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'Resiko ' + listKelurahan[index].risk,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                // ---- end kelurahan section
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child:
                        // ------ bottom section icon
                        Column(
                      children: [
                        // Icon tag
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 190,
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: categoryIcon.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  // color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(10),
                                              primary: Colors.blue[50]!
                                                  .withOpacity(.6),
                                              elevation: 0.0,
                                              shadowColor: Colors.transparent),
                                          onPressed: () {
                                            if (categoryIcon[index].name ==
                                                'Scan Beacon') {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return BeaconScreen();
                                              })).then((value) {
                                                setState(() {
                                                  if (user.checkinStatus) {
                                                    setBtOff();
                                                  }
                                                });
                                              });
                                            } else {
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                            categoryIcon[index].icon,
                                            size: 35,
                                            color: Colors.blue[500],
                                          ),
                                        ),
                                        Text(
                                          categoryIcon[index].name,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          width: size.width * .9,
                          height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.local_police_outlined,
                                  color: Colors.amber),
                              Text('Electronic Health Alert Card (e-HAC).'),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.blue[300],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    // end of bottom section icon
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
