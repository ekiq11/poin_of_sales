// ignore_for_file: prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../api/api.dart';
import '../../../model/currency_format.dart';
import '../../../model/detail/model_detail_lap_harian.dart';

class DetLapHarian extends StatefulWidget {
  DetLapHarian({Key? key}) : super(key: key);

  @override
  State<DetLapHarian> createState() => _DetLapHarianState();
}

class _DetLapHarianState extends State<DetLapHarian> {
  Future<List<LapDataHarian>> _fetchDetailLaporanHarian() async {
    final result = await http.get(Uri.parse(BaseURL.lapDataHarian));
    debugPrint('$result');
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    return await list
        .map<LapDataHarian>((json) => LapDataHarian.fromJson(json))
        .toList();
  }

  topSnackBar() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Terjadi kesalahan, cek koneksi internet anda !",
        ),
      );
    }
  }

  @override
  void initState() {
    topSnackBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.sp),
        child: AppBar(
          title: Row(
            // ignore: prefer__literals_to_create_immutables
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Detail Laporan Hari Ini",
                  style: TextStyle(fontSize: 10.sp)),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Detail Laporan Hari Ini",
                              style: TextStyle(
                                  fontSize: 10.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Berikut adalah laporan selama satu bulan terakhir",
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Divider(),
                      ),
                    ],
                  ),
                  FutureBuilder<List<LapDataHarian>>(
                    future: _fetchDetailLaporanHarian(),
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
                                                      width: 170,
                                                      child: Text(
                                                        "${e.barang}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 170,
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
                                                      width: 170,
                                                      child: Text(
                                                        " ${e.no_transaksi}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 170,
                                                      child: Text(
                                                        " ${CurrencyFormat.convertToIdr(int.parse(e.total), 0)}",
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
                                        "Total : ${CurrencyFormat.convertToIdr(snapshot.data.map((e) => int.parse(e.total)).reduce((a, b) => a + b), 0)}",
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
