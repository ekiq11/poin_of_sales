// ignore_for_file: use_key_in_widget_ructors, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../api/api.dart';
import '../../model/currency_format.dart';
import '../../model/model_lap_mingguan.dart';
import '../home.dart';
import 'detail/detail_lap_mingguan.dart';

class LaporanMingguan extends StatefulWidget {
  LaporanMingguan({Key? key}) : super(key: key);

  @override
  State<LaporanMingguan> createState() => _LaporanMingguanState();
}

class _LaporanMingguanState extends State<LaporanMingguan> {
  String? username, idUser;
  Future<List<DataMingguan>> _fetchLaporanMingguan() async {
    final result = await http.get(Uri.parse(BaseURL.laporanMingguan));
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    debugPrint('$result');
    return await list
        .map<DataMingguan>((json) => DataMingguan.fromJson(json))
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
          title: Text(
            "Laporan Mingguan",
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
      //Code Program
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
                      "Laporan (7) Tujuh Hari",
                      style: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Text(
                  "Berikut adalah laporan selama seminggu",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<DataMingguan>>(
            future: _fetchLaporanMingguan(),
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
                                          " ${CurrencyFormat.convertToIdr(int.parse(e.totalTransaksi), 0)}",
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
                                          " ${CurrencyFormat.convertToIdr(int.parse(e.rataRata), 0)}",
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
                                                      DetLapMingguan()),
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
