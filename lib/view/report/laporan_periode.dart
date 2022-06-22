// ignore_for_file: use_key_in_widget_ructors, use_build_context_synchronously, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../api/api.dart';
import '../../model/currency_format.dart';
import '../../model/model_lap_periode.dart';
import '../home.dart';
import 'detail/detail_lap_periode.dart';

class LapPeriode extends StatefulWidget {
  final String? drTgl;
  final String? smpTgl;

  LapPeriode({this.drTgl, this.smpTgl});

  @override
  State<LapPeriode> createState() => _LapPeriodeState();
}

class _LapPeriodeState extends State<LapPeriode> {
  String? username, idUser;
  Future<List<DataLapPeriode>> _fetchLaporanPeriode() async {
    final result = await http.get(Uri.parse(
        "${BaseURL.lapDataPeriode}dari_tanggal=${widget.drTgl}&sampai_tanggal=${widget.smpTgl}"));
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    debugPrint('$result');
    return await list
        .map<DataLapPeriode>((json) => DataLapPeriode.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.sp),
        child: AppBar(
          title: Text(
            "Laporan Periode",
            style: TextStyle(fontSize: 10.sp),
          ),
          elevation: 0,
        ),
      ),
      //buatkan drawer
      drawer: DrawerFlutter(),
      //buat body
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Add your onPressed code here!
          SharedPreferences preferences = await SharedPreferences.getInstance();
          setState(() {
            username = preferences.getString("username");
            idUser = preferences.getString("idUser");
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HalamanUtama(username: "$username", idUser: "$idUser"),
            ),
          );

          //  print("username: ${widget.username!}");
        },
        label: Text('Home', style: TextStyle(fontSize: 10.sp)),
        icon: Icon(Icons.home),
        backgroundColor: Colors.amber,
      ),

      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Laporan Periode",
                      style: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Text(
                  "Berikut adalah laporan periode  ${widget.drTgl} - ${widget.smpTgl}",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
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
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    "Total Penjualan ",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Total Transaksi ",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Rata-Rata ",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Aksi",
                                    style: TextStyle(
                                        fontSize: 10.sp,
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
                                          style: TextStyle(fontSize: 10.sp),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          "${e.totalPenjualan}",
                                          style: TextStyle(fontSize: 10.sp),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          " ${CurrencyFormat.convertToIdr(int.parse(e.rataRata), 2)}",
                                          style: TextStyle(fontSize: 10.sp),
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
                                                    DetLapPeriode(
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
                          ),
                        ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Image(
                          image: AssetImage("asset/icon/no_data.png"),
                          width: 100,
                        ),
                      ),
                    ),
                    Text("Tidak Ada Transaksi",
                        style: TextStyle(
                          fontSize: 10.sp,
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
