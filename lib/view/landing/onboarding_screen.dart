import 'package:flutter/material.dart';
import 'package:poin_of_sales/view/landing/botton_buttons.dart';
import 'package:poin_of_sales/view/landing/explanation.dart';

final List<ExplanationData> data = [
  ExplanationData(
      description:
          "Memudahkan mengatur dan mengelola toko yang anda miliki. Memudahkan mengatur dan mengelola toko yang anda miliki.",
      title: "Poin Of Sale",
      subtitle: "Roti Dua Lima",
      localImageSrc: "asset/image/splash_1.png"),
  ExplanationData(
      description:
          "Memudahkan mengatur dan mengelola toko yang anda miliki. Memudahkan mengatur dan mengelola toko yang anda miliki.",
      title: "Poin Of Sale",
      subtitle: "Roti Dua Lima",
      localImageSrc: "asset/image/splash_2.png"),
  ExplanationData(
      description:
          "Memudahkan mengatur dan mengelola toko yang anda miliki. Memudahkan mengatur dan mengelola toko yang anda miliki.",
      title: "Poin Of Sale",
      subtitle: "Roti Dua Lima",
      localImageSrc: "asset/image/splash_3.png"),
];

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> /*with ChangeNotifier*/ {
  final _controller = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: mediaQueryHeight,
        width: mediaQueryWidth,
        color: Colors.white,
        child: Container(
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          color: data[_currentIndex].backgroundColor,
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: mediaQueryHeight,
                        width: mediaQueryWidth,
                        alignment: Alignment.center,
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          controller: _controller,
                          onPageChanged: (value) {
                            // _painter.changeIndex(value);
                            setState(() {
                              _currentIndex = value;
                            });
                            // notifyListeners();
                          },
                          children: data
                              .map((e) => ExplanationPage(data: e))
                              .toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(data.length,
                                (index) => createCircle(index: index)),
                          ),
                          BottomButtons(
                            currentIndex: _currentIndex,
                            dataLength: data.length,
                            controller: _controller,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  createCircle({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.only(right: 4),
      height: 5,
      width: _currentIndex == index ? 15 : 5,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
