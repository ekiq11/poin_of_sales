// ignore_for_file: non_constant_identifier_names

class DetailLapPeriode {
  DetailLapPeriode({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapPeriode>? data;
}

class LapDataPeriode {
  String? barang;
  String? banyak;
  String? total;
  String? no_transaksi;
  String? jenis;

  LapDataPeriode({
    this.barang,
    this.banyak,
    this.no_transaksi,
    this.total,
    this.jenis,
  });

  factory LapDataPeriode.fromJson(Map<String, dynamic> json) {
    return LapDataPeriode(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        no_transaksi: json["no_transaksi"],
        jenis: json["jenis"]);
  }
}
