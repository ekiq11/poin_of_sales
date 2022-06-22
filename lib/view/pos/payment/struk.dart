// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, unrelated_type_equality_checks, use_build_context_synchronously, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poin_of_sales/view/pos/pos.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
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

  //popScope
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Warning !'),
            content: Text('Selesaikan transaksi terlebih dahulu'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight
                  ]);
                  final res = await http.get(
                    Uri.parse(BaseURL.selesaibelanja),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PoinOfSale()),
                  );
                }, //<-- SEE HERE
                child: Text('Ya'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // <-- SEE HERE
                child: Text('Tidak'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey,
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
                            width: mediaQueryWidth,
                            height: mediaQueryHeight * 0.7,
                            isCornerRounded: true,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 18.sp, right: 18.sp),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: mediaQueryHeight * 0.03),
                                      Text(
                                        "Roti Dua Delima",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text("Kompleks Pertokoan Istana Plaza",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                          )),
                                      Text("Jln. Panji Tilar No. 48 Jaksel",
                                          style: TextStyle(fontSize: 10.sp)),
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
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          snapshot.data['nama_kasir']
                                              .toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.28,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: mediaQueryHeight * 0.13,
                                              child:
                                                  FutureBuilder<List<dynamic>>(
                                                future: _struk(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snap) {
                                                  if (snap.hasData) {
                                                    return ListView.builder(
                                                      itemCount:
                                                          snap.data.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int x) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      mediaQueryWidth *
                                                                          0.2,
                                                                  child: Text(
                                                                      snap.data[
                                                                              x]
                                                                          [
                                                                          'barang'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.sp)),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      mediaQueryWidth *
                                                                          0.01,
                                                                  child: Text(
                                                                      snap.data[
                                                                              x]
                                                                              [
                                                                              'banyak']
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.sp)),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      mediaQueryWidth *
                                                                          0.3,
                                                                  child: Text(
                                                                      CurrencyFormat.convertToIdr(
                                                                          int.parse(snap.data[x]
                                                                              [
                                                                              'harga']),
                                                                          2),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.sp)),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      mediaQueryWidth *
                                                                          0.3,
                                                                  child: Text(
                                                                      CurrencyFormat.convertToIdr(
                                                                          int.parse(snap.data[x]
                                                                              [
                                                                              'total']),
                                                                          2),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.sp)),
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
                                                  width: mediaQueryWidth * 0.55,
                                                  child: Text("Diskon",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 10.sp)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                  child: Text(
                                                      snapshot.data['diskon']
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 10.sp)),
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
                                                    width:
                                                        mediaQueryWidth * 0.5,
                                                    child: Text("Total",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 10.sp)),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        mediaQueryWidth * 0.3,
                                                    child: Text(
                                                        CurrencyFormat.convertToIdr(
                                                            int.parse(snapshot
                                                                    .data[
                                                                'total_akhir']),
                                                            2),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 10.sp)),
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
                                                  width: mediaQueryWidth * 0.55,
                                                  child: Text("Bayar Tunai",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 10.sp)),
                                                ),
                                                SizedBox(
                                                  width: mediaQueryWidth * 0.3,
                                                  child: Text(
                                                      CurrencyFormat
                                                          .convertToIdr(
                                                              int.parse(
                                                                  snapshot.data[
                                                                      'bayar']),
                                                              2),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 10.sp)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: mediaQueryWidth * 0.55,
                                                  child: Text("Kembali",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 10.sp)),
                                                ),
                                                SizedBox(
                                                  width: mediaQueryWidth * 0.3,
                                                  child: Text(
                                                      CurrencyFormat
                                                          .convertToIdr(
                                                              int.parse(snapshot
                                                                      .data[
                                                                  'kembalian']),
                                                              2),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 10.sp)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: mediaQueryHeight * 0.1,
                                  ),
                                  Column(children: [
                                    Text("Terimakasih atas kunjungan anda",
                                        style: TextStyle(fontSize: 10.sp)),
                                    Text("Layanan konsumen dan pemesanan",
                                        style: TextStyle(fontSize: 10.sp)),
                                    Text("081935152277",
                                        style: TextStyle(fontSize: 10.sp))
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
                              image: AssetImage(
                                  "asset/image/keranjang_kosong.png"),
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
      ),
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
                fontSize: 14.0),
            labelBackgroundColor: Colors.black87),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.arrow_back_ios_new_rounded),
            backgroundColor: Colors.amber,
            onTap: () async {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft
              ]);
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
                fontSize: 14.0),
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

    const text = "Share From Roti Dua Delima";
    await Share.shareFiles([image.path], text: text);
    image.writeAsBytes(bytes);

    return result['filePath'];
  }
}
