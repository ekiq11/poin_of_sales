import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/api.dart';

class PoinOfSale extends StatefulWidget {
  const PoinOfSale({Key? key}) : super(key: key);

  @override
  State<PoinOfSale> createState() => _PoinOfSaleState();
}

class _PoinOfSaleState extends State<PoinOfSale> {
  Future<List<dynamic>> _fetchDataBarang() async {
    var result = await http.get(Uri.parse(BaseURL.pos));
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Roti Dua Lima'),
            ],
          ),
        ),
        //shadow
        elevation: 0,
        //back button
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchDataBarang(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data[index]['nama_barang']),
                    subtitle: Text(snapshot.data[index]['harga_pokok']),
                    // leading: CircleAvatar(
                    //   backgroundImage:
                    //       NetworkImage(snapshot.data[index]['gambar']),
                    // ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
