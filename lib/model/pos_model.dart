// ignore_for_file: unnecessary_this, prefer_collection_literals

class DataBarang {
  bool? error;
  List<Data>? data;

  DataBarang({this.error, this.data});

  DataBarang.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? kdBarang;
  String? namaBarang;
  String? idJenis;
  String? satuan;
  String? stok;
  String? hargaPokok;
  String? ppn;
  String? hargaJual;

  Data(
      {this.kdBarang,
      this.namaBarang,
      this.idJenis,
      this.satuan,
      this.stok,
      this.hargaPokok,
      this.ppn,
      this.hargaJual});

  Data.fromJson(Map<String, dynamic> json) {
    kdBarang = json['kd_barang'];
    namaBarang = json['nama_barang'];
    idJenis = json['id_jenis'];
    satuan = json['satuan'];
    stok = json['stok'];
    hargaPokok = json['harga_pokok'];
    ppn = json['ppn'];
    hargaJual = json['harga_jual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['kd_barang'] = this.kdBarang;
    data['nama_barang'] = this.namaBarang;
    data['id_jenis'] = this.idJenis;
    data['satuan'] = this.satuan;
    data['stok'] = this.stok;
    data['harga_pokok'] = this.hargaPokok;
    data['ppn'] = this.ppn;
    data['harga_jual'] = this.hargaJual;
    return data;
  }
}
