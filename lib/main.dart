import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stard1_mask_api/model/store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var stores = List<Store>();

  Future fetch() async {
    setState(() {
      stores = List<Store>();
    });
    final url =
        "https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json";
    final response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

    var jsonStores = jsonDecode(utf8.decode(response.bodyBytes))["stores"];
    var dynamics = jsonStores.map((json) => Store.fromJson(json));

    setState(() {
      stores = dynamics.toList().cast<Store>();
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('공적마스크 ${stores.length} 곳'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: fetch,
            )
          ],
        ),
        body: stores.length < 1 ? buildLoading() : buildContent());
  }

  buildLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('LOADING'), CircularProgressIndicator()],
        ),
      );

  buildContent() => ListView(
        children: stores
            .map((e) => ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
                  trailing: Text(e.remainStat ?? '모름'),
                ))
            .toList(),
      );
}
