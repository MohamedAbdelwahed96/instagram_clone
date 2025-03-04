import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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

  bool _isLogged=false;
  bool get isLogged => _isLogged;

  Future<void> signUp(context, UserModel user, String password) async {
    try{
      UserCredential userCd = await _auth.createUserWithEmailAndPassword(email: user.email, password: password);
      await _store.collection("users").doc(userCd.user!.uid).set(user.toMap());
      await _store.collection("users").doc(userCd.user!.uid).update({"uid":userCd.user!.uid});
      showScaffoldMSG(context, "created_successfully");
      _isLogged=true;
    }
    catch(e){
      showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
      _isLogged=false;
    }
    notifyListeners();
  }

  Future<void> signIn(context, String email, password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showScaffoldMSG(context, "logged_in_successfully");
      _isLogged = true;
    }
    catch(e){
      showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
      _isLogged=false;
    }
    notifyListeners();
  }

  Future<void> signOut(context) async{
    await _auth.signOut();
    showScaffoldMSG(context, "signed_out_successfully");
  }

  UserModel? _userData;
  UserModel? get userData => _userData;

  Future<UserModel?> getUserInfo(String userID) async {
    try {
      final userData = await _store.collection("users").doc(userID).get();
      return UserModel.fromMap(userData.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveInfo(context, String name, username, web, bio, email, phone, gender, pfpUrl) async {
    try {
      if(email!=currentUser!.email) {
        await currentUser!.verifyBeforeUpdateEmail(email);
        showScaffoldMSG(context, "check_email_to_confirm");
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
        showScaffoldMSG(context, "updated_successfully");
      }
    } catch (e) {
      showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
    }
  }

  Future<bool> checkLike({required String userID, required String postID}) async{
    final response = await _store.collection("posts").doc(postID).get();
    if ((response.data() as dynamic)["likes"].contains(userID)) return true;
    return false;
  }

  Future likePost({required String userID, required String postID, context}) async{
    try{
      final response = await _store.collection("posts").doc(postID).get();

      if((response.data() as dynamic)["likes"].contains(userID)){
        await _store.collection("posts").doc(postID).update({"likes":FieldValue.arrayRemove([userID])});
        await _store.collection("users").doc(userID).update({"likes":FieldValue.arrayRemove([postID])});
      } else {
        await _store.collection("posts").doc(postID).update({"likes":FieldValue.arrayUnion([userID])});
        await _store.collection("users").doc(userID).update({"likes":FieldValue.arrayUnion([postID])});
      } notifyListeners();
    }
    catch(e){
      showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
    }
  }

  Future<bool> checkFollow(String yourID, followerID) async{
    final response = await _store.collection("users").doc(yourID).get();
    if ((response.data() as dynamic)["following"].contains(followerID)) return true;
    return false;
  }

  Future followProfile(String yourID, followerID, context) async{
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
      showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
    }
  }

  Future<List<PostModel>> getUserPosts(String userID) async {
      final response = await _store.collection("posts").where("uid", isEqualTo: userID).get();
      return response.docs.map((e) => PostModel.fromMap(e.data())).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<PostModel>> getLikedPosts(String userID) async {
    final response = await _store.collection("posts").where("likes", arrayContains: userID).get();
    return response.docs.map((e) => PostModel.fromMap(e.data())).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<PostModel>> getSavedPosts(String userID) async {
    final userDoc = await _store.collection("users").doc(userID).get();
    List<String> savedPostIds = List<String>.from(userDoc.data()!["savedPosts"]);
    if (savedPostIds.isEmpty) return [];

    List<PostModel> posts = [];

    // chunks of 10 (Firestore limit for whereIn)
    for (var i = 0; i < savedPostIds.length; i += 10) {
      final chunk = savedPostIds.sublist(i, i + 10 > savedPostIds.length ? savedPostIds.length : i + 10);
      final response = await _store.collection("posts")
          .where(FieldPath.documentId, whereIn: chunk).get();

      posts.addAll(response.docs.map((e) => PostModel.fromMap(e.data())));
    }

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  Future<List<PostModel>> getAllPosts() async{
    final response = await _store.collection("posts").get();
    return response.docs.map((e)=>PostModel.fromMap(e.data())).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<UserModel>> getFollowings() async {
    try {
      final response = await _store.collection("users").doc(currentUser!.uid).get();
      final followingIds = List<String>.from((response.data() as Map<String, dynamic>)["following"] ?? []);

      if (followingIds.isEmpty) return [];

      List<UserModel> followingUsers = [];

      // chunks of 10 (Firestore limit for whereIn)
      for (var i = 0; i < followingIds.length; i += 10) {
        final chunk = followingIds.sublist(i, (i + 10 > followingIds.length) ? followingIds.length : i + 10);

        final response = await _store.collection("users").where("uid", whereIn: chunk).get();

        followingUsers.addAll(response.docs.map((doc) => UserModel.fromMap(doc.data())));
      }

      return followingUsers;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserModel>> searchUsers(context, String username) async {
    final response = await _store.collection("users").where("username", isGreaterThanOrEqualTo: username).get();
    notifyListeners();
    return response.docs.map((e)=>UserModel.fromMap(e.data())).toList();
  }

  Future<List<StoryModel>> getRecentStories(String userId) async {
    try {
      final response = await _store.collection("stories").where("userId", isEqualTo: userId).get();

      return response.docs.map((e) => StoryModel.fromMap(e.data())).where((story) =>
          story.createdAt.isAfter(DateTime.now().subtract(Duration(hours: 24)))).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> checkSave({required String userID, required String postID}) async{
   final response = await _store.collection("users").doc(userID).get();
   if ((response.data() as dynamic)["savedPosts"].contains(postID)) return true;
   return false;
  }

 Future savePost(context, {required String userID, required String postID}) async{
   try{
     final response = await _store.collection("users").doc(userID).get();

     if((response.data() as dynamic)["savedPosts"].contains(postID)){
       await _store.collection("users").doc(userID).update({"savedPosts":FieldValue.arrayRemove([postID])});
       showScaffoldMSG(context, "removed_from_saved_posts");
     } else {
       await _store.collection("users").doc(userID).update({"savedPosts":FieldValue.arrayUnion([postID])});
       showScaffoldMSG(context, "added_to_saved_posts");
     } notifyListeners();
   }
   catch(e){
     showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
   }
 }

  Future setLanguage({required String userID, required String language}) async{
    await _store.collection("users").doc(userID).update({"language": language});
    notifyListeners();
  }

  String chatId(String userId) => currentUser!.uid.compareTo(userId) < 0 ?
  "${currentUser!.uid}\_$userId" : "$userId\_${currentUser!.uid}";
}