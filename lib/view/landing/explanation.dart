import 'package:flutter/material.dart';

class ExplanationData {
  final String? subtitle;
  final String? title;
  final String? description;
  final String? localImageSrc;
  final Color? backgroundColor;

  ExplanationData(
      {this.title,
      this.description,
      this.localImageSrc,
      this.backgroundColor,
      this.subtitle});
}

class ExplanationPage extends StatelessWidget {
  final ExplanationData? data;

  // ignore: use_key_in_widget_constructors
  const ExplanationPage({this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 300,
            margin: const EdgeInsets.only(top: 40.0),
            child: Image.asset(data!.localImageSrc.toString(),
                height: MediaQuery.of(context).size.height * 0.30,
                alignment: Alignment.center)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data!.title.toString(),
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data!.subtitle.toString(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    data!.description.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
