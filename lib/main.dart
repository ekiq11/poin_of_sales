import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poin_of_sales/view/landing/onboarding_screen.dart';
import 'package:poin_of_sales/view/login/login.dart';
import 'package:poin_of_sales/view/pos/pos.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 28.0,
              color: Colors.amber,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600),
          headline2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
              fontFamily: 'Raleway'),
          bodyText1: TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700),
          bodyText2: TextStyle(
              fontSize: 16.0,
              height: 1.3,
              color: Colors.black87,
              fontWeight: FontWeight.w300),
          button: TextStyle(
              fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isviewed == 0 ? LoginPage() : Screen(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/pos': (context) => const PoinOfSale(),
        '/logout': (context) => LoginPage(),
      },
    );
  }
}
