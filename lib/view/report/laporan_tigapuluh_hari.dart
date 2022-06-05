import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import '../../api/api.dart';
import '../../model/currency_format.dart';
import '../../model/model_lap_tigapuluh_hari.dart';
import 'detail/detail_lap_tiga_puluh_hari.dart';

class LaporanTigaPuluhHari extends StatefulWidget {
  const LaporanTigaPuluhHari({Key? key}) : super(key: key);

  @override
  State<LaporanTigaPuluhHari> createState() => _LaporanTigaPuluhHariState();
}

class _LaporanTigaPuluhHariState extends State<LaporanTigaPuluhHari> {
  Future<List<DataTigaPuluhHari>> _fetchLaporanTigaPuluhHari() async {
    final result = await http.get(Uri.parse(BaseURL.laporanMingguan));
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    print(list);
    return await list
        .map<DataTigaPuluhHari>((json) => DataTigaPuluhHari.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: AppBar(
        title: Text("Laporan 30 Hari"),
        elevation: 0,
      ),
      //buatkan drawer
      drawer: DrawerFlutter(),
      //buat body

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Laporan (30) Tiga Puluh Hari",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  "Berikut adalah laporan selama Tiga Puluh Hari",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<DataTigaPuluhHari>>(
            future: _fetchLaporanTigaPuluhHari(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
                  child: snapshot.data == null
                      ? Center(child: CircularProgressIndicator())
                      : DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                "Total Penjualan ",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Total Transaksi ",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Rata-Rata ",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Aksi",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                          rows: snapshot.data.map<DataRow>((e) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      " ${CurrencyFormat.convertToIdr(int.parse(e.totalTransaksi), 2)}",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "${e.totalPenjualan}",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      " ${CurrencyFormat.convertToIdr(int.parse(e.rataRata), 2)}",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    child: IconButton(
                                      icon: Icon(Icons.visibility),
                                      color: Colors.black87,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetLapTigaPuluhHari()),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Image(
                          image: AssetImage("asset/icon/no_data.png"),
                          width: 100,
                        ),
                      ),
                    ),
                    Text("Tidak Ada Transaksi",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
