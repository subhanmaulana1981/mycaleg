import 'package:flutter/material.dart';
import 'package:mycaleg/models/caleg.dart';
import 'package:mycaleg/models/kecamatan.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/daerah_kecamatan.dart';
import 'package:provider/provider.dart';

class DaerahPilih extends StatefulWidget {
  const DaerahPilih({Key? key}) : super(key: key);

  @override
  State<DaerahPilih> createState() => _DaerahPilihState();
}

class _DaerahPilihState extends State<DaerahPilih> {
  @override
  Widget build(BuildContext context) {
    // print("dari daerah pemilihan");

    final caleg = Provider.of<Caleg>(context);
    // print("dapil caleg: ${caleg.dapil}");

    return StreamProvider<Iterable<Kecamatan>>.value(
      value: DatabaseService(dapil: caleg.dapil).kecamatans,
      initialData: const [],
      child: Stack(
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

          // kecamatan list
          KecamatanList(
              dapil: caleg.dapil.toString(),
              kecamatan: caleg.kecamatan.toString()),

        ],
      ),
    );
  }
}
