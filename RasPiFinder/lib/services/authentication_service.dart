import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // create user object based on firebase user
  MUser _userFromFirebaseUser(User user) {
    return user != null ? MUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<MUser> get user {
    return _firebaseAuth.authStateChanges()
    // .map((User user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password,);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String username, String phone) async {
    try {
      UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password,);
      User user= authResult.user;
      print('firebaseAuth authResult = ' + authResult.toString());
      print('firebaseAuth user id = ' +user.uid );

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).createUser(username, email, phone);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}