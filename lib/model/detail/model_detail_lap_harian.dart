// ignore_for_file: non_constant_identifier_names

class DetailLapHarian {
  DetailLapHarian({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapHarian>? data;
}

class LapDataHarian {
  String? barang;
  String? banyak;
  String? total;
  String? no_transaksi;
  String? jenis;

  LapDataHarian({
    this.barang,
    this.banyak,
    this.total,
    this.no_transaksi,
    this.jenis,
  });

  factory LapDataHarian.fromJson(Map<String, dynamic> json) {
    return LapDataHarian(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        no_transaksi: json["no_transaksi"],
        jenis: json["jenis"]);
  }
}
