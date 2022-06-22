// ignore_for_file: use_key_in_widget_ructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import 'package:sizer/sizer.dart';
import '../../../api/api.dart';
import '../../../model/currency_format.dart';
import '../../../model/detail/model_detail_lap_periode.dart';

class DetLapPeriode extends StatefulWidget {
  final String? drTgl;
  final String? smpTgl;
  DetLapPeriode({this.drTgl, this.smpTgl});

  @override
  State<DetLapPeriode> createState() => _DetLapPeriodeState();
}

class _DetLapPeriodeState extends State<DetLapPeriode> {
  Future<List<LapDataPeriode>> _fetchDetailLaporanPeriode() async {
    final result = await http.get(Uri.parse(
        "${BaseURL.lapDataPeriodeDetail}${BaseURL.lapDataPeriode}dari_tanggal=${widget.drTgl}&sampai_tanggal=${widget.smpTgl}"));
    debugPrint('$result');
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    return await list
        .map<LapDataPeriode>((json) => LapDataPeriode.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.sp),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Detail Laporan Periode"),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                  onPrimary: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 25.0),
                      child: Icon(Icons.arrow_back, color: Colors.amber),
                    ),
                    Text("Kembali",
                        style: TextStyle(color: Colors.amber, fontSize: 10.sp)),
                  ],
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
      ),
      //buatkan drawer
      drawer: DrawerFlutter(),
      //buat body

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                              "Detail Laporan Periode",
                              style: TextStyle(
                                  fontSize: 10.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Text(
                          "Berikut adalah laporan periode  ${widget.drTgl} - ${widget.smpTgl}",
                          style: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Divider(),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<LapDataPeriode>>(
                    future: _fetchDetailLaporanPeriode(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: snapshot.data == null
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.all(1.2),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: DataTable(
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.amber),
                                          sortColumnIndex: 1,
                                          sortAscending: true,
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                "Nama ",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Jenis ",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Qty ",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "No Transaksi ",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Total (Rp)",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                          rows: snapshot.data.map<DataRow>(
                                            (e) {
                                              return DataRow(
                                                cells: <DataCell>[
                                                  DataCell(
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        "${e.barang}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        "${e.jenis}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 50,
                                                      child: Text(
                                                        " ${e.banyak}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        " ${e.no_transaksi}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        " ${CurrencyFormat.convertToIdr(int.parse(e.total), 2)}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        "Total : ${CurrencyFormat.convertToIdr(snapshot.data.map((e) => int.parse(e.total)).reduce((a, b) => a + b), 2)}",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
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
            ),
          ),
        ],
      ),
    );
  }
}
