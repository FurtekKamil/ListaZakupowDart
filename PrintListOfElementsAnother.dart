import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekt_mobilki/model/list.dart';
import 'package:projekt_mobilki/services/database.dart';
import 'package:projekt_mobilki/services/auth.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintListOfElementAnother extends StatefulWidget {
  @override
  _PrintListOfElementAnotherState createState() =>
      _PrintListOfElementAnotherState();
}

class _PrintListOfElementAnotherState extends State<PrintListOfElementAnother> {
  final List<String> names = <String>[];
  final List<int> albought = <int>[];
  final AuthService _auth = AuthService();
  String uid = "Nie nadano";
  String private_uid = "Nie nadano";
  TextEditingController nameController = TextEditingController();
  Future<List<Lista>> wonsz;

  @override
  void initState() {
    super.initState();
    user_id();
    _read();
  }

  _save(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = uid;
    prefs.setString(key, value);
    print('saved $value');
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = prefs.getString(key);
    if (value != null) {
      setState(() {
        uid = value;
      });
    }
    return value;
  }

  user_id() async {
    dynamic result = await _auth.signByKey();
    setState(() {
      private_uid = result.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listOfObjects = Provider.of<List<Lista>>(context) ?? [];
    int dlugosc = 0;
    int i = 0;

    listOfObjects.forEach((element) {
      if (element.id == uid) {
        print("sss");
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
      Text("Twoj numer listy: "),
      ListTile(
          title: Text("$private_uid"),
          trailing: FlatButton(
              minWidth: 30,
              onPressed: () async {
                ClipboardManager.copyToClipBoard(private_uid).then((result) {
                  final snackBar = SnackBar(
                    content: Text('Kod skopiowano do schowka.'),
                    action: SnackBarAction(
                      label: 'Ok',
                      onPressed: () {},
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                });
              },
              child: Icon(Icons.copy))),
      TextField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Numer listy znajomego/rodziny',
        ),
      ),
      RaisedButton(
        child: Text('Synchronizuj'),
        color: Colors.green,
        onPressed: () async {
          dynamic result = await _auth.signByKeyAnother(nameController.text);
          if (result == null) {
            print('error');
          } else {
            print(result.uid);
            _save(result.uid);
            setState(() {
              uid = result.uid;
            });
          }
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
