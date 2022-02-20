import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/http/core/hi_error.dart';
import 'package:untitled/http/core/hi_net.dart';
import 'package:untitled/http/core/mock_adpter.dart';
import 'package:untitled/model/owner.dart';
import 'package:untitled/model/result.dart';
import 'package:untitled/test_request.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    test();
    test1();
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() async {
    TestRequest request = TestRequest();
    request.add("aa", "ddd").add("requestPrams", "333");

    try {
      var result = await HiNet.getInstance().fire(request);

      print(result);
    } on NeedAuth catch (e) {
      print(e);
    } on NeedLogin catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void test() {
    const jsonString = "{\"name\": \"flutter\"}";

    // json转map
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    print(jsonMap);
    print(jsonMap['name']);

    // map转json
    print(jsonEncode(jsonMap));
  }

  void test1() {
    var ownerMap = {
      "name": "翼龙11",
      "face": "www.baidu.com",
      "fans": 0,
    };

    Owner owner = Owner.fromJson(ownerMap);
    print('name: ${owner.name}');
    print('face: ${owner.face}');
    print('fans: ${owner.fans}');

    print(owner.toJson());

    // Result result = Result.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '我的22111',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
