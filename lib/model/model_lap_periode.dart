class LapPeriode {
  LapPeriode({
    this.error,
    this.data,
  });

  bool? error;
  List<LapPeriode>? data;
}

class DataLapPeriode {
  String? totalTransaksi;
  String? totalPenjualan;
  String? rataRata;

  DataLapPeriode({
    this.totalTransaksi,
    this.totalPenjualan,
    this.rataRata,
  });

  factory DataLapPeriode.fromJson(Map<String, dynamic> json) {
    return DataLapPeriode(
      totalTransaksi: json["total_transaksi"],
      totalPenjualan: json["total_penjualan"],
      rataRata: json["rata_rata"],
    );
  }
}
