import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycaleg/models/anggota.dart';
import 'package:mycaleg/models/caleg.dart';
import 'package:mycaleg/models/kecamatan.dart';
import 'package:mycaleg/models/kelurahan.dart';
import 'package:mycaleg/models/timses.dart';

class DatabaseService {
  // to connect document with the user
  final String? uid;
  final String? dapil;
  final String? kecamatan;
  final String? kelurahan;
  final String? namaKetuaTimses;
  final String? timsesID;

  DatabaseService(
      {this.uid,
      this.dapil,
      this.kecamatan,
      this.kelurahan,
      this.namaKetuaTimses,
      this.timsesID});

  // collection reference
  final CollectionReference calegCollection =
      FirebaseFirestore
          .instance
          .collection("caleg");

  final CollectionReference kecamatanCollection =
      FirebaseFirestore
          .instance
          .collection("kecamatan");

  final CollectionReference kelurahanCollection =
      FirebaseFirestore
          .instance
          .collection("kelurahan");

  final CollectionReference timsesCollection =
      FirebaseFirestore
          .instance
          .collection("ketuatimses");

  final CollectionReference anggotaCollection = FirebaseFirestore
      .instance
      .collection("ketuatimses");

  final Query<Map<String, dynamic>> anggotaAllQuery = FirebaseFirestore
      .instance
      .collectionGroup("anggota");

  // get (iterable) stream
  Stream<Iterable<Kecamatan>> get kecamatans {
    return kecamatanCollection
        .where("dapil", isEqualTo: dapil)
        .snapshots()
        .map(_kecamatanListFromSnapshot);
  }

  Stream<Iterable<Kecamatan>> get kecamatanGraph {
    return kecamatanCollection
        .where("jumlahanggota", isGreaterThan: 0)
        .snapshots()
        .map(_kecamatanGraphFromSnapshot);
  }

  Stream<Iterable<Kelurahan>> get kelurahans {
    return kelurahanCollection
        .where("namakecamatan", isEqualTo: kecamatan)
        .snapshots()
        .map(_kelurahanListFromSnapshot);
  }

  Stream<Iterable<Kelurahan>> get kelurahanGraph {
    return kelurahanCollection
        .where("jumlahanggota", isGreaterThan: 0)
        .snapshots()
        .map(_kelurahanGraphFromSnapshot);
  }

  Stream<Iterable<TimSes>> get timseses {
    return timsesCollection
        .snapshots()
        .map(_timsesListFromSnapshot);
  }

  Stream<Iterable<TimSes>> get timses {
    return timsesCollection
        .where("namaKetuaTimses", isEqualTo: namaKetuaTimses)
        .snapshots()
        .map(_timsesFromSnapshot);
  }
  
  Stream<Iterable<TimSes>> get timsesesByKelurahan {
    return timsesCollection
        .where("kelurahan", isEqualTo: kelurahan)
        .snapshots()
        .map(_timsesListFromSnapshot);
  }

  Stream<Iterable<Anggota>> get anggotas {
    return anggotaCollection.doc(timsesID)
        .collection("anggota")
        .snapshots()
        .map(_anggotaListFromSnapshot);
  }

  // get (non-iterable) stream
  Stream<Caleg> get calegs {
    return calegCollection.doc(uid).snapshots().map(_calegFromSnapshot);
  }

  // object list from snapshot above
  Caleg _calegFromSnapshot(DocumentSnapshot documentSnapshot) {
    return Caleg(
        uid: uid!,
        dapil: documentSnapshot["dapil"],
        nama: documentSnapshot["nama"],
        partai: documentSnapshot["partai"],
        kecamatan: documentSnapshot["kecamatan"]);
  }

  Iterable<TimSes> _timsesFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return TimSes(
          timsesID: doc["timsesID"],
          namaKetuaTimses: doc["namaKetuaTimses"],
          namaCaleg: doc["namaCaleg"],
          kecamatan: doc["kecamatan"],
          kelurahan: doc["kelurahan"],
          jumlahAnggota: doc["jumlahanggota"]
      );
    });
  }

  Iterable<Kecamatan> _kecamatanListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Kecamatan(
          dapil: doc["dapil"],
          namakecamatan: doc["nama"],
          jumlahAnggota: doc["jumlahanggota"]
      );
    });
  }

  Iterable<Kecamatan> _kecamatanGraphFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Kecamatan(
          dapil: doc["dapil"],
          namakecamatan: doc["nama"],
          jumlahAnggota: doc["jumlahanggota"]
      );
    });
  }

  Iterable<Kelurahan> _kelurahanListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Kelurahan(
          namakecamatan: doc["namakecamatan"],
          namakelurahan: doc["namakelurahan"],
          jumlahAnggota: doc["jumlahanggota"]
      );
    });
  }

  Iterable<Kelurahan> _kelurahanGraphFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Kelurahan(
          namakecamatan: doc["namakecamatan"],
          namakelurahan: doc["namakelurahan"],
          jumlahAnggota: doc["jumlahanggota"]
      );
    });
  }

  Iterable<TimSes> _timsesListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return TimSes(
          timsesID: doc["timsesID"],
          namaKetuaTimses: doc["namaKetuaTimses"],
          namaCaleg: doc["namaCaleg"],
          kecamatan: doc["kecamatan"],
          kelurahan: doc["kelurahan"],
          jumlahAnggota: doc["jumlahanggota"]
      );
    });
  }

  Iterable<Anggota> _anggotaListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Anggota(
        timsesID: doc["timsesID"],
        namaKetuaTimses: doc["namaKetuaTimses"],
        nomorKTP: doc["nomorKTP"],
        namaAnggota: doc["namaAnggota"],
        jenisKelamin: doc["jenisKelamin"],
        tempatLahir: doc["tempatLahir"],
        tanggalLahir: doc["tanggalLahir"],
        alamat: doc["alamat"],
        kelurahan: doc["kelurahan"],
        kecamatan: doc["kecamatan"],
        nomorTelepon: doc["nomorTelepon"]
      );
    });
  }

  // operate data (crud) create, update, delete, select
  Future<dynamic> setCalegData(String id, String partai, String dapil,
      String kecamatan, String nama) async {
    return await calegCollection.doc(uid).set({
      "id": id,
      "partai": partai,
      "dapil": dapil,
      "kecamatan": kecamatan,
      "nama": nama
    });
  }

  Future<dynamic> setTimsesData(
      String timsesID,
      String namaKetuaTimses,
      String namaCaleg,
      String kecamatan,
      String kelurahan,
      int jumlahAnggota
      ) async {
    return await timsesCollection.doc(timsesID).set({
      "timsesID": timsesID,
      "namaKetuaTimses": namaKetuaTimses,
      "namaCaleg": namaCaleg,
      "kecamatan": kecamatan,
      "kelurahan": kelurahan,
      "jumlahanggota": jumlahAnggota
    });
  }

  // dari kuldi project
  /*Future<QuerySnapshot<Map<String, dynamic>>> getAnggotas() async {
    return await anggotaCollection.doc().collection("anggota").get();
  }*/

  Future<QuerySnapshot<Map<String, dynamic>>> getAnggotaAll() async {
    return anggotaAllQuery.get();
  }

  Future<AggregateQuerySnapshot> getAnggotaCount(String kelurahan) async {
    return await anggotaAllQuery
      .where("kelurahan", isEqualTo: kelurahan)
      .count()
      .get();
  }

}
