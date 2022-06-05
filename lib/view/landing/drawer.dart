// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../report/laporan_periode.dart';

class DrawerFlutter extends StatefulWidget {
  const DrawerFlutter({Key? key}) : super(key: key);

  @override
  State<DrawerFlutter> createState() => _DrawerFlutterState();
}

class _DrawerFlutterState extends State<DrawerFlutter> {
  final TextEditingController daritglController = TextEditingController();
  bool visible = false;
  final TextEditingController smptglController = TextEditingController();
  final String? sUrl = "https://rotiduadelima.id/api/v1/laporan_periode.php?";

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
                  content: const Text("Masukkan Tanggal yang Sesuai"),
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

    }
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
              Navigator.pushNamed(context, '/laporanHarian');
            },
          ),
          ListTile(
            trailing: Icon(Icons.calendar_view_day, color: Colors.black87),
            title: Text("Kemarin"),
            onTap: () {
              Navigator.pushNamed(context, '/laporanKemarin');
            },
          ),
          ListTile(
            trailing: Icon(Icons.calendar_view_week, color: Colors.black87),
            title: Text("7 Hari"),
            onTap: () {
              Navigator.pushNamed(context, '/laporanMingguan');
            },
          ),
          ListTile(
            trailing:
                Icon(Icons.calendar_month_outlined, color: Colors.black87),
            title: Text("Bulan Ini"),
            onTap: () {
              Navigator.pushNamed(context, '/laporanBulanan');
            },
          ),
          ListTile(
            trailing:
                Icon(Icons.calendar_month_outlined, color: Colors.black87),
            title: Text("30 Hari"),
            onTap: () {
              Navigator.pushNamed(context, '/laporanTigaPuluhHari');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: Text("Laporan Periode",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
          ),
          Form(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
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
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
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
                      left: 20.0, right: 20.0, top: 15.0, bottom: 20.0),
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
                        'Login',
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
        ],
      ),
    );
  }
}
