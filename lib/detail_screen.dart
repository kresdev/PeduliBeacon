import 'package:flutter/material.dart';
import 'package:peduli_beacon/model/places.dart';
import 'package:peduli_beacon/model/user.dart';

class DetailScreen extends StatefulWidget {
  final PlaceCheckIn place;

  DetailScreen({required this.place});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int maxCapacity = 100;

  int currentCapacity = 0;
  

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;    

    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Check-In'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(widget.place.image),
          Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.place.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.place.address,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 2.0))),
                ),
                Text(
                  'Kategori Aktivitas',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.place.categoryActivity,
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Total Keramaian',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '${widget.place.currentCapacity}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: ' / ${widget.place.maxCapacity}',
                      style: TextStyle(fontSize: 20, color: Colors.black))
                ])),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 2.0))),
                ),
                Text(
                  """
      Selalu terapkan 3M:
      • Memakai masker.
      • Menjaga jarak.
      • Mencuci tangan atau menggunakan handsanitizer
                """,
                  style: TextStyle(height: 2),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: (user.checkinStatus == true) ? Colors.green : Colors.blue
                    ),
                    onPressed: () {
                      user.checkinPlace = widget.place.name;
                      user.checkinStatus = !user.checkinStatus;
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: Container(
                      width: size.width,
                      height: 40,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        (user.checkinStatus == false) ? 'CHECK-IN' : 'CHECK-OUT',
                        textAlign: TextAlign.center,
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
