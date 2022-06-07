// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, unused_local_variable, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poin_of_sales/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;
  final String? sUrl = "https://rotiduadelima.id/api/v1/";

  _cekLogin() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var params =
        "login.php?username=${userNameController.text}&password=${passwordController.text}";
    // ignore: avoid_print
    prefs.setString('username', userNameController.text);
    // print(params);
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        var res = await http.get(Uri.parse(sUrl! + params));
        if (res.statusCode == 200) {
          var response = json.decode(res.body);
          // ignore: avoid_print
          print(response);
          if (response['error'] == false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    HalamanUtama(username: userNameController.text),
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
                  title: const Text("Login Gagal"),
                  content: const Text("Username atau Password Salah"),
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
            title: const Text("Login Gagal"),
            content: const Text("Username atau Password Tidak Boleh Kosong!"),
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Selamat Datang",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Roti Dua Lima",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                              child: Image.asset(
                                "asset/login/login.png",
                                height: 70.0,
                                width: 200.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //CircularProgressIndicator

                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.amber,
                            ),
                            strokeWidth: 5.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Username',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                                scrollPadding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).viewInsets.top),
                                controller: userNameController,
                                style: const TextStyle(fontSize: 18),
                                obscureText: false,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: passwordController,
                              style: const TextStyle(fontSize: 18),
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
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
                        onTap: _cekLogin,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
