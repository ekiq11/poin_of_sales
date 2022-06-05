class LapBulanan {
  LapBulanan({
    this.error,
    this.data,
  });

  bool? error;
  List<LapBulanan>? data;
}

class DataBulanan {
  String? totalTransaksi;
  String? totalPenjualan;
  String? rataRata;

  DataBulanan({
    this.totalTransaksi,
    this.totalPenjualan,
    this.rataRata,
  });

  factory DataBulanan.fromJson(Map<String, dynamic> json) {
    return DataBulanan(
      totalTransaksi: json["total_transaksi"],
      totalPenjualan: json["total_penjualan"],
      rataRata: json["rata_rata"],
    );
  }
}
