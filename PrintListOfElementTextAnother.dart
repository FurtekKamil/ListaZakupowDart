import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekt_mobilki/model/list.dart';
import 'package:projekt_mobilki/services/database.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PrintListOfElementTextAnother extends StatefulWidget {
  @override
  _PrintListOfElementTextAnotherState createState() =>
      _PrintListOfElementTextAnotherState();
}

class _PrintListOfElementTextAnotherState
    extends State<PrintListOfElementTextAnother> {
  final List<String> names = <String>[];
  final List<int> albought = <int>[];
  TextEditingController nameController = TextEditingController();
  String uid = "Nie nadano";
  
  @override
  void initState() {
    super.initState();
    user_id();
  }

  user_id() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = prefs.getString(key) ?? 0;
    uid = value;
  }

  @override
  Widget build(BuildContext context) {
    final listOfObjects = Provider.of<List<Lista>>(context) ?? [];
    int dlugosc = 0;
    int i = 0;

    listOfObjects.forEach((element) {
      if (element.id == uid) {
        dlugosc = element.product.length;
        names.clear();
        albought.clear();
        for (i = 0; i < dlugosc; i++) {
          names.add(element.product[i]);
          albought.add(element.check[i]);
        }
      }
    });

    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nazwa produktu',
          ),
        ),
      ),
      RaisedButton(
        child: Text('Dodaj'),
        color: Colors.green,
        onPressed: () async {
          names.add(nameController.text);
          albought.add(1);
          DatabaseService(uid: uid).updateData(names, albought);
          nameController.text = '';
        },
      ),
      Expanded(
        child: ListView.builder(
          itemCount: dlugosc,
          itemBuilder: (context, index) {
            return ListTile(
                leading: albought[index] == 0
                    ? Icon(Icons.check)
                    : Icon(Icons.clear),
                tileColor:
                    albought[index] == 0 ? Colors.green[100] : Colors.red[100],
                title: Text(names[index]),
                trailing: FlatButton(
                  onPressed: () async {
                    names.remove(names[index]);
                    albought.remove(albought[index]);
                    DatabaseService(uid: uid).updateData(names, albought);
                  },
                  color: albought[index] == 0
                      ? Colors.green[100]
                      : Colors.red[100],
                  child: Icon(Icons.delete),
                ),
                onTap: () async {
                  if (albought[index] == 0) {
                    albought[index] = 1;
                  } else {
                    albought[index] = 0;
                  }
                  DatabaseService(uid: uid).updateData(names, albought);
                  print(names.toString());
                });
          },
        ),
      )
    ]);
  }
}
