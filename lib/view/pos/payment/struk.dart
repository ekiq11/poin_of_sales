// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poin_of_sales/view/pos/pos.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';
import '../../../model/currency_format.dart';

class Struk extends StatefulWidget {
  String? idTransaksi;
  Struk({this.idTransaksi});

  @override
  State<Struk> createState() => _StrukState();
}

class _StrukState extends State<Struk> {
  final _screenshotController = ScreenshotController();

  bool? isVisible = true;
  Future<Map<String, dynamic>?> _dataStruk() async {
    var result = await http
        .get(Uri.parse(BaseURL.struk + widget.idTransaksi!.toString()));
    var data = json.decode(result.body) as Map<String, dynamic>;
    print(data);
    return data;
  }

  Future<List<dynamic>> _struk() async {
    var result = await http
        .get(Uri.parse(BaseURL.struk + widget.idTransaksi!.toString()));
    var data = json.decode(result.body)['data'] as List<dynamic>;
    print(data);
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
      appBar: AppBar(title: Text("Bukti Transaksi"), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _dataStruk(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Screenshot(
                        controller: _screenshotController,
                        child: TicketWidget(
                          width: 550,
                          height: 600,
                          isCornerRounded: true,
                          padding: EdgeInsets.all(20),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Column(
                              children: [
                                Column(
                                  children: const [
                                    Text(
                                      "Roti Dua Delima",
                                      style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text("Kompleks Pertokoan Istana Plaza",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        )),
                                    Text("Jln. Panji Tilar No. 48 Jaksel",
                                        style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 20.0)),
                                Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data['waktu'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600)),
                                    Text(snapshot.data['nama_kasir'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.30,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: FutureBuilder<
                                                    List<dynamic>>(
                                                  future: _struk(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot snap) {
                                                    if (snap.hasData) {
                                                      return ListView.builder(
                                                        itemCount:
                                                            snap.data.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int x) {
                                                          print(snap.data[x]
                                                              ['barang']);
                                                          return Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            100.0,
                                                                        child: Text(
                                                                            snap.data[x][
                                                                                'barang'],
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10.0,
                                                                        child: Text(
                                                                            snap.data[x]['banyak']
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            120.0,
                                                                        child: Text(
                                                                            CurrencyFormat.convertToIdr(int.parse(snap.data[x]['harga']),
                                                                                2),
                                                                            textAlign: TextAlign.right,
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            120.0,
                                                                        child: Text(
                                                                            CurrencyFormat.convertToIdr(int.parse(snap.data[x]['total']),
                                                                                2),
                                                                            textAlign: TextAlign.right,
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text("Diskon",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text(
                                                        snapshot.data['diskon']
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 100.0,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 100.0,
                                                      child: Text("Total",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 16.0)),
                                                    ),
                                                    SizedBox(
                                                      width: 120.0,
                                                      child: Text(
                                                          CurrencyFormat.convertToIdr(
                                                              int.parse(snapshot
                                                                      .data[
                                                                  'total_akhir']),
                                                              2),
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 16.0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text("Bayar Tunai",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text(
                                                        CurrencyFormat
                                                            .convertToIdr(
                                                                int.parse(snapshot
                                                                        .data[
                                                                    'bayar']),
                                                                2),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text("Bayar Kartu",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text(
                                                        CurrencyFormat
                                                            .convertToIdr(
                                                                int.parse(snapshot
                                                                        .data[
                                                                    'bayar']),
                                                                2),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text("Kembali",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  SizedBox(
                                                    width: 120.0,
                                                    child: Text(
                                                        CurrencyFormat.convertToIdr(
                                                            int.parse(snapshot
                                                                    .data[
                                                                'kembalian']),
                                                            2),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(children: const [
                                  Text("Terimakasih atas kunjungan anda"),
                                  Text("Layanan konsumen dan pemesanan"),
                                  Text("081935152277")
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: const [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Image(
                            image:
                                AssetImage("asset/image/keranjang_kosong.png"),
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
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }

//FAB
  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.amber,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.share_rounded),
            backgroundColor: Colors.amber,
            onTap: () async {
              final image = await _screenshotController.capture();
              if (image == null) return;
              await saveImage(image);
            },
            label: 'Share',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.black87),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.arrow_back_ios_new_rounded),
            backgroundColor: Colors.amber,
            onTap: () async {
              final res = await http.get(
                Uri.parse(BaseURL.selesaibelanja),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PoinOfSale()),
              );
            },
            label: 'Back',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.black87)
      ],
    );
  }

//Save and share
  Future saveImage(Uint8List bytes) async {
    //Screenshoot
    await [Permission.storage].request();
    final time = DateTime.now().toIso8601String().replaceAll(':', '-');
    final name = 'screnshoot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    //Share
    final directory = await getApplicationDocumentsDirectory();
    directory.absolute.path;
    final image = File('/storage/emulated/0/Pictures/$name.jpg');

    const text = "Share From Roti Dua Lima";
    await Share.shareFiles([image.path], text: text);
    image.writeAsBytes(bytes);

    return result['filePath'];
  }
}
