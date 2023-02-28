import 'package:flutter/material.dart';
import 'package:mycaleg/models/anggota.dart';
import 'package:mycaleg/models/timses.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/loading.dart';

class AnggotaList extends StatefulWidget {
  // properti
  final String namaKelurahan;

  // konstruktor
  const AnggotaList({Key? key, required this.namaKelurahan}) : super(key: key);

  @override
  State<AnggotaList> createState() => _AnggotaListState();
}

class _AnggotaListState extends State<AnggotaList> {
  // late List<bool>? _isExpanded = [false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Per Tim Sukses"),
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

          // list anggota by timses
          SingleChildScrollView(
            child: _buildPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel() {
    // to filter by kelurahan
    String namaKelurahan = widget.namaKelurahan.toString();

    return StreamBuilder<Iterable<TimSes>>(
        initialData: const [],
        stream: DatabaseService(kelurahan: namaKelurahan.toString())
            .timsesesByKelurahan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TimSes> listTimses = snapshot.data!.toList();

            return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: listTimses.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(
                      listTimses[index]
                          .namaKetuaTimses
                          .toString()
                          .toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                        "Rekrut sebanyak ${listTimses[index].jumlahAnggota.toString()} orang"),
                    children: <Widget>[
                      StreamBuilder<Iterable<Anggota>>(
                          initialData: const [],
                          stream: DatabaseService(
                                  timsesID:
                                      listTimses[index].timsesID.toString())
                              .anggotas,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Anggota> listAnggota =
                                  snapshot.data!.toList();
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: listAnggota.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                          listAnggota[index].namaAnggota.toString()),
                                    );
                                  });
                            } else {
                              return const Loading();
                            }
                          }),
                    ],
                  );
                });
          } else {
            return const Loading();
          }
        });
  }
}
