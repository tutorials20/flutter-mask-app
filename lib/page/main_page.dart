import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:stard1_mask_api/model/store.dart';
import 'package:stard1_mask_api/viewmodel/store_view_model.dart';
import 'package:stard1_mask_api/widget/tile_item_store.dart';

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
            : buildContent(filteredStores(), viewModel().position));
  }

  buildLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('LOADING'), CircularProgressIndicator()],
        ),
      );

  buildContent(List<Store> stores, Position position) => ListView(
        children:
            stores.map((store) => TileItemStore(store, position)).toList(),
      );
}
