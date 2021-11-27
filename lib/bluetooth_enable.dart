import 'package:flutter/services.dart';


late String bluetoothStatus;

const platform = const MethodChannel("bluetooth_On_Off");

Future<void> setBtOn() async{
  final String btStatus = await platform.invokeMethod('setBtOn');

  bluetoothStatus = btStatus;
}

Future<void> setBtOff() async{
  final String btStatus = await platform.invokeMethod('setBtOff');

  bluetoothStatus = btStatus;
  
}

