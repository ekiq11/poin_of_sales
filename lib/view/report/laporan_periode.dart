// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import '../../api/api.dart';
import '../../model/currency_format.dart';
import '../../model/model_lap_periode.dart';
import 'detail/detail_lap_periode.dart';
import 'detail/detail_lap_tiga_puluh_hari.dart';

class LapPeriode extends StatefulWidget {
  final String? drTgl;
  final String? smpTgl;
  const LapPeriode({this.drTgl, this.smpTgl});

  @override
  State<LapPeriode> createState() => _LapPeriodeState();
}

class _LapPeriodeState extends State<LapPeriode> {
  Future<List<DataLapPeriode>> _fetchLaporanPeriode() async {
    final result = await http.get(Uri.parse(
        "${BaseURL.lapDataPeriode}dari_tanggal=${widget.drTgl}&sampai_tanggal=${widget.smpTgl}"));
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    print(list);
    return await list
        .map<DataLapPeriode>((json) => DataLapPeriode.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: AppBar(
        title: Text("Laporan Per Periode "),
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
              children: [
                Center(
                  child: Text(
                    "Laporan Periode",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  "Berikut adalah laporan periode  ${widget.drTgl} - ${widget.smpTgl}",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<DataLapPeriode>>(
            future: _fetchLaporanPeriode(),
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
                                            builder: (context) => DetLapPeriode(
                                                drTgl: widget.drTgl,
                                                smpTgl: widget.smpTgl),
                                          ),
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
