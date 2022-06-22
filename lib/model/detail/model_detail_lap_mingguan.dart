// ignore_for_file: non_constant_identifier_names

class DetailLapMingguan {
  DetailLapMingguan({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapMingguan>? data;
}

class LapDataMingguan {
  String? barang;
  String? banyak;
  String? total;
  String? no_transaksi;
  String? jenis;

  LapDataMingguan({
    this.barang,
    this.banyak,
    this.total,
    this.no_transaksi,
    this.jenis,
  });

  factory LapDataMingguan.fromJson(Map<String, dynamic> json) {
    return LapDataMingguan(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        no_transaksi: json["no_transaksi"],
        jenis: json["jenis"]);
  }
}
