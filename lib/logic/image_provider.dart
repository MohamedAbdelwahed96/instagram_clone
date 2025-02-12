import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagProvider extends ChangeNotifier{

  File? ImageFile;
  final ImagePicker picker = ImagePicker();
  String? filename;

  Future selectImageFromGallery()async{
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      ImageFile = File(image.path);
      notifyListeners();
    }
    notifyListeners();
  }

  Future selectImageFromCamera()async{
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if(image != null){
      ImageFile = File(image.path);
      notifyListeners();
    }
    notifyListeners();
  }

  Future uploadImage(context)async{
    if(ImageFile != null){
      filename = DateTime.now().millisecondsSinceEpoch.toString();
      await Supabase.instance.client.storage.from("images").upload("uploads/$filename", ImageFile!)
          .then((v){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uploaded Successfully")));
        ImageFile=null;
      });
      notifyListeners();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No image attached")));
      notifyListeners();
    }
  }

  List<String> media=[];

  Future<List<String>>getImages()async{
    try{
      final response = await Supabase.instance.client.storage.from("images").list(path: "uploads");
      if(response!=null){
        media = response.map((f){
          return Supabase.instance.client.storage.from("images").getPublicUrl("uploads/${f.name}");}).toList();
        return media;
      }
    }
    catch(e){
      print(e);
      return [];
    }
    return [];
  }

  String? image;
  Future<void> getImage(String imgName) async {
    try {
      image = Supabase.instance.client.storage.from("images").getPublicUrl("uploads/$imgName");
      notifyListeners();
    } catch (e) {
      image = "No image found in Suba_base";
      notifyListeners();
    }
  }
}
