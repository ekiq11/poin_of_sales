// ignore_for_file: non_constant_identifier_names

class DetailLapTigaPuluhHari {
  DetailLapTigaPuluhHari({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapTigaPuluhHari>? data;
}

class LapDataTigaPuluhHari {
  String? barang;
  String? banyak;
  String? total;
  String? no_transaksi;
  String? jenis;

  LapDataTigaPuluhHari({
    this.barang,
    this.banyak,
    this.total,
    this.no_transaksi,
    this.jenis,
  });

  factory LapDataTigaPuluhHari.fromJson(Map<String, dynamic> json) {
    return LapDataTigaPuluhHari(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        no_transaksi: json["no_transaksi"],
        jenis: json["jenis"]);
  }
}
