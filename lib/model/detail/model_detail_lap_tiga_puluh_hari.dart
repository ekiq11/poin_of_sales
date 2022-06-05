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
  String? jenis;

  LapDataTigaPuluhHari({
    this.barang,
    this.banyak,
    this.total,
    this.jenis,
  });

  factory LapDataTigaPuluhHari.fromJson(Map<String, dynamic> json) {
    return LapDataTigaPuluhHari(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        jenis: json["jenis"]);
  }
}
