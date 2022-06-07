// ignore_for_file: empty_catches, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../report/detail/detail_lap_periode.dart';
import '../report/laporan_bulanan.dart';
import '../report/laporan_harian.dart';
import '../report/laporan_kemarin.dart';
import '../report/laporan_mingguan.dart';
import '../report/laporan_periode.dart';
import '../report/laporan_tigapuluh_hari.dart';

class DrawerFlutter extends StatefulWidget {
  final String? username;
  const DrawerFlutter({this.username});

  @override
  State<DrawerFlutter> createState() => _DrawerFlutterState();
}

class _DrawerFlutterState extends State<DrawerFlutter> {
  final TextEditingController daritglController = TextEditingController();
  final TextEditingController smptglController = TextEditingController();
  final String? sUrl = "https://rotiduadelima.id/api/v1/laporan_periode.php?";
  bool visible = false;
  bool isVisible = true;
  _cekProses() async {
    setState(() {
      visible = true;
    });

    var params =
        "dari_tanggal=${daritglController.text}&sampai_tanggal=${smptglController.text}";
    // ignore: avoid_print
    print(params);
    if (daritglController.text.isNotEmpty && smptglController.text.isNotEmpty) {
      try {
        var res = await http.get(Uri.parse(sUrl! + params));
        if (res.statusCode == 200) {
          var response = json.decode(res.body);
          // ignore: avoid_print
          print(response);
          if (response['error'] == false) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => LapPeriode(
                    drTgl: daritglController.text,
                    smpTgl: smptglController.text),
              ),
            );
          } else {
            setState(
              () {
                visible = false;
              },
            );
            //alertdialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Tanggal Tidak Valid"),
                  content:
                      const Text("Tanggal yang anda masukkan tidak sesuai !"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          }
        }
      } catch (e) {}
    } else {
      setState(
        () {
          visible = false;
        },
      );
      //alertdialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Failed"),
            content: const Text("Tanggal harus di isi !"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  String? username;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            //add image
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: Center(
              child: Text(
                "Laporan Penjualan",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          ListTile(
            trailing: Icon(
              Icons.calendar_today_rounded,
              color: Colors.black87,
            ),
            title: Text("Hari Ini"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanHarian(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.calendar_view_day, color: Colors.black87),
            title: Text("Kemarin"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanKemarin(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.calendar_view_week, color: Colors.black87),
            title: Text("7 Hari"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanMingguan(),
                ),
              );
            },
          ),
          ListTile(
            trailing:
                Icon(Icons.calendar_month_outlined, color: Colors.black87),
            title: Text("Bulan Ini"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanBulanan(),
                ),
              );
            },
          ),
          ListTile(
            trailing:
                Icon(Icons.calendar_month_outlined, color: Colors.black87),
            title: Text("30 Hari"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanTigaPuluhHari(),
                ),
              );
            },
          ),
          ListTile(
            onTap: () {
              setState(
                () {
                  isVisible = !isVisible;
                },
              );
            },
            trailing: isVisible == false
                ? Icon(Icons.arrow_drop_down_outlined, color: Colors.black87)
                : Icon(Icons.arrow_drop_up_outlined, color: Colors.black87),
            title: Text("Laporan Periode"),
          ),
          Visibility(
            visible: isVisible,
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                    child: TextFormField(
                      controller: daritglController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Dari Tanggal",
                      ),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2025),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            daritglController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 20.0, top: 15.0),
                    child: TextFormField(
                      controller: smptglController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Sampai Tanggal",
                      ),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2025),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            smptglController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 20.0, top: 15.0, bottom: 20.0),
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                            colors: [Color(0xfffbb448), Color(0xfff7892b)],
                          ),
                        ),
                        child: const Text(
                          'Cari',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        _cekProses();
                      },
                    ),
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
