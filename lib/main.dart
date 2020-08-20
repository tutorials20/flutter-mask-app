import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stard1_mask_api/model/store.dart';
import 'package:stard1_mask_api/viewmodel/store_view_model.dart';

void main() {
  runApp(ChangeNotifierProvider.value(
    value: StoreViewModel(),
    child: MyApp(),
  ));
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    viewModel() => Provider.of<StoreViewModel>(context);

    stores() => viewModel().stores;

    bool filterExists(store) {
      switch (store.remainStat) {
        case 'plenty':
        case 'some':
        case 'few':
          return true;
      }
      return false;
    }

    List<Store> filteredStores() => stores().where(filterExists).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('공적마스크 ${filteredStores().length} 곳'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: viewModel().fetch,
            )
          ],
        ),
        body: stores().length < 1
            ? buildLoading()
            : buildContent(filteredStores()));
  }

  buildLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('LOADING'), CircularProgressIndicator()],
        ),
      );

  buildContent(List<Store> stores) => ListView(
        children: stores
            .map((e) => ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
                  trailing: buildRemainingComponent(e),
                ))
            .toList(),
      );

  buildRemainingComponent(Store store) {
    var title = '판매중지';
    var description = '';
    var color = Colors.grey;
    switch (store.remainStat) {
      case 'plenty':
        title = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        title = '보통';
        description = '30-100';
        color = Colors.yellow;
        break;
      case 'few':
        title = '부족';
        description = '2-30';
        color = Colors.red;
        break;
      case 'empty':
        title = '바닥';
        description = '1개 이하';
        color = Colors.grey;
        break;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(color: color, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
