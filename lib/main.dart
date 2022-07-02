import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:poin_of_sales/view/landing/onboarding_screen.dart';
import 'package:poin_of_sales/view/login/login.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

int? isviewed;
void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  @override
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    initialization();
    super.initState();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.amber,
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 12.sp,
                color: Colors.amber,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600),
            headline2: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
                fontFamily: 'Raleway'),
            bodyText1: TextStyle(
                fontSize: 10.sp,
                color: Colors.black87,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700),
            bodyText2: TextStyle(
                fontSize: 10.sp,
                height: 1.3,
                color: Colors.black87,
                fontWeight: FontWeight.w300),
            button: TextStyle(
                fontSize: 10.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w700),
          ),
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: isviewed == 0 ? LoginPage() : Screen(),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        // routes: {
        //   // When navigating to the "/second" route, build the SecondScreen widget.
        // '/pos': (context) => const PoinOfSale(),
        //   // '/logout': (context) => LoginPage(),
        //   // '/laporanHarian': (context) => LaporanHarian(),
        //   // '/laporanKemarin': (context) => LaporanKemarin(),
        //   // '/laporanMingguan': (context) => LaporanMingguan(),
        //   // '/laporanBulanan': (context) => LaporanBulanan(),
        //   // '/laporanTigaPuluhHari': (context) => LaporanTigaPuluhHari(),
        // },
      );
    });
  }
}
