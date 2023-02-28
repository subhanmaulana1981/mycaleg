import 'package:flutter/material.dart';
import 'package:mycaleg/models/caleg.dart';
import 'package:mycaleg/models/timses.dart';
import 'package:mycaleg/screens/form_timses.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/loading.dart';
import 'package:provider/provider.dart';

class TimSukses extends StatefulWidget {
  const TimSukses({Key? key}) : super(key: key);

  @override
  State<TimSukses> createState() => _TimSuksesState();
}

class _TimSuksesState extends State<TimSukses> {

  String? _currentCaleg;

  @override
  Widget build(BuildContext context) {

    final caleg = Provider.of<Caleg>(context);
    _currentCaleg = caleg.nama;
    /*print("dari daftar tim sukses");
    print("nama caleg: $_currentCaleg");*/

    return StreamBuilder<Iterable<TimSes>>(
        stream: DatabaseService().timseses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TimSes> listTimses = snapshot.data!.toList();

            return Scaffold(
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

                  // list timses
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: listTimses.length,
                      itemBuilder: (BuildContext context, int index) {

                        // tim sukses
                        return Card(
                          color: Colors.red[100],
                          elevation: 10.0,
                          child: ListTile(
                            leading: const Icon(
                              Icons.account_circle,
                              size: 48.0,
                            ),
                            title: Text(listTimses[index]
                                .namaKetuaTimses
                                .toString()
                                .toUpperCase()),
                            subtitle: Text(
                                listTimses[index]
                                    .kelurahan
                                    .toString()),
                            trailing: IconButton(
                              onPressed: () {

                                // buka form tim sukses
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return FormTimSes(
                                      namaketuatimses: listTimses[index]
                                          .namaKetuaTimses
                                          .toString(),
                                      namaCaleg: _currentCaleg.toString(),
                                    );
                                  }),
                                );

                              },
                              icon: const Icon(
                                Icons.info,
                                size: 48.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            );
          } else {
            return const Loading();
          }
        });
  }
}
