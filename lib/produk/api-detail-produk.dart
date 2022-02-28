import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:lgp/sqlhelper.dart';

// void hapusBookmark(String id) async {
//   await APICacheManager().deleteCache(id);
//   var cacheData = await APICacheManager().getCacheData('bookmark');

//   var fromCache1 = '[' + cacheData.syncData + ']';
//   var fromCache2 = '''$fromCache1''';
//   var jsonData = json.decode(fromCache2);
//   jsonData.removeWhere((element) => element['id'] == id);
//   var jsonD = jsonData.toString().replaceAll(r'[', '').replaceAll(r']', '');
//   var a2 = '''$jsonD''';
//   final string2 = a2.replaceAll("\"", "");
//   final quotedString = string2.replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
//     return '"${match.group(0)}"';
//   });
//   final decoded = json.decode(quotedString);
//   print(decoded);
//   // var enc = jsonEncode(a2);
//   // Map<String, dynamic> result = jsonDecode("""$a2""");
//   // print(result);
//   // print('enc ' + enc);
//   // List<dynamic> ubahData = a2 as List;
//   // var newData = ubahData[0];
//   print('json baru : ' + a2);
//   // await APICacheManager().addCacheData(APICacheDBModel(
//   //   syncData: a2,
//   //   key: "bookmark",
//   // ));
// }

// void buatBookmark(String newData) async {
//   // await APICacheManager().emptyCache();

//   var data = newData;
//   var adaCache = await APICacheManager().isAPICacheKeyExist('bookmark');
//   if (adaCache) {
//     // print('ada cache');
//     var getData = await APICacheManager().getCacheData('bookmark');
//     var preData = getData.syncData;
//     print(preData);
//     var addData = preData + "," + data;
//     await APICacheManager().addCacheData(APICacheDBModel(
//       syncData: addData,
//       key: "bookmark",
//     ));
//   } else {
//     // print('tidak ada');
//     var addData = await APICacheManager().addCacheData(APICacheDBModel(
//       syncData: data,
//       key: "bookmark",
//     ));
//   }

//   // var getCache = await APICacheManager().getCacheData('bookmark');
//   // var dataCache = getCache.syncData;
//   // print(dataCache);
// }

// Insert a new journal to the database
Future<void> addItem(String judul, String cache, String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    APICacheDBModel cacheDBModel =
        APICacheDBModel(key: cache, syncData: response.body);
    await APICacheManager().addCacheData(cacheDBModel);
    await SQLHelper.createItem(judul, cache);
  }
  print('sukses');
}

Future<List<ApiDetailProduk>> fetchDetailProduk(jenis, id, judul) async {
  EasyLoading.show(status: "Tunggu Sebentar...");
  String url =
      'https://sim.saktiputra.com/api/produk/detail/' + id + '/' + jenis;
  try {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.wifi) {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      EasyLoading.dismiss();

      // String cacheId = 'produk' + jenis + id;
      // await APICacheManager().emptyCache();
      // addItem(judul, cacheId, url);
      var parsed = json.decode(response.body);
      // print(parsed);
      List jsonResponse = parsed as List;
      print(jsonResponse);
      print('wifi');
      return jsonResponse
          .map((data) => ApiDetailProduk.fromJson(data))
          .toList();
    } else {
      EasyLoading.dismiss();

      return List.empty();
      // throw Exception('Gagal Mengambil Data Baru');
    }
    // }
    // else if (connectivityResult == ConnectivityResult.mobile) {
    //   // print(idJenis + produk);

    //   final response = await http.get(Uri.parse(url));
    //   if (response.statusCode == 200) {
    //     EasyLoading.dismiss();
    //     // APICacheDBModel cacheDBModel = APICacheDBModel(
    //     //     key: 'produk' + jenis + id, syncData: response.body);
    //     // await APICacheManager().addCacheData(cacheDBModel);

    //     var parsed = json.decode(response.body);
    //     // print(parsed);
    //     List jsonResponse = parsed as List;
    //     print('mobile');
    //     return jsonResponse
    //         .map((data) => ApiDetailProduk.fromJson(data))
    //         .toList();
    //   } else {
    //     EasyLoading.dismiss();

    //     return List.empty();
    //     // throw Exception('Gagal Mengambil Data Baru');
    //   }
    // } else {
    //   var adaCache =
    //       await APICacheManager().isAPICacheKeyExist('produk' + jenis + id);
    //   if (adaCache) {
    //     EasyLoading.dismiss();
    //     var cacheData =
    //         await APICacheManager().getCacheData('produk' + jenis + id);
    //     print('cache : ' + cacheData.syncData);
    //     var parsed =
    //         jsonDecode(cacheData.syncData); //lalu kita decode hasil datanya
    //     List jsonResponse = parsed as List;
    //     print('cache');
    //     return jsonResponse
    //         .map((data) => ApiDetailProduk.fromJson(data))
    //         .toList();
    //   } else {
    //     EasyLoading.dismiss();
    //     // return List.empty();
    //     throw Exception('Gagal Mengambil Data');
    //   }
    // }
  } catch (e) {
    rethrow;
  }
}

class ApiDetailProduk {
  String? id;
  String? nama;
  String? cabang;
  List<Stok>? stok;
  String? stokPcs;
  List<Satuan>? satuan;
  List<Modal>? modal;
  String? hargaModal;
  Gambar? gambar;
  List<RiwayatModal>? riwayatModal;
  String? tanggalUpdate;

  ApiDetailProduk(
      {this.id,
      this.nama,
      this.cabang,
      this.stok,
      this.stokPcs,
      this.satuan,
      this.modal,
      this.hargaModal,
      this.gambar,
      this.riwayatModal,
      this.tanggalUpdate});

  ApiDetailProduk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    cabang = json['cabang'];
    if (json['stok'] != null) {
      stok = <Stok>[];
      json['stok'].forEach((v) {
        stok!.add(Stok.fromJson(v));
      });
    }
    stokPcs = json['stok_pcs'];
    if (json['satuan'] != null) {
      satuan = <Satuan>[];
      json['satuan'].forEach((v) {
        satuan!.add(Satuan.fromJson(v));
      });
    }
    if (json['modal'] != null) {
      modal = <Modal>[];
      json['modal'].forEach((v) {
        modal!.add(Modal.fromJson(v));
      });
    }
    hargaModal = json['harga_modal'];
    gambar = json['gambar'] != null ? Gambar.fromJson(json['gambar']) : null;
    if (json['riwayat_modal'] != null) {
      riwayatModal = <RiwayatModal>[];
      json['riwayat_modal'].forEach((v) {
        riwayatModal!.add(RiwayatModal.fromJson(v));
      });
    }
    tanggalUpdate = json['tanggal_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['cabang'] = cabang;
    if (stok != null) {
      data['stok'] = stok!.map((v) => v.toJson()).toList();
    }
    data['stok_pcs'] = stokPcs;
    if (satuan != null) {
      data['satuan'] = satuan!.map((v) => v.toJson()).toList();
    }
    if (modal != null) {
      data['modal'] = modal!.map((v) => v.toJson()).toList();
    }
    data['harga_modal'] = hargaModal;
    if (gambar != null) {
      data['gambar'] = gambar!.toJson();
    }
    if (riwayatModal != null) {
      data['riwayat_modal'] = riwayatModal!.map((v) => v.toJson()).toList();
    }
    data['tanggal_update'] = tanggalUpdate;
    return data;
  }
}

class Stok {
  int? stok;
  String? satuan;

  Stok({this.stok, this.satuan});

  Stok.fromJson(Map<String, dynamic> json) {
    stok = json['stok'];
    satuan = json['satuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stok'] = stok;
    data['satuan'] = satuan;
    return data;
  }
}

class Satuan {
  int? id;
  String? konversi;
  String? satuan;

  Satuan({this.id, this.konversi, this.satuan});

  Satuan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    konversi = json['konversi'];
    satuan = json['satuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['konversi'] = konversi;
    data['satuan'] = satuan;
    return data;
  }
}

class Modal {
  int? id;
  String? konversi;
  String? satuan;

  Modal({this.id, this.konversi, this.satuan});

  Modal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    konversi = json['konversi'];
    satuan = json['satuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['konversi'] = konversi;
    data['satuan'] = satuan;
    return data;
  }
}

class Gambar {
  String? def;
  List<Li>? li;

  Gambar({this.def, this.li});

  Gambar.fromJson(Map<String, dynamic> json) {
    def = json['default'];
    if (json['list'] != null) {
      li = <Li>[];
      json['list'].forEach((v) {
        li!.add(Li.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['default'] = def;
    if (li != null) {
      data['list'] = li!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Li {
  String? gambar;
  String? id;

  Li({this.gambar, this.id});

  Li.fromJson(Map<String, dynamic> json) {
    gambar = json['gambar'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gambar'] = gambar;
    data['id'] = id;
    return data;
  }
}

class RiwayatModal {
  String? id;
  String? modalLama;
  String? modalBaru;
  String? update;

  RiwayatModal({this.id, this.modalLama, this.modalBaru, this.update});

  RiwayatModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modalLama = json['modal_lama'];
    modalBaru = json['modal_baru'];
    update = json['update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modal_lama'] = modalLama;
    data['modal_baru'] = modalBaru;
    data['update'] = update;
    return data;
  }
}
