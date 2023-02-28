
import 'package:flutter/material.dart';
import 'package:mycaleg/models/kecamatan.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/daerah_kelurahan.dart';
import 'package:mycaleg/widgets/loading.dart';

class KecamatanList extends StatefulWidget {

  final String dapil;
  final String kecamatan;

  const KecamatanList({
    Key? key,
    required this.dapil,
    required this.kecamatan
  })
      : super(key: key);

  @override
  State<KecamatanList> createState() => _KecamatanListState();
}

class _KecamatanListState extends State<KecamatanList> {

  @override
  Widget build(BuildContext context) {

    // untuk filtering by kecamatan
    String namaKecamatan = widget.kecamatan.toString();

    return StreamBuilder<Iterable<Kecamatan>>(
      stream: DatabaseService(dapil: widget.dapil, kecamatan: widget.kecamatan).kecamatans,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final kecamatans = snapshot.data!.toList();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(kecamatans.length, (index) {
                return Card(
                  elevation: 10.0,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[

                      // background
                      Image.asset(
                        "assets/logo_bekasi.png",
                        fit: BoxFit.fitWidth,
                      ),

                      // data
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Text(
                            kecamatans[index].namakecamatan.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Dapil: ${kecamatans[index].dapil}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "Anggota: ${kecamatans[index].jumlahAnggota} orang",
                          ),
                          
                          ElevatedButton(
                            onPressed: () {

                              // ke kelurahan
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return KelurahanList(
                                      namaKecamatan: namaKecamatan
                                    );
                                  }
                                ),
                              );

                            },
                            child: const Text("Per Kelurahan")
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
    );
  }

}
