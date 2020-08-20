import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stard1_mask_api/model/store.dart';
import 'package:stard1_mask_api/viewmodel/store_view_model.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    viewModel() => Provider.of<StoreViewModel>(context);

    filteredStores() => viewModel().filteredStores();

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
        body: viewModel().isLoading()
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
