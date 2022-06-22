// ignore_for_file: non_constant_identifier_names

class DetailLapKemarin {
  DetailLapKemarin({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapKemarin>? data;
}

class LapDataKemarin {
  String? barang;
  String? banyak;
  String? total;
  String? no_transaksi;
  String? jenis;

  LapDataKemarin({
    this.barang,
    this.banyak,
    this.total,
    this.no_transaksi,
    this.jenis,
  });

  factory LapDataKemarin.fromJson(Map<String, dynamic> json) {
    return LapDataKemarin(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        no_transaksi: json["no_transaksi"],
        jenis: json["jenis"]);
  }
}
