class Kelurahan {
  String name;
  String risk;
  bool myLocation;

  Kelurahan(this.name, this.risk, this.myLocation);
}

List<Kelurahan> listKelurahan = [
  Kelurahan('Pondok Labu', 'Rendah', true),
  Kelurahan('Cipete Selatan', 'Sedang', false),
  Kelurahan('Gandaria Selatan', 'Tinggi', false),
  Kelurahan('Cilandak Barat', 'Rendah', false),
  Kelurahan('Lebak Bulus', 'Sedang', false)
];
