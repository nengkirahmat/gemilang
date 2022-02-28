// import 'dart:async';
// import 'dart:convert';

// import 'package:api_cache_manager/api_cache_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lgp/api-detail-produk.dart';
// import 'package:lgp/bookmark-detail.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

// // Future<List<ApiBookmark>> fetchApiBookmark() async {
// //   var adaCache = await APICacheManager().isAPICacheKeyExist('bookmark');
// //   if (adaCache) {
// //     print('ada');
// //     var cacheData = await APICacheManager().getCacheData('bookmark');
// //     List<dynamic> fromCache = cacheData.syncData as List;
// //     List data = [];
// //     fromCache.forEach((element) {
// //       data = element['id'];
// //     });
// //     // List jsonResponse = fromCache as List;

// //     return data
// //         .map((e) => ApiBookmark(id: e.id, nama: e.nama, url: e.url))
// //         .toList();
// //   } else {
// //     print('tidak ada');
// //     throw Exception('Failed to load bookmark');
// //   }
// // }

// List<ApiBookmark> listApi = <ApiBookmark>[];
// Future<List<ApiBookmark>> fetchApiBookmark() async {
//   listApi.clear();
//   var adaCache = await APICacheManager().isAPICacheKeyExist('bookmark');
//   if (adaCache) {
//     // var fromCache = '''[{"id":"2911","nama":"Abcd1","url":"myUrl"},
//     //   {"id":"2910","nama":"Abcd2","url":"myUrl"},
//     //   {"id":"2911","nama":"Abcd3","url":"myUrl"},
//     //   {"id":"2549","nama":"Abcd4","url":"myUrl"}]''';
//     var cacheData = await APICacheManager().getCacheData('bookmark');
//     var fromCache1 = '[' + cacheData.syncData + ']';
//     var fromCache2 = '''$fromCache1''';
//     print(fromCache2);
//     final jsonData = json.decode(fromCache2);

//     for (var item in jsonData) {
//       listApi.add(ApiBookmark.fromJson(item));
//     }
//     for (var item in listApi) {
//       print("${item.id} ${item.nama} ${item.url}");
//     }
//     return listApi;
//   } else {
//     print('tidak ada');
//     throw Exception('Failed to load bookmark');
//   }
// }

// class ApiBookmark {
//   final String id;
//   final String nama;
//   final String url;

//   const ApiBookmark({
//     required this.id,
//     required this.nama,
//     required this.url,
//   });

//   factory ApiBookmark.fromJson(Map<String, dynamic> json) {
//     return ApiBookmark(
//       id: json['id'],
//       nama: json['nama'],
//       url: json['url'],
//     );
//   }
// }

// class Bookmark extends StatefulWidget {
//   const Bookmark({Key? key}) : super(key: key);

//   @override
//   _BookmarkState createState() => _BookmarkState();
// }

// class _BookmarkState extends State<Bookmark> {
//   late Future<List<ApiBookmark>> futureBookmark;

//   @override
//   void initState() {
//     super.initState();
//     futureBookmark = fetchApiBookmark();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bookmark'),
//       ),
//       body: Center(
//         child: FutureBuilder<List<ApiBookmark>>(
//           future: futureBookmark,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     int no = index + 1;
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   BookmarkDetail(id: snapshot.data![index].id),
//                             ));
//                       },
//                       child: Container(
//                         constraints: BoxConstraints(
//                           maxHeight: double.infinity,
//                         ),
//                         child: Card(
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     no.toString() +
//                                         ". " +
//                                         snapshot.data![index].nama.toString(),
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: TextButton.icon(
//                                       onPressed: () {
//                                         // _deleteItem(_journals[index]['id']);
//                                       },
//                                       icon: Icon(
//                                         Icons.delete,
//                                         color: Colors.red,
//                                       ),
//                                       label: Text('')),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   });
//             } else if (snapshot.hasError) {
//               return Text('${snapshot.error}');
//             }

//             // By default, show a loading spinner.
//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }
