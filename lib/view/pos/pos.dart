// ignore_for_file: sized_box_for_whitespace, unused_local_variable, use_build_context_synchronously, sort_child_properties_last

import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:poin_of_sales/view/pos/payment/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api/api.dart';
import '../../model/currency_format.dart';
import '../home.dart';

class PoinOfSale extends StatefulWidget {
  const PoinOfSale({Key? key}) : super(key: key);

  @override
  State<PoinOfSale> createState() => _PoinOfSaleState();
}

class _PoinOfSaleState extends State<PoinOfSale> {
  bool? isVisible = true;

  final StreamController<List>? streamController = StreamController();
  final StreamController<List>? streamctrl = StreamController();
  Timer? _timer;
  Timer? _waktu;

  @override
  void initState() {
    getPref();
    _fetchDataKeranjang();
    _fetchDataTotal();
    _timer =
        Timer.periodic(Duration(seconds: 1), (timer) => _fetchDataKeranjang());
    _waktu = Timer.periodic(Duration(seconds: 1), (timer) => _fetchDataTotal());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer!.isActive) _timer!.cancel();
    if (_waktu!.isActive) _waktu!.cancel();
    super.dispose();
  }

  Future<List<dynamic>> _fetchDataBarang() async {
    var result = await http.get(Uri.parse(BaseURL.pos));
    return json.decode(result.body)['data'];
  }

  Future<List<dynamic>?> _fetchDataKeranjang() async {
    var result = await http.get(Uri.parse(BaseURL.dataKeranjang));
    var data = json.decode(result.body)['data'];
    if (data != null) {
      streamController!.add(data);
    } else {
      streamController!.add([]);
    }
    return data;
  }

  Future<List<dynamic>?> _fetchDataTotal() async {
    var result = await http.get(Uri.parse(BaseURL.dataKeranjang));
    var data = json.decode(result.body)['data'];
    if (data != null) {
      streamctrl!.add(data);
    } else {
      streamctrl!.add([]);
    }
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

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    final paddingTop = MediaQuery.of(context).padding.top;
    final myappBar = PreferredSize(
        preferredSize: Size.fromHeight(30.sp),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Roti Dua Lima', style: TextStyle(fontSize: 10.sp)),
                IconButton(
                    onPressed: () async {
                      // Add your onPressed code here!
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      setState(() {
                        username = preferences.getString("username");
                        idUser = preferences.getString("idUser");
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => HalamanUtama(
                              username: "$username", idUser: "$idUser"),
                        ),
                      );

                      //  print("username: ${widget.username!}");
                    },
                    icon: Icon(Icons.home, size: 14.sp, color: Colors.black87)),
              ],
            ),
          ),
          //shadow
          elevation: 0,
        ) //back button
        );
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        myappBar.preferredSize.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //appbar
        appBar: myappBar,
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: FutureBuilder<List<dynamic>>(
                future: _fetchDataBarang(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      snapshot.data[index]['nama_barang'],
                                      style: TextStyle(fontSize: 10.sp)),
                                  subtitle: Text(
                                      CurrencyFormat.convertToIdr(
                                          int.parse(
                                            snapshot.data[index]['harga_jual'],
                                          ),
                                          2),
                                      style: TextStyle(fontSize: 10.sp)),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "http://kbu-cdn.com/dk/wp-content/uploads/roti-goreng-madu.jpg"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ))),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Text("+ Add",
                                              style:
                                                  TextStyle(fontSize: 10.sp)),
                                        ),
                                        Icon(Icons.add_shopping_cart_rounded,
                                            size: 12.sp),
                                      ],
                                    ),
                                    onPressed: () async {
                                      int counter = 0;
                                      setState(() {
                                        isVisible = !isVisible!;
                                        counter++;
                                      });
                                      final res = await http.post(
                                        Uri.parse(BaseURL.tambahKeranjang),
                                        body: {
                                          "kd_barang": snapshot.data[index]
                                                  ['kd_barang']
                                              .toString(),
                                          "barang": snapshot.data[index]
                                                  ['nama_barang']
                                              .toString(),
                                          "harga": snapshot.data[index]
                                                  ['harga_jual']
                                              .toString(),
                                          "banyak": "$counter",
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_rounded, size: 14.sp),
                              Text(" Keranjang Belanja",
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 230, 230, 230),
                      height: mediaQueryHeight -
                          myappBar.preferredSize.height -
                          MediaQuery.of(context).padding.top * 1.7 -
                          16.5.sp,
                      width: mediaQueryWidth,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: StreamBuilder(
                              stream: streamController!.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return FutureBuilder<List<dynamic>?>(
                                    future: _fetchDataKeranjang(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          padding: EdgeInsets.all(3.0),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: ListTile(
                                                          title: Text(
                                                              snapshot.data[
                                                                      index]
                                                                  ['barang'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp)),
                                                          subtitle: Text(
                                                              CurrencyFormat
                                                                  .convertToIdr(
                                                                      int.parse(
                                                                        snapshot.data[index]
                                                                            [
                                                                            'harga'],
                                                                      ),
                                                                      2),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp)),
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    "http://kbu-cdn.com/dk/wp-content/uploads/roti-goreng-madu.jpg"),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              int counter = int
                                                                  .parse(snapshot
                                                                          .data[
                                                                      index]['id']);
                                                              setState(() {
                                                                counter--;
                                                              });
                                                              final res =
                                                                  await http
                                                                      .get(
                                                                Uri.parse(BaseURL
                                                                        .kurangi +
                                                                    snapshot.data[
                                                                            index]
                                                                        ['id']),
                                                              );
                                                            },
                                                            icon: Icon(
                                                                Icons.remove,
                                                                size: 14.sp),
                                                          ),
                                                          Badge(
                                                            toAnimate: false,
                                                            shape: BadgeShape
                                                                .square,
                                                            badgeColor:
                                                                Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            badgeContent: Text(
                                                                snapshot.data[
                                                                        index]
                                                                    ['banyak'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .black87)),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              int counter = int
                                                                  .parse(snapshot
                                                                          .data[
                                                                      index]['id']);
                                                              setState(() {
                                                                counter++;
                                                              });
                                                              final res =
                                                                  await http
                                                                      .get(
                                                                Uri.parse(BaseURL
                                                                        .add +
                                                                    snapshot.data[
                                                                            index]
                                                                        ['id']),
                                                              );
                                                            },
                                                            icon: Icon(
                                                                Icons.add,
                                                                size: 14.sp),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: mediaQueryWidth *
                                                            0.06,
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            final res =
                                                                await http.get(
                                                              Uri.parse(BaseURL
                                                                      .hapus +
                                                                  snapshot.data[
                                                                          index]
                                                                      ['id']),
                                                            );
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .delete_forever_rounded,
                                                              size: 14.sp,
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                height: mediaQueryHeight * 0.3,
                                                child: Image(
                                                  image: AssetImage(
                                                      "asset/image/keranjang_kosong.png"),
                                                  width: mediaQueryHeight * 0.2,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Belum ada Produk yang di beli",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 50.0),
                                          child: Image(
                                            image: AssetImage(
                                                "asset/image/keranjang_kosong.png"),
                                            width: mediaQueryHeight * 0.2,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Belum ada Produk yang di beli",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            height: mediaQueryHeight * 0.1,
                            child: StreamBuilder(
                              stream: streamctrl!.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return FutureBuilder<List<dynamic>?>(
                                    future: _fetchDataTotal(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            padding: EdgeInsets.all(3.0),
                                            itemCount: 1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                height: mediaQueryHeight *
                                                    0.1, //set your height here
                                                width: double
                                                    .maxFinite, //set your width here
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          "Total : " +
                                                              CurrencyFormat.convertToIdr(
                                                                  int.parse(snapshot
                                                                              .data[
                                                                          index]
                                                                      [
                                                                      'total_belanja']),
                                                                  2),
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0),
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Payment(),
                                                              ),
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .black87),
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0))),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 10.sp,
                                                                  color: Colors
                                                                      .amber),
                                                              Text(" Check Out",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .amber)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return Text("");
                                      }
                                    },
                                  );
                                } else {
                                  return Text("");
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
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => Payment()));
        //   },
        //   label: Text(" Checkout",
        //       style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
        //   icon: Icon(Icons.check, size: 14.sp),
        // ),
      ),
    );
  }
}
