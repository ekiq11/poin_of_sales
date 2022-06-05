class LapMingguan {
  LapMingguan({
    this.error,
    this.data,
  });

  bool? error;
  List<DataMingguan>? data;
}

class DataMingguan {
  String? totalTransaksi;
  String? totalPenjualan;
  String? rataRata;

  DataMingguan({
    this.totalTransaksi,
    this.totalPenjualan,
    this.rataRata,
  });

  factory DataMingguan.fromJson(Map<String, dynamic> json) {
    return DataMingguan(
      totalTransaksi: json["total_transaksi"],
      totalPenjualan: json["total_penjualan"],
      rataRata: json["rata_rata"],
    );
  }
}
