// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, unrelated_type_equality_checks, use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poin_of_sales/view/pos/payment/struk.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../api/api.dart';
import '../../../model/currency_format.dart';

import '../pos.dart';

class TransaksiSelesai extends StatefulWidget {
  int? kembalian;
  TransaksiSelesai({this.kembalian});

  @override
  State<TransaksiSelesai> createState() => _TransaksiSelesaiState();
}

class _TransaksiSelesaiState extends State<TransaksiSelesai> {
  bool? isVisible = true;
  Future<List<dynamic>?> _fetchDataKeranjang() async {
    var result = await http.get(Uri.parse(BaseURL.dataKeranjang));
    var data = json.decode(result.body)['data'];
    return data;
  }

  String? username, idUser, idTransaksi;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("idUser");
    });
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
    getPref();
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: FutureBuilder<List<dynamic>?>(
          future: _fetchDataKeranjang(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      TicketWidget(
                        width: mediaQueryWidth,
                        height: bodyHeight,
                        isCornerRounded: false,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                    ),
                                    Chip(
                                      backgroundColor: Colors.amber,
                                      label: Text(
                                        "Nomor Transaksi",
                                        style: TextStyle(fontSize: 10.sp),
                                      ),
                                    ),
                                    Text(
                                        snapshot.data[index]['no_transaksi']
                                            .toString(),
                                        style: TextStyle(fontSize: 8.sp)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: mediaQueryHeight * 0.00),
                            Column(
                              children: [
                                Text("Pembayaran Sukses",
                                    style: TextStyle(fontSize: 10.sp)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                      width: mediaQueryWidth * 0.10,
                                      height: mediaQueryHeight * 0.10,
                                      child: Image.asset(
                                          "asset/image/sukses.png")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text("Total Kembalian",
                                      style: TextStyle(fontSize: 10.sp)),
                                ),
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      int.parse(widget.kembalian.toString()),
                                      0),
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                SizedBox(
                                  height: mediaQueryHeight * 0.05,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                          DeviceOrientation.portraitDown
                                        ]);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (context) => Struk(
                                                  idTransaksi: snapshot
                                                      .data[index]
                                                          ['no_transaksi']
                                                      .toString()),
                                            ));
                                      },
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: Size(
                                            mediaQueryWidth * 0.01,
                                            mediaQueryHeight * 0.1 - 10.0),
                                        backgroundColor: Colors.amber,
                                        primary: Colors.black87,
                                        side: BorderSide(color: Colors.amber),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            child: Icon(
                                                Icons.monetization_on_outlined,
                                                color: Colors.black87,
                                                size: 14.sp),
                                          ),
                                          Text('Cetak Struk',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(10.0)),
                                    OutlinedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isVisible = true;
                                        });
                                        final res = await http.get(
                                          Uri.parse(BaseURL.selesaibelanja),
                                        );

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PoinOfSale()),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: Size(
                                            mediaQueryWidth * 0.01,
                                            mediaQueryHeight * 0.1 - 10.0),
                                        backgroundColor: Colors.lightBlueAccent,
                                        primary: Colors.black87,
                                        side: BorderSide(
                                            color: Colors.lightBlueAccent),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            child: Icon(
                                                Icons.monetization_on_outlined,
                                                color: Colors.black87,
                                                size: 14.sp),
                                          ),
                                          Text('Selesai',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return Column(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Image(
                        image: AssetImage("asset/image/keranjang_kosong.png"),
                        width: 100,
                      ),
                    ),
                  ),
                  Text(
                    "Belum ada Produk yang di beli",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
