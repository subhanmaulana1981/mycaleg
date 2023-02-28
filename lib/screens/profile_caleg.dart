import 'package:flutter/material.dart';
import 'package:mycaleg/models/caleg.dart';
import 'package:mycaleg/models/kecamatan.dart';
import 'package:mycaleg/models/pengguna.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/loading.dart';
import 'package:provider/provider.dart';

class ProfileCaleg extends StatefulWidget {
  const ProfileCaleg({Key? key}) : super(key: key);

  @override
  State<ProfileCaleg> createState() => _ProfileCalegState();
}

class _ProfileCalegState extends State<ProfileCaleg> {
  final _formKey = GlobalKey<FormState>();
  final List<String> partais = [
    "pdip",
    "pks",
    "nasdem",
    "demokrat",
    "pkb",
    "pan",
    "golkar",
    "ppp",
    "gerindra",
    "pbb",
    "hanura",
    "psi",
    "perindo",
    "garuda",
    "pkn",
    "gelora",
    "buruh",
    "ummat"
  ];

  final List<String> dapils = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];

  // form state values
  String? _currentPartaiValue;
  String? _currentDapilValue;
  String? _currentNamaCaleg;
  String? _currentCalegID;
  String? _currentKecamatanValue;

  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<Pengguna>(context);

    return StreamBuilder<Caleg>(
      stream: DatabaseService(uid: pengguna.uid).calegs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Caleg? caleg = snapshot.data;
          // print("kecamatan dari caleg: ${caleg?.kecamatan.toString()}");

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text("Profile Caleg"),
            ),
            body: Stack(
              children: <Widget>[

                // background
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pelangi_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // form caleg
                SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            // gambar profil
                            Image.asset(
                              "assets/profile.png",
                              fit: BoxFit.fitWidth,
                              width: 128.0,
                            ),

                            // partai
                            DropdownButtonFormField(
                              value: _currentPartaiValue ?? caleg?.partai,
                              items: partais.map((partai) {
                                return DropdownMenuItem(
                                  value: partai,
                                  child: Text(partai.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: (val) {
                                _currentPartaiValue = val!;

                                /*print("dari profil caleg");
                                print("value: $val");*/

                                // warna bendera

                              },
                            ),

                            // dapil
                            DropdownButtonFormField(
                              value: _currentDapilValue ?? caleg?.dapil,
                              items: dapils.map((dapil) {
                                return DropdownMenuItem(
                                  value: dapil,
                                  child: Text(dapil),
                                );
                              }).toList(),
                              onChanged: (val) => _currentDapilValue = val!,
                            ),

                            // kecamatan
                            StreamBuilder<Iterable<Kecamatan>>(
                                stream: DatabaseService(dapil: _currentDapilValue).kecamatans,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<Kecamatan> listKecamatan = snapshot.data!.toList();
                                    return DropdownButtonFormField<String>(
                                      value: _currentKecamatanValue ?? caleg?.kecamatan,
                                      items: listKecamatan.map<DropdownMenuItem<String>>((Kecamatan kecamatan) {
                                        return DropdownMenuItem<String>(
                                            value: kecamatan.namakecamatan,
                                            child: Text(kecamatan.namakecamatan.toUpperCase()));
                                      }).toList(),
                                      onChanged: (val) => _currentKecamatanValue = val!,
                                    );
                                  } else {
                                    return const Loading();
                                  }
                                }),

                            // nama caleg
                            TextFormField(
                              initialValue: caleg?.nama,
                              decoration: const InputDecoration(
                                  labelText: "Nama Lengkap",
                                  hintText: "Masukkan nama lengkap"),
                              validator: (val) =>
                                  val!.isEmpty ? "Tolong isi nama" : null,
                              onChanged: (val) {
                                setState(() {
                                  _currentNamaCaleg = val;
                                });
                              },
                            ),

                            // separator
                            const SizedBox(
                              height: 50.0,
                            ),

                            // buttons
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Batal"),
                                ),

                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await DatabaseService(uid: pengguna.uid).setCalegData(
                                            (_currentCalegID ?? caleg!.uid)!,
                                            (_currentPartaiValue ?? caleg!.partai)!,
                                            (_currentDapilValue ?? caleg!.dapil)!,
                                            (_currentKecamatanValue ?? caleg!.kecamatan)!,
                                            (_currentNamaCaleg ?? caleg!.nama)!
                                        );
                                      } catch(err) {
                                        // print(err.toString());
                                      } finally {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
                                  child: const Text("Simpan"),
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
                        ),
                      )),
                ),
              ],
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
