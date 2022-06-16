// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/pos/payment/struk.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text("Transaksi Selesai"), elevation: 0),
      body: FutureBuilder<List<dynamic>?>(
        future: _fetchDataKeranjang(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TicketWidget(
                        width: 500,
                        height: 500,
                        isCornerRounded: true,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Chip(
                                      backgroundColor: Colors.amber,
                                      label: Text(
                                        "Nomor Transaksi",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                    Text(
                                        snapshot.data[index]['no_transaksi']
                                            .toString(),
                                        style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                            Column(
                              children: [
                                Text("Pembayaran Sukses",
                                    style: TextStyle(fontSize: 16.0)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                      width: 100.0,
                                      height: 100.0,
                                      child: Image.asset(
                                          "asset/image/sukses.png")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text("Total Kembalian",
                                      style: TextStyle(fontSize: 16.0)),
                                ),
                                Text(
                                    CurrencyFormat.convertToIdr(
                                        int.parse(widget.kembalian.toString()),
                                        2),
                                    style: TextStyle(fontSize: 35.0))
                              ],
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Struk(
                                            idTransaksi: snapshot.data[index]
                                                    ['no_transaksi']
                                                .toString()),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    primary: Colors.black87,
                                    side: BorderSide(color: Colors.amber),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                            Icons.monetization_on_outlined,
                                            color: Colors.black87),
                                      ),
                                      Text('Cetak Struk',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
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
                                    backgroundColor: Colors.lightBlueAccent,
                                    primary: Colors.black87,
                                    side: BorderSide(
                                        color: Colors.lightBlueAccent),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                            Icons.monetization_on_outlined,
                                            color: Colors.black87),
                                      ),
                                      Text('Selesai',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }
}
