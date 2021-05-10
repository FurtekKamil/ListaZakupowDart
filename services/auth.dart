import 'package:firebase_auth/firebase_auth.dart';
import 'package:projekt_mobilki/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CName _fromFirebaseUser(User user) {
    return user != null ? CName(uid: user.uid) : null;
  }

  CName _fromFirebaseUserAnother(User user, String uid) {
    return user != null ? CName(uid: uid) : null;
  }

  Future signByKey() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return _fromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signByKeyAnother(String uid) async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return _fromFirebaseUserAnother(user, uid);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
