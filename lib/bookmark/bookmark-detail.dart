import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lgp/bookmark/api-bookmark-produk.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookmarkDetail extends StatefulWidget {
  final String id;
  const BookmarkDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _BookmarkDetailState createState() => _BookmarkDetailState();
}

class _BookmarkDetailState extends State<BookmarkDetail>
    with SingleTickerProviderStateMixin {
  late Future<List<ApiBookmarkDetail>> _detail;

  late TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    const Tab(
      text: 'Detail',
    ),
    const Tab(
      text: 'Riwayat',
    ),
  ];

  final controller = ScrollController();
  double offset = 0;

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
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
    setState(() {});

    _detail = fetchBookmarkProduk(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 13, 9, 243),
                Color.fromARGB(255, 11, 55, 90)
              ])),
        ),
        title: Text("Detail Produk", style: GoogleFonts.oswald()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<ApiBookmarkDetail>>(
              future: _detail,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  List<ApiBookmarkDetail>? data = snapshot.data;

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
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        (data.first.gambar!.li!.isNotEmpty)
                                            ? CarouselSlider(
                                                options: CarouselOptions(
                                                    autoPlay: true),
                                                items: data.first.gambar!.li!
                                                    .map((item) => Container(
                                                          color: Color.fromARGB(
                                                              255,
                                                              229,
                                                              236,
                                                              248),
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              CachedNetworkImage(
                                                            repeat: ImageRepeat
                                                                .noRepeat,
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            imageUrl: item
                                                                .gambar
                                                                .toString(),
                                                          ),
                                                        ))
                                                    .toList(),
                                              )
                                            : Container(
                                                color: Color.fromARGB(
                                                    255, 229, 236, 248),
                                                alignment: Alignment.center,
                                                child: CachedNetworkImage(
                                                  repeat: ImageRepeat.noRepeat,
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  imageUrl: data
                                                      .first.gambar!.def
                                                      .toString(),
                                                ),
                                              ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              5, 5, 5, 0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  data.first.cabang.toString(),
                                                  style: GoogleFonts.oswald(
                                                      fontSize: 14))),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 5),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                data.first.nama.toString(),
                                                style: GoogleFonts.oswald(
                                                    fontSize: 20),
                                              )),
                                        ),
                                        Container(
                                          color:
                                              Color.fromARGB(255, 62, 82, 199),
                                          child: TabBar(
                                            onTap: (index) {
                                              // Should not used it as it only called when tab options are clicked,
                                              // not when user swapped
                                            },
                                            controller: _controller,
                                            tabs: list,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: TabBarView(
                                              controller: _controller,
                                              children: [
                                                listBookmarkDetail(
                                                    data, context),
                                                listRiwayatModal(data, context),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text('Tidak ada data'),
                        );
                } else if (snapshot.hasError) {
                  EasyLoading.dismiss();
                  // print(snapshot.error);
                  return const AlertDialog(
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
                    children: const <Widget>[
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
    );
  }

  Column listBookmarkDetail(
      List<ApiBookmarkDetail> data, BuildContext context) {
    return Column(
      children: data
          .map((produk) => Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Stock',
                                  style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Satuan',
                                  style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Perhitungan',
                                  style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Modal',
                                  style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Column(
                          children: produk.stok!
                              .map((e) => Align(
                                    alignment: Alignment.center,
                                    child: Text(e.stok.toString()),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: produk.modal!
                              .map((e) => Align(
                                    alignment: Alignment.center,
                                    child: Text(e.satuan.toString()),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: produk.satuan!
                              .map((e) => Align(
                                    alignment: Alignment.center,
                                    child: Text(e.konversi.toString()),
                                  ))
                              .toList(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: produk.modal!
                              .map((e) => Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('Rp. ' + e.konversi.toString()),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ))
          .toList(),
    );
  }

  Column listRiwayatModal(List<ApiBookmarkDetail> data, BuildContext context) {
    return Column(
      children: data
          .map((produk) => Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text('Tanggal',
                                    style: GoogleFonts.oswald(
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text('Modal Lama',
                                    style: GoogleFonts.oswald(
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Modal Baru',
                                  style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        controller: controller,
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.first.riwayatModal!.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<RiwayatModal>? riwayat =
                                  data.first.riwayatModal;
                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(riwayat![index]
                                                  .update
                                                  .toString()),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text('Rp. ' +
                                                  riwayat[index]
                                                      .modalLama
                                                      .toString()),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text('Rp. ' +
                                                  riwayat[index]
                                                      .modalBaru
                                                      .toString()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ))
          .toList(),
    );
  }
}
