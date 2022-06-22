// ignore_for_file: non_constant_identifier_names

class DetailLapBulanan {
  DetailLapBulanan({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapBulanan>? data;
}

class LapDataBulanan {
  String? barang;
  String? banyak;
  String? total;
  String? no_transaksi;
  String? jenis;

  LapDataBulanan({
    this.barang,
    this.banyak,
    this.no_transaksi,
    this.total,
    this.jenis,
  });

  factory LapDataBulanan.fromJson(Map<String, dynamic> json) {
    return LapDataBulanan(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        no_transaksi: json["no_transaksi"],
        jenis: json["jenis"]);
  }
}
