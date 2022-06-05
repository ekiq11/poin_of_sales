import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/drawer.dart';
import '../../../api/api.dart';
import '../../../model/currency_format.dart';
import '../../../model/detail/model_detail_lap_kemarin.dart';

class DetLapKemarin extends StatefulWidget {
  const DetLapKemarin({Key? key}) : super(key: key);

  @override
  State<DetLapKemarin> createState() => _DetLapKemarinState();
}

class _DetLapKemarinState extends State<DetLapKemarin> {
  Future<List<LapDataKemarin>> _fetchDetailLaporanKemarin() async {
    final result = await http.get(Uri.parse(BaseURL.lapDataKemarin));
    print(result);
    var list = json.decode(result.body)['data'].cast<Map<String, dynamic>>();
    return await list
        .map<LapDataKemarin>((json) => LapDataKemarin.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //buat Appbar
      appBar: AppBar(
        title: Text("Detail Laporan Kemarin"),
        elevation: 0,
      ),
      //buatkan drawer
      drawer: DrawerFlutter(),
      //buat body

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Detail Laporan Kemarin",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  "Berikut adalah laporan kemarin",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<LapDataKemarin>>(
            future: _fetchDetailLaporanKemarin(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
                  child: snapshot.data == null
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    "Nama ",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Jenis ",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Qty ",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Total (Rp)",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                              rows: snapshot.data.map<DataRow>(
                                (e) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            "${e.barang}",
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "${e.jenis}",
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 170,
                                          child: Text(
                                            "${e.banyak}",
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 180,
                                          child: Text(
                                            " ${CurrencyFormat.convertToIdr(int.parse(e.total), 2)}",
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Total : ${CurrencyFormat.convertToIdr(snapshot.data.map((e) => int.parse(e.total)).reduce((a, b) => a + b), 2)}",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Image(
                          image: AssetImage("asset/icon/no_data.png"),
                          width: 100,
                        ),
                      ),
                    ),
                    Text("Tidak Ada Transaksi",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
