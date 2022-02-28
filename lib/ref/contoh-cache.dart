import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_db_helper.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> fetchapiCach() async {
  // await APICacheDBHelper.deleteAll(APICacheDBModel.table);

  var lists = new List<int>.generate(10, (i) => i + 1);
  lists.forEach((element) async {
    var cacheData2 = await APICacheManager().addCacheData(new APICacheDBModel(
      syncData: '{"name":"lava$element"}',
      key: "$element",
    ));
  });

  List<Map<String, dynamic>> list =
      await APICacheDBHelper.query(APICacheDBModel.table);
  // await APICacheDBHelper.rawQuery("select * from ${APICacheDBModel.table}");
  // print(list);
  list.forEach((element) {
    print(element);
  });
  return list;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatelessWidget(),
        ),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchapiCach(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    height: 10, width: 10, child: CircularProgressIndicator()));
          } else {
            print(snapshot.data);
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          "${snapshot.data![index]["key"]}",
                          style: TextStyle(fontSize: 25),
                        ),
                        Expanded(
                            child: Align(
                          alignment: Alignment.topRight,
                          child: Text("${snapshot.data![index]["syncData"]}"),
                        )),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Align(
                              alignment: Alignment.topRight,
                              child:
                                  Text("${snapshot.data![index]["syncTime"]}")),
                        )
                      ],
                    ),
                    leading: CircleAvatar(),
                  );
                });
          }
          ;
        });
  }
}
