import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/data/story_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:instagram_clone/presentation/widgets/scaffold_msg.dart';

class MediaProvider extends ChangeNotifier{
  final _supa = Supabase.instance.client.storage;
  String? filename;
  List<String> media=[];
  PlatformFile? mediaFile;
  List<PlatformFile> mediaFiles=[];

  Future selectMedia(FileType type, {bool multiple = false}) async {
    final response = await FilePicker.platform.pickFiles(type: type, allowMultiple: multiple);
    if (response != null) {
      if (multiple) {
        mediaFiles = response.files;
      } else {
        mediaFile = response.files.first;
      }
    }
    notifyListeners();
  }

  Future uploadImage(context, {required String bucketName, required String folder}) async {
    if (mediaFile == null) {
      showScaffoldMSG(context, "no_image_attached");
      return;
    }
    try {
      filename = "${DateTime.now().millisecondsSinceEpoch}.${mediaFile!.extension}";
      await _supa.from(bucketName).upload("$folder/$filename", File(mediaFile!.path!));
      showScaffoldMSG(context, "uploaded_successfully");
      notifyListeners();
      mediaFile = null;
    } catch (e) {
      showScaffoldMSG(context, "${"upload_failed".tr()}: ${e.toString()}");
    }
  }

  Future uploadMedia(BuildContext context, String id) async {
    if (mediaFiles.isEmpty) {
      showScaffoldMSG(context, "no_media_attached");
      return;
    }
    media=[];
    try {
      for (var file in mediaFiles) {
        if (file.path == null) continue;
        filename = "${DateTime.now().millisecondsSinceEpoch}.${file.extension}";
        media.add(filename!);
        await _supa.from("posts").upload("$id/$filename", File(file.path!));
      }
      showScaffoldMSG(context, "uploaded_successfully");
      notifyListeners();
      mediaFiles.clear();
    } catch (e) {
      showScaffoldMSG(context, "${"upload_failed".tr()}: ${e.toString()}");
    }
  }

  Future<String> getImage({
    required String bucketName, required String folderName, required String fileName}) async {
    try {
      String img = await _supa.from(bucketName).getPublicUrl("$folderName/$fileName");
      return img;
    } catch (e) {
      return "";
    }
  }

  Future<List<String>>getImages({required String bucketName, required String folderName})async{
    try{
      final response = await _supa.from(bucketName).list(path: folderName);
      final media = response.map((file){
          return _supa.from(bucketName).getPublicUrl("$folderName/${file.name}");}).toList();
        return media;
    }
    catch(e){
      return [];
    }
  }

  Future uploadPost(context, PostModel post) async {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    try{
      await FirebaseFirestore.instance.collection('posts').doc(post.postId).set(post.toMap());
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({"posts":FieldValue.arrayUnion([post.postId])});
      showScaffoldMSG(context, "uploaded_successfully");
    }
    catch(e){
      showScaffoldMSG(context, "upload_failed");
    }
    notifyListeners();
  }

  Future deletePost(context, PostModel post) async {
    try{
      final user = Provider.of<UserProvider>(context, listen: false).currentUser!.uid;
      await FirebaseFirestore.instance.collection('posts').doc(post.postId).delete();
      await FirebaseFirestore.instance.collection("users").doc(user).update({"posts":FieldValue.arrayRemove([post.postId])});
      await _supa.from("posts").remove(post.mediaUrls.map((file) => "${post.postId}/$file").toList());
      showScaffoldMSG(context, "deleted_successfully");
    }
    catch(e){
      showScaffoldMSG(context, "${"something_went_wrong".tr()} $e");
    }
    notifyListeners();
  }

  Future uploadStory(context, StoryModel story) async {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    try{
      await FirebaseFirestore.instance.collection('stories').doc(story.storyId).set(story.toMap());
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({"stories":FieldValue.arrayUnion([story.storyId])});
      showScaffoldMSG(context, "uploaded_successfully");
    }
    catch(e){
      showScaffoldMSG(context, "upload_failed");
    }
    notifyListeners();
  }
}
