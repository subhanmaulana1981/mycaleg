import 'package:flutter/material.dart';
import 'package:mycaleg/models/kelurahan.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/anggota_list.dart';
import 'package:mycaleg/widgets/loading.dart';

class KelurahanList extends StatefulWidget {

  // properties
  final String namaKecamatan;

  // konstruktor
  const KelurahanList({
    Key? key,
    required this.namaKecamatan,
  })
      : super(key: key);

  @override
  State<KelurahanList> createState() => _KelurahanListState();
}

class _KelurahanListState extends State<KelurahanList> {
  @override
  Widget build(BuildContext context) {

    // untuk filtering by kecamatan
    String namaKecamatan = widget.namaKecamatan.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Per Kelurahan"),
      ),
      body: Stack(
        children: <Widget>[

          // back image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pelangi_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // list kelurahan
          StreamBuilder<Iterable<Kelurahan>>(
              initialData: const [],
              stream: DatabaseService(kecamatan: namaKecamatan).kelurahans,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Kelurahan> listKelurahan = snapshot.data!.toList();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(listKelurahan.length, (index) {
                        return Card(
                          elevation: 10.0,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[

                              // back image
                              Image.asset(
                                "assets/logo_bekasi.png",
                                fit: BoxFit.fitWidth,
                              ),

                              // list data kelurahan
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  // nama kelurahan
                                  Text(
                                    listKelurahan[index].namakelurahan.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  // nama kecamatan
                                  Text(
                                    listKelurahan[index].namakecamatan.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  // separator
                                  const SizedBox(
                                    height: 25.0,
                                  ),

                                  // jumlah anggota
                                  Text(
                                    "Anggota ${listKelurahan[index]
                                        .jumlahAnggota
                                        .toString()} orang",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // tombol timses
                                  ElevatedButton(
                                      onPressed: () {
                                        if(listKelurahan[index].jumlahAnggota == 0) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return SimpleDialog(
                                                  title: const Text("Data tidak ditemukan!"),
                                                  titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                                                  children: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("Ok"),
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return AnggotaList(
                                                    namaKelurahan: listKelurahan[index].namakelurahan.toString()
                                                  );
                                                }
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Per Timses")
                                  ),

                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                } else {
                  return const Loading();
                }
              }
          )
        ],
      ),
    );
  }

}
