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
  String? jenis;

  LapDataMingguan({
    this.barang,
    this.banyak,
    this.total,
    this.jenis,
  });

  factory LapDataMingguan.fromJson(Map<String, dynamic> json) {
    return LapDataMingguan(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        jenis: json["jenis"]);
  }
}
