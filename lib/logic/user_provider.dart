import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/data/user_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final User usercd = FirebaseAuth.instance.currentUser!;
  UserModel? _user;
  UserModel? get user => _user;

  Future <bool> signUp(context, UserModel user, String email, password) async {
    try{
      UserCredential userCd = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _store.collection("users").doc(userCd.user!.uid).set(user.toMap()).then((v){
        _store.collection("users").doc(userCd.user!.uid).update({"uid":userCd.user!.uid});
      }).then((v){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Created Successfully")));
        notifyListeners();
      });
      return true;
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
      return false;
    }
  }

  Future <bool> signIn(context, String email, password) async {
      try{
        await _auth.signInWithEmailAndPassword(email: email, password: password).then((v){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in Successfully")));
          notifyListeners();
        });
        return true;
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        notifyListeners();
        return false;
      }
  }

  Future<void> getUserInfo() async {
    try {
      DocumentSnapshot userData = await _store.collection("users").doc(usercd.uid).get();

      if (userData.exists) {
        _user = UserModel.fromMap(userData.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> uploadPost(PostModel post) async {
    await FirebaseFirestore.instance.collection('posts').doc(post.postId).set(post.toMap());
  }


  String? get pfpUrl => _user?.pfpUrl;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  String? _username, _password, _email, _phone, _fullName, _birthDate, _pfp;

  String? get username => _username;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get password => _password;
  String? get birthDate => _birthDate;
  String? get phone => _phone;
  String? get pfp => _pfp;

  set phone(String? user) {
    _phone = user;
    notifyListeners();
  }

  set pfp(String? user) {
    _pfp = user;
    notifyListeners();
  }

  set username(String? user) {
    _username = user;
    notifyListeners();
  }

  set fullName(String? user) {
    _fullName = user;
    notifyListeners();
  }

  set email(String? user) {
    _email = user;
    notifyListeners();
  }

  set password(String? user) {
    _password = user;
    notifyListeners();
  }

  set birthDate(String? user) {
    _birthDate = user;
    notifyListeners();
  }
}
