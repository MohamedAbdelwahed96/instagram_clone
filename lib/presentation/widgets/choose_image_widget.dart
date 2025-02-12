import 'package:flutter/material.dart';
import 'package:instagram_clone/logic/image_provider.dart';
import 'package:provider/provider.dart';

class ChooseImageWidget extends StatefulWidget {
  const ChooseImageWidget({super.key});

  @override
  State<ChooseImageWidget> createState() => _ChooseImageWidgetState();
}

class _ChooseImageWidgetState extends State<ChooseImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImagProvider>(builder: (context, provider, _){
      return SizedBox(
        height: MediaQuery.of(context).size.height*0.15,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        provider.selectImageFromCamera();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.camera_alt, size: MediaQuery.of(context).size.height*0.06)),
                  Text("Camera")
                ],
              ),
              SizedBox(width: 24),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        provider.selectImageFromGallery();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.photo_library, size: MediaQuery.of(context).size.height*0.06)),
                  Text("Gallery")
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
