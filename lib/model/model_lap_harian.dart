class LapHarian {
  LapHarian({
    this.error,
    this.data,
  });

  bool? error;
  List<LapHarian>? data;
}

class DataHarian {
  String? totalTransaksi;
  String? totalPenjualan;
  String? rataRata;

  DataHarian({
    this.totalTransaksi,
    this.totalPenjualan,
    this.rataRata,
  });

  factory DataHarian.fromJson(Map<String, dynamic> json) {
    return DataHarian(
      totalTransaksi: json["total_transaksi"],
      totalPenjualan: json["total_penjualan"],
      rataRata: json["rata_rata"],
    );
  }
}
