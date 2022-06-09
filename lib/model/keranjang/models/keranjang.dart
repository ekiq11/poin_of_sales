class Keranjang {
  final String? kdPelanggan;
  final String? kdPedagang;
  final String? kdBank;
  final String? idKasir;
  final String? subTotal;
  final String? diskon;
  final String? totalAkhir;
  final String? bayar;
  final String? kembalian;
  final String? kdBarang;
  final String? barang;
  final String? harga;
  final String? qty;
  final String? total;

  Keranjang({
    this.kdPelanggan,
    this.kdPedagang,
    this.kdBank,
    this.idKasir,
    this.subTotal,
    this.diskon,
    this.totalAkhir,
    this.bayar,
    this.kembalian,
    this.kdBarang,
    this.barang,
    this.harga,
    this.qty,
    this.total,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) {
    return Keranjang(
      kdPelanggan: json['kd_pelanggan'] as String,
      kdPedagang: json['kd_pedagang'] as String,
      kdBank: json['kd_bank'] as String,
      idKasir: json['id_kasir'] as String,
      subTotal: json['subtotal'] as String,
      diskon: json['diskon'] as String,
      totalAkhir: json['total_akhir'] as String,
      bayar: json['bayar'] as String,
      kembalian: json['kembalian'] as String,
      kdBarang: json['kd_barang'] as String,
      barang: json['barang'] as String,
      harga: json['harga'] as String,
      qty: json['banyak'] as String,
      total: json['total'] as String,
    );
  }

  factory Keranjang.fromMap(Map<String, dynamic> map) {
    return Keranjang(
      kdPelanggan: map['kd_pelanggan'] as String,
      kdPedagang: map['kd_pedagang'] as String,
      kdBank: map['kd_bank'] as String,
      idKasir: map['id_kasir'] as String,
      subTotal: map['subtotal'] as String,
      diskon: map['diskon'] as String,
      totalAkhir: map['total_akhir'] as String,
      bayar: map['bayar'] as String,
      kembalian: map['kembalian'] as String,
      kdBarang: map['kd_barang'] as String,
      barang: map['barang'] as String,
      harga: map['harga'] as String,
      qty: map['banyak'] as String,
      total: map['total'] as String,
    );
  }
}
