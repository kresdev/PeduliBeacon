
class Beacon{
  String name;
  String uuid;
  String mac;
  int major;
  int minor;
  double distance;
  int statusMakesure = 0;

  double get distanceNow{
    return distance;
  }

  void set distanceNow(double val){
    distance = val;
  }

  
  Beacon(this.name, this.uuid, this.mac, this.major, this.minor, this.distance);
  
  factory Beacon.fromJson(Map<String, dynamic> data){
    var name = data['name'] as String;
    var uuid = data['uuid'] as String;
    var mac = data['macAddress'] as String;
    var major = data['major'] as String;
    var minor = data['minor'] as String;
    var distance = data['distance'] as String;

    return Beacon(name, uuid, mac, int.parse(major), int.parse(minor), double.parse(distance));
  }


}