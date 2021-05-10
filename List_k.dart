import 'package:flutter/material.dart';
import 'package:projekt_mobilki/Add_itemsAnother.dart';
import 'package:projekt_mobilki/PrintListOfElementsAnother.dart';
import 'package:projekt_mobilki/services/auth.dart';
import 'package:projekt_mobilki/services/database.dart';
import 'package:projekt_mobilki/main.dart';
import 'package:provider/provider.dart';
import 'package:projekt_mobilki/model/list.dart';

class Keys extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Keys> {
  TextEditingController nameController = TextEditingController();
  final AuthService _auth = AuthService();
  String uid = "Nie nadano";
  final List<String> names = <String>[];
  final List<int> albought = <int>[];

  @override
  void initState() {
    super.initState();
    user_id();
  }

  user_id() async {
    dynamic result = await _auth.signByKey();
    setState(() {
      uid = result.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Lista>>.value(
        value: DatabaseService().getElementsOfList,
        child: WillPopScope(
            onWillPop: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp();
              }));
              return null;
            },
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AdditemsAnother();
                    }));
                  },
                  child: Icon(Icons.add),
                ),
                appBar: AppBar(
                    leading: Icon(Icons.shopping_bag),
                    title: Text('Zarządzanie listą:'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.check, color: Colors.white),
                          onPressed: () {
                            print("powrot");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MyApp();
                            }));
                          })
                    ]),
                body: PrintListOfElementAnother())));
  }
}
