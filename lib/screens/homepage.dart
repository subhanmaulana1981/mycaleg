
import 'package:flutter/material.dart';
import 'package:mycaleg/models/caleg.dart';
import 'package:mycaleg/models/pengguna.dart';
import 'package:mycaleg/screens/profile_caleg.dart';
import 'package:mycaleg/screens/tentang.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/daerah_pilih.dart';
import 'package:mycaleg/widgets/loading.dart';
import 'package:mycaleg/widgets/monitoring.dart';
import 'package:mycaleg/widgets/tim_sukses.dart';
import 'package:mycaleg/services/auth.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final String uid;
  const MyHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;
  bool loading = false;

  final List<Widget> _widgetOptions = <Widget>[
    Monitoring(),
    const DaerahPilih(),
    const TimSukses(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("inisialisasi homepage");
    print("uid inisialisasi homepage: ${widget.uid}");*/
  }

  @override
  Widget build(BuildContext context) {
    // print("dari home page");

    String? uid = widget.uid;
    // print("homepage build uid: $uid");

    return loading
        ? const Loading()
        : MultiProvider(
            providers: [

              // provider caleg
              StreamProvider<Caleg>.value(
                value: DatabaseService(uid: uid).calegs,
                initialData: Caleg(uid: "", nama: "", partai: "", dapil: ""),
                catchError: (BuildContext context, Object? exception) {
                  return Caleg(nama: "Caleg tidak ditemukan");
                },
              ),

              /*StreamProvider<Iterable<TimSes>>.value(
                value: DatabaseService().timseses,
                initialData: const [],
                catchError: (BuildContext context, Object? exception) {
                  return <TimSes>[TimSes(namaKetuaTimses: "Timses tidak ditemukan!")];
                },
              ),*/

            ],
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Beranda"),
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text("Keluar di sini"),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await _authService.signOut();
                          setState(() {
                            loading = false;
                          });
                        },
                        icon: const Icon(
                          Icons.logout,
                        ),
                        tooltip: "Ke luar",
                      ),
                    ],
                  ),
                ],
              ),
              drawer: Drawer(
                child: DrawerHeader(
                  child: ListView(
                    children: <Widget>[
                      // drawer header
                      StreamBuilder<Pengguna>(
                        stream: AuthService().onAuthStateChanges,
                        initialData: Pengguna(uid: "", email: ""),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Pengguna pengguna = Pengguna(
                                uid: snapshot.data!.uid,
                                email: snapshot.data!.email);
                            // print("email pengguna $email");

                            return UserAccountsDrawerHeader(
                              currentAccountPicture: const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/profile.png",
                                ),
                              ),
                              currentAccountPictureSize: const Size(64.0, 64.0),
                              accountName: const Text("Hello, "),
                              accountEmail: Text(pengguna.email),
                            );
                          } else {
                            return const Text("Loading..");
                          }
                        },
                      ),

                      // profil caleg
                      Card(
                        child: ListTile(
                          title: const Text('Profile Caleg'),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const ProfileCaleg();
                              }),
                            );
                          },
                        ),
                      ),

                      // tentang aplikasi
                      Card(
                        child: ListTile(
                          title: const Text('Tentang Aplikasi'),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const Tentang();
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard), label: "Monitoring"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.area_chart), label: "Daerah Pilih"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: "Tim Sukses"),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          );
  }
}
