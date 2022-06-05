class LapTigaPulHari {
  LapTigaPulHari({
    this.error,
    this.data,
  });

  bool? error;
  List<DataTigaPuluhHari>? data;
}

class DataTigaPuluhHari {
  String? totalTransaksi;
  String? totalPenjualan;
  String? rataRata;

  DataTigaPuluhHari({
    this.totalTransaksi,
    this.totalPenjualan,
    this.rataRata,
  });

  factory DataTigaPuluhHari.fromJson(Map<String, dynamic> json) {
    return DataTigaPuluhHari(
      totalTransaksi: json["total_transaksi"],
      totalPenjualan: json["total_penjualan"],
      rataRata: json["rata_rata"],
    );
  }
}
