// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, duplicate_ignore, unused_local_variable, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poin_of_sales/view/pos/payment/selesai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';
import '../../../model/currency_format.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

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
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
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
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Column(
                        children: [
                          Row(
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
                          SizedBox(
                            width: mediaQueryWidth * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
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
                                            minimumSize: Size(
                                                mediaQueryWidth * 0.01,
                                                mediaQueryHeight * 0.1 - 10.0),
                                            backgroundColor:
                                                Colors.lightBlueAccent,
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
                                              Icon(
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: Colors.black87,
                                                  size: 14.sp),
                                              Text(' Bayar Tunai',
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Total Tagihan",
                                              style: TextStyle(fontSize: 10.sp),
                                            ),
                                            Text(
                                              CurrencyFormat.convertToIdr(
                                                  int.parse(snapshot.data[index]
                                                      ['total_belanja']),
                                                  2),
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87),
                                            ),
                                            // ignore: prefer_interpolation_to_compose_strings
                                            Text(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              "Kembalian : " +
                                                  CurrencyFormat.convertToIdr(
                                                      int.parse("$result"), 2),
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              isVisible = true;
                                              form = true;
                                              kdBank = "kartu";
                                              nonTunai = false;
                                              tunai = true;
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: Size(
                                                mediaQueryWidth * 0.01,
                                                mediaQueryHeight * 0.1 - 10.0),
                                            backgroundColor: Colors.amber,
                                            primary: Colors.black87,
                                            side:
                                                BorderSide(color: Colors.amber),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.credit_card_outlined,
                                                  color: Colors.black87,
                                                  size: 14.sp),
                                              Text('Non Tunai',
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: mediaQueryHeight * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Visibility(
                                  visible: isVisible!,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Container(
                                                height: 230,
                                                width: 300,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                          color: Colors.white70,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10.0)),
                                                              Image(
                                                                  image: AssetImage(
                                                                      "asset/image/sukses.png"),
                                                                  width: 60),
                                                              Text("Berhasil",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10.sp))
                                                            ],
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        color: Color.fromARGB(
                                                            255, 95, 183, 98),
                                                        child: SizedBox.expand(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  CurrencyFormat.convertToIdr(
                                                                      int.parse(
                                                                          snapshot.data[index]
                                                                              [
                                                                              'total_belanja']),
                                                                      2),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50), // <-- Radius
                                                                    ),
                                                                    primary: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Text(
                                                                      'O k e',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.sp)),
                                                                  onPressed:
                                                                      () => {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop()
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            kembali = false;
                                            nonTunai = true;
                                            tunai = false;
                                            num1 = int.parse(snapshot
                                                .data[index]['total_belanja']);
                                            num2 = int.parse(snapshot
                                                .data[index]['total_belanja']);
                                            result = num1! - num2!;
                                            print(result);
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size(
                                              mediaQueryWidth * 0.01,
                                              mediaQueryHeight * 0.1 - 10.0),
                                          primary: Colors.black,
                                          side: BorderSide(color: Colors.green),
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
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: Colors.black87,
                                                  size: 14.sp),
                                            ),
                                            Text('Uang Pas',
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          num1 = 50000;

                                          if (num1! <
                                              int.parse(snapshot.data[index]
                                                  ['total_belanja'])) {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Container(
                                                  height: 210,
                                                  width: 300,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          color: Colors.white70,
                                                          child: Icon(
                                                            Icons
                                                                .account_balance_wallet,
                                                            size: 60,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color:
                                                              Colors.redAccent,
                                                          child:
                                                              SizedBox.expand(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Uang anda kurang !",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50), // <-- Radius
                                                                      ),
                                                                      primary:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: Text(
                                                                        'Ok',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10.sp)),
                                                                    onPressed:
                                                                        () => {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop()
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Container(
                                                  height: 230,
                                                  width: 300,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                            color:
                                                                Colors.white70,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                10.0)),
                                                                Image(
                                                                    image: AssetImage(
                                                                        "asset/image/sukses.png"),
                                                                    width: 60),
                                                                Text("Berhasil",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.sp))
                                                              ],
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: Color.fromARGB(
                                                              255, 95, 183, 98),
                                                          child:
                                                              SizedBox.expand(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Rp. 50.000,00",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50), // <-- Radius
                                                                      ),
                                                                      primary:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: Text(
                                                                        'O k e',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10.sp)),
                                                                    onPressed:
                                                                        () => {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop()
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          setState(() {
                                            kembali = false;
                                            nonTunai = true;
                                            tunai = false;
                                            num1 = 50000;
                                            num2 = int.parse(snapshot
                                                .data[index]['total_belanja']);
                                            result = num1! - num2!;
                                            print(result);
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size(
                                              mediaQueryWidth * 0.01,
                                              mediaQueryHeight * 0.1 - 10.0),
                                          primary: Colors.black,
                                          side: BorderSide(color: Colors.blue),
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
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: Colors.black87,
                                                  size: 14.sp),
                                            ),
                                            Text('Rp.50.000,00',
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          num1 = 100000;
                                          if (num1! <
                                              int.parse(snapshot.data[index]
                                                  ['total_belanja'])) {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Container(
                                                  height: 210,
                                                  width: 300,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          color: Colors.white70,
                                                          child: Icon(
                                                            Icons
                                                                .account_balance_wallet,
                                                            size: 60,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color:
                                                              Colors.redAccent,
                                                          child:
                                                              SizedBox.expand(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Uang anda kurang !",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50), // <-- Radius
                                                                      ),
                                                                      primary:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: Text(
                                                                        'Ok',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10.sp)),
                                                                    onPressed:
                                                                        () => {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop()
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Container(
                                                  height: 230,
                                                  width: 300,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                            color:
                                                                Colors.white70,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                10.0)),
                                                                Image(
                                                                    image: AssetImage(
                                                                        "asset/image/sukses.png"),
                                                                    width: 60),
                                                                Text("Berhasil",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.sp))
                                                              ],
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: Color.fromARGB(
                                                              255, 95, 183, 98),
                                                          child:
                                                              SizedBox.expand(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Rp. 100.000,00",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50), // <-- Radius
                                                                      ),
                                                                      primary:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: Text(
                                                                        'Ok',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10.sp)),
                                                                    onPressed:
                                                                        () => {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop()
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          kembali = false;
                                          nonTunai = true;
                                          tunai = false;
                                          setState(() {
                                            num1 = 100000;
                                            num2 = int.parse(snapshot
                                                .data[index]['total_belanja']);
                                            result = num1! - num2!;
                                            print(result);
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size(
                                              mediaQueryWidth * 0.01,
                                              mediaQueryHeight * 0.1 - 10.0),
                                          primary: Colors.black,
                                          side: BorderSide(color: Colors.red),
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
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: Colors.black87,
                                                  size: 14.sp),
                                            ),
                                            Text('Rp.100.000,00',
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: form!,
                                  child: AutoSizeTextField(
                                    fullwidth: false,
                                    minFontSize: 0,
                                    maxLines: null,
                                    textAlignVertical: TextAlignVertical.center,
                                    inputFormatters: [
                                      ThousandsFormatter(),
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    controller: totalUangController,
                                    onChanged: (s) {
                                      // print(CurrencyFormat.convertToIdr(
                                      //     int.parse(s), 2));
                                      s == ''
                                          ? 0
                                          : num1 = int.parse(totalUangController
                                              .text
                                              .replaceAll(",", ""));
                                      num2 = num2 = int.parse(snapshot
                                          .data[index]['total_belanja']);
                                      setState(() {
                                        print("ini" + num1.toString());
                                        result = num1! - num2!;
                                      });

                                      print(result);
                                    },
                                    decoration: InputDecoration(
                                      prefixText: 'Rp.',
                                      hintText: "Jumlah Uang",
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
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
                                SizedBox(height: 12.sp),
                                Visibility(
                                  visible: tunai!,
                                  child: InkWell(
                                    child: Container(
                                      height: mediaQueryHeight * 0.10,
                                      width: mediaQueryWidth * 0.7,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset: const Offset(2, 4),
                                              blurRadius: 50,
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.monetization_on_sharp,
                                              color: Colors.black87,
                                              size: 13.sp),
                                          Text(
                                            ' Bayar',
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      //navigasi
                                      if (num1 == null) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Container(
                                              height: 210,
                                              width: 300,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.white70,
                                                      child: Icon(
                                                        Icons
                                                            .account_balance_wallet,
                                                        size: 60,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.redAccent,
                                                      child: SizedBox.expand(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Masukkan nominal",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50), // <-- Radius
                                                                  ),
                                                                  primary: Colors
                                                                      .white,
                                                                ),
                                                                child: Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.sp)),
                                                                onPressed: () =>
                                                                    {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      if (result! < 0) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Container(
                                              height: 210,
                                              width: 300,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.white70,
                                                      child: Icon(
                                                        Icons
                                                            .account_balance_wallet,
                                                        size: 60,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.redAccent,
                                                      child: SizedBox.expand(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Masukkan nominal",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50), // <-- Radius
                                                                  ),
                                                                  primary: Colors
                                                                      .white,
                                                                ),
                                                                child: Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.sp)),
                                                                onPressed: () =>
                                                                    {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        num1 = num1 = int.parse(
                                            totalUangController.text
                                                .replaceAll(",", ""));
                                        num2 = int.parse(snapshot.data[index]
                                            ['total_belanja']);
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
                                            "diskon": snapshot.data[index]
                                                    ['diskon']
                                                .toString(),
                                            "total_akhir": snapshot.data[index]
                                                    ['total_belanja']
                                                .toString(),
                                            "bayar": "$num1".toString(),
                                            "kembalian": "$result".toString(),
                                            "kd_barang": snapshot.data[index]
                                                    ['kd_barang']
                                                .toString(),
                                            "barang": snapshot.data[index]
                                                    ['barang']
                                                .toString(),
                                            "harga": snapshot.data[index]
                                                    ['harga']
                                                .toString(),
                                            "banyak": snapshot.data[index]
                                                    ['banyak']
                                                .toString(),
                                            "total": snapshot.data[index]
                                                    ['total']
                                                .toString(),
                                          },
                                        );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransaksiSelesai(
                                                        kembalian: result)));
                                      }
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: nonTunai!,
                                  child: InkWell(
                                    child: Container(
                                      height: mediaQueryHeight * 0.10,
                                      width: mediaQueryWidth * 0.7,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset: const Offset(2, 4),
                                              blurRadius: 50,
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.monetization_on_sharp,
                                              color: Colors.black87,
                                              size: 13.sp),
                                          Text(
                                            ' Bayar',
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      //navigasi
                                      if (result! < 0) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Container(
                                              height: 210,
                                              width: 300,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.white70,
                                                      child: Icon(
                                                        Icons
                                                            .account_balance_wallet,
                                                        size: 60,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.redAccent,
                                                      child: SizedBox.expand(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Masukan nominal",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50), // <-- Radius
                                                                  ),
                                                                  primary: Colors
                                                                      .white,
                                                                ),
                                                                child: Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.sp)),
                                                                onPressed: () =>
                                                                    {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        print("$result");
                                        final res = await http.post(
                                          Uri.parse(BaseURL.transaksi),
                                          body: {
                                            "kd_bank": "$kdBank".toString(),
                                            "id_kasir": "$idUser".toString(),
                                            "subtotal": snapshot.data[index]
                                                    ['total_belanja']
                                                .toString(),
                                            "diskon": snapshot.data[index]
                                                    ['diskon']
                                                .toString(),
                                            "total_akhir": snapshot.data[index]
                                                    ['total_belanja']
                                                .toString(),
                                            "bayar": "$num1".toString(),
                                            "kembalian": "$result".toString(),
                                            "kd_barang": snapshot.data[index]
                                                    ['kd_barang']
                                                .toString(),
                                            "barang": snapshot.data[index]
                                                    ['barang']
                                                .toString(),
                                            "harga": snapshot.data[index]
                                                    ['harga']
                                                .toString(),
                                            "banyak": snapshot.data[index]
                                                    ['banyak']
                                                .toString(),
                                            "total": snapshot.data[index]
                                                    ['total']
                                                .toString(),
                                          },
                                        );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransaksiSelesai(
                                                        kembalian: result)));
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
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
    );
  }
}
