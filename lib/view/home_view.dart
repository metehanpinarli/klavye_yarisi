import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var step = 0;
  var typedCharLength = 0;
  var lastTypeAt;
  var userName;
  var url = Uri.parse('https://klavyeyarisiapi.herokuapp.com/users/score');
  final userNameController = TextEditingController();
  var lorem =
      "                                       Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis auctor nec arcu et interdum. Donec sit amet nibh neque. Aenean lacinia nulla a ornare dictum. Nunc euismod dignissim lacus vitae efficitur. Morbi in leo est. Proin vehicula ante eget tortor imperdiet ultricies. Sed non sem finibus, facilisis diam vitae, tincidunt est. Etiam blandit sed justo eu pretium. Nam mollis lorem tortor."
          .toLowerCase()
          .replaceAll(",", '')
          .replaceAll('.', '');

  void onStartClick() async {
    userName = userNameController.text;
    print(userName);
    setState(() {
      updateLastTypedAt();
      step++;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        if (step == 1 && now - lastTypeAt > 3000) {
          step++;
          http.post(url, body: {'userName': userName.toString(), 'score': typedCharLength.toString()});
        }
      });
    });
  }

  updateLastTypedAt() {
    this.lastTypeAt = DateTime.now().millisecondsSinceEpoch;
  }

  aa(String a) {
    setState(() {});
  }

  onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
        http.post(url, body: {'userName': userName.toString(), 'score': typedCharLength.toString()});
      } else {
        typedCharLength = value.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Klavye Yar??????"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: showWidget(),
          ),
        ));
  }

  List<Widget> showWidget() {
    if (step == 0)
      return [
        Text("Ho??geldin Ad??n Nedir?"),
        TextField(
          onChanged: aa,
          controller: userNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Ad??n",
          ),
        ),
        ElevatedButton(onPressed: userNameController.text.length < 2 ? null : onStartClick, child: Text("ba??la"))
      ];
    else if (step == 1) {
      return [
        Text(typedCharLength.toString()),
        Container(
          height: 50,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            crossAxisAlignment: CrossAxisAlignment.center,
            decelerationCurve: Curves.easeInOut,
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(seconds: 15),
            accelerationDuration: Duration(milliseconds: 500),
            startPadding: 0,
            velocity: 75,
            blankSpace: 20,
            scrollAxis: Axis.horizontal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: onType,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Yazmaya Ba??la",
            ),
          ),
        )
      ];
    } else {
      return [
        Text("Kaybettin Puan??n : $typedCharLength"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              step = 0;
              typedCharLength = 0;
              updateLastTypedAt();
            });
          },
          child: Text("Tekrar Dene"),
        )
      ];
    }
  }
}
