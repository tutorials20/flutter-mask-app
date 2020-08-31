# stard1_mask_api

공적 마스크 API 연습

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### CREATE MODEL CLASS
- [API](https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json)
- [JSON TO DART](https://javiercbk.github.io/json_to_dart/)

### IMPORT HTTP LIBRARY
- [pub.dev](https://pub.dev/packages/http)
- 


# 2주차
## Store 목록 저장
```
    final jsonStores = jsonDecode(utf8.decode(response.bodyBytes))["stores"];
    final dynamics = jsonStores.map((json) => Store.fromJson(json));
    this.stores = dynamics.toList().cast<Store>();
```

## anynomous async function
```
    onPressed: () async {
        await fetch();
        print(stores.length);
    }
```

## ListView 에 표시
```
    final jsonStores = jsonDecode(utf8.decode(response.bodyBytes))["stores"];
    final dynamics = jsonStores.map((json) => Store.fromJson(json));

    // 목록 저장
    setState(() {
      this.stores = dynamics.toList().cast<Store>();
    });
    
    // ListView 처리
    body: ListView(
        children: stores.map((e) => Text(e.name)).toList(),
    ));

```

## ListTile 활용
```
    body: ListView(
//      children: stores.map((e) => Text(e.name)).toList(),
      children: stores
          .map((e) => ListTile(
                title: Text(e.name),
                subtitle: Text(e.addr),
                trailing: Text(e.remainStat ?? '모름'),
              ))
          .toList(),
    ));
```

## Refresh Icon
```
  actions: [
    IconButton(
      icon: Icon(Icons.refresh),
      onPressed: fetch,
    )
  ],
```

## Loading Progress
```

    setState(() {
      stores = List<Store>(); // 값이 비어 있으면 로딩 중으로 간주함
    });
    
   ...
   
   // stores 의 상태에 따라, 로딩 / 컨텐트 출력
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

```

## 남은 갯수 표기용 펑션
```
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
```

## 데이타 필터링
```
  List<Store> filteredStores() => stores.where(filterExists).toList();

  bool filterExists(store) {
    switch (store.remainStat) {
      case 'plenty':
      case 'some':
      case 'few':
        return true;
    }
    return false;
  }
```
