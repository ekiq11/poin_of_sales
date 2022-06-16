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
    return data;
  }

  Future<List<dynamic>> _struk() async {
    var result = await http
        .get(Uri.parse(BaseURL.struk + widget.idTransaksi!.toString()));
    var data = json.decode(result.body)['data'];
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
            flex: 3,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _dataStruk(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Screenshot(
                          controller: _screenshotController,
                          child: TicketWidget(
                            width: 500,
                            height: 500,
                            isCornerRounded: true,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Column(
                                  children: const [
                                    Text(
                                      "Roti Dua Lima",
                                      style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text("Kompleks Pertokoan Istana Plaza",
                                        style: TextStyle(fontSize: 16.0)),
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
                                        style: TextStyle(fontSize: 16.0)),
                                    Text(snapshot.data['nama_kasir'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.2,
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
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        itemCount:
                                                            snap.data.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      snap.data[
                                                                              index]
                                                                              [
                                                                              'barang']
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16.0)),
                                                                  Text(
                                                                      snap.data[
                                                                              index]
                                                                              [
                                                                              'banyak']
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16.0)),
                                                                  Text(
                                                                      CurrencyFormat.convertToIdr(
                                                                          int.parse(snap.data[index]
                                                                              [
                                                                              'harga']),
                                                                          2),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16.0)),
                                                                  Text(
                                                                      CurrencyFormat.convertToIdr(
                                                                          int.parse(snap.data[index]
                                                                              [
                                                                              'total']),
                                                                          2),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16.0)),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                8.0,
                                                                            bottom:
                                                                                3.0),
                                                                        child: Text(
                                                                            "Diskon",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      Text(
                                                                          snapshot.data['diskon']
                                                                              .toString(),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              TextStyle(fontSize: 16.0)),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        child: Text(
                                                                            "Total",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      Text(
                                                                          CurrencyFormat.convertToIdr(
                                                                              int.parse(snapshot.data[
                                                                                  'total_akhir']),
                                                                              2),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              TextStyle(fontSize: 16.0)),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        child: Text(
                                                                            "Bayar Tunai",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      Text(
                                                                          CurrencyFormat.convertToIdr(
                                                                              int.parse(snapshot.data[
                                                                                  'bayar']),
                                                                              2),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              TextStyle(fontSize: 16.0)),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        child: Text(
                                                                            "Bayar Kartu",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      Text(
                                                                          CurrencyFormat.convertToIdr(
                                                                              int.parse(snapshot.data[
                                                                                  'bayar']),
                                                                              2),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              TextStyle(fontSize: 16.0)),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        child: Text(
                                                                            "Kembali",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                      ),
                                                                      Text(
                                                                          CurrencyFormat.convertToIdr(
                                                                              int.parse(snapshot.data[
                                                                                  'kembalian']),
                                                                              2),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              TextStyle(fontSize: 16.0)),
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                Column(children: const [
                                  Text("Terimakasih atas kunjungan anda"),
                                  Text("Layanan konsumen dan pemesanan"),
                                  Text("081935152277")
                                ])
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
