import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projekt_mobilki/List_k.dart';
import 'Add_items.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:projekt_mobilki/services/database.dart';
import 'package:projekt_mobilki/PrintListOfElement.dart';
import 'package:projekt_mobilki/model/list.dart';
import 'package:projekt_mobilki/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(primaryColor: Colors.green),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final List<String> names = <String>[];
  final List<int> albought = <int>[];
  TextEditingController nameController = TextEditingController();
  final AuthService _auth = AuthService();
  String count;
  String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Lista>>.value(
        value: DatabaseService().getElementsOfList,
        child: WillPopScope(
            onWillPop: () {
              SystemNavigator.pop();
              return null;
            },
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Additems();
                  }));
                },
                child: Icon(Icons.add),
              ),
              appBar: AppBar(
                  leading: Icon(Icons.shopping_bag),
                  title: Text('Twoja lista zakupów:'),
                  actions: <Widget>[
                    IconButton(
                        icon:
                            Icon(Icons.cleaning_services, color: Colors.white),
                        onPressed: () async {
                          print("clean");
                          names.clear();
                          albought.clear();
                          dynamic result = await _auth.signByKey();
                          DatabaseService(uid: result.uid)
                              .updateData(names, albought);
                        }),
                    IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Keys();
                          }));
                        })
                  ]),
              body: PrintListOfElement(),
            )));
  }
}
