import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import '../../api/api.dart';
import '../../model/currency_format.dart';
import '../../model/model_lap_bulanan.dart';
import 'detail/detail_lap_bulanan.dart';

class LaporanBulanan extends StatefulWidget {
  const LaporanBulanan({Key? key}) : super(key: key);

  @override
  State<LaporanBulanan> createState() => _LaporanBulananState();
}

class _LaporanBulananState extends State<LaporanBulanan> {
  Future<List<DataBulanan>> _fetchLaporanBulanan() async {
    final result = await http.get(Uri.parse(BaseURL.laporanMingguan));
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    print(list);
    return await list
        .map<DataBulanan>((json) => DataBulanan.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: AppBar(
        title: Text("Laporan Bulanan"),
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
                    "Laporan Bulanan",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  "Berikut adalah laporan selama satu bulan terakhir",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<DataBulanan>>(
            future: _fetchLaporanBulanan(),
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
                                                  DetLapBulanan()),
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
