import 'package:flutter/material.dart';
import 'package:mycaleg/models/timses.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/loading.dart';

class FormTimSes extends StatefulWidget {

  final String namaketuatimses;
  final String namaCaleg;

  const FormTimSes({
    Key? key,
    required this.namaketuatimses,
    required this.namaCaleg
  }) : super(key: key);

  @override
  State<FormTimSes> createState() => _FormTimSesState();
}

class _FormTimSesState extends State<FormTimSes> {

  // form state
  String? _currentKecamatan;
  String? _currentKelurahan;
  String? _currentTimses;
  String? _currentCaleg;
  String? _currentTimsesID;
  int? _currentAnggotaTimses;

  final TextEditingController _controllerKecamatan = TextEditingController();
  final TextEditingController _controllerKelurahan = TextEditingController();
  final TextEditingController _controllerTimses = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // initialized for updating nama caleg
    _currentCaleg = widget.namaCaleg.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Form TimSes"),
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

          // form timses
          SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: StreamBuilder<Iterable<TimSes>>(
                  stream: DatabaseService(namaKetuaTimses: widget.namaketuatimses).timses,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      List<TimSes> listTimses = snapshot.data!.toList();
                      _currentKecamatan = listTimses.single.kecamatan.toString();
                      _currentKelurahan = listTimses.single.kelurahan.toString();
                      _currentTimses = listTimses.single.namaKetuaTimses.toString();
                      _currentTimsesID = listTimses.single.timsesID.toString();
                      _currentAnggotaTimses = listTimses.single.jumlahAnggota;

                      /*print("kecamatan: $_currentKecamatan");
                      print("kelurahan: $_currentKelurahan");
                      print("timses: $_currentTimses");
                      print("email: $_currentEmail");*/

                      _controllerKecamatan.text = _currentKecamatan.toString();
                      _controllerKelurahan.text = _currentKelurahan.toString();
                      _controllerTimses.text = _currentTimses.toString();

                      return Column(
                        children: <Widget>[

                          // Kecamatan
                          TextFormField(
                            controller: _controllerKecamatan,
                            decoration: const InputDecoration(
                              label: Text("Nama Kecamatan"),
                            ),
                          ),

                          // Kelurahan
                          TextFormField(
                            controller: _controllerKelurahan,
                            decoration: const InputDecoration(
                              label: Text("Nama Kelurahan"),

                            ),
                          ),

                          // Ketua Timses
                          TextFormField(
                            controller: _controllerTimses,
                            decoration: const InputDecoration(
                              label: Text("Ketua Timses"),
                            ),
                          ),

                          // separator
                          const SizedBox(
                            height: 50.0,
                          ),

                          ButtonBar(
                            children: <ElevatedButton>[
                              ElevatedButton(
                                onPressed: () async {

                                  try {

                                    /*print("dari form timses");
                                    print("timses id: $_currentTimsesID");
                                    print("timses: $_currentTimses");
                                    print("caleg: $_currentCaleg");
                                    print("kecamatan: $_currentKecamatan");
                                    print("kelurahan: $_currentKelurahan");
                                    print("jumlah anggota: $_currentAnggotaTimses");*/

                                    await DatabaseService(timsesID: _currentTimsesID.toString())
                                        .setTimsesData(
                                        (_currentTimsesID.toString()),
                                        (_currentTimses.toString()),
                                        (_currentCaleg.toString()),
                                        (_currentKecamatan.toString()),
                                        (_currentKelurahan.toString()),
                                        (_currentAnggotaTimses!)
                                    );

                                  } catch(error) {
                                    // print(error.toString());
                                  } finally {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Timses berhasil diRekrut.."),
                                        duration: Duration(seconds: 5),
                                        elevation: 10.0,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  }

                                },
                                child: const Text("Rekrut Timses"),
                              ),

                            ],
                          ),

                          // separator
                          const SizedBox(
                            height: 50.0,
                          ),


                          // copyright
                          const Text(
                            "(c) 2022 Maju Bersama production",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Loading();
                    }
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
