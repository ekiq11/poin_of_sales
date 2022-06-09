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
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: FutureBuilder<List<dynamic>>(
              future: _fetchDataBarang(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title:
                                    Text(snapshot.data[index]['nama_barang']),
                                subtitle:
                                    Text(snapshot.data[index]['harga_pokok']),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "http://kbu-cdn.com/dk/wp-content/uploads/roti-goreng-madu.jpg"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: ElevatedButton(
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 15.0),
                                        child: Text("ADD"),
                                      ),
                                      Icon(Icons.add_shopping_cart_rounded),
                                    ],
                                  ),
                                  onPressed: () {}),
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
            child: Container(
              color: Color.fromARGB(255, 221, 221, 221),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(Icons.shopping_cart_checkout_rounded,
                              color: Colors.black87, size: 32.0),
                        ),
                        Text("Keranjang",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                      ],
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
