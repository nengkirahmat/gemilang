import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<List<ApiBookmarkDetail>> fetchBookmarkProduk(id) async {
  EasyLoading.show(status: "Tunggu Sebentar...");
  print(id);
  try {
    var adaCache = await APICacheManager().isAPICacheKeyExist(id);
    if (adaCache) {
      EasyLoading.dismiss();
      var cacheData = await APICacheManager().getCacheData(id);
      print('cache : ' + cacheData.syncData);
      var parsed =
          jsonDecode(cacheData.syncData); //lalu kita decode hasil datanya
      List jsonResponse = parsed as List;
      return jsonResponse
          .map((data) => ApiBookmarkDetail.fromJson(data))
          .toList();
    } else {
      print('tidak ada cache');
      EasyLoading.dismiss();
      // return List.empty();
      throw Exception('Bookmark tidak ditemukan');
    }
  } catch (e) {
    rethrow;
  }
}

class ApiBookmarkDetail {
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

  ApiBookmarkDetail(
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

  ApiBookmarkDetail.fromJson(Map<String, dynamic> json) {
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
