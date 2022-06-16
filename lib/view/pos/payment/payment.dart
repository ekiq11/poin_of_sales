// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/pos/payment/selesai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';
import '../../../model/currency_format.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool? isVisible = true;
  String? jumlahUang, kdBank;
  int? kembalian, num1, num2;
  int? result = 0;
  bool? form = false;
  bool? cek = false;
  bool? tunai = false;
  bool? nonTunai = false;
  bool? kembali;

  final TextEditingController totalUangController = TextEditingController();
  Future<List<dynamic>?> _fetchDataKeranjang() async {
    var result = await http.get(Uri.parse(BaseURL.dataKeranjang));
    var data = json.decode(result.body)['data'];

    return data;
  }

  String? username, idUser;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("idUser");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text("Payment"), elevation: 0),
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
                        width: 600,
                        height: 600,
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
                            Spacer(
                              flex: 2,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Total Tagihan",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      int.parse(snapshot.data[index]
                                          ['total_belanja']),
                                      2),
                                  style: TextStyle(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                // ignore: prefer_interpolation_to_compose_strings
                                if (result != null)
                                  kembali == true
                                      ? Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "Kembalian : " +
                                              CurrencyFormat.convertToIdr(
                                                  int.parse("0"), 2),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black87))
                                      : Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "Kembalian : " +
                                              CurrencyFormat.convertToIdr(
                                                  int.parse("$result"), 2),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black87))
                                else
                                  Text(""),
                                Padding(
                                    padding: EdgeInsets.only(
                                  bottom: 25.0,
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisible = true;
                                            form = true;
                                            kdBank = "tunai";
                                            tunai = true;
                                            nonTunai = false;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          primary: Colors.black87,
                                          side: BorderSide(
                                              color: Colors.lightBlueAccent),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: Icon(
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: Colors.black87),
                                            ),
                                            Text('Pembayaran Tunai',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisible = false;
                                            form = true;
                                            kdBank = "kartu";
                                            nonTunai = false;
                                            tunai = true;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          primary: Colors.black87,
                                          side: BorderSide(color: Colors.amber),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: Icon(
                                                  Icons.credit_card_outlined,
                                                  color: Colors.black87),
                                            ),
                                            Text('Pembayaran Non Tunai',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  child: Visibility(
                                    visible: isVisible!,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              kembali = false;
                                              nonTunai = true;
                                              tunai = false;
                                              num1 = int.parse(
                                                  snapshot.data[index]
                                                      ['total_belanja']);
                                              num2 = int.parse(
                                                  snapshot.data[index]
                                                      ['total_belanja']);
                                              result = num1! - num2!;
                                              print(result);
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            primary: Colors.black,
                                            side:
                                                BorderSide(color: Colors.green),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0),
                                                child: Icon(
                                                    Icons
                                                        .monetization_on_outlined,
                                                    color: Colors.black87),
                                              ),
                                              Text('Uang Pas',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              kembali = false;
                                              nonTunai = true;
                                              tunai = false;
                                              num1 = 50000;
                                              num2 = int.parse(
                                                  snapshot.data[index]
                                                      ['total_belanja']);
                                              result = num1! - num2!;
                                              print(result);
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            primary: Colors.black,
                                            side:
                                                BorderSide(color: Colors.blue),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0),
                                                child: Icon(
                                                    Icons
                                                        .monetization_on_outlined,
                                                    color: Colors.black87),
                                              ),
                                              Text('Rp.50.000,00',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            kembali = false;
                                            nonTunai = true;
                                            tunai = false;
                                            setState(() {
                                              num1 = 100000;
                                              num2 = int.parse(
                                                  snapshot.data[index]
                                                      ['total_belanja']);
                                              result = num1! - num2!;
                                              print(result);
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            primary: Colors.black,
                                            side: BorderSide(color: Colors.red),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0),
                                                child: Icon(
                                                    Icons
                                                        .monetization_on_outlined,
                                                    color: Colors.black87),
                                              ),
                                              Text('Rp.100.000,00',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: form!,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    controller: totalUangController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Jumlah Uang",
                                      hintStyle: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        cek == cek;
                                        result;
                                        kembali = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Visibility(
                              visible: tunai!,
                              child: InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: const Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xfffbb448),
                                        Color(0xfff7892b)
                                      ],
                                    ),
                                  ),
                                  child: const Text(
                                    'Bayar',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                ),
                                onTap: () async {
                                  //navigasi

                                  num1 = int.parse(totalUangController.text);
                                  num2 = int.parse(
                                      snapshot.data[index]['total_belanja']);
                                  result = num1! - num2!;
                                  print(result);
                                  final res = await http.post(
                                    Uri.parse(BaseURL.transaksi),
                                    body: {
                                      "kd_bank": "$kdBank".toString(),
                                      "id_kasir": "$idUser".toString(),
                                      "subtotal": snapshot.data[index]
                                              ['total_belanja']
                                          .toString(),
                                      "diskon": snapshot.data[index]['diskon']
                                          .toString(),
                                      "total_akhir": snapshot.data[index]
                                              ['total_belanja']
                                          .toString(),
                                      "bayar": "$num1".toString(),
                                      "kembalian": "$result".toString(),
                                      "kd_barang": snapshot.data[index]
                                              ['kd_barang']
                                          .toString(),
                                      "barang": snapshot.data[index]['barang']
                                          .toString(),
                                      "harga": snapshot.data[index]['harga']
                                          .toString(),
                                      "banyak": snapshot.data[index]['banyak']
                                          .toString(),
                                      "total": snapshot.data[index]['total']
                                          .toString(),
                                    },
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransaksiSelesai(
                                                  kembalian: result)));
                                },
                              ),
                            ),
                            Visibility(
                              visible: nonTunai!,
                              child: InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: const Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xfffbb448),
                                        Color(0xfff7892b)
                                      ],
                                    ),
                                  ),
                                  child: const Text(
                                    'Bayar',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                ),
                                onTap: () async {
                                  //navigasi
                                  print("$result");
                                  final res = await http.post(
                                    Uri.parse(BaseURL.transaksi),
                                    body: {
                                      "kd_bank": "$kdBank".toString(),
                                      "id_kasir": "$idUser".toString(),
                                      "subtotal": snapshot.data[index]
                                              ['total_belanja']
                                          .toString(),
                                      "diskon": snapshot.data[index]['diskon']
                                          .toString(),
                                      "total_akhir": snapshot.data[index]
                                              ['total_belanja']
                                          .toString(),
                                      "bayar": "$num1".toString(),
                                      "kembalian": "$result".toString(),
                                      "kd_barang": snapshot.data[index]
                                              ['kd_barang']
                                          .toString(),
                                      "barang": snapshot.data[index]['barang']
                                          .toString(),
                                      "harga": snapshot.data[index]['harga']
                                          .toString(),
                                      "banyak": snapshot.data[index]['banyak']
                                          .toString(),
                                      "total": snapshot.data[index]['total']
                                          .toString(),
                                    },
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransaksiSelesai(
                                                  kembalian: result)));
                                },
                              ),
                            )
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
