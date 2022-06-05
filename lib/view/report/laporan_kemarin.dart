// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/model/model_lap_kemarin.dart';
import 'package:poin_of_sales/view/home.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import '../../api/api.dart';
import '../../model/currency_format.dart';
import 'detail/detail_lap_kemarin.dart';

class LaporanKemarin extends StatefulWidget {
  final String? username;
  const LaporanKemarin({this.username});

  @override
  State<LaporanKemarin> createState() => _LaporanKemarinState();
}

class _LaporanKemarinState extends State<LaporanKemarin> {
  Future<List<DataKemarin>> _fetchLaporanKemarin() async {
    final result = await http.get(Uri.parse(BaseURL.laporanKemarin));
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    debugPrint('$result');
    return await list
        .map<DataKemarin>((json) => DataKemarin.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: AppBar(
        title: Text("Laporan Kemarin"),
        elevation: 0,
      ),
      //buatkan drawer
      drawer: DrawerFlutter(),
      //buat body
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanUtama(username: widget.username),
            ),
          );
          //   print("username: ${widget.username!}");
        },
        label: const Text('Home'),
        icon: const Icon(Icons.home),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Laporan Kemarin",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  "Berikut adalah laporan penjualan pada hari kemarin",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<DataKemarin>>(
            future: _fetchLaporanKemarin(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
                  child: snapshot.data == null
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(1.2),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.amber),
                              sortColumnIndex: 1,
                              sortAscending: true,
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
                                                      DetLapKemarin()),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
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
