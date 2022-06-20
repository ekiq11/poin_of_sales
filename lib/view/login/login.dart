// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, unused_local_variable, empty_catches
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poin_of_sales/api/api.dart';
import 'package:poin_of_sales/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ScrollController scrollController = ScrollController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;

  _cekLogin() async {
    setState(() {
      visible = true;
    });

    // print(params);
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        final res = await http.post(Uri.parse(BaseURL.login), body: {
          "username": userNameController.text,
          "password": passwordController.text,
        });
        if (res.statusCode == 200) {
          var response = json.decode(res.body);

          // ignore: avoid_print
          print(response['error']);
          if (response['error'] != true) {
            final tes = await http.post(Uri.parse(BaseURL.login), body: {
              "username": userNameController.text,
              "password": passwordController.text,
            });
            if (tes.statusCode == 200) {
              var responseData = json.decode(res.body)['data'];
              print(responseData[0]['id_user']);
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('username', userNameController.text);
              prefs.setString('idUser', responseData[0]['id_user']);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => HalamanUtama(
                      username: userNameController.text,
                      idUser: responseData[0]['id_user']),
                ),
              );
            }
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
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;
    final paddingTop = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: mediaQueryWidth / 2,
                  height: mediaQueryHeight,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "Selamat Datang",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Roti Dua Delima",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                child: Image.asset(
                                  "asset/login/login.png",
                                  height: mediaQueryHeight * 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //CircularProgressIndicator

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.amber,
                              ),
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: mediaQueryHeight * 0.12.sp,
                              child: TextField(
                                scrollPadding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).viewInsets.top),
                                controller: userNameController,
                                style: TextStyle(fontSize: 12.sp),
                                obscureText: false,
                                decoration: InputDecoration(
                                    hintText: 'Username',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                          style: BorderStyle.none,
                                          color: Colors.amber),
                                    ),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: mediaQueryHeight * 0.12.sp,
                              child: TextField(
                                controller: passwordController,
                                style: TextStyle(fontSize: 12.sp),
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mediaQueryHeight * 0.03.sp,
                        ),
                        InkWell(
                          child: Container(
                            width: mediaQueryWidth,
                            padding: EdgeInsets.symmetric(vertical: 13.sp),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
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
                            child: Text(
                              'L O G I N',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          onTap: _cekLogin,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
