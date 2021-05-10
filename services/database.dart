import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projekt_mobilki/model/list.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference shopList =
      FirebaseFirestore.instance.collection('shop_list');

  Future updateUserData(List<String> word, List<int> check) async {
    return await shopList.doc(uid).set({
      'Nazwa': word,
      'Stan': check,
      'id': uid,
    });
  }

  updateData(List<String> word, List<int> check) {
    return shopList.doc(uid).set({
      'Nazwa': word,
      'Stan': check,
      'id': uid,
    });
  }

  List<Lista> _getSpecificVal(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Lista(
        product: doc.data()['Nazwa'],
        check: doc.data()['Stan'],
        id: doc.data()['id'],
      );
    }).toList();
  }

  Stream<List<Lista>> get getElementsOfList {
    return shopList.snapshots().map(_getSpecificVal);
  }
}
