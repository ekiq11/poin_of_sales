class DetailLapPeriode {
  DetailLapPeriode({
    this.error,
    this.totalTransaksi,
    this.data,
  });

  bool? error;
  int? totalTransaksi;
  List<DetailLapPeriode>? data;
}

class LapDataPeriode {
  String? barang;
  String? banyak;
  String? total;
  String? jenis;

  LapDataPeriode({
    this.barang,
    this.banyak,
    this.total,
    this.jenis,
  });

  factory LapDataPeriode.fromJson(Map<String, dynamic> json) {
    return LapDataPeriode(
        barang: json["barang"],
        banyak: json["banyak"],
        total: json["total"],
        jenis: json["jenis"]);
  }
}
