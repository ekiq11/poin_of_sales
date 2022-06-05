class LapKemarin {
  LapKemarin({
    this.error,
    this.data,
  });

  bool? error;
  List<LapKemarin>? data;
}

class DataKemarin {
  String? totalTransaksi;
  String? totalPenjualan;
  String? rataRata;

  DataKemarin({
    this.totalTransaksi,
    this.totalPenjualan,
    this.rataRata,
  });

  factory DataKemarin.fromJson(Map<String, dynamic> json) {
    return DataKemarin(
      totalTransaksi: json["total_transaksi"],
      totalPenjualan: json["total_penjualan"],
      rataRata: json["rata_rata"],
    );
  }
}
