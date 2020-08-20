import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:stard1_mask_api/model/store.dart';
import 'package:url_launcher/url_launcher.dart';

class TileItemStore extends StatelessWidget {
  final Store store;
  final Position position;

  TileItemStore(this.store, this.position);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(store.name),
      subtitle: Text(store.addr),
      leading: Text(distance()),
      trailing: buildRemainingComponent(store),
      onTap: onTap,
    );
  }

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

  void onTap() async {
    final url =
        'https://google.com/maps/search/?api=1&query=${store.lat},${store.lng}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String distance() => new Distance()
      .as(LengthUnit.Kilometer, new LatLng(position.latitude, position.longitude),
          new LatLng(store.lat, store.lng))
      .toString() + "km";
}
