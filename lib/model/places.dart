class PlaceCheckIn {
  late String name;
  late String image;
  late String address;
  late String categoryActivity;
  late int maxCapacity;
  late int currentCapacity;
  late String uuid;

  PlaceCheckIn(
      {required this.name,
      required this.image,
      required this.address,
      required this.categoryActivity,
      required this.maxCapacity,
      required this.currentCapacity,
      required this.uuid});
}

List<PlaceCheckIn> listPlaceCheckIn = [
  PlaceCheckIn(
      name: 'Gedung XYX',
      image: 'assets/img/gedung.png',
      address: 'jl. Bendungan Hilir',
      categoryActivity: 'Aktivitas Dalam Ruangan',
      maxCapacity: 1000,
      currentCapacity: 255,
      uuid: "74278BDA-B644-4520-8F0C-720EAF059935"
      ),
  PlaceCheckIn(
      name: 'MRT Bendungan Hilir',
      image: 'assets/img/mrtbenhil.png',
      address: 'jl. MRT Benhil',
      categoryActivity: 'Aktivitas Dalam Ruangan',
      maxCapacity: 300,
      currentCapacity: 10,
      uuid: "74278BDA-B644-4520-8F0C-720EAF059934"
      )
];
