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
  String? jenis;

  LapDataKemarin({
    this.barang,
    this.banyak,
    this.total,
    this.jenis,
  });

  factory LapDataKemarin.fromJson(Map<String, dynamic> json) {
    return LapDataKemarin(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        jenis: json["jenis"]);
  }
}
