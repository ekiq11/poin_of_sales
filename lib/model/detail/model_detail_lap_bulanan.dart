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
  String? jenis;

  LapDataBulanan({
    this.barang,
    this.banyak,
    this.total,
    this.jenis,
  });

  factory LapDataBulanan.fromJson(Map<String, dynamic> json) {
    return LapDataBulanan(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        jenis: json["jenis"]);
  }
}
