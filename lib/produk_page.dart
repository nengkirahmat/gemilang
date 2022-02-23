import 'dart:convert';

// import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lgp/api-data-produk.dart';
import 'package:lgp/format_rupiah.dart';
import 'package:lgp/main_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:api_cache_manager/api_cache_manager.dart';

class ProdukPage extends StatefulWidget {
  final String jenis;
  const ProdukPage({Key? key, required this.jenis}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  TextEditingController namaProduk = TextEditingController();

  final controller = ScrollController();
  double offset = 0;
  late Future<List<ApiDataProduk>> _func;

  String? _valCabangGudang;
  List _dataCabangGudang = [];

  // Future<Null> _getCabangGudang(jenis) async {
  //   EasyLoading.show(status: "Tunggu Sebentar...");
  //   var adaCache = await APICacheManager().isAPICacheKeyExist(jenis);
  //   if (!adaCache) {
  //     String _baseUrl = "https://sim.saktiputra.com/api/produk/" + jenis;
  //     final response = await http
  //         .get(Uri.parse(_baseUrl)); //untuk melakukan request ke webservice
  //     if (response.statusCode == 200) {
  //       APICacheDBModel cacheDBModel =
  //           APICacheDBModel(key: jenis, syncData: response.body);
  //       await APICacheManager().addCacheData(cacheDBModel);
  //       var listData =
  //           jsonDecode(response.body); //lalu kita decode hasil datanya
  //       setState(() {
  //         _dataCabangGudang =
  //             listData; // dan kita set kedalam variable _dataProvince
  //         EasyLoading.dismiss();
  //       });
  //       print('From URL');
  //     } else {
  //       EasyLoading.dismiss();
  //       throw Exception('Gagal Mengambil Data ' + response.body);
  //     }
  //   } else {
  //     if (adaCache) {
  //       var cacheData = await APICacheManager().getCacheData(jenis);
  //       var listData =
  //           jsonDecode(cacheData.syncData); //lalu kita decode hasil datanya
  //       setState(() {
  //         _dataCabangGudang =
  //             listData; // dan kita set kedalam variable _dataProvince
  //         EasyLoading.dismiss();
  //       });
  //     } else {
  //       EasyLoading.dismiss();
  //       throw Exception('Gagal Mengambil Data');
  //     }
  //     print('From Cache');
  //   }
  // }

  Future<Null> _getCabangGudang(jenis) async {
    EasyLoading.show(status: "Tunggu Sebentar...");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      String _baseUrl = "https://sim.saktiputra.com/api/produk/" + jenis;
      final response = await http
          .get(Uri.parse(_baseUrl)); //untuk melakukan request ke webservice
      if (response.statusCode == 200) {
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: jenis, syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        var listData =
            jsonDecode(response.body); //lalu kita decode hasil datanya
        setState(() {
          _dataCabangGudang =
              listData; // dan kita set kedalam variable _dataProvince
          EasyLoading.dismiss();
        });
        print('From URL');
      } else {
        EasyLoading.dismiss();
        throw Exception('Gagal Mengambil Data ' + response.body);
      }

      print('mobile');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      String _baseUrl = "https://sim.saktiputra.com/api/produk/" + jenis;
      final response = await http
          .get(Uri.parse(_baseUrl)); //untuk melakukan request ke webservice
      if (response.statusCode == 200) {
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: jenis, syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        var listData =
            jsonDecode(response.body); //lalu kita decode hasil datanya
        setState(() {
          _dataCabangGudang =
              listData; // dan kita set kedalam variable _dataProvince
          EasyLoading.dismiss();
        });
        print('From URL');
      } else {
        EasyLoading.dismiss();
        throw Exception('Gagal Mengambil Data ' + response.body);
      }
      print('wifi');
    } else {
      var adaCache = await APICacheManager().isAPICacheKeyExist(jenis);
      if (adaCache) {
        EasyLoading.dismiss();
        var cacheData = await APICacheManager().getCacheData(jenis);
        var listData =
            jsonDecode(cacheData.syncData); //lalu kita decode hasil datanya
        setState(() {
          _dataCabangGudang =
              listData; // dan kita set kedalam variable _dataProvince
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Gagal Mengambil Data');
      }
      print('no connect');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  void initState() {
    controller.addListener(onScroll);
    super.initState();
    _func = fetchDataProduk('', '');
    _getCabangGudang(widget.jenis);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Daftar Produk'),
        //   backgroundColor: Colors.green[400],
        // ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    hint: Text("PILIH " + widget.jenis.toUpperCase()),
                    icon: Visibility(
                        visible: false, child: Icon(Icons.arrow_downward)),
                    value: _valCabangGudang,
                    onChanged: (value) {
                      setState(() {
                        _valCabangGudang = value.toString();
                      });
                    },
                    items: _dataCabangGudang.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['nama']),
                        value: item['id'],
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: namaProduk,
                    decoration: InputDecoration(hintText: 'NAMA PRODUK')),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 47, 60, 240),
                  child: TextButton.icon(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        this._cariPorduk();
                      },
                      icon: Icon(Icons.search, color: Colors.white),
                      label: Text(
                        'Cari Produk',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<ApiDataProduk>>(
                  future: _func,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<ApiDataProduk>? data = snapshot.data;
                      int no = 1;
                      // print('data is ' + data.toString());
                      return (data!.isNotEmpty)
                          ? SingleChildScrollView(
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 10),
                                              color: Colors.black26,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              'Nama Produk'))),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Harga Modal'))),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: data
                                                  .map((produk) => Column(
                                                        children: <Widget>[
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 5),
                                                            color:
                                                                Colors.black12,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    child: Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(produk
                                                                            .nama
                                                                            .toString()))),
                                                                Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    child: Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        child: Text(CurrencyFormat.ganti(produk
                                                                            .hargaModal
                                                                            .toString())))),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      6,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          'Stock')),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          'Satuan')),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          'Perhitungan')),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          'Modal')),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color:
                                                                Colors.black26,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    6,
                                                                child: Column(
                                                                  children: produk
                                                                      .stok!
                                                                      .map((e) =>
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text(e.stok.toString()),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    5,
                                                                child: Column(
                                                                  children: produk
                                                                      .modal!
                                                                      .map((e) =>
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text(e.satuan.toString()),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    5,
                                                                child: Column(
                                                                  children: produk
                                                                      .satuan!
                                                                      .map((e) =>
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text(e.konversi.toString()),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            20,
                                                                            0),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3,
                                                                child: Column(
                                                                  children: produk
                                                                      .modal!
                                                                      .map((e) =>
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Text('Rp. ' + e.konversi.toString()),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )
                          : Center(
                              child: Text('Tidak ada data'),
                            );
                    } else if (snapshot.hasError) {
                      EasyLoading.dismiss();
                      // print(snapshot.error);
                      return AlertDialog(
                        title: Text(
                          'Terjadi Kesalahan...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        // content: Text(
                        //   "${snapshot.error}",
                        //   style: TextStyle(
                        //     color: Colors.blueAccent,
                        //   ),
                        // ),
                        // actions: <Widget>[
                        //   TextButton(
                        //     child: Text(
                        //       'Refresh',
                        //       style: TextStyle(
                        //         color: Colors.redAccent,
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.pop(context);
                        //       // Navigator.pushReplacement(
                        //       //     context,
                        //       //     MaterialPageRoute(
                        //       //       builder: (context) => MainPage(),
                        //       //     ));
                        //     },
                        //   )
                        // ],
                      );
                    }
                    // By default, show a loading spinner.
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Ini mungkin memakan waktu..')
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cariPorduk() {
    if (_valCabangGudang == '' || namaProduk.text.isEmpty) {
      Alert(
        context: context,
        title: "Pesan",
        content:
            Text("Silahkan Pilih " + widget.jenis + " dan isi Nama Produk"),
        type: AlertType.info,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      _func = fetchDataProduk(_valCabangGudang, namaProduk.text);
      setState(() {
        _func;
      });
    }
  }
}
