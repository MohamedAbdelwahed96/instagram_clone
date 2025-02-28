import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/story_model.dart';
import '/data/post_model.dart';
import '/data/user_model.dart';
import 'package:instagram_clone/presentation/widgets/scaffold_msg.dart';

class UserProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  List <PostModel> posts=[];

  bool _isLogged=false;
  bool get isLogged => _isLogged;

  Future<void> signUp(context, UserModel user, String password) async {
    try{
      UserCredential userCd = await _auth.createUserWithEmailAndPassword(email: user.email, password: password);
      await _store.collection("users").doc(userCd.user!.uid).set(user.toMap());
      await _store.collection("users").doc(userCd.user!.uid).update({"uid":userCd.user!.uid});
      showScaffoldMSG(context, "Created Successfully");
      _isLogged=true;
    }
    catch(e){
      showScaffoldMSG(context, "Something went wrong: ${e.toString()}");
      _isLogged=false;
    }
    notifyListeners();
  }

  Future<void> signIn(context, String email, password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showScaffoldMSG(context, "Logged in Successfully");
      _isLogged = true;
    }
    catch(e){
      showScaffoldMSG(context, "Something went wrong: ${e.toString()}");
      _isLogged=false;
    }
    notifyListeners();
  }

  Future<void> signOut(context) async{
    await _auth.signOut();
    showScaffoldMSG(context, "Signed out Successfully!");
  }

  UserModel? _userData;
  UserModel? get userData => _userData;

  Future<UserModel?> getUserInfo(String userID) async {
    try {
      final userData = await _store.collection("users").doc(userID).get();

      return UserModel.fromMap(userData.data() as Map<String, dynamic>);
    } catch (e) {
      print("Something went wrong: ${e.toString()}");
      return null;
    }
  }

  Future<void> saveInfo(context, String name, username, web, bio, email, phone, gender, pfpUrl) async {
    try {
      if(email!=currentUser!.email) {
        await currentUser!.verifyBeforeUpdateEmail(email);
        showScaffoldMSG(context, "Check your email to confirm.");
      }

      User? updatedUser = _auth.currentUser;
      if (updatedUser != null && updatedUser.email == email) {
        _store.collection("users").doc(currentUser!.uid).update({
          "fullName": name,
          "username": username,
          "website": web,
          "bio": bio,
          "email": email,
          "pNumber": phone,
          "gender": gender,
          "pfpUrl": pfpUrl
        });
        showScaffoldMSG(context, "Updated Successfully");
      }
    } catch (e) {
      showScaffoldMSG(context, "Error: ${e.toString()}");
    }
  }

  Future<bool> checkLike({required String userID, required String postID}) async{
    final response = await _store.collection("posts").doc(postID).get();

    if ((response.data() as dynamic)["likes"].contains(userID)) {
      return true;
    } else {
      return false;
    }
  }

  Future likePost({required String userID, required String postID}) async{
    try{
      final response = await _store.collection("posts").doc(postID).get();

      if((response.data() as dynamic)["likes"].contains(userID)){
        await _store.collection("posts").doc(postID).update({"likes":FieldValue.arrayRemove([userID])});
      } else {
        await _store.collection("posts").doc(postID).update({"likes":FieldValue.arrayUnion([userID])});
      } notifyListeners();
    }
    catch(e){
      print("Something went wrong: ${e.toString()}");
    }
  }

  Future<bool> checkFollow(String yourID, followerID) async{
    final response = await _store.collection("users").doc(yourID).get();

    if ((response.data() as dynamic)["following"].contains(followerID)) {
      return true;
    } else {
      return false;
    }
  }

  Future followProfile(String yourID, followerID) async{
    try{
      final response = await _store.collection("users").doc(yourID).get();

      if((response.data() as dynamic)["following"].contains(followerID)){
        await _store.collection("users").doc(followerID).update({"followers":FieldValue.arrayRemove([yourID])});
        await _store.collection("users").doc(yourID).update({"following":FieldValue.arrayRemove([followerID])});
      }
      else {
        await _store.collection("users").doc(followerID).update({"followers":FieldValue.arrayUnion([yourID])});
        await _store.collection("users").doc(yourID).update({"following":FieldValue.arrayUnion([followerID])});}
      notifyListeners();
    }
    catch(e){
      print("Something went wrong: ${e.toString()}");
    }
  }

  // Future<bool> checkSave({required String userID, required String postID}) async{
  //   final response = await _store.collection("posts").doc(postID).get();
  //
  //   if ((response.data() as dynamic)["saves"].contains(userID)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  //
  // Future savePost({required String userID, required String postID}) async{
  //   try{
  //     final response = await _store.collection("posts").doc(postID).get();
  //
  //     if((response.data() as dynamic)["saves"].contains(userID)){
  //       await _store.collection("posts").doc(postID).update({"saves":FieldValue.arrayRemove([userID])});
  //     } else {
  //       await _store.collection("posts").doc(postID).update({"saves":FieldValue.arrayUnion([userID])});
  //     } notifyListeners();
  //   }
  //   catch(e){
  //     print("Something went wrong: ${e.toString()}");
  //   }
  // }

  Future setLanguage({required String userID, required String language}) async{
    await _store.collection("users").doc(userID).update({"language": language});
    notifyListeners();
  }

  Future setTheme({required String userID, required bool theme}) async{
    await _store.collection("users").doc(userID).update({"darkTheme": theme});
    notifyListeners();
  }

  Future<PostModel?> getPostInfo(String postID) async {
    try {
      final response = await _store.collection("posts").doc(postID).get();
      PostModel post = PostModel.fromMap(response.data() as Map<String, dynamic>);
      return post;
    } catch (e) {
      print("Something went wrong: ${e.toString()}");
      return null;
    }
  }

  Future<List<PostModel>> getUserPosts(String userID) async {
    try {
      final response = await _store.collection("posts").where("userID", isEqualTo: userID).get();
      return response.docs.map((e) => PostModel.fromMap(e.data())).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print("Something went wrong: ${e.toString()}");
      return [];
    }
  }


  Future getAllPosts() async{
    final response = await _store.collection("posts").get();
    posts = response.docs.map((e)=>PostModel.fromMap(e.data())).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<List<StoryModel>> getRecentStories(String userId) async {
    try {
      final last24Hours = DateTime.now().subtract(Duration(hours: 24));

      final response = await _store.collection("stories").where("userId", isEqualTo: userId)
          // .where("createdAt", isGreaterThan: Timestamp.fromDate(last24Hours))
          // .orderBy("createdAt", descending: true)
          .get();

      return response.docs.map((e) => StoryModel.fromMap(e.data())).toList();
    } catch (e) {
      print("Error fetching recent stories: ${e.toString()}");
      return [];
    }
  }

  Future<List<UserModel>> getFollowings() async {
    try {
      final response = await _store.collection("users").doc(currentUser!.uid).get();
      final followingIds = (response.data() as Map<String, dynamic>)["following"] ?? [];
      if (followingIds.isEmpty) return [];
      final followingUsers = await _store.collection("users").where("uid", whereIn: followingIds).get();
      return followingUsers.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching followings: $e");
      return [];
    }
  }

  Future<List<UserModel>> searchUsers(context, String username) async {
    final response = await _store.collection("users").where("username", isGreaterThanOrEqualTo: username).get();
    notifyListeners();
    return response.docs.map((e)=>UserModel.fromMap(e.data())).toList();
  }

  String chatId(String userId) => currentUser!.uid.compareTo(userId) < 0 ?
    "${currentUser!.uid}\_$userId" : "$userId\_${currentUser!.uid}";
}