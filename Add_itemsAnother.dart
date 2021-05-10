import 'package:flutter/material.dart';
import 'package:projekt_mobilki/List_k.dart';
import 'package:projekt_mobilki/PrintListOfElementTextAnother.dart';
import 'package:projekt_mobilki/main.dart';
import 'package:provider/provider.dart';
import 'package:projekt_mobilki/services/database.dart';
import 'package:projekt_mobilki/model/list.dart';

class AdditemsAnother extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AdditemsAnother> {
  List<String> names = <String>[];
  final List<int> albought = <int>[];
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void addItemToList() {
    setState(() {
      // _save(nameController.text);
      nameController.text = "";
    });
  }

  void AddSomeItems(BuildContext context) {
    var adding = RaisedButton(
      child: Text('Dodaj'),
      color: Colors.green,
      onPressed: () {
        addItemToList();
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return adding;
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
              appBar: AppBar(
                  leading: Icon(Icons.shopping_bag),
                  title: Text('Twoja lista zakupów'),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.check, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Keys();
                          }));
                        })
                  ]),
              body: PrintListOfElementTextAnother(),
            )));
  }
}
