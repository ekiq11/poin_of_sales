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
  String? jenis;

  LapDataHarian({
    this.barang,
    this.banyak,
    this.total,
    this.jenis,
  });

  factory LapDataHarian.fromJson(Map<String, dynamic> json) {
    return LapDataHarian(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        jenis: json["jenis"]);
  }
}
