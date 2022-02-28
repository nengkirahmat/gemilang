import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class ApiDataProduk {
  String? id;
  String? nama;
  String? hargaModal;
  List<Stok>? stok;
  List<Satuan>? satuan;
  List<Modal>? modal;
  // String? gambar;
  // String? tanggalUpdate;

  ApiDataProduk({
    this.id,
    this.nama,
    this.stok,
    this.satuan,
    this.hargaModal,
    this.modal,
    // this.gambar,
    // this.tanggalUpdate
  });

  ApiDataProduk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    hargaModal = json['harga_modal'];
    if (json['stok'] != null) {
      stok = <Stok>[];
      json['stok'].forEach((v) {
        stok!.add(Stok.fromJson(v));
      });
    }
    if (json['satuan'] != null) {
      satuan = <Satuan>[];
      json['satuan'].forEach((v) {
        satuan!.add(Satuan.fromJson(v));
      });
    }
    if (json['modal'] != null) {
      modal = <Modal>[];
      for (var v in (json['modal'] as List)) {
        modal!.add(Modal.fromJson(v));
      }
    }
    // gambar = json['gambar'];
    // tanggalUpdate = json['tanggal_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['harga_modal'] = hargaModal;
    if (stok != null) {
      data['stok'] = stok!.map((v) => v.toJson()).toList();
    }
    if (satuan != null) {
      data['satuan'] = satuan!.map((v) => v.toJson()).toList();
    }
    if (modal != null) {
      data['modal'] = modal!.map((v) => v.toJson()).toList();
    }
    // data['gambar'] = this.gambar;
    // data['tanggal_update'] = this.tanggalUpdate;
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

  map(Row Function(dynamic e) param0) {}
}

class Satuan {
  String? konversi;
  String? satuan;

  Satuan({this.konversi, this.satuan});

  Satuan.fromJson(Map<String, dynamic> json) {
    konversi = json['konversi'];
    satuan = json['satuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['konversi'] = konversi;
    data['satuan'] = satuan;
    return data;
  }
}

class Modal {
  String? konversi;
  String? satuan;

  Modal({this.konversi, this.satuan});

  Modal.fromJson(Map<String, dynamic> json) {
    konversi = json['konversi'];
    satuan = json['satuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['konversi'] = konversi;
    data['satuan'] = satuan;
    return data;
  }
}

Future<List<ApiDataProduk>> fetchDataProduk(idJenis, produk) async {
  EasyLoading.show(status: "Tunggu Sebentar...");
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    Map body = {};
    // print(idJenis + produk);
    if (produk != '') {
      body = {'cabang': idJenis, 'produk': produk};
      final response = await http.post(
          Uri.parse('https://sim.saktiputra.com/api/produk/get'),
          body: body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: idJenis + produk, syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        var parsed = json.decode(response.body);
        // print(parsed);
        List jsonResponse = parsed as List;
        // print('wifi');
        return jsonResponse
            .map((data) => ApiDataProduk.fromJson(data))
            .toList();
      } else {
        EasyLoading.dismiss();

        return List.empty();
        // throw Exception('Gagal Mengambil Data Baru');
      }
    } else {
      EasyLoading.dismiss();
      return List.empty();
    }
  } else if (connectivityResult == ConnectivityResult.mobile) {
    Map body = {};
    // print(idJenis + produk);
    if (produk != '') {
      body = {'cabang': idJenis, 'produk': produk};
      final response = await http.post(
          Uri.parse('https://sim.saktiputra.com/api/produk/get'),
          body: body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: idJenis + produk, syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        var parsed = json.decode(response.body);
        // print(parsed);
        List jsonResponse = parsed as List;
        // print('mobile');
        return jsonResponse
            .map((data) => ApiDataProduk.fromJson(data))
            .toList();
      } else {
        EasyLoading.dismiss();

        return List.empty();
        // throw Exception('Gagal Mengambil Data Baru');
      }
    } else {
      EasyLoading.dismiss();
      return List.empty();
    }
  } else {
    var adaCache = await APICacheManager().isAPICacheKeyExist(idJenis + produk);
    if (adaCache) {
      EasyLoading.dismiss();
      var cacheData = await APICacheManager().getCacheData(idJenis + produk);
      var parsed =
          jsonDecode(cacheData.syncData); //lalu kita decode hasil datanya
      List jsonResponse = parsed as List;
      // print('cache');
      return jsonResponse.map((data) => ApiDataProduk.fromJson(data)).toList();
    } else {
      EasyLoading.dismiss();
      return List.empty();
      // throw Exception('Gagal Mengambil Data');
    }
  }
}
