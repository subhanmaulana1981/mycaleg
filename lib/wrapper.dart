import 'package:flutter/material.dart';
import 'package:mycaleg/models/kecamatan.dart';
import 'package:mycaleg/models/kelurahan.dart';
import 'package:mycaleg/models/pengguna.dart';
import 'package:mycaleg/models/timses.dart';
import 'package:mycaleg/otentikasi/otentikasi.dart';
import 'package:mycaleg/screens/homepage.dart';
import 'package:mycaleg/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("dari wrapper otentikasi");

    // return either welcome or otentikasi
    final pengguna = Provider.of<Pengguna>(context);
    String uid = pengguna.uid.toString();
    if (pengguna.uid == "" || pengguna.uid == "Pengguna belum sign-in") {
      // print("otentikasi terlebih dulu");
      return const Otentikasi();
    } else {
      return MultiProvider(
        providers: [

          // provide data timses
          StreamProvider<Iterable<TimSes>>.value(
            value: DatabaseService().timseses,
            initialData: const [],
            catchError: (BuildContext context, Object? exception) {
              return <TimSes>[TimSes(namaKetuaTimses: "Timses tidak ditemukan!")];
            },
          ),

          // provide data kecamatan
          StreamProvider<Iterable<Kecamatan>>.value(
            value: DatabaseService().kecamatanGraph,
            initialData: const [],
            catchError: (BuildContext context, Object? exception) {
              return <Kecamatan>[
                Kecamatan(
                  dapil: "Dapil tidak ditemukan",
                  namakecamatan: "Kecamatan tidak ditemukan",
                  jumlahAnggota: 0
                )
              ];
            },
          ),

          // provide data kelurahan
          StreamProvider<Iterable<Kelurahan>>.value(
            value: DatabaseService().kelurahanGraph,
            initialData: const [],
            catchError: (BuildContext context, Object? exception) {
              return <Kelurahan>[
                Kelurahan(
                    namakecamatan: "Kecamatan tidak ditemukan!",
                    namakelurahan: "Kelurahan tidak ditemukan!",
                    jumlahAnggota: 0
                )
              ];
            },
          ),

        ],
        child: MyHomePage(uid: uid),
      );
    }
  }
}
