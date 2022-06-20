// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/login/login.dart';
import 'package:poin_of_sales/view/pos/pos.dart';
import 'package:poin_of_sales/view/report/laporan_harian.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HalamanUtama extends StatefulWidget {
  final String? username;
  final String? idUser;
  const HalamanUtama({this.username, this.idUser});
  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
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
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Roti Dua Delima', style: TextStyle(fontSize: 12.sp)),
              Text('$username - ${widget.idUser}',
                  style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
        //shadow
        elevation: 0,
        //back button
      ),
      body: GridView.count(
        childAspectRatio: (3 / 4),
        crossAxisCount: 3,
        children: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PoinOfSale()),
                );
              },
              child: CustomCard(title: "P O S", image: "asset/icon/pos.png")),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanHarian(),
                ),
              );
              //print("username: ${widget.username!}");
            },
            child: CustomCard(
              title: "REPORT",
              image: "asset/icon/report.png",
            ),
          ),
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('username');
              prefs.remove('idUser');
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: CustomCard(
              title: "LOGOUT",
              image: "asset/icon/logout.png",
            ),
          ),
        ],
      ),
    );
  }
}

//membuat customcard yang bisa kita panggil setiap kali dibutuhkan
class CustomCard extends StatelessWidget {
  final String? title;
  final String? image;

  const CustomCard({this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              image.toString(),
              fit: BoxFit.fill,
            ),
            Text(
              title.toString(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
